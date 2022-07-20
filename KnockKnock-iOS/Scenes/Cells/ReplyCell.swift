//
//  ReplyCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/19.
//

import UIKit

import KKDSKit

class ReplyCell: BaseCollectionViewCell {

  // MARK: - Properties

  let countReplies: Int = 3

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
    $0.text = "댓글 내용입니다.댓글 내용입니다.댓글 내용입니다.댓글 내용입니다.댓글 내용입니다.댓글 내용입니다.댓글 내용입니다.댓글 내용입니다.댓글 내용입니다.댓글 내용입니다.댓글 내용입니다댓글 내용입니다.댓글 내용입니다.댓글 내용입니다.댓글 내용입니다.댓글 내용입니다댓글 내용입니다.댓글 내용입니다.댓글 내용입니다.댓글 내용입니다.댓글 내용입니다"
    $0.numberOfLines = 0
    $0.font = .systemFont(ofSize: 13, weight: .medium)
  }

  private let writtenDateLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = "1시간전"
    $0.font = .systemFont(ofSize: 12, weight: .medium)
    $0.textColor = .gray70
  }

  // MARK: - Bind

  func bind(reply: Reply) {
    self.userIdLabel.text = reply.userID
    self.commentLabel.text = reply.contents
  }

  // MARK: - Configure

  override func setupConstraints() {
    [self.profileImageView, self.userIdLabel, self.commentLabel, self.writtenDateLabel].addSubViews(self.contentView)

    NSLayoutConstraint.activate([
      self.profileImageView.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor),
      self.profileImageView.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor, constant: 42),
      self.profileImageView.widthAnchor.constraint(equalToConstant: 24),
      self.profileImageView.heightAnchor.constraint(equalToConstant: 24),

      self.userIdLabel.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor),
      self.userIdLabel.leadingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor, constant: 10),
      self.userIdLabel.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor),

      self.commentLabel.topAnchor.constraint(equalTo: self.userIdLabel.bottomAnchor, constant: 3),
      self.commentLabel.leadingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor, constant: 10),
      self.commentLabel.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor),

      self.writtenDateLabel.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor),
      self.writtenDateLabel.leadingAnchor.constraint(equalTo: self.commentLabel.leadingAnchor),
      self.writtenDateLabel.topAnchor.constraint(equalTo: self.commentLabel.bottomAnchor, constant: 15)
    ])
  }
}
