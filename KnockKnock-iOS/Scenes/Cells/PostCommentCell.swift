//
//  PostCommentCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/29.
//

import UIKit

import KKDSKit
import SnapKit
import Then

final class PostCommentCell: BaseCollectionViewCell {

  // MARK: - Constants

  private enum Metric {
    static let profileImageViewWidth = 32.f
    static let profileImageViewHeight = 32.f

    static let profileImageViewLeadingForReply = 42.f
    static let profileImageViewWidthForReply = 24.f
    static let profileImageViewHeightForReply = 24.f

    static let userIdLabelLeadingMargin = 10.f

    static let commentLabelTopMargin = 3.f

    static let replyMoreButtonTopMargin = 15.f
    static let replyMoreButtonBottomMargin = 20.f

    static let replyWriteButtonContentPadding = 10.f
    static let commentDeleteButtonContentPadding = 10.f
    static let replyMoreButtonContentPadding = 10.f

    static let writtenDateLabelTopMargin = 3.f

    static let replyWriteButtonLeadingMargin = 10.f

    static let commentDeleteButtonLeadingMargin = 10.f
  }

  // MARK: - UIs

  private let profileImageView = UIImageView().then {
    $0.image = KKDS.Image.ic_person_24
    $0.layer.cornerRadius = (Metric.profileImageViewWidth / 2)
    $0.clipsToBounds = true
    $0.contentMode = .scaleToFill
  }

