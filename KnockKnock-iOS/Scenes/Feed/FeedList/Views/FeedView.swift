//
//  FeedDetailListView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/13.
//

import UIKit

import Then

class FeedView: UIView {

  // MARK: - UIs

  let searchBar = UISearchController()

  let tagCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then {
      $0.scrollDirection = .horizontal
//      $0.minimumLineSpacing = 5
      $0.minimumInteritemSpacing = 5
    }
  ).then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.showsHorizontalScrollIndicator = false
  }

  let gradientImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = UIImage(named: "tagButton_gradient")
  }

  let feedCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then {
      $0.scrollDirection = .vertical
      $0.minimumLineSpacing = 10
      $0.minimumInteritemSpacing = 10
    }
  ).then {
    $0.translatesAutoresizingMaskIntoConstraints = false
  }

  let viewMoreButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setTitle("+ 더보기", for: .normal)
    $0.setTitleColor(.gray80, for: .normal)
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.gray30?.cgColor
  }

  let scrollView = UIScrollView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
  }

  lazy var stackView = UIStackView(arrangedSubviews: [self.feedCollectionView, self.viewMoreButton]).then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.axis = .vertical
    $0.distribution = .fill
    $0.alignment = .fill

    $0.spacing = 20
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
    [self.tagCollectionView, self.gradientImageView].addSubViews(self)
    [self.scrollView].addSubViews(self)
    [self.stackView].addSubViews(self.scrollView)

    NSLayoutConstraint.activate([
      self.tagCollectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
      self.tagCollectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      self.tagCollectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
      self.tagCollectionView.heightAnchor.constraint(equalToConstant: 60),

      self.gradientImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
      self.gradientImageView.trailingAnchor.constraint(equalTo: self.tagCollectionView.trailingAnchor),
      self.gradientImageView.bottomAnchor.constraint(equalTo: self.tagCollectionView.bottomAnchor),
      self.gradientImageView.widthAnchor.constraint(equalToConstant: 30),

      self.scrollView.topAnchor.constraint(equalTo: self.tagCollectionView.bottomAnchor),
      self.scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 15),
      self.scrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -15),
      self.scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),

      self.stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
      self.stackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
      self.stackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
      self.stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
      self.stackView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),

      self.viewMoreButton.heightAnchor.constraint(equalToConstant: 40),
      self.feedCollectionView.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor)
    ])
  }

  func feedCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    let compositionalLayout: UICollectionViewCompositionalLayout = {

      let inset: CGFloat = 2.5

      // Items
      let largeItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.666), heightDimension: .fractionalHeight(1))
      let largeItem = NSCollectionLayoutItem(layoutSize: largeItemSize)
      largeItem.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)

      let smallItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
      let smallItem = NSCollectionLayoutItem(layoutSize: smallItemSize)
      smallItem.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)

      // Nested Group
      let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.333), heightDimension: .fractionalHeight(1))
      let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize, subitems: [smallItem])

      // Outer Group
      let largeFirstMixedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.666))
      let largeFirstMixedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: largeFirstMixedGroupSize, subitems: [largeItem, verticalGroup])

      let verticalFirstMixedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.666))
      let verticalFirstMixedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: verticalFirstMixedGroupSize, subitems: [verticalGroup, largeItem])

      let threeVerticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.666))
      let threeVerticalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: threeVerticalGroupSize, subitems: [verticalGroup, verticalGroup, verticalGroup])

      let OuterGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(4))
      let OuterGroup = NSCollectionLayoutGroup.vertical(layoutSize: OuterGroupSize, subitems: [largeFirstMixedGroup, threeVerticalGroup, verticalFirstMixedGroup, threeVerticalGroup])

      // Section
      let section = NSCollectionLayoutSection(group: OuterGroup)

      return UICollectionViewCompositionalLayout(section: section)
    }()
    return compositionalLayout
  }
}
