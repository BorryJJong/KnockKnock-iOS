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
    static let tagCollectionViewItemSpacing = 5.f
    static let tagCollectionViewLeadingMargin = 20.f
    static let tagCollectionViewTrailingMargin = -20.f
    static let tagCollectionViewHeight = 60.f

    static let gradientImageViewWidth = 30.f

    static let scrollViewLeadingMargin = 15.f
    static let scrollViewTrailingMargin = -15.f

    static let feedCollectionViewLineSpacing = 10.f
    static let feedCollectionViewItemSpacing = 10.f

    static let viewMoreButtonHeight = 40.f

    static let stackViewSpacing = 20.f
  }

  // MARK: - UIs

  let searchBar = UISearchController()

  let tagCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then {
      $0.scrollDirection = .horizontal
      $0.minimumInteritemSpacing = Metric.tagCollectionViewItemSpacing
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
      $0.minimumLineSpacing = Metric.feedCollectionViewLineSpacing
      $0.minimumInteritemSpacing = Metric.feedCollectionViewItemSpacing
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

  private let scrollView = UIScrollView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
  }

  lazy var stackView = UIStackView(arrangedSubviews: [self.feedCollectionView, self.viewMoreButton]).then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.axis = .vertical
    $0.distribution = .fill
    $0.alignment = .fill
    $0.spacing = Metric.stackViewSpacing
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
      self.tagCollectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.tagCollectionViewLeadingMargin),
      self.tagCollectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.tagCollectionViewTrailingMargin),
      self.tagCollectionView.heightAnchor.constraint(equalToConstant: Metric.tagCollectionViewHeight),

      self.gradientImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
      self.gradientImageView.trailingAnchor.constraint(equalTo: self.tagCollectionView.trailingAnchor),
      self.gradientImageView.bottomAnchor.constraint(equalTo: self.tagCollectionView.bottomAnchor),
      self.gradientImageView.widthAnchor.constraint(equalToConstant: Metric.gradientImageViewWidth),

      self.scrollView.topAnchor.constraint(equalTo: self.tagCollectionView.bottomAnchor),
      self.scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.scrollViewLeadingMargin),
      self.scrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.scrollViewTrailingMargin),
      self.scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),

      self.stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
      self.stackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
      self.stackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
      self.stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
      self.stackView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),

      self.viewMoreButton.heightAnchor.constraint(equalToConstant: Metric.viewMoreButtonHeight),
      self.feedCollectionView.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor)
    ])
  }

  func feedCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    let compositionalLayout: UICollectionViewCompositionalLayout = {

      let inset: CGFloat = 2.5

      let largeItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.666), heightDimension: .fractionalHeight(1))
      let largeItem = NSCollectionLayoutItem(layoutSize: largeItemSize)
      largeItem.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)

      let verticalSmallItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
      let verticalSmallItem = NSCollectionLayoutItem(layoutSize: verticalSmallItemSize)
      verticalSmallItem.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)

      let horizontalSmallItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.333), heightDimension: .fractionalHeight(1))
      let horizontalSmallItem = NSCollectionLayoutItem(layoutSize: horizontalSmallItemSize)
      horizontalSmallItem.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)

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

      return UICollectionViewCompositionalLayout(section: section)
    }()
    return compositionalLayout
  }
}
