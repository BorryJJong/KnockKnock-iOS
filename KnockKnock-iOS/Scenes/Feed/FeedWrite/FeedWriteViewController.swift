//
//  FeedWriteViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/17.
//

import UIKit

protocol FeedWriteViewProtocol: AnyObject {
  var interactor: FeedWriteInteractorProtocol? { get set }
}

final class FeedWriteViewController: BaseViewController<FeedWriteView> {

  // MARK: - Properties

  var interactor: FeedWriteInteractorProtocol?

  // MARK: - Life cycle

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func setupConfigure() {
    self.navigationItem.title = "새 게시글"
    self.containerView.contentTextView.do {
      $0.delegate = self
    }
    self.containerView.tagSelectButton.addTarget(self,
                                                 action: #selector(tagSelectButtonDidTap(_:)),
                                                 for: .touchUpInside)
    self.containerView.shopSearchButton.addTarget(self,
                                                  action: #selector(shopSearchButtonDidTap(_:)),
                                                  for: .touchUpInside)
  }

  @objc func tagSelectButtonDidTap(_ sender: UIButton) {
    self.navigationController?.pushViewController(PropertySelectViewController(), animated: true)
  }

  @objc func promotionSelectButtonDidTap(_ sender: UIButton) {
    self.navigationController?.pushViewController(PropertySelectViewController(), animated: true)
  }

  @objc func shopSearchButtonDidTap(_ sender: UIButton) {
    self.navigationController?.pushViewController(ShopSearchViewController(), animated: true)
  }
}

extension FeedWriteViewController: UITextViewDelegate {
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
    }
  }
}

extension FeedWriteViewController: FeedWriteViewProtocol {
  
}
