//
//  HomeViewController.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/02/26.
//

import UIKit

import Then

final class HomeViewController: BaseViewController<HomeView> {

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupConfigure()
    self.view.backgroundColor = .lightGray
  }

  override func setupConfigure() {
    self.containerView.homeCollectionView.do {
      $0.dataSource = self
      $0.delegate = self
      $0.registHeaderView(type: HomeHeaderCollectionReusableView.self)
      $0.registCell(type: HomeMainCell.self)
      $0.registCell(type: StoreCell.self)
      $0.registCell(type: BannerCell.self)
      $0.registCell(type: TagCell.self)
      $0.collectionViewLayout = self.containerView.mainCollectionViewLayout()
    }
  }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 5
  }

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    //    return HomeSection.allCases.countgit
    return 4
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let section = HomeSection(rawValue: indexPath.section)
    switch section {
    case .main, .banner:
      return UICollectionReusableView()
    case .store, .event, .tag:
      let header = collectionView.dequeueReusableSupplementaryHeaderView(
        withType: HomeHeaderCollectionReusableView.self,
        for: indexPath
      )

      return header

    case .popularPost:
      let header = collectionView.dequeueReusableSupplementaryHeaderView(
        withType: HomeHeaderCollectionReusableView.self,
        for: indexPath
      )

      return header

    default:
      assert(false)

    }

  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let section = HomeSection(rawValue: indexPath.section)

    switch section {
    case .main:
      let cell = collectionView.dequeueCell(
        withType: HomeMainCell.self,
        for: indexPath
      )
      return cell

    case .store:
      let cell = collectionView.dequeueCell(
        withType: StoreCell.self,
        for: indexPath
      )
      return cell

    case .banner:
      let cell = collectionView.dequeueCell(
        withType: BannerCell.self,
        for: indexPath
      )
      return cell

    case .tag:
      let cell = collectionView.dequeueCell(
        withType: TagCell.self,
        for: indexPath
      )
      return cell

      //    case .popularPost:
      //      let cell = collectionView.dequeueCell(withType: HomeMainCell.self, for: indexPath)
      //      return cell
      //    case .event:
      //      let cell = collectionView.dequeueCell(withType: HomeMainCell.self, for: indexPath)
      //      return cell

    default:
      assert(false)
    }
  }
}
