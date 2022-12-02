//
//  AlertViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/12/02.
//

import UIKit

final class AlertViewController: BaseViewController<AlertView> {

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    self.configure()
  }

  func configure() {

    self.containerView.cancelButton.do {
      $0.addTarget(
        self,
        action: #selector(self.alertCancelButtonDidTap(_:)),
        for: .touchUpInside
      )
    }

    self.containerView.confirmButton.do {
      $0.addTarget(
        self,
        action: #selector(self.alertConfirmButtonDidTap(_:)),
        for: .touchUpInside
      )
    }
  }

  @objc func alertConfirmButtonDidTap(_ sender: UIButton) {
//    self.navigationController?.present(AlertViewController(), animated: false)
    self.dismiss(animated: false)
//    self.containerView.setAlertView(menuType: nil)
  }

  @objc func alertCancelButtonDidTap(_ sender: UIButton) {
//    self.containerView.setAlertView(menuType: nil)
    self.dismiss(animated: false)
  }

  /// menuType == nil 일 때 alertView hidden
  func setAlertView(menuType: MyMenuType?) {
    var content = ""

    guard let menuType = menuType else {
      self.containerView.isHidden = true
      return
    }

    if menuType == .signOut {
      content = "계정을 삭제하면 게시글, 좋아요, 댓글 등 모든 활동 정보가 삭제됩니다. 그래도 탈퇴 하시겠습니까?"
      self.containerView.bind(content: content, isCancelActive: true)

    } else if menuType == .versionInfo {
      content = "현재 최신버전을 사용중입니다."
      self.containerView.bind(content: content, isCancelActive: false)

    }
    self.containerView.isHidden = false
  }
}

