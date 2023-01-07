//
//  FeedDetailListView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/13.
//

import UIKit

import Then

class FeedMainView: UIView {
  
  // MARK: - Constants
  
  private enum Metric {
    static let tagCollectionViewItemSpacing = 5.f
    static let tagCollectionViewLeadingMargin = 20.f
    static let tagCollectionViewTrailingMargin = -20.f
    static let tagCollectionViewHeight = 50.f

    static let gradientImageViewWidth = 30.f
    static let gradientImageViewHeight = 40.f
    
    static let feedCollectionViewLeadingMargin = 15.f
    static let feedCollectionViewTrailingMargin = -15.f
    
    static let feedCollectionViewLineSpacing = 10.f
    static let feedCollectionViewItemSpacing = 10.f
    
    static let viewMoreButtonHeight = 40.f
    
    static let stackViewSpacing = 20.f
  }
  
  // MARK: - UIs

  private let gradientImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = UIImage(named: "tagButton_gradient")
  }

  let tagCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then {
      $0.scrollDirection = .horizontal
    }
  ).then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.alwaysBounceVertical = false
    $0.backgroundColor = .clear
  }

  let feedCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then {
      $0.scrollDirection = .vertical
      $0.minimumLineSpacing = Metric.feedCollectionViewLineSpacing
      $0.minimumInteritemSpacing = Metric.feedCollectionViewItemSpacing
    }
  ).then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .clear
    $0.registFooterView(type: FeedMainFooterCollectionReusableView.self)
  }
  
  // MARK: - Initailize
  
  init() {
    super.init(frame: .zero)
    self.setupConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  // MARK: - Constraints
  
  func setupConstraints() {
    [self.tagCollectionView, self.feedCollectionView].addSubViews(self)
    [self.gradientImageView].addSubViews(self)
    
    NSLayoutConstraint.activate([
      self.tagCollectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
      self.tagCollectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.tagCollectionViewLeadingMargin),
      self.tagCollectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.tagCollectionViewTrailingMargin),
      self.tagCollectionView.heightAnchor.constraint(equalToConstant: Metric.tagCollectionViewHeight),

      self.gradientImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
      self.gradientImageView.trailingAnchor.constraint(equalTo: self.tagCollectionView.trailingAnchor),
      self.gradientImageView.bottomAnchor.constraint(equalTo: self.tagCollectionView.bottomAnchor),
      
      self.feedCollectionView.topAnchor.constraint(equalTo: self.tagCollectionView.bottomAnchor),
      self.feedCollectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.feedCollectionViewLeadingMargin),
      self.feedCollectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.feedCollectionViewTrailingMargin),
      self.feedCollectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
    ])
  }

  func tagCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    let estimatedWidth: CGFloat = 50
    let estimatedHeigth: CGFloat = 30

    let tagItemSize = NSCollectionLayoutSize(widthDimension: .estimated(estimatedWidth),
                                             heightDimension: .estimated(estimatedHeigth))
    let tagItem = NSCollectionLayoutItem(layoutSize: tagItemSize)

    let tagGroupSize = NSCollectionLayoutSize(widthDimension: .estimated(estimatedWidth), heightDimension: .estimated(estimatedHeigth))
    let tagGroup = NSCollectionLayoutGroup.vertical(layoutSize: tagGroupSize, subitems: [tagItem])

    let section = NSCollectionLayoutSection(group: tagGroup)
    section.interGroupSpacing = 10
    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0.0, bottom: 0, trailing: 0.0)
    section.orthogonalScrollingBehavior = .continuous

    let layout = UICollectionViewCompositionalLayout(section: section)

    return layout
  }

  func feedCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    let sectionInset: CGFloat = 2.5

    // section 2
    let largeItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.666), heightDimension: .fractionalHeight(1))
    let largeItem = NSCollectionLayoutItem(layoutSize: largeItemSize)
    largeItem.contentInsets = NSDirectionalEdgeInsets(top: sectionInset, leading: sectionInset, bottom: sectionInset, trailing: sectionInset)
    
    let verticalSmallItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
    let verticalSmallItem = NSCollectionLayoutItem(layoutSize: verticalSmallItemSize)
    verticalSmallItem.contentInsets = NSDirectionalEdgeInsets(top: sectionInset, leading: sectionInset, bottom: sectionInset, trailing: sectionInset)
    
    let horizontalSmallItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.333), heightDimension: .fractionalHeight(1))
    let horizontalSmallItem = NSCollectionLayoutItem(layoutSize: horizontalSmallItemSize)
    horizontalSmallItem.contentInsets = NSDirectionalEdgeInsets(top: sectionInset, leading: sectionInset, bottom: sectionInset, trailing: sectionInset)
    
    let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.333), heightDimension: .fractionalHeight(1))
    let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize, subitems: [verticalSmallItem])
    
    let horizontalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
    let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalGroupSize, subitem: horizontalSmallItem, count: 3)
    
    let twoHorizontalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.666))
    let twoHorizontalGroup = NSCollectionLayoutGroup.vertical(layoutSize: twoHorizontalGroupSize, subitem: horizontalGroup, count: 2)
    
    let largeFirstMixedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.666))
    let largeFirstMixedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: largeFirstMixedGroupSize, subitems: [largeItem, verticalGroup])
    
    let verticalFirstMixedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.666))
    let verticalFirstMixedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: verticalFirstMixedGroupSize, subitems: [verticalGroup, largeItem])
    
    let outerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(2.666))
    let outerGroup = NSCollectionLayoutGroup.vertical(layoutSize: outerGroupSize, subitems: [largeFirstMixedGroup, twoHorizontalGroup, verticalFirstMixedGroup, twoHorizontalGroup])
    
    let section = NSCollectionLayoutSection(group: outerGroup)

    // footer
    let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50.0))
    let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
    footer.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 200, trailing: 0)

    section.boundarySupplementaryItems = [footer]

    let layout = UICollectionViewCompositionalLayout(section: section)
    
    return layout
  }
}
