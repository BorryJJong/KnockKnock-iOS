//
//  ChallengeDetailViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/05/10.
//

import UIKit

import KKDSKit

class ChallengeDetailViewController: BaseViewController<ChallengeDetailView> {

  // MARK: - Properties

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

  func setNavigationItem() {
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

    self.navigationItem.leftBarButtonItem = self.backBarButtonItem
    self.navigationItem.rightBarButtonItems = [self.shareBarButtonItem, self.homeBarButtonItem]
  }

  @objc func tapBackBarButton(_ sender: UIBarButtonItem) {
    self.navigationController?.popViewController(animated: true)
  }
}

// MARK: - CollectionView delegate, datasource

extension ChallengeDetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return 3
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueCell(withType: ChallengeDetailCell.self, for: indexPath)
    cell.bind()
    return cell
  }

  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryHeaderView(withType: ChallengeDetailHeaderCollectionReusableView.self, for: indexPath)
    header.bind()
    return header
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y < 0 {
      self.navigationController?.navigationBar.tintColor = .white
    } else {
      self.navigationController?.navigationBar.tintColor = .black
    }
  }
}

extension ChallengeDetailViewController: UIGestureRecognizerDelegate {
}
