//
//  StoreListViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/22.
//

import UIKit

final class StoreListViewController: BaseViewController<StoreListView> {

  // MARK: - Properties

  var interactor: StoreListInteractorProtocol?
  
  private var storeList: [StoreDetail] = []

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupConfigure()

    self.interactor?.fetchStoreDetailList()
  }

  override func setupConfigure() {
    self.navigationItem.title = "인증된 스토어"
    self.navigationItem.titleView?.tintColor = .black
    self.containerView.storeCollectionView.do {
      $0.delegate = self
      $0.dataSource = self
      $0.registCell(type: StoreListCell.self)
    }
  }
}

extension StoreListViewController: StoreListViewProtocol {
  func fetchStoreList(storeList: [StoreDetail]) {
    self.storeList = storeList

    DispatchQueue.main.async {
      self.containerView.storeCollectionView.reloadData()
    }
  }
}

extension StoreListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
//    print(self.storeList.count)
    return self.storeList.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueCell(
      withType: StoreListCell.self,
      for: indexPath
    )
    let isLast = indexPath.item == (self.storeList.count - 1)
    cell.setSeparatorLineView(isLast: isLast)
    cell.bind(store: self.storeList[indexPath.item])

    return cell
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(
      width: self.containerView.frame.width - 40,
      height: 95
    )
  }
}
