//
//  MyViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/10/05.
//

import UIKit

final class MyViewController: BaseViewController<MyView> {

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupConfigure()
  }

  // MARK: - Configure

  override func setupConfigure() {
    self.navigationController?.navigationBar.barTintColor = .white
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationItem.title = "설정"

    self.containerView.settingCollectionView.do {
      $0.dataSource = self
      $0.delegate = self
      $0.registCell(type: SettingCell.self)
      $0.registHeaderView(type: MyHeaderCollectionReusableView.self)
      $0.registFooterView(type: MyFooterCollectionReusableView.self)
    }
  }
}

  // MARK: - CollectionView DataSource

extension MyViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
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

extension MyViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: self.containerView.frame.width, height: 30)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 15
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForFooterInSection section: Int
  ) -> CGSize {
    if section == 2 {
      return CGSize(width: self.containerView.frame.width, height: 130)
    } else {
      return CGSize(width: self.containerView.frame.width, height: 50)
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int
  ) -> CGSize {
    return CGSize(width: self.containerView.frame.width, height: 50)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    switch kind {
    case UICollectionView.elementKindSectionHeader:
      let header = collectionView.dequeueReusableSupplementaryHeaderView(
        withType: MyHeaderCollectionReusableView.self,
        for: indexPath
      )

      header.bind(title: "test")

      return header
    case UICollectionView.elementKindSectionFooter:
      let footer = collectionView.dequeueReusableSupplementaryFooterView(
        withType: MyFooterCollectionReusableView.self,
        for: indexPath
      )

      footer.bind(isLast: indexPath.section == 2)

      return footer

    default:
      return UICollectionReusableView()
    }
  }
}
