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

  func fetchChallenges(
    challenges: Challenge,
    sortType: ChallengeSortType
  )

  func showAlertView(
    message: String,
    isCancelActive: Bool?,
    confirmAction: (() -> Void)?
  )
}

final class ChallengeViewController: BaseViewController<ChallengeView> {
  
  // MARK: Properties
  
  var interactor: ChallengeInteractorProtocol?

  var challenges: Challenge?
  
  // MARK: - Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setNavigationItem()
    self.interactor?.fetchChallenge(sortType: ChallengeSortType.new)
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

extension ChallengeViewController: ChallengeViewProtocol, AlertProtocol {

  func fetchChallenges(
    challenges: Challenge,
    sortType: ChallengeSortType
  ) {
    self.challenges = challenges

    DispatchQueue.main.async {
      self.containerView.setSortButton(sortType: sortType)
      self.containerView.setCountLabel(
        totalCount: self.challenges?.challengeTotalCount,
        newCount: self.challenges?.challengeNewCount
      )
      self.containerView.challengeCollectionView.reloadData()
    }
  }

  /// Alert 팝업 창
  func showAlertView(
    message: String,
    isCancelActive: Bool? = false,
    confirmAction: (() -> Void)? = nil
  ) {
    DispatchQueue.main.async {
      self.showAlert(
        message: message,
        isCancelActive: isCancelActive,
        confirmAction: confirmAction
      )
    }
  }
}

// MARK: - UICollectionView Data Source

extension ChallengeViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int) -> Int {
      return self.challenges?.challengeTotalCount ?? 0
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {

    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: ChallengeCell.reusableIdentifier,
      for: indexPath)
    as! ChallengeCell

    let challenge = self.challenges?.challenges[indexPath.row]

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

    guard let id = challenges?.challenges[indexPath.item].id else { return }

    self.interactor?.navigateToChallengeDetail(
      challengeId: id
    )
  }
}
