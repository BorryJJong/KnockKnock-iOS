//
//  FeedListViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/22.
//

import UIKit

import Then
import KKDSKit

protocol FeedListViewProtocol: AnyObject {
  var interactor: FeedListInteractorProtocol? { get set }
  var router: FeedListRouterProtocol? { get set }
  
  func fetchFeedList(feedList: FeedList)
}

final class FeedListViewController: BaseViewController<FeedListView> {
  
  // MARK: - Properties
  
  var interactor: FeedListInteractorProtocol?
  var router: FeedListRouterProtocol?
  
  var feedList: FeedList?
  var feedListPost: [FeedListPost] = [] {
    didSet {
      self.containerView.feedListCollectionView.reloadData()
    }
  }

  private var currentPage: Int = 1
  private var pageSize: Int = 1
  var challengeId: Int = 0
  var feedId: Int = 2

  lazy var tapGesture = UITapGestureRecognizer(
    target: self,
    action: #selector(tapScrollViewSection(_:))
  )
  
  // MARK: - Life Cycles
  
  override func viewDidLoad() {
    super.viewDidLoad()
    LoadingIndicator.showLoading()
    
    self.interactor?.fetchFeedList(
      currentPage: self.currentPage,
      pageSize: self.pageSize,
      feedId: self.feedId,
      challengeId: self.challengeId
    )
    self.containerView.addGestureRecognizer(tapGesture)
  }
  
  override func setupConfigure() {
    let backButton = UIBarButtonItem(
      image: KKDS.Image.ic_back_24_bk,
      style: .done,
      target: self,
      action: #selector(backButtonDidTap(_:))
    )

    self.navigationItem.leftBarButtonItem = backButton

    self.containerView.feedListCollectionView.do {
      $0.delegate = self
      $0.dataSource = self
      $0.registCell(type: FeedListCell.self)
      $0.registHeaderView(type: FeedListHeaderReusableView.self)
    }
  }
  
  // MARK: - didSelectItem
  
  /// ScrollView 영역을 포함하여 didSelectItem 호출하기 위한 메소드
  @objc func tapScrollViewSection(_ sender: UITapGestureRecognizer) {
    let collectionView = self.containerView.feedListCollectionView
    
    let touchLocation: CGPoint = sender.location(
      ofTouch: 0,
      in: collectionView
    )
    let indexPath = collectionView.indexPathForItem(at: touchLocation)
    
    if let indexPath = indexPath {
      if let cell = collectionView.cellForItem(at: indexPath) {
        if !cell.isSelected {
          self.router?.navigateToFeedDetail(
            source: self,
            feedId: self.feedListPost[indexPath.section].id
          )
        }
      }
    }
  }

  // MARK: - Button Actions

  @objc private func backButtonDidTap(_ sender: UIButton) {
    self.router?.navigateToFeedMain(source: self)
  }

  @objc func configureButtonDidTap(_ sender: UIButton) {
    self.router?.presentBottomSheetView(source: self)
  }

  @objc func commentButtonDidTap(_ sender: UIButton) {
    self.router?.navigateToCommentView(source: self)
  }
}

// MARK: - Extensions

extension FeedListViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return self.feedListPost.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return 1
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {

    let cell = collectionView.dequeueCell(
      withType: FeedListCell.self,
      for: indexPath
    )

    cell.bind(feedList: self.feedListPost[indexPath.section])
    cell.commentsButton.addTarget(
      self,
      action: #selector(commentButtonDidTap(_:)),
      for: .touchUpInside
    )

    return cell
  }

  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryHeaderView(
      withType: FeedListHeaderReusableView.self,
      for: indexPath
    )

    header.bind(feed: self.feedListPost[indexPath.section])
    header.configureButton.addTarget(
      self,
      action: #selector(self.configureButtonDidTap(_:)),
      for: .touchUpInside
    )

    return header
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let height = scrollView.frame.height
    let contentSizeHeight = scrollView.contentSize.height
    let offset = scrollView.contentOffset.y
    let reachedBottom = (offset + height == contentSizeHeight)

    if reachedBottom {
      scrollViewDidReachBottom(scrollView)
    }
  }

  func scrollViewDidReachBottom(_ scrollView: UIScrollView) {
    if let isNext = self.feedList?.isNext {
      if isNext {
        self.currentPage += 1
        self.interactor?.fetchFeedList(
          currentPage: self.currentPage,
          pageSize: self.pageSize,
          feedId: self.feedId,
          challengeId: self.challengeId
        )
      }
    }
  }
}

extension FeedListViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {

    let scale = feedListPost[indexPath.section].imageScale
    let scaleType = ImageScaleType(rawValue: scale)
    
    return scaleType?.cellSize(width: self.containerView.frame.width) ?? CGSize.init()
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int
  ) -> CGSize {

    return CGSize(
      width: self.containerView.frame.width,
      height: 50
    )
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {

    return UIEdgeInsets(
      top: 10,
      left: 0,
      bottom: 40,
      right: 0
    )
  }
}

extension FeedListViewController: FeedListViewProtocol {
  func fetchFeedList(feedList: FeedList) {
    self.feedList = feedList
    feedList.feeds.forEach {
      self.feedListPost.append($0)
    }
  }
}
