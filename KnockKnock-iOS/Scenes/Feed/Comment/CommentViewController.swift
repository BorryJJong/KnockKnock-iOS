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

  func getAllComments(allComments: [Comment])
  func setVisibleComments(comments: [Comment])
}

final class CommentViewController: BaseViewController<CommentView> {

  // MARK: - Properties

  var router: CommentRouterProtocol?
  var interactor: CommentInteractorProtocol?

  private var allComments: [Comment] = []
  private var visibleComments: [Comment] = []

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    self.interactor?.getAllComments()
    self.interactor?.setVisibleComments(comments: self.allComments)
  }

  // MARK: - Configure

  override func setupConfigure() {
    self.containerView.commentCollectionView.do {
      $0.delegate = self
      $0.dataSource = self
      $0.registCell(type: PostCommentCell.self)
      $0.collectionViewLayout = self.containerView.commentCollectionViewLayout()
      $0.scrollsToTop = true
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

    self.addKeyboardNotification()
    self.hideKeyboardWhenTappedAround()
    self.changeStatusBarBgColor(bgColor: .white
    )
  }

  func changeStatusBarBgColor(bgColor: UIColor?) {
    if #available(iOS 13.0, *) {
      let window = UIApplication.shared.windows.first
      let statusBarManager = window?.windowScene?.statusBarManager

      let statusBarView = UIView(frame: statusBarManager?.statusBarFrame ?? .zero)
      statusBarView.backgroundColor = bgColor

      window?.addSubview(statusBarView)
    } else {
      let statusBarView = UIApplication.shared.value(forKey: "statusBar") as? UIView
      statusBarView?.backgroundColor = bgColor
    }
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
    self.setContainerViewConstant(notification: notification, isAppearing: true)
    self.setCommentsTextViewConstant(isAppearing: true)
  }

  @objc private func keyboardWillHide(_ notification: Notification) {
    self.setContainerViewConstant(notification: notification, isAppearing: false)
    self.setCommentsTextViewConstant(isAppearing: false)
  }

  private func setCommentsTextViewConstant(isAppearing: Bool) {
    let textViewHeightConstant = isAppearing ? 15.f : -19.f

    self.containerView.commentTextView.bottomConstraint?.constant = textViewHeightConstant
  }

  private func setContainerViewConstant(notification: Notification, isAppearing: Bool) {
    let userInfo = notification.userInfo

    if let keyboardFrame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
      let keyboardSize = keyboardFrame.cgRectValue
      let keyboardHeight = keyboardSize.height

      guard let animationDurationValue = userInfo?[
        UIResponder
          .keyboardAnimationDurationUserInfoKey
      ] as? NSNumber else { return }

      let viewHeightConstant = isAppearing ? (-keyboardHeight) : 0

      self.containerView.contentView.bottomConstraint?.constant = viewHeightConstant

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
    self.visibleComments[sender.tag].isOpen.toggle()

    self.interactor?.setVisibleComments(comments: self.visibleComments)

    self.containerView.commentCollectionView.reloadData()
  }

  @objc private func longPressGestureDidDetect(_ sender: UILongPressGestureRecognizer) {
    self.router?.presentBottomSheetView(source: self)
  }
}

// MARK: - CommentViewProtocol

extension CommentViewController: CommentViewProtocol {
  func getAllComments(allComments: [Comment]) {
    self.allComments = allComments
  }

  func setVisibleComments(comments: [Comment]) {
    self.visibleComments = comments
  }
}

// MARK: - CollectionView Delegate, DataSource

extension CommentViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return self.visibleComments.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueCell(
      withType: PostCommentCell.self,
      for: indexPath
    )
    cell.replyMoreButton.tag = indexPath.item
    cell.replyMoreButton.addTarget(
      self,
      action: #selector(replyMoreButtonDidTap(_:)),
      for: .touchUpInside
    )

    cell.bind(comment: self.visibleComments[indexPath.item])

    return cell
  }
}

extension CommentViewController: UICollectionViewDelegateFlowLayout {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if self.containerView.commentCollectionView.isDragging {
      let offset = scrollView.contentOffset.y

      if offset <= 0 {
        self.dismissKeyboard()
      }
    }
  }
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
