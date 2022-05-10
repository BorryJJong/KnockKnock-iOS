//
//  ChallengeView.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/03/05.
//

import UIKit

import Then

final class ChallengeView: UIView {
  
  // MARK: - UI

  let challengeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    let flowLayout = UICollectionViewFlowLayout.init()
    flowLayout.scrollDirection = .vertical
    $0.collectionViewLayout = flowLayout
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .white
    $0.register(ChallengeCell.self, forCellWithReuseIdentifier: "cell")
  }
  
  // MARK: - Initialize
  
  init() {
    super.init(frame: .zero)
    self.setupConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  private func setupConstraints() {
    [self.challengeCollectionView].addSubViews(self)
    
    NSLayoutConstraint.activate([
      self.challengeCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
      self.challengeCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      self.challengeCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      self.challengeCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
    ])
  }
}
