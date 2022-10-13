//
//  PostCommentCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/29.
//

import UIKit

import KKDSKit
import Then

final class PostCommentCell: BaseCollectionViewCell {

  // MARK: - Constants

  private enum Metric {
    static let profileImageViewTrailingMargin = 32.f
    static let profileImageViewBottomMargin = 32.f

    static let userIdLabelLeadingMargin = 10.f

    static let commentLabelTopMargin = 3.f
    static let commentLabelLeadingMargin = 10.f

    static let replyMoreButtonTopMargin = 15.f

    static let writtenDateLabelTopMargin = 3.f

    static let replyWriteButtonLeadingMargin = 10.f
  }

  // MARK: - UIs

  private let profileImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = KKDS.Image.ic_person_24
  }

  private let userIdLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = "userID"
    $0.font = .systemFont(ofSize: 12, weight: .bold)
  }

  private let commentLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = "댓글 내용입니다."
    $0.numberOfLines = 0
    $0.font = .systemFont(ofSize: 13, weight: .medium)
  }

  private let writtenDateLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = "1시간전"
    $0.font = .systemFont(ofSize: 12, weight: .medium)
    $0.textColor = .gray70
  }

  private let replyWriteButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setTitleColor(.gray70, for: .normal)
    $0.setImage(KKDS.Image.etc_bar_8_gr, for: .normal)
    $0.setTitle("   댓글달기", for: .normal)
    $0.semanticContentAttribute = .forceLeftToRight
    $0.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
  }

  lazy var replyMoreButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setImage(KKDS.Image.etc_bar_30_gr, for: .normal)
    $0.setTitleColor(.gray70, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
  }
  
  // MARK: - Bind

  func bind(comment: Comment) {
    let reply = comment.commentData.reply
    self.setReplyMoreButton(count: reply?.count ?? 0, isOpen: comment.isOpen)

    self.userIdLabel.text = comment.commentData.nickname
    self.commentLabel.text = comment.commentData.content

    if comment.isReply {
      self.profileImageView.trailingConstraint?.constant = 66
      self.profileImageView.bottomConstraint?.constant = 24
      self.profileImageView.leadingConstraint?.constant = 42
    } else {
      self.profileImageView.trailingConstraint?.constant = 32
      self.profileImageView.bottomConstraint?.constant = 32
      self.profileImageView.leadingConstraint?.constant = 0
    }
  }

  // MARK: - Configure

  private func setReplyMoreButton(count: Int, isOpen: Bool) {
    if count == 0 {
      self.replyMoreButton.isHidden = true
      self.replyMoreButton.bottomConstraint?.constant = 20
    } else {
      self.replyMoreButton.bottomConstraint?.constant = 0
      if !isOpen {
        self.replyMoreButton.isHidden = false
        self.replyMoreButton.setTitle("   답글 \(count)개 보기", for: .normal)
      } else {
        self.replyMoreButton.isHidden = false
        self.replyMoreButton.setTitle("   답글 숨기기", for: .normal)
      }
    }
  }

  override func setupConstraints() {
    [self.profileImageView, self.userIdLabel, self.commentLabel, self.writtenDateLabel, self.replyWriteButton, self.replyMoreButton].addSubViews(self)

    NSLayoutConstraint.activate([
      self.profileImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
      self.profileImageView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
      self.profileImageView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.profileImageViewTrailingMargin),
      self.profileImageView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: Metric.profileImageViewBottomMargin),

      self.userIdLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
      self.userIdLabel.leadingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor, constant: Metric.userIdLabelLeadingMargin),
      self.userIdLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),

      self.commentLabel.topAnchor.constraint(equalTo: self.userIdLabel.bottomAnchor, constant: Metric.commentLabelTopMargin),
      self.commentLabel.leadingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor, constant: Metric.commentLabelLeadingMargin),
      self.commentLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),

      self.replyMoreButton.leadingAnchor.constraint(equalTo: self.commentLabel.leadingAnchor),
      self.replyMoreButton.topAnchor.constraint(equalTo: self.writtenDateLabel.bottomAnchor, constant: Metric.replyMoreButtonTopMargin),
      self.replyMoreButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),

      self.writtenDateLabel.topAnchor.constraint(equalTo: self.commentLabel.bottomAnchor, constant: Metric.writtenDateLabelTopMargin),
      self.writtenDateLabel.leadingAnchor.constraint(equalTo: self.commentLabel.leadingAnchor),

      self.replyWriteButton.leadingAnchor.constraint(equalTo: self.writtenDateLabel.trailingAnchor, constant: Metric.replyWriteButtonLeadingMargin),
      self.replyWriteButton.topAnchor.constraint(equalTo: self.writtenDateLabel.topAnchor),
      self.replyWriteButton.bottomAnchor.constraint(equalTo: self.writtenDateLabel.bottomAnchor)
    ])
  }
}
