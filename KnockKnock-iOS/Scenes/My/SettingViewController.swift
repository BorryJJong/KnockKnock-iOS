//
//  SettingViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/10/05.
//

import UIKit

final class SettingViewController: BaseViewController<SettingView> {

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupConfigure()
  }

  override func setupConfigure() {
    self.containerView.settingCollectionView.do {
      $0.dataSource = self
      $0.registCell(type: SettingCell.self)
    }
  }
}

extension SettingViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueCell(withType: SettingCell.self, for: indexPath)

    return cell
  }

  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return 3
  }

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 3
  }

}
