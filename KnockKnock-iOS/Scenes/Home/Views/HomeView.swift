//
//  HomeView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/23.
//

import UIKit

import Then
import KKDSKit
import SnapKit

final class HomeView: UIView {

  // MARK: - UIs

  let homeCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then {
      $0.scrollDirection = .vertical
    }).then {
      $0.contentInsetAdjustmentBehavior = .never
      $0.backgroundColor = .clear
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

    self.homeCollectionView.snp.makeConstraints {
      $0.top.equalTo(self.snp.top)
      $0.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
    }
  }

  // MARK: - CollectionView Layout

  func mainCollectionViewLayout() -> UICollectionViewCompositionalLayout {

    // Section Header

    let headerHeight: CGFloat = 60

    let headerSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .absolute(headerHeight)
    )
    let header = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerSize,
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top
    )
    header.contentInsets = NSDirectionalEdgeInsets(
      top: 20,
      leading: 0,
      bottom: 20,
      trailing: 0
    )

    let layout = UICollectionViewCompositionalLayout {(section: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

      let homeSection = HomeSection(rawValue: section)

      switch homeSection {
      case .main:

        let mainSection = self.mainSectionLayout()
        return mainSection

      case .store:

        let storeSection = self.storeSectionLayout()
        storeSection.boundarySupplementaryItems = [header]

        return storeSection

      case .banner:

        let bannerSection = self.bannerSectionLayout()
        return bannerSection

      case .tag:

        let tagSection = self.tagSectionLayout()
        tagSection.boundarySupplementaryItems = [header]

        return tagSection
        
      case .popularPost:

        let popularSection = self.popularSectionLayout()
        return popularSection

      case .event:

        let eventSection = self.eventSectionLayout()
        eventSection.boundarySupplementaryItems = [header]

        return eventSection

      default:
        return self.setDefaultSection()
      }
    }

    return layout
  }

  // MARK: - Main Section Layout

  private func mainSectionLayout() -> NSCollectionLayoutSection {
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
    mainSection.contentInsets = NSDirectionalEdgeInsets(
      top: 0,
      leading: 0,
      bottom: 45,
      trailing: 0
    )

    return mainSection
  }

  // MARK: - Store Section Layout

  private func storeSectionLayout() -> NSCollectionLayoutSection {
    let storeWidth: CGFloat = 150
    let storeEstimatedHeight: CGFloat = 200

    let storeItemSize = NSCollectionLayoutSize(
      widthDimension: .absolute(storeWidth),
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
      bottom: 0,
      trailing: 0
    )
    storeSection.orthogonalScrollingBehavior = .continuous

    return storeSection
  }

  // MARK: - Banner Section Layout

  private func bannerSectionLayout() -> NSCollectionLayoutSection {

    let bannerHeight: CGFloat = 80

    let bannerItemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .absolute(bannerHeight)
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
      heightDimension: .absolute(bannerHeight)
    )
    let bannerGroup = NSCollectionLayoutGroup.horizontal(
      layoutSize: bannerGroupSize,
      subitems: [bannerItem]
    )

    let bannerSection = NSCollectionLayoutSection(group: bannerGroup)
    bannerSection.contentInsets = NSDirectionalEdgeInsets(
      top: 40,
      leading: 17,
      bottom: 45,
      trailing: 0
    )
    bannerSection.orthogonalScrollingBehavior = .groupPaging

    return bannerSection
  }

  // MARK: - Tag Section Layout

  private func tagSectionLayout() -> NSCollectionLayoutSection {
    let tagHeight: CGFloat = 40

    let tagItemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .absolute(tagHeight)
    )
    let tagItem = NSCollectionLayoutItem(layoutSize: tagItemSize)

    let tagGroupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .absolute(tagHeight)
    )
    let tagGroup = NSCollectionLayoutGroup.horizontal(
      layoutSize: tagGroupSize,
      subitems: [tagItem]
    )

    let tagSection = NSCollectionLayoutSection(group: tagGroup)
    tagSection.contentInsets = NSDirectionalEdgeInsets(
      top: 0,
      leading: 20,
      bottom: 0,
      trailing: 10
    )
    return tagSection
  }

  // MARK: - Popular Section Layout

  private func popularSectionLayout() -> NSCollectionLayoutSection {

    // footer

    let footerEstimatedHeight: CGFloat = 60

    let popularFooterSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .estimated(footerEstimatedHeight)
    )
    let popularFooter = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: popularFooterSize,
      elementKind: UICollectionView.elementKindSectionFooter,
      alignment: .bottom
    )

    // Item

    let sectionInset: CGFloat = 2.5

    let largeItemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(0.666),
      heightDimension: .fractionalHeight(1)
    )
    let largeItem = NSCollectionLayoutItem(layoutSize: largeItemSize)
    largeItem.contentInsets = NSDirectionalEdgeInsets(
      top: sectionInset,
      leading: sectionInset,
      bottom: sectionInset,
      trailing: sectionInset
    )

    let verticalSmallItemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalHeight(0.5)
    )
    let verticalSmallItem = NSCollectionLayoutItem(layoutSize: verticalSmallItemSize)
    verticalSmallItem.contentInsets = NSDirectionalEdgeInsets(
      top: sectionInset,
      leading: sectionInset,
      bottom: sectionInset,
      trailing: sectionInset
    )

    let horizontalSmallItemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(0.333),
      heightDimension: .fractionalHeight(1)
    )
    let horizontalSmallItem = NSCollectionLayoutItem(layoutSize: horizontalSmallItemSize)
    horizontalSmallItem.contentInsets = NSDirectionalEdgeInsets(
      top: sectionInset,
      leading: sectionInset,
      bottom: sectionInset,
      trailing: sectionInset
    )

    let verticalGroupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(0.333),
      heightDimension: .fractionalHeight(1)
    )
    let verticalGroup = NSCollectionLayoutGroup.vertical(
      layoutSize: verticalGroupSize,
      subitems: [verticalSmallItem]
    )

    let horizontalGroupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalHeight(0.333)
    )
    let horizontalGroup = NSCollectionLayoutGroup.horizontal(
      layoutSize: horizontalGroupSize,
      subitem: horizontalSmallItem, count: 3
    )

    let largeFirstMixedGroupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalWidth(0.666)
    )
    let largeFirstMixedGroup = NSCollectionLayoutGroup.horizontal(
      layoutSize: largeFirstMixedGroupSize,
      subitems: [largeItem, verticalGroup]
    )

    let outerGroupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalWidth(1)
    )
    let outerGroup = NSCollectionLayoutGroup.vertical(
      layoutSize: outerGroupSize,
      subitems: [largeFirstMixedGroup, horizontalGroup]
    )
    outerGroup.contentInsets = NSDirectionalEdgeInsets(
      top: 0,
      leading: 20,
      bottom: 0,
      trailing: 20
    )

    let popularSection = NSCollectionLayoutSection(group: outerGroup)
    popularSection.contentInsets = NSDirectionalEdgeInsets(
      top: 20,
      leading: 0,
      bottom: 0,
      trailing: 0
    )
    popularSection.boundarySupplementaryItems = [popularFooter]

    return popularSection
  }

  // MARK: - Event Section Layout

  private func eventSectionLayout() -> NSCollectionLayoutSection {

    let eventItemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalWidth(0.5)
    )
    let eventItem = NSCollectionLayoutItem(layoutSize: eventItemSize)

    let eventGroupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalWidth(0.5)
    )
    let eventGroup = NSCollectionLayoutGroup.vertical(
      layoutSize: eventGroupSize,
      subitems: [eventItem]
    )
    eventGroup.contentInsets = NSDirectionalEdgeInsets(
      top: 0,
      leading: 0,
      bottom: 0,
      trailing: 20
    )

    let eventSection = NSCollectionLayoutSection(group: eventGroup)
    eventSection.interGroupSpacing = 20
    eventSection.contentInsets = NSDirectionalEdgeInsets(
      top: 0,
      leading: 20,
      bottom: 40,
      trailing: 0
    )
    return eventSection
  }

  private func setDefaultSection() -> NSCollectionLayoutSection {
    let defaultItemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalWidth(1)
    )
    let defaultItem = NSCollectionLayoutItem(layoutSize: defaultItemSize)

    let defaultGroupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalWidth(1)
    )
    let defaultGroup = NSCollectionLayoutGroup.horizontal(
      layoutSize: defaultGroupSize,
      subitems: [defaultItem]
    )

    let defaultSection = NSCollectionLayoutSection(group: defaultGroup)

    return defaultSection
  }
}
