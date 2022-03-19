//
//  FeedWriteViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/17.
//

import UIKit

//protocol FeedWriteViewProtocol: AnyObject {
//  var interactor: FeedWriteInteractorProtocol? { get set }
//}

final class FeedWriteViewController: BaseViewController<FeedWriteView> {

  // MARK: - Properties

  // MARK: - Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func setupConfigure() {
    self.navigationItem.title = "새 게시글"
    self.containerView.contentTextView.do {
      $0.delegate = self
    }
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
