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
  
  func fetchFeedList(feedList: FeedList)
  func updateFeedList(feedList: FeedList, sections: [IndexPath])
  func reloadFeedList()
}

final class FeedListViewController: BaseViewController<FeedListView> {
  
  // MARK: - Properties
  
  var interactor: FeedListInteractorProtocol?

  private var isNext: Bool = true
  private var feedListPost: [FeedList.Post] = []

  private var currentPage: Int = 1
  private var pageSize: Int = 5
  var challengeId: Int = 0
  var feedId: Int = 2

  private lazy var tapGesture = UITapGestureRecognizer(
    target: self,
    action: #selector(tapScrollViewSection(_:))
  )
  
  // MARK: - Life Cycles
  
  override func viewDidLoad() {
    super.viewDidLoad()

    self.interactor?.fetchFeedList(
      currentPage: self.currentPage,
      pageSize: self.pageSize,
      feedId: self.feedId,
      challengeId: self.challengeId
    )
    self.containerView.addGestureRecognizer(tapGesture)
  }

  override func viewWillAppear(_ animated: Bool) {
    self.tabBarController?.tabBar.isHidden = false
  }

  // MARK: - Configure
  
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
          self.interactor?.navigateToFeedDetail(feedId: self.feedListPost[indexPath.section].id)
        }
      }
    }
  }

  // MARK: - Button Actions

  @objc private func backButtonDidTap(_ sender: UIButton) {
    self.interactor?.navigateToFeedMain()
  }

  @objc func configureButtonDidTap(_ sender: UIButton) {
    let isMyPost = self.feedListPost[sender.tag].isWriter
    let feedId = self.feedListPost[sender.tag].id

    self.interactor?.presentBottomSheetView(
      isMyPost: isMyPost,
      deleteAction: {
        self.interactor?.requestDelete(feedId: feedId)
      },
      feedData: self.feedListPost[sender.tag]
    )
  }

  @objc func commentButtonDidTap(_ sender: UIButton) {
    self.interactor?.navigateToCommentView(feedId: sender.tag)
  }

  private func likeButtonDidTap(sender: UIButton) {
    self.interactor?.requestLike(feedId: sender.tag)
  }
}

// MARK: - UICollectionView DataSource

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

    cell.commentsButton.tag = self.feedListPost[indexPath.section].id
    cell.commentsButton.addTarget(
      self,
      action: #selector(self.commentButtonDidTap(_:)),
      for: .touchUpInside
    )
    cell.likeButton.tag = self.feedListPost[indexPath.section].id

    cell.likeButton.addAction(
      for: .touchUpInside,
      closure: {
        self.likeButtonDidTap(sender: $0)
      }
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
    let post = self.feedListPost[indexPath.section]

    header.bind(feed: post)
    header.configureButton.tag = indexPath.section
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
    if self.isNext {
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

// MARK: - UICollectionView Delegate

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

// MARK: - Feed List View Protocol

extension FeedListViewController: FeedListViewProtocol {

  /// 피드 최초 요청 이벤트
  ///
  /// - Parameters:
  ///   - feedList: 최초 요청한 피드리스트
  func fetchFeedList(feedList: FeedList) {
    self.isNext = feedList.isNext
    self.feedListPost = feedList.feeds

    DispatchQueue.main.async {
      self.containerView.feedListCollectionView.reloadData()
    }
  }

  /// 피드 업데이트 이벤트
  ///
  /// - Parameters:
  ///   - feedList: 업데이트 되어진 피드 리스트
  ///   - sections: 업데이트 된 피드의 Sections
  func updateFeedList(feedList: FeedList, sections: [IndexPath]) {
    self.feedListPost = feedList.feeds

    DispatchQueue.main.async {
      UIView.performWithoutAnimation {
        sections.forEach { indexPath in
          self.containerView.feedListCollectionView.reloadSections(IndexSet(integer: indexPath.section))
        }
      }
    }
  }

  /// 로그인/로그아웃 시 피드 데이터 re-fatch & reload
  func reloadFeedList() {
    self.interactor?.fetchFeedList(
      currentPage: self.currentPage,
      pageSize: self.pageSize,
      feedId: self.feedId,
      challengeId: self.challengeId
    )
  }
}
