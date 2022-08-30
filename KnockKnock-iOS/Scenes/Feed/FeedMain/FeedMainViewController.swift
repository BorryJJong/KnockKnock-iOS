//
//  FeedMainView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/13.
//

import UIKit

protocol FeedMainViewProtocol: AnyObject {
  var interactor: FeedMainInteractorProtocol? { get set }
  
  func fetchFeedMain(feed: FeedMain)
  func fetchChallengeTitles(challengeTitle: [ChallengeTitle], index: IndexPath?)
}

final class FeedMainViewController: BaseViewController<FeedMainView> {
  
  // MARK: - Enums
  
  private enum CollectionViewTag: Int, CaseIterable {
    case tag = 0
    case feed = 1
  }
  
  // MARK: - Properties
  
  var interactor: FeedMainInteractorProtocol?
  var router: FeedMainRouterProtocol?
  
  var feedMain: FeedMain?

  var feedMainPost: [FeedMainPost] = [] {
    didSet {
      self.containerView.feedCollectionView.reloadData()
    }
  }
  var challengeTitles: [ChallengeTitle] = []
  
  var currentPage = 1
  let pageSize = 1 // pageSize 논의 필요, 페이지네이션 작동 테스트를 위해 1로 임시 설정
  var challengeId = 0
  
  // MARK: - Lify Cycles
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.extendedLayoutIncludesOpaqueBars = true
    self.navigationItem.hidesSearchBarWhenScrolling = false
    
    self.interactor?.fetchFeedMain(
      currentPage: self.currentPage,
      pageSize: self.pageSize,
      challengeId: self.challengeId
    )
    self.interactor?.fetchChallengeTitles()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  // MARK: - Configure
  
  override func setupConfigure() {
    self.navigationItem.searchController = containerView.searchBar
    
    self.containerView.tagCollectionView.do {
      $0.delegate = self
      $0.dataSource = self
      $0.registCell(type: TagCell.self)
      $0.collectionViewLayout = self.containerView.tagCollectionViewLayout()
      $0.tag = CollectionViewTag.tag.rawValue
    }
    
    self.containerView.feedCollectionView.do {
      $0.delegate = self
      $0.dataSource = self
      $0.registCell(type: FeedCell.self)
      $0.collectionViewLayout = self.containerView.feedCollectionViewLayout()
      $0.tag = CollectionViewTag.feed.rawValue
    }
  }
  
  // MARK: - Button Actions
  
  @objc func didTapViewMoreButton(_ sender: UIButton) {
    self.currentPage += 1
    self.interactor?.fetchFeedMain(
      currentPage: self.currentPage,
      pageSize: self.pageSize,
      challengeId: self.challengeId
    )
  }
}

// MARK: - Extensions

extension FeedMainViewController: FeedMainViewProtocol {
  func fetchFeedMain(feed: FeedMain) {
    self.feedMain = feed
    self.feedMain?.feeds.forEach {
      self.feedMainPost.append($0)
    }
  }
  
  func fetchChallengeTitles(
    challengeTitle: [ChallengeTitle],
    index: IndexPath?
  ) {
    self.challengeTitles = challengeTitle
    
    if let index = index {
      UIView.performWithoutAnimation {
        self.containerView.tagCollectionView.reloadSections([0])
        self.containerView.tagCollectionView.scrollToItem(
          at: index,
          at: .centeredHorizontally,
          animated: false)
      }
    } else {
      self.containerView.tagCollectionView.reloadData()
    }
  }
}

extension FeedMainViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    switch collectionView.tag {
    case CollectionViewTag.tag.rawValue:

      return self.challengeTitles.count
      
    case CollectionViewTag.feed.rawValue:

      return self.feedMainPost.count
      
    default:
      return 0
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    switch collectionView.tag {
    case CollectionViewTag.tag.rawValue:
      let cell = collectionView.dequeueCell(
        withType: TagCell.self,
        for: indexPath
      )
      cell.bind(tag: self.challengeTitles[indexPath.item])
      
      if indexPath.item == 0 {
        cell.isSelected = true
        collectionView.selectItem(
          at: indexPath,
          animated: false,
          scrollPosition: .init()
        )
      }
      
      return cell
      
    case CollectionViewTag.feed.rawValue:
      let cell = collectionView.dequeueCell(
        withType: FeedCell.self,
        for: indexPath
      )

      cell.bind(post: self.feedMainPost[indexPath.item])

      return cell
      
    default:
      return UICollectionViewCell()
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    let footer = collectionView.dequeueReusableSupplementaryFooterView(
      withType: FeedMainFooterCollectionReusableView.self,
      for: indexPath
    )
    if let feedMain = self.feedMain {
      if !feedMain.isNext {
        footer.viewMoreButton.isHidden = true
      } else {
        footer.viewMoreButton.isHidden = false
      }
    }
    
    footer.viewMoreButton.addTarget(
      self,
      action: #selector(self.didTapViewMoreButton(_:)),
      for: .touchUpInside
    )
    return footer
  }
}

extension FeedMainViewController: UICollectionViewDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    switch collectionView.tag {
    case CollectionViewTag.tag.rawValue:
      self.interactor?.setSelectedStatus(
        challengeTitles: challengeTitles,
        selectedIndex: indexPath
      )

      self.feedMainPost = []
      self.challengeId = indexPath.item
      self.currentPage = 1
      
      self.interactor?.fetchFeedMain(
        currentPage: self.currentPage,
        pageSize: self.pageSize,
        challengeId: self.challengeId
      )
      
    case CollectionViewTag.feed.rawValue:
      self.router?.navigateToFeedList(source: self)
      
    default:
      return
    }
  }
}
