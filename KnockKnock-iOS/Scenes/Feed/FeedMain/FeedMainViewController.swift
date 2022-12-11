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
  func fetchSearchLog(searchKeyword: [SearchKeyword])
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
  var searchKeyword: [SearchKeyword] = []
  var popularPost: [String] = []
  
  var currentPage = 1
  let pageSize = 1 // pageSize 논의 필요, 페이지네이션 작동 테스트를 위해 1로 임시 설정
  var challengeId = 0

  // MARK: - UIs

  lazy var searchBar = UISearchController(
    searchResultsController: FeedSearchRouter.createFeedSearch()
  ).then {
    $0.hidesNavigationBarDuringPresentation = false
    $0.showsSearchResultsController = true

    $0.searchBar.delegate = self
    $0.searchBar.placeholder = "검색어를 입력하세요."
    $0.searchBar.tintColor = .black
    $0.searchBar.setValue("취소", forKey: "cancelButtonText")
  }

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

    self.navigationItem.searchController = searchBar
    self.navigationItem.backButtonTitle = ""
    self.navigationController?.navigationBar.setDefaultAppearance()

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

// MARK: - FeedMainView Protocol

extension FeedMainViewController: FeedMainViewProtocol {
  func fetchFeedMain(feed: FeedMain) {
    self.feedMain = feed
    self.feedMain?.feeds.forEach {
      self.feedMainPost.append($0)
    }
  }

  func fetchSearchLog(searchKeyword: [SearchKeyword]) {
    self.searchKeyword = searchKeyword
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

// MARK: - SearchTextField Delegate

extension FeedMainViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    if let keyword = searchBar.searchTextField.text {
      let searchLog = SearchKeyword(category: "계정", keyword: keyword)
      self.searchKeyword.append(searchLog)
      self.interactor?.saveSearchKeyword(searchKeyword: self.searchKeyword)
    }
  }
}

// MARK: - CollectionView DataSource, Delegate

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
      self.router?.navigateToFeedList(
        source: self,
        feedId: feedMainPost[indexPath.item].id,
        challengeId: self.challengeId
      )
      
    default:
      return
    }
  }
}
