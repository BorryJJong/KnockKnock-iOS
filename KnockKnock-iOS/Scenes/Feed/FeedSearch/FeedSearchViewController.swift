//
//  FeedSearchViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/30.
//

import UIKit

import Then

protocol FeedSearchViewProtocol {
  var interactor: FeedSearchInteractorProtocol? { get set }
  var router: FeedSearchRouterProtocol? { get set }

  func fetchSearchLog(searchKeyword: [SearchKeyword])
}

final class FeedSearchViewController: BaseViewController<FeedSearchView> {

  // MARK: - Properties

  var interactor: FeedSearchInteractorProtocol?
  var router: FeedSearchRouterProtocol?

  private var currentIndex = 0 {
    didSet {
      self.containerView.searchTapCollectionView.reloadData()
      self.movePager()
    }
  }

  var searchKeyword: [SearchKeyword] = [] {
    didSet {
      self.containerView.searchResultPageCollectionView.reloadData()
    }
  }

  // MARK: - Constants

  private enum SearchCollectionViewTag: Int {
    case tap = 0
    case result = 1
  }

  // MARK: - Properties

  private let taps: [String] = ["인기", "계정", "태그", "장소"]

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupConfigure()
    self.interactor?.getSearchLog()
  }

  override func setupConfigure() {
    self.containerView.searchTapCollectionView.do {
      $0.tag = SearchCollectionViewTag.tap.rawValue
      $0.delegate = self
      $0.dataSource = self
      $0.registCell(type: TapCell.self)
    }
    self.containerView.searchResultPageCollectionView.do {
      $0.tag = SearchCollectionViewTag.result.rawValue
      $0.delegate = self
      $0.dataSource = self
      $0.registCell(type: SearchResultPageCell.self)
      $0.isPagingEnabled = true
    }
  }

  // MARK: - Pager 이동 애니메이션 메소드

  private func movePager() {
    UIView.animate(
      withDuration: 0.3,
      animations: {
        self.containerView.underLineView.transform = CGAffineTransform(
          translationX: 50 * self.currentIndex.f,
          y: 0
        )
      }
    )
  }
}

  // MARK: - FeedSearchViewProtocol

extension FeedSearchViewController: FeedSearchViewProtocol {
  func fetchSearchLog(searchKeyword: [SearchKeyword]){
    self.searchKeyword = searchKeyword
  }
}

  // MARK: - CollectionView DataSource, Delegate

extension FeedSearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return SearchTap.allCases.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {

    let collectionViewTag = SearchCollectionViewTag(rawValue: collectionView.tag)

    switch collectionViewTag {

    case .tap:
      let cell = collectionView.dequeueCell(
        withType: TapCell.self,
        for: indexPath
      )
      let isSelected = indexPath.item == self.currentIndex 

      cell.bind(tapName: SearchTap.allCases[indexPath.item].rawValue, isSelected: isSelected)

      return cell

    case .result:
      let cell = collectionView.dequeueCell(
        withType: SearchResultPageCell.self,
        for: indexPath
      )
      cell.bind(index: indexPath, searchKeyword: self.searchKeyword)
      
      return cell

    default:
      assert(false)
    }

  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let collectionViewTag = SearchCollectionViewTag(rawValue: collectionView.tag)

    switch collectionViewTag {

    case .tap:
      return CGSize(
        width: 25,
        height: 40
      )

    case .result:
      return CGSize(
        width: self.containerView.frame.width,
        height: self.containerView.searchResultPageCollectionView.frame.height
      )

    default:
      assert(false)
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    self.currentIndex = indexPath.item

    if collectionView.tag == SearchCollectionViewTag.tap.rawValue {
      self.containerView.searchResultPageCollectionView.scrollToItem(
        at: indexPath,
        at: .centeredHorizontally,
        animated: true
      )
    }
  }

  func scrollViewWillEndDragging(
    _ scrollView: UIScrollView,
    withVelocity velocity: CGPoint,
    targetContentOffset: UnsafeMutablePointer<CGPoint>
  ) {
    let cellWidthIncludingSpacing = UIScreen.main.bounds.size.width
    var offset = targetContentOffset.pointee
    let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
    var roundedIndex = round(index)

    if scrollView.contentOffset.x > targetContentOffset.pointee.x {
      roundedIndex = floor(index)
    } else if scrollView.contentOffset.x < targetContentOffset.pointee.x {
      roundedIndex = ceil(index)
    } else {
      roundedIndex = round(index)
    }

    if self.currentIndex.f > roundedIndex {
      self.currentIndex -= 1
      roundedIndex = self.currentIndex.f
    } else if currentIndex.f < roundedIndex {
      self.currentIndex += 1
      roundedIndex = self.currentIndex.f
    }

    offset = CGPoint(
      x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left,
      y: -scrollView.contentInset.top
    )
    targetContentOffset.pointee = offset
  }
}
