//
//  FeedDetailView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/23.
//

import UIKit

import KKDSKit
import Then

class FeedDetailView: UIView {

  // MARK: - Properties

  private let commentTextViewPlaceholder = "댓글을 입력하세요..."

  // MARK: - Constants

  private enum Metric {
    static let headerViewHeight = 50.f
    static let headerViewTrailingMargin = -10.f

    static let commentInputViewTopMargin = -20.f

    static let commentTextViewHeight = 34.f
    static let commentTextViewBottomMargin = -19.f
    static let commentTextViewTrailingMargin = -10.f
    static let commentTextViewLeadingMargin = 10.f

    static let registButtonTrailingMargin = -20.f
    static let registButtonBottomMargin = -15.f
    static let registButtonWidth = 50.f
    static let registButtonHeight = 30.f
  }

  // MARK: - UIs

  private let headerView = UIView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
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

  let likeButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setImage(KKDS.Image.ic_like_24_off, for: .normal)
    $0.setImage(KKDS.Image.ic_like_24_on, for: .selected)
  }

  lazy var commentTextView = UITextView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = self.commentTextViewPlaceholder
    $0.textColor = .gray50
    $0.font = .systemFont(ofSize: 15, weight: .regular)
    $0.autocorrectionType = .no
    $0.spellCheckingType = .no
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
    [self.headerView].addSubViews(self)
    [self.commentInputView, self.likeButton, self.commentTextView, self.registButton].addSubViews(self)

    NSLayoutConstraint.activate([
      self.headerView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
      self.headerView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
      self.headerView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.headerViewTrailingMargin),
      self.headerView.heightAnchor.constraint(equalToConstant: Metric.headerViewHeight),

      self.commentInputView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
      self.commentInputView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
      self.commentInputView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
      self.commentInputView.topAnchor.constraint(equalTo: self.commentTextView.topAnchor, constant: Metric.commentInputViewTopMargin),

      self.likeButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      self.likeButton.centerYAnchor.constraint(equalTo: self.commentTextView.centerYAnchor),

      self.commentTextView.heightAnchor.constraint(equalToConstant: Metric.commentTextViewHeight),
      self.commentTextView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: Metric.commentTextViewBottomMargin),
      self.commentTextView.trailingAnchor.constraint(equalTo: self.registButton.leadingAnchor, constant: Metric.commentTextViewTrailingMargin),
      self.commentTextView.leadingAnchor.constraint(equalTo: self.likeButton.trailingAnchor, constant: Metric.commentTextViewLeadingMargin),

      self.registButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.registButtonTrailingMargin),
      self.registButton.bottomAnchor.constraint(equalTo: self.commentTextView.bottomAnchor),
      self.registButton.widthAnchor.constraint(equalToConstant: Metric.registButtonWidth),
      self.registButton.heightAnchor.constraint(equalToConstant: Metric.registButtonHeight)
    ])
  }
}
