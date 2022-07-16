//
//  CommentsView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/13.
//

import UIKit

import KKDSKit
import Then

class CommentView: UIView {

  // MARK: - Constants

  private enum Metric {
    static let commentInputViewTopMargin = -20.f

    static let commentTextViewHeight = 34.f
    static let commentTextViewBottomMargin = -19.f
    static let commentTextViewTrailingMargin = -70.f
    static let commentTextViewLeadingMargin = 20.f

    static let registButtonTrailingMargin = -20.f
    static let registButtonBottomMargin = -15.f
    static let registButtonWidth = 50.f
    static let registButtonHeight = 30.f
  }

  // MARK: - Properties

  let commentTextViewPlaceholder = "댓글을 입력하세요..."

  // MARK: - UIs

  let commentCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then{
      $0.scrollDirection = .vertical
    }).then {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.backgroundColor = .yellow
    }

  let commentInputView = UIView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .white
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.white.cgColor
    $0.layer.masksToBounds = false
    $0.layer.shadowColor = UIColor.black.cgColor
    $0.layer.shadowOpacity = 0.05
    $0.layer.shadowOffset = CGSize(width: 0, height: -3)
  }

  lazy var commentTextView = UITextView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = self.commentTextViewPlaceholder
    $0.textColor = .gray50
    $0.font = .systemFont(ofSize: 15, weight: .regular)
  }

  let registButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setTitle("등록", for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 15
    $0.backgroundColor = .green50
    $0.setTitleColor(.white, for: .normal)
  }

  // MARK: - Initailize

  init() {
    super.init(frame: .zero)
    self.setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: - Configure

  func setPlaceholder() {
    if self.commentTextView.text == self.commentTextViewPlaceholder {
      self.commentTextView.text = nil
      self.commentTextView.textColor = .black
    } else if self.commentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
      self.commentTextView.text = self.commentTextViewPlaceholder
      self.commentTextView.textColor = .gray50
    }
  }

  // MARK: - Constraints

  func setupConstraints() {
    [self.commentCollectionView, self.commentInputView].addSubViews(self)
    [self.commentTextView, self.registButton].addSubViews(self)

    NSLayoutConstraint.activate([
      self.commentCollectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
      self.commentCollectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
      self.commentCollectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
      self.commentCollectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),

      self.commentInputView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
      self.commentInputView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
      self.commentInputView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
      self.commentInputView.topAnchor.constraint(equalTo: self.commentTextView.topAnchor, constant: Metric.commentInputViewTopMargin),

      self.commentTextView.heightAnchor.constraint(equalToConstant: Metric.commentTextViewHeight),
      self.commentTextView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: Metric.commentTextViewBottomMargin),
      self.commentTextView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.commentTextViewTrailingMargin),
      self.commentTextView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.commentTextViewLeadingMargin),

      self.registButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.registButtonTrailingMargin),
      self.registButton.bottomAnchor.constraint(equalTo: self.commentTextView.bottomAnchor),
      self.registButton.widthAnchor.constraint(equalToConstant: Metric.registButtonWidth),
      self.registButton.heightAnchor.constraint(equalToConstant: Metric.registButtonHeight)
    ])
  }
}
