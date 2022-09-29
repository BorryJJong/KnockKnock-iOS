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
  var router: ChallengeRouterProtocol? { get set }

  func fetchChallenges(challenges: [Challenges])
}

final class ChallengeViewController: BaseViewController<ChallengeView> {
  
  // MARK: Properties
  
  var interactor: ChallengeInteractorProtocol?
  var router: ChallengeRouterProtocol?

  var challenges: [Challenges] = []
  
  // MARK: - Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setNavigationItem()
    self.interactor?.fetchChallenge()
  }

  override func viewWillAppear(_ animated: Bool) {
    self.tabBarController?.tabBar.isHidden = false
    self.setNavigationItem()
  }

  override func setupConfigure() {
    self.containerView.challengeCollectionView.do {
      $0.delegate = self
      $0.dataSource = self
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

  @objc func tapSortChallengeButton(_ sender: UIButton) {
    let bottomSheetViewController = BottomSheetViewController()
    bottomSheetViewController.setBottomSheetContents(contents: ["수정", "삭제"])
    bottomSheetViewController.modalPresentationStyle = .overFullScreen
    self.present(bottomSheetViewController, animated: false, completion: nil)
  }
}

extension ChallengeViewController: ChallengeViewProtocol {
  func fetchChallenges(challenges: [Challenges]) {
    self.challenges = challenges
    self.containerView.challengeCollectionView.reloadData()
  }
}

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
      for: indexPath) as! ChallengeCell
    let challenge = self.challenges[indexPath.row]
    cell.backgroundColor = .white
    cell.bind(data: challenge)
    return cell
  }
}

extension ChallengeViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(
      width: (self.containerView.frame.width - 40),
      height: (self.containerView.frame.height - 100) / 2)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 40
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 20
  }
}

extension ChallengeViewController: UICollectionViewDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    self.router?.navigateToChallengeDetail(
      source: self,
      challengeId: challenges[indexPath.item].id
    )
  }
}