  private let userIdLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 12, weight: .bold)
  }

  private let commentLabel = UILabel().then {
    $0.numberOfLines = 0
    $0.font = .systemFont(ofSize: 13, weight: .medium)
  }

  private let writtenDateLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 12, weight: .medium)
    $0.textColor = .gray70
  }

  let replyWriteButton = UIButton().then {
    $0.setTitleColor(.gray70, for: .normal)
    $0.setImage(KKDS.Image.etc_bar_8_gr, for: .normal)
    $0.setTitle("댓글달기", for: .normal)
    $0.contentEdgeInsets.right = Metric.replyWriteButtonContentPadding
    $0.titleEdgeInsets.left = Metric.replyWriteButtonContentPadding
    $0.titleEdgeInsets.right = -(Metric.replyWriteButtonContentPadding)
    $0.semanticContentAttribute = .forceLeftToRight
    $0.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
  }

  lazy var replyMoreButton = UIButton().then {
    $0.setImage(KKDS.Image.etc_bar_30_gr, for: .normal)
    $0.setTitleColor(.gray70, for: .normal)
    $0.contentEdgeInsets.right = Metric.replyMoreButtonContentPadding
    $0.titleEdgeInsets.left = Metric.replyMoreButtonContentPadding
    $0.titleEdgeInsets.right = -(Metric.replyMoreButtonContentPadding)
    $0.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
  }

  let commentDeleteButton = UIButton().then {
    $0.setImage(KKDS.Image.etc_bar_8_gr, for: .normal)
    $0.setTitle("삭제", for: .normal)
    $0.contentEdgeInsets.right = Metric.commentDeleteButtonContentPadding
    $0.titleEdgeInsets.left = Metric.commentDeleteButtonContentPadding
    $0.titleEdgeInsets.right = -(Metric.commentDeleteButtonContentPadding)
    $0.setTitleColor(.gray70, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
  }
  
  // MARK: - Bind

  func bind(
    comment: Comment,
    isLoggedIn: Bool
  ) {
    
    Task {
      self.profileImageView.image = await self.setProfileImage(stringUrl: comment.data.image)
    }

    let reply = comment.data.reply.map {
      $0.filter { !$0.isDeleted }
    } ?? []
    
    self.setReplyMoreButton(
      count: reply.count,
      isOpen: comment.isOpen
    )

    self.userIdLabel.text = comment.data.nickname
    self.commentLabel.text = comment.data.content
    self.writtenDateLabel.text = comment.data.regDate

    self.replyWriteButton.isHidden = !isLoggedIn
    self.commentDeleteButton.isHidden = !isLoggedIn

    if comment.isReply {
      self.replyWriteButton.isHidden = comment.isReply
      self.commentDeleteButton.snp.remakeConstraints {
        $0.top.equalTo(self.writtenDateLabel)
        $0.leading.equalTo(self.writtenDateLabel.snp.trailing).offset(Metric.commentDeleteButtonLeadingMargin)
      }
      self.profileImageView.snp.remakeConstraints {
        $0.leading.equalTo(self.safeAreaLayoutGuide).offset(Metric.profileImageViewLeadingForReply)
        $0.width.equalTo(Metric.profileImageViewWidthForReply)
        $0.height.equalTo(Metric.profileImageViewHeightForReply)
      }
      
    } else {
      self.commentDeleteButton.snp.remakeConstraints {
        $0.top.equalTo(self.writtenDateLabel)
        $0.leading.equalTo(self.replyWriteButton.snp.trailing).offset(Metric.commentDeleteButtonLeadingMargin)
      }
      self.profileImageView.snp.remakeConstraints {
        $0.leading.equalTo(self.safeAreaLayoutGuide)
        $0.width.equalTo(Metric.profileImageViewWidth)
        $0.height.equalTo(Metric.profileImageViewHeight)
      }
    }
  }

  // MARK: - Configure

  private func setReplyMoreButton(count: Int, isOpen: Bool) {
    if count == 0 {
      self.replyMoreButton.isHidden = true
      self.replyMoreButton.snp.updateConstraints {
        $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(Metric.replyMoreButtonBottomMargin)
      }
    } else {
      self.replyMoreButton.isHidden = false
      self.replyMoreButton.snp.updateConstraints {
        $0.bottom.equalTo(self.safeAreaLayoutGuide)
      }
      if !isOpen {
        self.replyMoreButton.setTitle("답글 \(count)개 보기", for: .normal)
      } else {
        self.replyMoreButton.setTitle("답글 숨기기", for: .normal)
      }
    }
  }

  override func setupConstraints() {
    [self.profileImageView, self.userIdLabel, self.commentLabel, self.writtenDateLabel, self.replyWriteButton, self.replyMoreButton, self.commentDeleteButton].addSubViews(self)

    self.profileImageView.snp.makeConstraints {
      $0.top.leading.equalTo(self.safeAreaLayoutGuide)
      $0.width.equalTo(Metric.profileImageViewWidth)
      $0.height.equalTo(Metric.profileImageViewHeight)
    }

    self.userIdLabel.snp.makeConstraints {
      $0.top.trailing.equalTo(self.safeAreaLayoutGuide)
      $0.leading.equalTo(self.profileImageView.snp.trailing).offset(Metric.userIdLabelLeadingMargin)
    }

    self.commentLabel.snp.makeConstraints {
      $0.top.equalTo(self.userIdLabel.snp.bottom).offset(Metric.commentLabelTopMargin)
      $0.leading.equalTo(self.userIdLabel)
      $0.trailing.equalTo(self.safeAreaLayoutGuide)
    }

    self.replyMoreButton.snp.makeConstraints {
      $0.leading.equalTo(self.commentLabel)
      $0.top.equalTo(self.writtenDateLabel.snp.bottom).offset(Metric.replyMoreButtonTopMargin)
      $0.bottom.equalTo(self.safeAreaLayoutGuide)
    }

    self.writtenDateLabel.snp.makeConstraints {
      $0.top.equalTo(self.commentLabel.snp.bottom).offset(Metric.writtenDateLabelTopMargin)
      $0.leading.equalTo(self.commentLabel)
    }

    self.replyWriteButton.snp.makeConstraints {
      $0.leading.equalTo(self.writtenDateLabel.snp.trailing).offset(Metric.replyWriteButtonLeadingMargin)
      $0.top.bottom.equalTo(self.writtenDateLabel)
    }

    self.commentDeleteButton.snp.makeConstraints {
      $0.top.equalTo(self.writtenDateLabel)
      $0.leading.equalTo(self.replyWriteButton.snp.trailing).offset(Metric.commentDeleteButtonLeadingMargin)
    }
  }
}

extension PostCommentCell {

  /// 프로필 이미지 로드
  ///
  /// - Parameters:
  ///  - stringUrl: 이미지 url(String type)
  private func setProfileImage(stringUrl: String?) async -> UIImage {
    var stringUrl = stringUrl

      do {
        if let stringUrl = stringUrl,
           let url = URL(string: stringUrl) {

          let (data, _) = try await URLSession.shared.data(from: url)
          let image = UIImage(data: data)

          return image?.resizeSquareImage(newWidth: 24) ?? KKDS.Image.ic_person_24

        } else {
          return KKDS.Image.ic_person_24
        }

      } catch {
        return KKDS.Image.ic_person_24
      }
  }
}
