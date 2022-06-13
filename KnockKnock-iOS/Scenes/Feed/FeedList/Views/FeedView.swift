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
    }
  ).then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .yellow
  }

  let gradientImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
  }

  let feedCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then {
      $0.scrollDirection = .vertical
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
      self.tagCollectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
      self.tagCollectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
      self.tagCollectionView.heightAnchor.constraint(equalToConstant: 60),

      self.feedCollectionView.topAnchor.constraint(equalTo: self.tagCollectionView.bottomAnchor),
      self.feedCollectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
      self.feedCollectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
      self.feedCollectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
}
