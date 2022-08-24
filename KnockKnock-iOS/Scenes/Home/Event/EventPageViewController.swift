//
//  EventListViewContoller.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/12.
//

import UIKit

import Then

final class EventPageViewController: BaseViewController<EventPageView> {

  // MARK: - Properties

  let eventViewControllers = [OngoingEventListViewController(), ClosedEventListViewController()]

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupConfigure()
  }

  // MARK: - Configure

  override func setupConfigure() {
    self.containerView.tapCollectionView.do {
      $0.delegate = self
      $0.dataSource = self
      $0.registCell(type: TapCell.self)
    }
    self.containerView.eventPageViewController.do {
      if let firstViewController = eventViewControllers.first {
        $0.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
      }
      $0.delegate = self
      $0.dataSource = self
    }
  }

  // MARK: - Pager 이동 애니메이션 메소드

  private func movePager(currentPage: Int) {
    print(currentPage)
    UIView.animate(withDuration: 0.3, animations: {
      self.containerView.underLineView.transform = CGAffineTransform(
        translationX: CGFloat(100 * currentPage),
        y: 0
      )
    })
  }

  var currentPage: Int = 0 {
    didSet {
      bind(oldValue: oldValue, newValue: currentPage)
    }
  }

  private func bind(oldValue: Int, newValue: Int) {
    let direction: UIPageViewController.NavigationDirection = oldValue < newValue ? .forward : .reverse

    self.containerView.eventPageViewController.setViewControllers([eventViewControllers[currentPage]], direction: direction, animated: true, completion: nil)
    self.movePager(currentPage: currentPage)
  }
}

// MARK: - CollectionView Delegate, DataSource

extension EventPageViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 2
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueCell(withType: TapCell.self, for: indexPath)

    return cell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 70, height: 40)
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.currentPage = indexPath.item
  }
}

// MARK: - PageViewController DataSource, Delegate

extension EventPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let index = eventViewControllers.firstIndex(of: viewController as! BaseViewController<EventListView>) else { return nil }
    let previousIndex = index - 1

    if previousIndex < 0 {
      return nil
    }
    return eventViewControllers[previousIndex]
  }

  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let index = eventViewControllers.firstIndex(of: viewController as! BaseViewController<EventListView>) else { return nil }
    let nextIndex = index + 1

    if nextIndex == eventViewControllers.count {
      return nil
    }
    return eventViewControllers[nextIndex]
  }

  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    if completed {
      if previousViewControllers.first == eventViewControllers[0] {
        self.currentPage = 1
      } else {
        self.currentPage = 0
      }
    }
  }
}
