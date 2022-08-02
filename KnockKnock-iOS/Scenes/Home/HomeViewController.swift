//
//  HomeViewController.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/02/26.
//

import UIKit

import Then

final class HomeViewController: BaseViewController<HomeView> {

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupConfigure()
    self.view.backgroundColor = .lightGray
  }

  override func setupConfigure() {
    self.containerView.homeCollectionView.do {
      $0.dataSource = self
      $0.delegate = self
      $0.registCell(type: HomeMainCell.self)
      $0.collectionViewLayout = self.containerView.mainCollectionViewLayout()
    }
  }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 5
  }

  func numberOfSections(in collectionView: UICollectionView) -> Int {
//    return HomeSection.allCases.countgit
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueCell(withType: HomeMainCell.self, for: indexPath)
    return cell
  }
}
