//
//  FeedListView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/22.
//

import UIKit

import Then

class FeedListView: UIView {
  
  // MARK: - UIs

  let feedListCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then {
    $0.scrollDirection = .vertical
    $0.minimumLineSpacing = 50
  }).then {
    $0.translatesAutoresizingMaskIntoConstraints = false
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

  // MARK: - Bind
  
  func setLikeButtonTitle(currentNum: String?, isSelected: Bool) -> String {
    var number = 0
    var newTitle = " "

    let numberFormatter = NumberFormatter().then {
      $0.numberStyle = .decimal
    }

    if let title = currentNum?.filter({ $0.isNumber }) {
      if let titleToInt = Int(title) {
        number = isSelected ? (titleToInt + 1) : (titleToInt - 1)
        newTitle = numberFormatter.string(from: NSNumber(value: number)) ?? ""
      }
    }

    return " \(newTitle)"
  }

  // MARK: - Constraints

  func setupConstraints() {
    [self.feedListCollectionView].addSubViews(self)

    NSLayoutConstraint.activate([
      self.feedListCollectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
      self.feedListCollectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
      self.feedListCollectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
      self.feedListCollectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
}
