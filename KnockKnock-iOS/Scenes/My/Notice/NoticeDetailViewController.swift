//
//  NoticeDetailViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/02.
//

import UIKit

import KKDSKit

final class NoticeDetailViewController: BaseViewController<NoticeDetailView> {
  
  // MARK: - Life Cycles
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupConfigure()
  }
  
  // MARK: - Configure
  
  override func setupConfigure() {
    let backButton = UIBarButtonItem(
      image: KKDS.Image.ic_back_24_bk,
      style: .done,
      target: self,
      action: #selector(self.backButtonDidTap(_:))
    )

    self.navigationController?.navigationBar.setDefaultAppearance()
    self.navigationItem.leftBarButtonItem = backButton
    self.navigationItem.title = "공지사항"
  }
  
  // MARK: - Button Actions
  
  @objc private func backButtonDidTap(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
}
