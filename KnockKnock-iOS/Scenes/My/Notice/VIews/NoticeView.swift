//
//  NoticeView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/10/31.
//

import UIKit

import Then
import SnapKit

final class NoticeView: UIView {

  // MARK: - Constants

  private enum Metric {
    static let noticeCollectionViewTopMargin = 20.f
  }

  // MARK: - UIs

  let noticeCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then {
      $0.scrollDirection = .vertical
    }).then {
      $0.backgroundColor = .clear
    }

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
    [self.noticeCollectionView].addSubViews(self)

    self.noticeCollectionView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
      $0.top.equalTo(self.safeAreaLayoutGuide).offset(Metric.noticeCollectionViewTopMargin)
    }
  }

  func setNoticeCollectionViewLayout() -> UICollectionViewCompositionalLayout {

    let estimatedHeigth: CGFloat = 55

    let noticeItemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .estimated(estimatedHeigth)
    )
    let noticeItem = NSCollectionLayoutItem(layoutSize: noticeItemSize)

    let noticeGroupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .estimated(estimatedHeigth)
    )
    let noticeGroup = NSCollectionLayoutGroup.vertical(
      layoutSize: noticeGroupSize,
      subitems: [noticeItem]
    )

    let section = NSCollectionLayoutSection(group: noticeGroup)
    section.interGroupSpacing = 20

    let layout = UICollectionViewCompositionalLayout(section: section)

    return layout
  }

}
