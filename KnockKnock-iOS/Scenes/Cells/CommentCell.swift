//
//  CommentCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/13.
//

import UIKit

import KKDSKit

class CommentCell: BaseCollectionViewCell {

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
    $0.setTitle("   답글 \(self.countReplies)개 보기", for: .normal)
    $0.setTitle("답글 숨기기", for: .selected)
    $0.setTitleColor(.gray70, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
    $0.isHidden = self.countReplies == 0
  }

  @objc private func replyMoreButtonDidTap(_ sender: UIButton) {
  }

  override func setupConstraints() {
    [self.profileImageView, self.userIdLabel, self.commentLabel, self.writtenDateLabel, self.replyWriteButton, self.replyMoreButton].addSubViews(self.contentView)

    NSLayoutConstraint.activate([
      self.profileImageView.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor),
      self.profileImageView.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor),
      self.profileImageView.widthAnchor.constraint(equalToConstant: 32),
      self.profileImageView.heightAnchor.constraint(equalToConstant: 32),

      self.userIdLabel.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor),
      self.userIdLabel.leadingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor, constant: 10),
      self.userIdLabel.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor),

      self.commentLabel.topAnchor.constraint(equalTo: self.userIdLabel.bottomAnchor, constant: 3),
      self.commentLabel.leadingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor, constant: 10),
      self.commentLabel.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor),

      self.replyMoreButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
      self.replyMoreButton.leadingAnchor.constraint(equalTo: self.commentLabel.leadingAnchor),
      self.replyMoreButton.topAnchor.constraint(equalTo: self.writtenDateLabel.bottomAnchor, constant: 15),

      self.writtenDateLabel.topAnchor.constraint(equalTo: self.commentLabel.bottomAnchor, constant: 3),
      self.writtenDateLabel.leadingAnchor.constraint(equalTo: self.commentLabel.leadingAnchor),

      self.replyWriteButton.leadingAnchor.constraint(equalTo: self.writtenDateLabel.trailingAnchor, constant: 10),
      self.replyWriteButton.topAnchor.constraint(equalTo: self.writtenDateLabel.topAnchor),
      self.replyWriteButton.bottomAnchor.constraint(equalTo: self.writtenDateLabel.bottomAnchor)
    ])
  }
}
