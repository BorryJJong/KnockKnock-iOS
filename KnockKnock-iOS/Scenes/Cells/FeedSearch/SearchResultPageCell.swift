//
//  SearchResultPageCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/30.
//

import UIKit

import Then
import SnapKit

class SearchResultPageCell: BaseCollectionViewCell {

  // MARK: - UIs

  let SearchResultCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then {
      $0.scrollDirection = .vertical
    }
  )

  // MARK: - Configure

  override func setupConfigure() {
    self.SearchResultCollectionView.do {
      $0.delegate = self
      $0.dataSource = self
      $0.registCell(type: SearchResultCell.self)
    }
  }

  override func setupConstraints() {
    [self.SearchResultCollectionView].addSubViews(self.contentView)

    self.SearchResultCollectionView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(20)
    }
  }
}

extension SearchResultPageCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueCell(withType: SearchResultCell.self, for: indexPath)
    cell.backgroundColor = .white
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: self.frame.width, height: 62)
  }

}
