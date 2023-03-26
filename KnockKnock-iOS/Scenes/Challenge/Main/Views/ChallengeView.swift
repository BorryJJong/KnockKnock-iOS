//
//  ChallengeView.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/03/05.
//

import UIKit

import Then
import KKDSKit

final class ChallengeView: UIView {

  // MARK: - Constants

  private enum Metric {
    static let headerViewTopMargin = 16.f
    static let headerViewHeight = 30.f
    static let headerViewLeadingMargin = 20.f
    static let headerViewTrailingMargin = -20.f

    static let challengeCollectionViewTopMargin = 15.f
  }

  // MARK: - UI

  let challengeCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: .init()
  ).then {
    let flowLayout = UICollectionViewFlowLayout.init()
    flowLayout.scrollDirection = .vertical
    $0.collectionViewLayout = flowLayout
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .white
  }

  let totalChallengeLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.textColor = KKDS.Color.green50
    $0.font = .boldSystemFont(ofSize: 13)
  }

  let numOfNewChallengeLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.textColor = KKDS.Color.gray60
    $0.font = .systemFont(ofSize: 13)
  }

  let sortChallengeButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.contentVerticalAlignment = .top
    $0.setTitleColor(KKDS.Color.gray80, for: .normal)
    $0.setTitle("최신순", for: .normal)
    $0.setImage(KKDS.Image.ic_down_20_gr, for: .normal)
    $0.semanticContentAttribute = .forceRightToLeft
    $0.titleLabel?.font = .systemFont(ofSize: 13)
  }

  let headerView = UIView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  // MARK: - Initialize
  
  init() {
    super.init(frame: .zero)
    self.setupConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: - Bind

  func setSortButton(sortType: ChallengeSortType) {
    switch sortType {
    case .new:
      self.sortChallengeButton.setTitle("최신순", for: .normal)
      
    case .popular:
      self.sortChallengeButton.setTitle("인기순", for: .normal)
    }
  }

  func setCountLabel(totalCount: Int?, newCount: Int?) {
    self.totalChallengeLabel.text = "총 \(totalCount ?? 0)개"
    self.numOfNewChallengeLabel.text = " • 신규 \(newCount ?? 0)개"
  }

  // MARK: - Constraints
  
  private func setupConstraints() {
    [self.numOfNewChallengeLabel, self.totalChallengeLabel, self.sortChallengeButton].addSubViews(self.headerView)
    [self.headerView, self.challengeCollectionView].addSubViews(self)

    NSLayoutConstraint.activate([
      self.headerView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: Metric.headerViewTopMargin),
      self.headerView.heightAnchor.constraint(equalToConstant: Metric.headerViewHeight),
      self.headerView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.headerViewLeadingMargin),
      self.headerView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.headerViewTrailingMargin),

      self.totalChallengeLabel.centerYAnchor.constraint(equalTo: self.headerView.centerYAnchor),
      self.totalChallengeLabel.leadingAnchor.constraint(equalTo: self.headerView.leadingAnchor),

      self.numOfNewChallengeLabel.centerYAnchor.constraint(equalTo: self.headerView.centerYAnchor),
      self.numOfNewChallengeLabel.leadingAnchor.constraint(equalTo: self.totalChallengeLabel.trailingAnchor),

      self.sortChallengeButton.trailingAnchor.constraint(equalTo: self.headerView.trailingAnchor),
      self.sortChallengeButton.centerYAnchor.constraint(equalTo: self.headerView.centerYAnchor),

      self.challengeCollectionView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: Metric.challengeCollectionViewTopMargin),
      self.challengeCollectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
      self.challengeCollectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
      self.challengeCollectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
    ])
  }

  func challengeCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    let estimatedHeigth: CGFloat = 300

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
    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)

    let layout = UICollectionViewCompositionalLayout(section: section)

    return layout
  }
}
