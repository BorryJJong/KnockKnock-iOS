//
//  ClosedEventListViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/19.
//

import UIKit

final class ClosedEventListViewController: BaseViewController<EventListView> {

  // MARK: - Properties

  private var endEventList: [EventDetail] = []
  
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

      self.endEventList = await self.repository?.requestEventDetailList(
        eventTapType: .end
      )?.data ?? []

      await MainActor.run {
        self.containerView.showResult(hasData: self.endEventList.count != 0)
        self.containerView.eventCollectionView.reloadData()
      }

    }
  }
}

// MARK: - CollectionView DataSource, Delegate

extension ClosedEventListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return self.endEventList.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueCell(
      withType: EventCell.self,
      for: indexPath
    )

    let eventDetail = self.endEventList[indexPath.item]

    let event = Event(
      id: eventDetail.id,
      isNewBadge: eventDetail.isNewBadge,
      title: eventDetail.title,
      eventPeriod: eventDetail.eventPeriod,
      image: eventDetail.image
    )

    cell.bind(event: event)
    cell.isClosedEvent(isClosed: true)
    
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
    guard let url = self.endEventList[indexPath.item].url else { return }

    UIApplication.shared.open(url)
  }
}
