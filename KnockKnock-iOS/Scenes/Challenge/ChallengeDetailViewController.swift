//
//  ChallengeDetailViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/05/10.
//

import UIKit

class ChallengeDetailViewController: BaseViewController<ChallengeDetailView> {

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
    let backBarButtonItem = UIBarButtonItem(
      image: UIImage(named: "ic_back_24_wh"),
      style: .plain,
      target: self,
      action: #selector(tapBackBarButton(_:)))
    let shareBarButtonItem = UIBarButtonItem(
      image: UIImage(named: "ic_gnb_share_24_wh"),
      style: .plain,
      target: self,
      action: nil)
    let homeBarBUttonItem = UIBarButtonItem(
      image: UIImage(named: "ic_gnb_home_24_wh"),
      style: .plain,
      target: self,
      action: nil)

    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
    self.navigationController?.view.backgroundColor = UIColor.clear

    self.navigationItem.leftBarButtonItem = backBarButtonItem
    self.navigationItem.rightBarButtonItems = [shareBarButtonItem, homeBarBUttonItem]
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
}
