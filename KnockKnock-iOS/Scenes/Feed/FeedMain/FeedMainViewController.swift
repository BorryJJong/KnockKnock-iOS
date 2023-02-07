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
  func reloadFeedMain()
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

  private var feedMainPost: [FeedMain.Post] = []
  private var isNext: Bool = false

  private var challengeTitles: [ChallengeTitle] = []
  private var searchKeyword: [SearchKeyword] = []
  
  private var currentPage = 1
  private let pageSize = 9

  private var challengeId = 0

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
    self.feedMainPost = feed.feeds
    self.isNext = feed.isNext

    DispatchQueue.main.async {
      self.containerView.feedCollectionView.reloadData()
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
          animated: false
        )
      }
    } else {
      self.containerView.tagCollectionView.reloadData()
    }
  }

  /// 피드 데이터 re-fatch
  func reloadFeedMain() {
    self.interactor?.fetchFeedMain(
      currentPage: 1,
      pageSize: self.pageSize,
      challengeId: self.challengeId
    )
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

    footer.viewMoreButton.isHidden = !self.isNext
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
