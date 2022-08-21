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
      $0.setViewControllers([OngoingEventListViewController()], direction: .forward, animated: true, completion: nil)
      $0.delegate = self
      $0.dataSource = self
    }
  }

  // MARK: - Pager 이동 애니메이션 메소드

  private func movePager(currentPage: Int) {
    print(currentPage)
    UIView.animate(withDuration: 0.5, animations: {
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

    // collectionView 에서 선택한 경우
    let direction: UIPageViewController.NavigationDirection = oldValue < newValue ? .forward : .reverse
    self.containerView.eventPageViewController.setViewControllers([eventViewControllers[currentPage]], direction: direction, animated: true, completion: nil)
    // pageViewController에서 paging한 경우
    self.containerView.tapCollectionView.selectItem(at: IndexPath(item: currentPage, section: 0), animated: true, scrollPosition: .left)
//    self.movePager(currentPage: currentPage)
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
    self.movePager(currentPage: indexPath.item)
    self.currentPage = indexPath.item
  }
}

extension EventPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    return OngoingEventListViewController()
  }

  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    return ClosedEventListViewController()
  }
}
