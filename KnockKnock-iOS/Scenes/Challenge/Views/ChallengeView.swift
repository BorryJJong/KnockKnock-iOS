//
//  ChallengeView.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/03/05.
//

import UIKit

import Then

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

  let challengeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    let flowLayout = UICollectionViewFlowLayout.init()
    flowLayout.scrollDirection = .vertical
    $0.collectionViewLayout = flowLayout
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .white
    $0.register(ChallengeCell.self, forCellWithReuseIdentifier: "cell")
  }

  let totalChallengeLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.textColor = .green50
    $0.font = .boldSystemFont(ofSize: 13)
    $0.text = "총 10개"
  }

  let numOfNewChallengeLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.textColor = .gray60
    $0.font = .systemFont(ofSize: 13)
    $0.text = " • 신규 2개"
  }

  let sortChallengeButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.contentVerticalAlignment = .top
    $0.setTitleColor(.gray80, for: .normal)
    $0.setTitle("최신순 ∨", for: .normal)
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
  
  private func setupConstraints() {
      [self.numOfNewChallengeLabel, self.totalChallengeLabel, self.sortChallengeButton].addSubViews(self.headerView)
      [self.headerView, self.challengeCollectionView].addSubViews(self)

      NSLayoutConstraint.activate([

        self.headerView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: Metric.headerViewTopMargin),
        self.headerView.heightAnchor.constraint(equalToConstant: Metric.headerViewHeight),
        self.headerView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.headerViewLeadingMargin),
        self.headerView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.headerViewTrailingMargin),

        self.totalChallengeLabel.topAnchor.constraint(equalTo: self.headerView.topAnchor),
        self.totalChallengeLabel.bottomAnchor.constraint(equalTo: self.headerView.bottomAnchor),
        self.totalChallengeLabel.leadingAnchor.constraint(equalTo: self.headerView.leadingAnchor),

        self.numOfNewChallengeLabel.topAnchor.constraint(equalTo: self.headerView.topAnchor),
        self.numOfNewChallengeLabel.bottomAnchor.constraint(equalTo: self.headerView.bottomAnchor),
        self.numOfNewChallengeLabel.leadingAnchor.constraint(equalTo: self.totalChallengeLabel.trailingAnchor),

        self.sortChallengeButton.topAnchor.constraint(equalTo: self.headerView.topAnchor),
        self.sortChallengeButton.trailingAnchor.constraint(equalTo: self.headerView.trailingAnchor),
        self.sortChallengeButton.bottomAnchor.constraint(equalTo: self.headerView.bottomAnchor),

        self.challengeCollectionView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: Metric.challengeCollectionViewTopMargin),
        self.challengeCollectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
        self.challengeCollectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
        self.challengeCollectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
      ])
    }

}
