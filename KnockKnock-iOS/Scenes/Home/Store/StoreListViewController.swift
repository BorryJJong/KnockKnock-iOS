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
    didSelectItemAt indexPath: IndexPath
  ) {
    guard let kakaoMapScheme = URL(string: "kakaomap://") else { return }

    // 카카오맵으로 연결할 수 있는 기기인지 판별
    if UIApplication.shared.canOpenURL(kakaoMapScheme) {

      // 카카오맵 설치 디바이스인 경우
      guard let url = URL(string: "kakaomap://look?p=37.402056,127.108212") else { return }
      UIApplication.shared.open(url, options: [:], completionHandler: nil)

    } else {
      // 미 설치 디바이스인 경우에는 사파리를 통해 카카오맵 진입하도록 처리
      DispatchQueue.main.async {
        guard let url = URL(string: "https://map.kakao.com/link/map/marker,37.402056,127.108212") else { return }
        UIApplication.shared.open(url, options: [:])
      }
    }
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
