//
//  ChallengeDetailView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/05/10.
//

import UIKit

import Then
import KKDSKit
import SnapKit

class ChallengeDetailView: UIView {

  // MARK: - Constants

  private enum Metric {
    static let challengDetailCollectionViewTopMargin = -100.f
    static let challengDetailCollectionViewBottomMargin = -50.f

    static let participateButtonBottomMargin = -10.f
    static let participateButtonLeadingMargin = 20.f
    static let participateButtonTrailingMargin = -20.f
    static let participateButtonHeight = 45.f

    static let backgroundGradientImageViewTopMargin = -50.f
  }

  // MARK: - UIs

  let challengeDetailCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then {
      $0.scrollDirection = .vertical
    }).then {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.backgroundColor = .clear
      $0.contentInsetAdjustmentBehavior = .never
    }

  private let bottomGradientImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = KKDS.Image.ic_bg_gradient_wh
  }

  let participateButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .green50
    $0.setTitle("챌린지 참여하기", for: .normal)
    $0.titleLabel?.textColor = .white
    $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
    $0.layer.cornerRadius = 3
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
    [self.challengeDetailCollectionView, self.bottomGradientImageView, self.participateButton].addSubViews(self)

    self.challengeDetailCollectionView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
    }

    self.bottomGradientImageView.snp.makeConstraints {
      $0.bottom.leading.trailing.equalTo(self.safeAreaLayoutGuide)
      $0.top.equalTo(self.participateButton.snp.top).offset(Metric.backgroundGradientImageViewTopMargin)
    }

    self.participateButton.snp.makeConstraints {
      $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(Metric.participateButtonBottomMargin)
      $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(Metric.participateButtonLeadingMargin)
    }
  }

  func challengeCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    let estimatedHeigth: CGFloat = 200

    let headerSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .estimated(estimatedHeigth)
    )
    let header = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerSize,
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top
    )

    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .estimated(estimatedHeigth)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .estimated(estimatedHeigth)
    )
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

    let section = NSCollectionLayoutSection(group: group)
    section.boundarySupplementaryItems = [header]

    let layout = UICollectionViewCompositionalLayout(section: section)

    return layout
  }
}
