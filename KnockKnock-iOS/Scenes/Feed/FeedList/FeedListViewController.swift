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
  func deleteFeedPost(feedId: Int)
}

final class FeedListViewController: BaseViewController<FeedListView> {
  
  // MARK: - Properties
  
  var interactor: FeedListInteractorProtocol?

  private var isNext: Bool = true
  private var feedListPost: [FeedList.Post] = [] {
    didSet {
      self.containerView.feedListCollectionView.reloadData()
    }
  }
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
          self.interactor?.navigateToFeedDetail(
            source: self,
            feedId: self.feedListPost[indexPath.section].id
          )
        }
      }
    }
  }

  // MARK: - Button Actions

  @objc private func backButtonDidTap(_ sender: UIButton) {
    self.interactor?.navigateToFeedMain(source: self)
  }

  @objc func configureButtonDidTap(_ sender: UIButton) {
    let isMyPost = self.feedListPost[sender.tag].isWriter
    let feedId = self.feedListPost[sender.tag].id

    self.interactor?.presentBottomSheetView(
      source: self,
      isMyPost: isMyPost,
      deleteAction: {
        self.interactor?.requestDelete(feedId: feedId)
      }
    )
  }

  @objc func commentButtonDidTap(_ sender: UIButton) {
    self.interactor?.navigateToCommentView(
      feedId: sender.tag,
      source: self
    )
  }

  @objc func likeButtonDidTap(_ sender: UIButton) {
    sender.isSelected.toggle()
    
    let title = self.containerView.setLikeButtonTitle(
      currentNum: sender.titleLabel?.text,
      isSelected: sender.isSelected
    )
    sender.setTitle(title, for: .normal)

    if sender.isSelected {

      self.interactor?.requestLike(
        source: self,
        feedId: sender.tag
      )
    } else {

      self.interactor?.requestLikeCancel(
        source: self,
        feedId: sender.tag
      )
    }
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

    cell.commentsButton.tag = self.feedListPost[indexPath.section].id
    cell.commentsButton.addTarget(
      self,
      action: #selector(self.commentButtonDidTap(_:)),
      for: .touchUpInside
    )
    cell.likeButton.tag = self.feedListPost[indexPath.section].id
    cell.likeButton.addTarget(
      self,
      action: #selector(self.likeButtonDidTap(_:)),
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

extension FeedListViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    
    return CGSize(
      width: (self.containerView.frame.width - 40),
      height: (self.containerView.frame.width - 40) + 100
    )
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
    self.isNext = feedList.isNext
    self.feedListPost += feedList.feeds
  }
  
  func deleteFeedPost(feedId: Int) {
    if let feedIndex = self.feedListPost.firstIndex(where: {
      $0.id == feedId
    }) {
      self.feedListPost.remove(at: feedIndex)
    }
  }
}
