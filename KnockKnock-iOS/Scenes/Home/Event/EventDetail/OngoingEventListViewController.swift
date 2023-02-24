//
//  OngoingEventListViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/19.
//

import UIKit

final class OngoingEventListViewController: BaseViewController<EventListView> {

  // MARK: - Properties

  private var ongoingEventList: [EventDetail] = []
  
  var repository: EventRepositoryProtocol?

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()

    self.setupConfigure()
    self.fetchEventDetailList()
  }

  // MARK: - Configure

  override func setupConfigure() {
    self.containerView.eventCollectionView.do {
      $0.delegate = self
      $0.dataSource = self
      $0.registCell(type: EventCell.self)
    }
  }

  /// 이벤트 상세 목록 조회
  private func fetchEventDetailList() {
    
    Task{

      self.ongoingEventList = await self.repository?.requestEventDetailList(
        eventTapType: .ongoing
      ) ?? []

      await MainActor.run {
        self.containerView.showResult(hasData: self.ongoingEventList.count != 0)
        self.containerView.eventCollectionView.reloadData()
      }

    }
  }
}

  // MARK: - CollectionView DataSource, Delegate

extension OngoingEventListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return self.ongoingEventList.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueCell(
      withType: EventCell.self,
      for: indexPath
    )

    let eventDetail = self.ongoingEventList[indexPath.item]

    let event = Event(
      id: eventDetail.id,
      isNewBadge: eventDetail.isNewBadge,
      title: eventDetail.title,
      eventPeriod: eventDetail.eventPeriod,
      image: eventDetail.image
    )

    cell.bind(event: event)
    
    return cell
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {

    let width = self.containerView.frame.width - 40

    return CGSize(
      width: width,
      height: width/2
    )
  }

  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    guard let url = self.ongoingEventList[indexPath.item].url else { return }

    UIApplication.shared.open(url)
  }
}
