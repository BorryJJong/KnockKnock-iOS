//
//  ChallengeViewController.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/02/26.
//

import UIKit

import KKDSKit

protocol ChallengeViewProtocol: AnyObject {
  var interactor: ChallengeInteractorProtocol? { get set }

  func fetchChallenges(challenges: [Challenge], sortType: String)
}

final class ChallengeViewController: BaseViewController<ChallengeView> {
  
  // MARK: Properties
  
  var interactor: ChallengeInteractorProtocol?

  var challenges: [Challenge] = []
  
  // MARK: - Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setNavigationItem()
    self.interactor?.fetchChallenge(sortType: ChallengeSortType.new.rawValue)
  }

  override func viewWillAppear(_ animated: Bool) {
    self.tabBarController?.tabBar.isHidden = false
    self.setNavigationItem()
  }

  // MARK: - Configure

  override func setupConfigure() {
    self.containerView.challengeCollectionView.do {
      $0.delegate = self
      $0.dataSource = self
      $0.collectionViewLayout = self.containerView.challengeCollectionViewLayout()
      $0.registCell(type: ChallengeCell.self)
    }
    self.containerView.sortChallengeButton.addTarget(
      self,
      action: #selector(tapSortChallengeButton(_:)),
      for: .touchUpInside)
  }

  func setNavigationItem() {
    let searchBarButtonItem = UIBarButtonItem(
      image: KKDS.Image.ic_search_24_bk,
      style: .plain,
      target: self,
      action: nil
    )

    self.navigationItem.title = "챌린지"
    self.navigationController?.navigationBar.setDefaultAppearance()
    self.navigationItem.rightBarButtonItem = searchBarButtonItem
  }

  // MARK: - Button Actions

  @objc func tapSortChallengeButton(_ sender: UIButton) {
    self.interactor?.presentBottomSheet()
  }
}

// MARK: - Challenge View Protocol

extension ChallengeViewController: ChallengeViewProtocol {
  func fetchChallenges(challenges: [Challenge], sortType: String) {
    self.challenges = challenges

    DispatchQueue.main.async {
      self.containerView.setSortButton(sortType: sortType)
      self.containerView.challengeCollectionView.reloadData()
    }
  }
}

// MARK: - UICollectionView Data Source

extension ChallengeViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int) -> Int {
    return self.challenges.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {

    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: ChallengeCell.reusableIdentifier,
      for: indexPath)
    as! ChallengeCell

    let challenge = self.challenges[indexPath.row]

    cell.backgroundColor = .white

    cell.bind(data: challenge)

    return cell
  }
}

extension ChallengeViewController: UICollectionViewDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    self.interactor?.navigateToChallengeDetail(
      challengeId: challenges[indexPath.item].id
    )
  }
}
