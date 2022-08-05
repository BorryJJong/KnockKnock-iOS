//
//  HomeView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/23.
//

import UIKit

import Then
import KKDSKit

class HomeView: UIView {

  // MARK: - UIs

  let homeCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then {
      $0.scrollDirection = .vertical
    }).then {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.contentInsetAdjustmentBehavior = .never
    }

  // MARK: - Initailize

  init() {
    super.init(frame: .zero)
    self.setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: - Configure

  private func setupConstraints() {
    [self.homeCollectionView].addSubViews(self)

    NSLayoutConstraint.activate([
      self.homeCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
      self.homeCollectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
      self.homeCollectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
      self.homeCollectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
    ])
  }

  func mainCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    // Section Header
    let headerEstimatedHeight: CGFloat = 60

    let headerSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(headerEstimatedHeight)
    )
    let header = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerSize,
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top
    )

    // Section 1: Main

    let mainItemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalWidth(1.333)
    )
    let mainItem = NSCollectionLayoutItem(layoutSize: mainItemSize)

    let mainGroupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalWidth(1.333)
    )
    let mainGroup = NSCollectionLayoutGroup.horizontal(
      layoutSize: mainGroupSize,
      subitems: [mainItem]
    )

    let mainSection = NSCollectionLayoutSection(group: mainGroup)
    mainSection.orthogonalScrollingBehavior = .paging

    // Section 2: Store

    let storeEstimatedHeight: CGFloat = 100

    let storeItemSize = NSCollectionLayoutSize(
      widthDimension: .absolute(150),
      heightDimension: .estimated(storeEstimatedHeight)
    )
    let storeItem = NSCollectionLayoutItem(layoutSize: storeItemSize)
    
    let storeGroupSize = NSCollectionLayoutSize(
      widthDimension: .estimated(storeEstimatedHeight),
      heightDimension: .estimated(storeEstimatedHeight)
    )
    let storeGroup = NSCollectionLayoutGroup.horizontal(
      layoutSize: storeGroupSize,
      subitems: [storeItem]
    )

    let storeSection = NSCollectionLayoutSection(group: storeGroup)
    storeSection.interGroupSpacing = 10
    storeSection.contentInsets = NSDirectionalEdgeInsets(
      top: 0,
      leading: 20,
      bottom: 40,
      trailing: 0
    )
    storeSection.orthogonalScrollingBehavior = .continuous
    storeSection.boundarySupplementaryItems = [header]

    // Section 3: Banner

    let bannerItemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .estimated(80)
    )
    let bannerItem = NSCollectionLayoutItem(layoutSize: bannerItemSize)
    bannerItem.contentInsets = NSDirectionalEdgeInsets(
      top: 0,
      leading: 3,
      bottom: 0,
      trailing: 3
    )

    let bannerGroupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(0.9),
      heightDimension: .estimated(80)
    )
    let bannerGroup = NSCollectionLayoutGroup.horizontal(
      layoutSize: bannerGroupSize,
      subitems: [bannerItem]
    )

    let bannerSection = NSCollectionLayoutSection(group: bannerGroup)
    bannerSection.contentInsets = NSDirectionalEdgeInsets(
      top: 0,
      leading: 17,
      bottom: 0,
      trailing: 0
    )

    bannerSection.orthogonalScrollingBehavior = .groupPaging

    // Section 4: Tag
    let tagEstimatedWidth: CGFloat = 50
    let tagEstimatedHeigth: CGFloat = 30
    let tagItemSize = NSCollectionLayoutSize(
      widthDimension: .estimated(tagEstimatedWidth),
      heightDimension: .estimated(tagEstimatedHeigth)
    )
    let tagItem = NSCollectionLayoutItem(layoutSize: tagItemSize)

    let tagGroupSize = NSCollectionLayoutSize(
      widthDimension: .estimated(tagEstimatedWidth),
      heightDimension: .estimated(tagEstimatedHeigth)
    )
    let tagGroup = NSCollectionLayoutGroup.vertical(
      layoutSize: tagGroupSize,
      subitems: [tagItem]
    )

    let tagSection = NSCollectionLayoutSection(group: tagGroup)
    tagSection.interGroupSpacing = 10
    tagSection.contentInsets = NSDirectionalEdgeInsets(
      top: 0,
      leading: 20,
      bottom: 0,
      trailing: 20
    )
    tagSection.orthogonalScrollingBehavior = .continuous
    tagSection.boundarySupplementaryItems = [header]

    let layout = UICollectionViewCompositionalLayout {(section: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

      let homeSection = HomeSection(rawValue: section)

      switch homeSection {
      case .main:
        return mainSection

      case .store:
        return storeSection

      case .banner:
        return bannerSection

      case .tag:
        return tagSection
        //
        //         case .popularPost:
        //           return popularSection
        //
        //         case .event:
        //           return eventSection

      default:
        assert(false)
      }
    }

    return layout
  }
}
