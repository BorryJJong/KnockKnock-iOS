//
//  ChallengeDetailView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/05/10.
//

import UIKit

import Then
import KKDSKit

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
    }

  private let backgroundGradientImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = KKDS.Image.ic_background_gradient_90_wh
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
    [self.challengeDetailCollectionView, self.backgroundGradientImageView, self.participateButton].addSubViews(self)

    NSLayoutConstraint.activate([
      // 27 branch merge 이후에 top constant 값 변경 필요(UIDevice extension)
      self.challengeDetailCollectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: -100),
      self.challengeDetailCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      self.challengeDetailCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      self.challengeDetailCollectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: Metric.challengDetailCollectionViewBottomMargin),

      self.backgroundGradientImageView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
      self.backgroundGradientImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      self.backgroundGradientImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      self.backgroundGradientImageView.topAnchor.constraint(equalTo: self.participateButton.topAnchor, constant: Metric.backgroundGradientImageViewTopMargin),

      self.participateButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: Metric.participateButtonBottomMargin),
      self.participateButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.participateButtonLeadingMargin),
      self.participateButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.participateButtonTrailingMargin),
      self.participateButton.heightAnchor.constraint(equalToConstant: Metric.participateButtonHeight)
    ])
  }

  func challengeCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    let estimatedHeigth: CGFloat = 400

    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(estimatedHeigth))
    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)

    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                          heightDimension: .estimated(estimatedHeigth))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(estimatedHeigth))
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

    let section = NSCollectionLayoutSection(group: group)
    section.boundarySupplementaryItems = [header]

    let layout = UICollectionViewCompositionalLayout(section: section)

    return layout
  }
}
