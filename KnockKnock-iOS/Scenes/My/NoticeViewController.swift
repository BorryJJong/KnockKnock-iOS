//
//  NoticeViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/10/31.
//

import UIKit

final class NoticeViewController: BaseViewController<NoticeView> {

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupConfigure()
  }

  // MARK: - Configure

  override func setupConfigure() {
    self.navigationController?.navigationBar.setDefaultAppearance()
    self.navigationItem.title = "공지사항"

    self.containerView.noticeCollectionView.do {
      $0.registCell(type: NoticeCell.self)
      $0.collectionViewLayout = self.containerView.setNoticeCollectionViewLayout()
      $0.delegate = self
      $0.dataSource = self
    }
  }
}

extension NoticeViewController: UICollectionViewDelegateFlowLayout {
}

extension NoticeViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return 5
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueCell(withType: NoticeCell.self, for: indexPath)

    return cell
  }
}
