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

    self.containerView.contentTextView.delegate = self
    
    self.navigationController?.navigationBar.setDefaultAppearance()
  }

  // MARK: - Buttton Actions

  @objc func backButtonDidTap(_ sender: UIBarButtonItem) {
    self.navigationController?.popViewController(animated: true)
  }
}

// MARK: - FeedEdit View Protocol

extension FeedEditViewController: FeedEditViewProtocol {
  func fetchOriginPost(feedDetail: FeedDetail) {
    self.feedData = feedDetail
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
