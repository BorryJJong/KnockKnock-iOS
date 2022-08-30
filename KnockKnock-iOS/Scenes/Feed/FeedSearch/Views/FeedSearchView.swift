//
//  FeedSearchView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/30.
//

import UIKit

import SnapKit
import KKDSKit
import Then

class FeedSearchView: UIView {

  // MARK: - UIs

  let searchTapCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then {
      $0.scrollDirection = .horizontal
    }
  )

  let underLineView = UIView().then {
    $0.backgroundColor = .green40
  }

  private let separatorLineView = UIView().then {
    $0.backgroundColor = .gray20
  }

  let searchResultCollectionView =  UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then {
      $0.scrollDirection = .horizontal
    }
  )
  
  // MARK: - Initialize

  override init(frame: CGRect) {
    super.init(frame: .zero)
    self.setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Configure

  private func setupConstraints() {
    [self.searchTapCollectionView, self.underLineView, self.separatorLineView, self.searchResultCollectionView].addSubViews(self)

    self.searchTapCollectionView.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide)
      $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
      $0.height.equalTo(40)
    }

    self.underLineView.snp.makeConstraints {
      $0.top.equalTo(self.searchTapCollectionView.snp.bottom).offset(5)
      $0.leading.equalTo(self.searchTapCollectionView.snp.leading)
      $0.width.equalTo(25)
      $0.height.equalTo(2)
    }

    self.separatorLineView.snp.makeConstraints {
      $0.top.equalTo(self.underLineView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(1)
    }

    self.searchResultCollectionView.snp.makeConstraints {
      $0.top.equalTo(self.separatorLineView.snp.bottom).offset(15)
      $0.trailing.leading.equalTo(self.safeAreaLayoutGuide).inset(20)
      $0.bottom.equalTo(self.safeAreaLayoutGuide)
    }
  }
}
