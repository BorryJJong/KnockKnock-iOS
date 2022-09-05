//
//  FeedListViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/22.
//

import UIKit

import Then

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
  
  lazy var tapGesture = UITapGestureRecognizer(
    target: self,
    action: #selector(tapScrollViewSection(_:))
  )
  
  // MARK: - Life Cycles
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.interactor?.fetchFeedList(currentPage: 1, count: 1, feedId: 2, challengeId: 0)
    self.containerView.addGestureRecognizer(tapGesture)
  }
  
  override func setupConfigure() {
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
          self.router?.navigateToFeedDetail(source: self)
        }
      }
    }
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

    cell.bind(feedList: self.feedListPost[indexPath.item])
    cell.commentsButton.addTarget(
      self,
      action: #selector(commentButtonDidTap(_:)),
      for: .touchUpInside
    )

    return cell
  }

  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind
    kind: String, at indexPath: IndexPath
  ) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryHeaderView(
      withType: FeedListHeaderReusableView.self,
      for: indexPath
    )
    return header
  }
}

extension FeedListViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {

    let scale = feedListPost[indexPath.item].imageScale
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
    self.feedListPost = feedList.feeds
    print(feedList)
  }
}
