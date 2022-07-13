//
//  FeedDetailListView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/13.
//

import UIKit

import Then

class FeedView: UIView {
  
  // MARK: - Constants
  
  private enum Metric {
    static let gradientImageViewWidth = 30.f
    static let gradientImageViewHeight = 60.f
    
    static let scrollViewLeadingMargin = 15.f
    static let scrollViewTrailingMargin = -15.f
    
    static let feedCollectionViewLineSpacing = 10.f
    static let feedCollectionViewItemSpacing = 10.f
    
    static let viewMoreButtonHeight = 40.f
    
    static let stackViewSpacing = 20.f
  }
  
  // MARK: - UIs
  
  let searchBar = UISearchController()
 
  let gradientImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = UIImage(named: "tagButton_gradient")
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
    $0.registFooterView(type: FooterCollectionReusableView.self)
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
    [self.feedCollectionView].addSubViews(self)
    [self.gradientImageView].addSubViews(self)
    
    NSLayoutConstraint.activate([
      self.gradientImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
      self.gradientImageView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
      self.gradientImageView.heightAnchor.constraint(equalToConstant: Metric.gradientImageViewHeight),
      self.gradientImageView.widthAnchor.constraint(equalToConstant: Metric.gradientImageViewWidth),
      
      self.feedCollectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
      self.feedCollectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.scrollViewLeadingMargin),
      self.feedCollectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.scrollViewTrailingMargin),
      self.feedCollectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
  
  func feedCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    let sectionTwoInset: CGFloat = 2.5

    // section 1
    let estimatedWidth: CGFloat = 50
    let estimatedHeigth: CGFloat = 60

    let tagItemSize = NSCollectionLayoutSize(widthDimension: .estimated(estimatedWidth),
                                            heightDimension: .estimated(estimatedHeigth))
    let tagItem = NSCollectionLayoutItem(layoutSize: tagItemSize)

    let tagGroupSize = NSCollectionLayoutSize(widthDimension: .estimated(estimatedWidth), heightDimension: .estimated(estimatedHeigth))
    let tagGroup = NSCollectionLayoutGroup.vertical(layoutSize: tagGroupSize, subitems: [tagItem])

    let sectionOne = NSCollectionLayoutSection(group: tagGroup)
    sectionOne.interGroupSpacing = 10
    sectionOne.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0.0, bottom: 15, trailing: 0.0)
    sectionOne.orthogonalScrollingBehavior = .continuous

    // section 2
    let largeItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.666), heightDimension: .fractionalHeight(1))
    let largeItem = NSCollectionLayoutItem(layoutSize: largeItemSize)
    largeItem.contentInsets = NSDirectionalEdgeInsets(top: sectionTwoInset, leading: sectionTwoInset, bottom: sectionTwoInset, trailing: sectionTwoInset)
    
    let verticalSmallItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
    let verticalSmallItem = NSCollectionLayoutItem(layoutSize: verticalSmallItemSize)
    verticalSmallItem.contentInsets = NSDirectionalEdgeInsets(top: sectionTwoInset, leading: sectionTwoInset, bottom: sectionTwoInset, trailing: sectionTwoInset)
    
    let horizontalSmallItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.333), heightDimension: .fractionalHeight(1))
    let horizontalSmallItem = NSCollectionLayoutItem(layoutSize: horizontalSmallItemSize)
    horizontalSmallItem.contentInsets = NSDirectionalEdgeInsets(top: sectionTwoInset, leading: sectionTwoInset, bottom: sectionTwoInset, trailing: sectionTwoInset)
    
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
    
    let sectionTwo = NSCollectionLayoutSection(group: outerGroup)

    // footer
    let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50.0))
    let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
    footer.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0)

    sectionTwo.boundarySupplementaryItems = [footer]

    let layout = UICollectionViewCompositionalLayout { (section: Int, _) -> NSCollectionLayoutSection? in
      if section == 0 {
        return sectionOne

      } else {
        return sectionTwo
      }
    }
    
    return layout
  }
}