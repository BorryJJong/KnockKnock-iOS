//
//  ChallengeDetailViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/05/10.
//

import UIKit

import KKDSKit

protocol ChallengeDetailViewProtocol {
  var interactor: ChallengeDetailInteractorProtocol? { get set }
  var router: ChallengeDetailRouterProtocol? { get set }

  func getChallengeDetail(challengeDetail: ChallengeDetail)
}

final class ChallengeDetailViewController: BaseViewController<ChallengeDetailView> {

  // MARK: - Properties

  var interactor: ChallengeDetailInteractorProtocol?
  var router: ChallengeDetailRouterProtocol?

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
    action: nil
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
    self.interactor?.getChallengeDetail()
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
  }

  private func setNavigationItem() {
    let topAppearance = UINavigationBarAppearance().then {
      $0.configureWithOpaqueBackground()
      $0.backgroundColor = .clear
      $0.shadowImage = UIImage()
      $0.shadowColor = .clear
    }

    let scrollAppearance = UINavigationBarAppearance().then {
      $0.configureWithOpaqueBackground()
      $0.backgroundColor = .white
      $0.shadowImage = UIImage()
      $0.shadowColor = .clear
    }

    self.navigationController?.interactivePopGestureRecognizer?.delegate = self

    self.navigationController?.navigationBar.standardAppearance = scrollAppearance
    self.navigationController?.navigationBar.scrollEdgeAppearance = topAppearance
    self.navigationController?.navigationBar.isTranslucent = true
    self.navigationController?.navigationBar.tintColor = .white

    self.navigationItem.leftBarButtonItem = self.backBarButtonItem
    self.navigationItem.rightBarButtonItems = [self.shareBarButtonItem, self.homeBarButtonItem]
  }

  @objc func tapBackBarButton(_ sender: UIBarButtonItem) {
    self.navigationController?.popViewController(animated: true)
  }
}

// MARK: - Bind

extension ChallengeDetailViewController: ChallengeDetailViewProtocol {
  func getChallengeDetail(challengeDetail: ChallengeDetail) {
    self.challengeDetail = challengeDetail
  }
}

// MARK: - CollectionView delegate, datasource

extension ChallengeDetailViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    guard let contents = self.challengeDetail?.contents else { return 0 }
    
    return contents.count
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
      cell.bind(challengeContent: challengeDetail.contents[indexPath.item])
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

extension ChallengeDetailViewController: UIGestureRecognizerDelegate {
}
