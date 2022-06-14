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
      $0.minimumLineSpacing = 10
      $0.minimumInteritemSpacing = 10
    }
  ).then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .yellow
    $0.showsHorizontalScrollIndicator = false
  }

  let gradientImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
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
    $0.backgroundColor = .purple
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

    NSLayoutConstraint.activate([
      self.tagCollectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
      self.tagCollectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      self.tagCollectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
      self.tagCollectionView.heightAnchor.constraint(equalToConstant: 60),

      self.feedCollectionView.topAnchor.constraint(equalTo: self.tagCollectionView.bottomAnchor),
      self.feedCollectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      self.feedCollectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
      self.feedCollectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
}
