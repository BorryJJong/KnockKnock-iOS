//
//  ChallengeDetailViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/05/10.
//

import UIKit

import KKDSKit

protocol ChallengeDetailViewProtocol: AnyObject {
  var interactor: ChallengeDetailInteractorProtocol? { get set }

  func getChallengeDetail(challengeDetail: ChallengeDetail)
}

final class ChallengeDetailViewController: BaseViewController<ChallengeDetailView> {

  // MARK: - Properties

  var interactor: ChallengeDetailInteractorProtocol?
  
  var challengeId: Int = 12
  var challengeDetail: ChallengeDetail?

  lazy var backBarButtonItem = UIBarButtonItem(
    image: KKDS.Image.ic_back_24_wh,
    style: .plain,
    target: self,
    action: #selector(tapBackBarButton(_:))
  )

  lazy var shareBarButtonItem = UIBarButtonItem(
    image: KKDS.Image.ic_gnb_share_24_wh,
    style: .plain,
    target: self,
    action: #selector(self.shareBarButtonDidTap(_:))
  )

  lazy var homeBarButtonItem = UIBarButtonItem(
    image: KKDS.Image.ic_gnb_home_24_wh,
    style: .plain,
    target: self,
    action: nil
  )

  // MARK: - Life cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.interactor?.getChallengeDetail(challengeId: challengeId)
  }

  override func viewWillAppear(_ animated: Bool) {
    self.tabBarController?.tabBar.isHidden = true
  }

  // MARK: - Configure

  override func setupConfigure() {
    self.setNavigationItem()
    self.containerView.challengeDetailCollectionView.do {
      $0.delegate = self
      $0.dataSource = self
      $0.registCell(type: ChallengeDetailCell.self)
      $0.registHeaderView(type: ChallengeDetailHeaderCollectionReusableView.self)
      $0.collectionViewLayout = self.containerView.challengeCollectionViewLayout()
    }

    self.containerView.participateButton.addTarget(
      self,
      action: #selector(self.participateButtonDidTap(_:)),
      for: .touchUpInside
    )
  }

  private func setNavigationItem() {
    let topAppearance = UINavigationBarAppearance().then {
      $0.configureWithOpaqueBackground()
      $0.configureWithTransparentBackground()
    }

    let scrollAppearance = UINavigationBarAppearance().then {
      $0.configureWithOpaqueBackground()
      $0.backgroundColor = .white
      $0.shadowImage = UIImage()
      $0.shadowColor = .clear
    }

    self.navigationController?.navigationBar.standardAppearance = scrollAppearance
    self.navigationController?.navigationBar.scrollEdgeAppearance = topAppearance

    self.navigationController?.navigationBar.setDefaultAppearance()
    self.navigationController?.navigationBar.tintColor = .white

    self.navigationItem.leftBarButtonItem = self.backBarButtonItem
    self.navigationItem.rightBarButtonItems = [self.shareBarButtonItem, self.homeBarButtonItem]
  }

  @objc
  func tapBackBarButton(_ sender: UIBarButtonItem) {
    self.interactor?.popChallengeDetailView()
  }

  @objc
  func shareBarButtonDidTap(_ sender: UIBarButtonItem) {
    self.interactor?.shareChallenge(challengeData: self.challengeDetail)
  }

  @objc
  func participateButtonDidTap(_ sender: UIButton) {
    self.interactor?.presentToFeedWrite(challengeId: self.challengeId)
  }
}

// MARK: - Bind

extension ChallengeDetailViewController: ChallengeDetailViewProtocol {
  func getChallengeDetail(challengeDetail: ChallengeDetail) {
    self.challengeDetail = challengeDetail
    
    DispatchQueue.main.async {
      self.containerView.challengeDetailCollectionView.reloadData()
    }
  }
}

// MARK: - CollectionView delegate, datasource

extension ChallengeDetailViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    guard let contents = self.challengeDetail?.content else { return 0 }
    
    return contents.subContents.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueCell(
      withType: ChallengeDetailCell.self,
      for: indexPath
    )

    if let challengeDetail = self.challengeDetail {
      let isLast = challengeDetail.content.subContents.count - 1 == indexPath.item

      cell.bind(challengeContent: challengeDetail.content.subContents[indexPath.item], isLast: isLast)
    }

    return cell
  }

  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryHeaderView(
      withType: ChallengeDetailHeaderCollectionReusableView.self,
      for: indexPath
    )

    if let challengeDetail = self.challengeDetail {

      header.bind(challengeDetail: challengeDetail)
    }

    return header
  }
}

extension ChallengeDetailViewController: UICollectionViewDelegateFlowLayout {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y <= 0 {
      self.navigationController?.navigationBar.tintColor = .white
    } else {
      self.navigationController?.navigationBar.tintColor = .black
    }
  }
}
