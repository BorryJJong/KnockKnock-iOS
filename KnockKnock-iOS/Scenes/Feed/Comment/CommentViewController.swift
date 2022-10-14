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

  func getComments(comments: [Comment])
}

final class CommentViewController: BaseViewController<CommentView> {

  // MARK: - Properties

  var router: CommentRouterProtocol?
  var interactor: CommentInteractorProtocol?

  var feedId: Int = 6
  var comments: [Comment] = []
  var reply: [Int: [Reply]] = [ : ]

  lazy var longPressGestureRecognizer = UILongPressGestureRecognizer(
    target: self,
    action: #selector(longPressGestureDidDetect(_:))
  )

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    self.interactor?.getComments(feedId: feedId)
  }

  // MARK: - Configure

  override func setupConfigure() {
    self.longPressGestureRecognizer.do {
      $0.minimumPressDuration = 0.5
      $0.delaysTouchesBegan = true
    }

    self.containerView.commentCollectionView.do {
      $0.delegate = self
      $0.dataSource = self
      $0.registCell(type: ReplyCell.self)
      $0.collectionViewLayout = self.containerView.commentCollectionViewLayout()
      $0.addGestureRecognizer(self.longPressGestureRecognizer)
    }

    self.containerView.exitButton.do {
      $0.addTarget(
        self,
        action: #selector(exitButtonDidTap(_:)),
        for: .touchUpInside
      )
    }

    self.containerView.commentTextView.do {
      $0.delegate = self
    }

    self.containerView.registButton.do {
      $0.addTarget(self, action: #selector(self.regitstButtonDidTap(_:)), for: .touchUpInside)
    }

    self.addKeyboardNotification()
    self.hideKeyboardWhenTappedAround()
  }

  // MARK: - Keyboard Show & Hide

  private func addKeyboardNotification() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow(_:)),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide(_:)),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
  }

  @objc private func keyboardWillShow(_ notification: Notification) {
    self.setCommentsTextViewConstant(notification: notification, isAppearing: true)
  }

  @objc private func keyboardWillHide(_ notification: Notification) {
    self.setCommentsTextViewConstant(notification: notification, isAppearing: false)
  }

  private func setCommentsTextViewConstant(
    notification: Notification,
    isAppearing: Bool
  ) {
    let userInfo = notification.userInfo

    if let keyboardFrame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
      let keyboardSize = keyboardFrame.cgRectValue
      let keyboardHeight = keyboardSize.height

      guard let animationDurationValue = userInfo?[
        UIResponder
          .keyboardAnimationDurationUserInfoKey
      ] as? NSNumber else { return }

      let heightConstant = isAppearing ? (-keyboardHeight + 15) : -19

      self.containerView.commentTextView.bottomConstraint?.constant = heightConstant

      UIView.animate(withDuration: animationDurationValue.doubleValue) {
        self.containerView.layoutIfNeeded()
      }
    }
  }

  // MARK: - Button action

  @objc private func exitButtonDidTap(_ sender: UIButton) {
    self.router?.dismissCommentView(view: self)
  }

  @objc private func replyMoreButtonDidTap(_ sender: UIButton) {
    self.comments[sender.tag].isOpen.toggle()

    if self.comments[sender.tag].isOpen {
      self.reply[sender.tag] = self.comments[sender.tag].commentData.reply
    } else {
      self.reply[sender.tag] = []
    }
    
    UIView.performWithoutAnimation {
      self.containerView.commentCollectionView.reloadSections([sender.tag])
    }
  }

  @objc private func longPressGestureDidDetect(_ sender: UILongPressGestureRecognizer) {
    self.router?.presentBottomSheetView(source: self)
  }

  @objc private func regitstButtonDidTap(_ sender: UIButton) {
    let content = self.containerView.commentTextView.text
  }
}

// MARK: - CommentViewProtocol

extension CommentViewController: CommentViewProtocol {
  func getComments(comments: [Comment]) {
    self.comments = comments
    for index in 0 ..< comments.count {
      self.reply[index] = []
    }
    self.containerView.commentCollectionView.reloadData()
  }
}

// MARK: - CollectionView Delegate, DataSource

extension CommentViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    guard let reply = self.reply[section] else { return 0 }

    return reply.count
  }

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return self.comments.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueCell(
      withType: ReplyCell.self,
      for: indexPath
    )
    if let reply = self.reply[indexPath.section] {
      cell.bind(reply: reply[indexPath.item])
    }
    return cell
  }

  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {

    let header = collectionView.dequeueReusableSupplementaryHeaderView(
      withType: CommentHeaderCollectionReusableView.self,
      for: indexPath
    )
    header.bind(comment: self.comments[indexPath.section])

    header.replyMoreButton.tag = indexPath.section
    header.replyMoreButton.addTarget(
      self,
      action: #selector(replyMoreButtonDidTap(_:)),
      for: .touchUpInside
    )

    return header
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
