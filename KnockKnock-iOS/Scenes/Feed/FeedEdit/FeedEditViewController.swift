//
//  FeedEditViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/12/18.
//

import UIKit

import KKDSKit

protocol FeedEditViewProtocol: AnyObject {
  var interactor: FeedEditInteractorProtocol? { get set}

  func fetchOriginPost(feedDetail: FeedDetail)
  func fetchTag(tag: String)
  func fetchPromotion(promotion: String)
  func fetchAddress(address: AddressResponse.Documents)
}

final class FeedEditViewController: BaseViewController<FeedEditView> {

  // MARK: - Properties

  var interactor: FeedEditInteractorProtocol?

  var feedId: Int = 0
  var feedData: FeedDetail? {
    didSet {
      self.containerView.bind(data: self.feedData)
    }
  }

  // MARK: - UIs

  private lazy var backButton = UIBarButtonItem(
    image: KKDS.Image.ic_back_24_bk,
    style: .done,
    target: self,
    action: #selector(self.backButtonDidTap(_:))
  )

  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.interactor?.fetchOriginPost(feedId: self.feedId)
  }

  override func setupConfigure() {
    self.hideKeyboardWhenTappedAround()

    self.navigationItem.do {
      $0.title = "게시글 수정"
      $0.leftBarButtonItem = self.backButton
    }

    self.containerView.tagSelectButton.addTarget(
      self,
      action: #selector(self.tagSelectButtonDidTap(_:)),
      for: .touchUpInside
    )

    self.containerView.promotionSelectButton.addTarget(
      self,
      action: #selector(self.promotionSelectButtonDidTap(_:)),
      for: .touchUpInside
    )

    self.containerView.shopSearchButton.addTarget(
      self,
      action: #selector(self.shopSearchButtonDidTap(_:)),
      for: .touchUpInside
    )
    self.containerView.doneButton.addTarget(
      self,
      action: #selector(self.doneButtonDidTap(_:)),
      for: .touchUpInside
    )

    self.containerView.contentTextView.delegate = self
    
    self.navigationController?.navigationBar.setDefaultAppearance()
  }

  // MARK: - Buttton Actions

  @objc private func backButtonDidTap(_ sender: UIBarButtonItem) {
    self.interactor?.popFeedEditView()
  }

  @objc private func tagSelectButtonDidTap(_ sender: UIButton) {
    self.interactor?.navigateToProperty(propertyType: .tag)
  }

  @objc private func promotionSelectButtonDidTap(_ sender: UIButton) {
    self.interactor?.navigateToProperty(propertyType: .promotion)
  }

  @objc private func shopSearchButtonDidTap(_ sender: UIButton) {
    self.interactor?.navigateToShopSearch()
  }

  @objc private func doneButtonDidTap(_ sender: UIButton) {
    self.interactor?.checkEssentialField(feedId: self.feedId)
  }
}

// MARK: - FeedEdit View Protocol

extension FeedEditViewController: FeedEditViewProtocol {
  func fetchOriginPost(feedDetail: FeedDetail) {
    self.feedData = feedDetail
  }

  func fetchTag(tag: String) {
    self.containerView.setTag(tag: tag)
  }

  func fetchPromotion(promotion: String) {
    self.containerView.setPromotion(promotion: promotion)
  }

  func fetchAddress(address: AddressResponse.Documents) {
    self.containerView.setAddress(
      name: address.placeName,
      address: address.addressName
    )
  }
}

// MARK: - TextView Delegate

extension FeedEditViewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == .gray40 {
      textView.text = nil
      textView.textColor = .black
    }
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = "내용을 입력해주세요. (글자수 1,000자 이내)"
      textView.textColor = .gray40
      self.interactor?.setCurrentText(text: "")
    } else {
      self.interactor?.setCurrentText(text: textView.text)
    }
  }
}
