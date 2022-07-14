//
//  CommentViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/13.
//

import Foundation

import Then
import KKDSKit

protocol CommentViewProtocol {
  var router: CommentRouterProtocol? { get set }
  var interactor: CommentInteractorProtocol? { get set }
}

final class CommentViewController: BaseViewController<CommentView>, CommentViewProtocol {

  // MARK: - Properties

  var router: CommentRouterProtocol?
  var interactor: CommentInteractorProtocol?

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupConfigure()
  }

  // MARK: - Configure

  override func setupConfigure() {
    self.containerView.commentCollectionView.do {
      $0.delegate = self
      $0.dataSource = self
      $0.registCell(type: CommentCell.self)
    }
    
    self.containerView.commentTextView.do {
      $0.delegate = self
    }
  }
}

// MARK: - CollectionView Delegate, DataSource

extension CommentViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueCell(withType: CommentCell.self, for: indexPath)
    return cell
  }
}

extension CommentViewController: UICollectionViewDelegateFlowLayout {
}

// MARK: - TextField delegate

extension CommentViewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    self.containerView.setPlaceholder()
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    self.containerView.setPlaceholder()
  }

  func textViewDidChange(_ textView: UITextView) {

    let size = CGSize(width: view.frame.width, height: .infinity)
    let estimatedSize = textView.sizeThatFits(size)

    textView.constraints.forEach { (constraint) in
      if estimatedSize.height <= 60 && constraint.firstAttribute == .height {
        constraint.constant = estimatedSize.height
      }
    }
  }
}
