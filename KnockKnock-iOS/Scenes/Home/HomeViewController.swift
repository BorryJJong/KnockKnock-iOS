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
      $0.registCell(type: HomeMainPagerCell.self)
      $0.registCell(type: StoreCell.self)
      $0.registCell(type: BannerCell.self)
      $0.registCell(type: HomeTagCell.self)
      $0.registCell(type: PopularPostCell.self)
      $0.registFooterView(type: PopularFooterCollectionReusableView.self)
      $0.registCell(type: EventCell.self)

      $0.collectionViewLayout = self.containerView.mainCollectionViewLayout()
    }
  }

  @objc func didTapMoreButton(_ sender: UIButton) {
    let section = HomeSection(rawValue: sender.tag)

    if section == .event {
      self.navigationController?.pushViewController(EventPageViewController(), animated: true)
    }
  }
}

  // MARK: - CollectionView DataSource, Delegate

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    let section = HomeSection(rawValue: section)

    switch section {
    case .main, .tag:
      return 1
      
    default:
      return 6
    }
  }

  func numberOfSections(
    in collectionView: UICollectionView
  ) -> Int {
        return HomeSection.allCases.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    let section = HomeSection(rawValue: indexPath.section)

    switch section {
    case .main, .banner:
      return UICollectionReusableView()

    case .store, .event, .tag:
      let header = collectionView.dequeueReusableSupplementaryHeaderView(
        withType: HomeHeaderCollectionReusableView.self,
        for: indexPath
      )
      header.bind(section: section)
      header.moreButton.tag = indexPath.section
      header.moreButton.addTarget(self, action: #selector(didTapMoreButton(_:)), for: .touchUpInside)

      return header

    case .popularPost:
      let footer = collectionView.dequeueReusableSupplementaryFooterView(
        withType: PopularFooterCollectionReusableView.self,
        for: indexPath
      )

      return footer

    default:
      assert(false)
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let section = HomeSection(rawValue: indexPath.section)

    switch section {
    case .main:
      let cell = collectionView.dequeueCell(
        withType: HomeMainPagerCell.self,
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
        withType: HomeTagCell.self,
        for: indexPath
      )

      return cell

    case .popularPost:
      let cell = collectionView.dequeueCell(
        withType: PopularPostCell.self,
        for: indexPath
      )

      return cell

    case .event:
      let cell = collectionView.dequeueCell(
        withType: EventCell.self,
        for: indexPath
      )
      
      return cell

    default:
      assert(false)
    }
  }
}
