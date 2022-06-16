//
//  FeedListVIew.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/13.
//

import UIKit

import Then

class FeedViewController: BaseViewController<FeedView> {

  // MARK: - Properties

  private let tagList = ["전체", "#친환경", "#제로웨이스트", "#용기내챌린지", "#업사이클링" ]

  // MARK: - Lify Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func setupConfigure() {
    self.navigationItem.searchController = containerView.searchBar
    self.containerView.tagCollectionView.do {
      $0.delegate = self
      $0.dataSource = self
      $0.registCell(type: TagCell.self)
    }

    self.containerView.feedCollectionView.do {
      $0.delegate = self
      $0.dataSource = self
      $0.registCell(type: FeedCell.self)
      $0.collectionViewLayout = self.containerView.feedCollectionViewLayout()
    }
  }
}

extension FeedViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    var cellSize = CGSize()

    switch collectionView {
    case self.containerView.tagCollectionView:
      let attributes = [NSAttributedString.Key.font: UIFont.systemFont(
        ofSize: 12,
        weight: .medium)]
      let tagLength = (self.tagList[indexPath.row] as NSString)
        .size(withAttributes: attributes as [NSAttributedString.Key: Any])

      cellSize = CGSize(width: tagLength.width + 60, height: 35)

    default:
      break
    }
    return cellSize
  }
}

extension FeedViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {

    switch collectionView {
    case self.containerView.tagCollectionView:
      return self.tagList.count
      
    case self.containerView.feedCollectionView:
      return 33
      
    default:
      return 0
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    if collectionView == self.containerView.tagCollectionView {

      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: TagCell.reusableIdentifier,
        for: indexPath
      ) as! TagCell
      cell.backgroundColor = .white
      cell.tagLabel.text = self.tagList[indexPath.item]

      return cell

    } else {

      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: FeedCell.reusableIdentifier,
        for: indexPath
      ) as! FeedCell
      cell.backgroundColor = .white
      return cell
    }
  }
}

extension FeedViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let cell = collectionView.cellForItem(at: indexPath) as? TagCell {
      cell.tagLabel.backgroundColor = .green50
      cell.tagLabel.textColor = .white
      cell.tagLabel.font = .systemFont(ofSize: 16, weight: .bold)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    if let cell = collectionView.cellForItem(at: indexPath) as? TagCell {
      cell.tagLabel.backgroundColor = .white
      cell.tagLabel.textColor = .green50
      cell.tagLabel.font = .systemFont(ofSize: 16, weight: .medium)
    }
  }
}
