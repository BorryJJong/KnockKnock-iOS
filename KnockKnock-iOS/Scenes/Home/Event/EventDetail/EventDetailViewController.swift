//
//  EventDetailViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/02/15.
//

import UIKit

import Then
import KKDSKit

final class EventDetailViewController: BaseViewController<EventDetailView> {

  // MARK: - Properties

  var eventViewControllers: [UIViewController] = []

  private enum TapMenu: String, CaseIterable {
    case ongoing = "진행 이벤트"
    case end = "종료 이벤트"
  }

  private var currentPage: Int = 0 {
    didSet {
      self.bind(
        oldValue: oldValue,
        newValue: currentPage
      )
    }
  }

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()

    self.setupConfigure()
  }

  // MARK: - Configure

  override func setupConfigure() {
    self.navigationItem.title = "이벤트"

    self.containerView.tapCollectionView.do {
      $0.delegate = self
      $0.dataSource = self
      $0.registCell(type: TapCell.self)
    }

    self.containerView.eventPageViewController.do {
      $0.delegate = self
      $0.dataSource = self

      if let firstViewController = eventViewControllers.first {
        $0.setViewControllers(
          [firstViewController],
          direction: .forward,
          animated: true,
          completion: nil
        )
      }
    }
  }

  // MARK: - Bind

  private func bind(
    oldValue: Int,
    newValue: Int
  ) {

    let direction: UIPageViewController.NavigationDirection = oldValue < newValue
    ? .forward
    : .reverse

    DispatchQueue.main.async {
      self.containerView.eventPageViewController.setViewControllers(
        [self.eventViewControllers[self.currentPage]],
        direction: direction,
        animated: true,
        completion: nil
      )
      
      self.movePager(currentPage: self.currentPage)
      self.containerView.tapCollectionView.reloadData()
    }
  }

  // MARK: - Pager 이동 애니메이션 메소드

  private func movePager(currentPage: Int) {
    UIView.animate(withDuration: 0.2, animations: {
      self.containerView.underLineView.transform = CGAffineTransform(
        translationX: CGFloat(100 * currentPage),
        y: 0
      )
    })
  }
}

// MARK: - CollectionView Delegate, DataSource

extension EventDetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {

    return TapMenu.allCases.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {

    let cell = collectionView.dequeueCell(
      withType: TapCell.self,
      for: indexPath
    )

    cell.bind(
      tapName: TapMenu.allCases[indexPath.item].rawValue,
      isSelected: indexPath.item == currentPage
    )

    return cell
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {

    return CGSize(
      width: 70,
      height: 40
    )
  }

  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {

    self.currentPage = indexPath.item
  }
}

// MARK: - PageViewController DataSource, Delegate

extension EventDetailViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {

  func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerBefore viewController: UIViewController
  ) -> UIViewController? {

    guard let index = self.eventViewControllers.firstIndex(
      of: viewController as! BaseViewController<EventListView>
    ) else {
      return nil
    }

    let previousIndex = index - 1

    if previousIndex < 0 {
      return nil
    }

    return self.eventViewControllers[previousIndex]
  }

  func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerAfter viewController: UIViewController
  ) -> UIViewController? {
    guard let index = self.eventViewControllers.firstIndex(
      of: viewController as! BaseViewController<EventListView>
    ) else {
      return nil
    }

    let nextIndex = index + 1

    if nextIndex == self.eventViewControllers.count {
      return nil
    }
    return self.eventViewControllers[nextIndex]
  }

  func pageViewController(
    _ pageViewController: UIPageViewController,
    didFinishAnimating finished: Bool,
    previousViewControllers: [UIViewController],
    transitionCompleted completed: Bool
  ) {

    if completed {
      if previousViewControllers.first == self.eventViewControllers[0] {
        self.currentPage = 1
      } else {
        self.currentPage = 0
      }
    }
  }
}
