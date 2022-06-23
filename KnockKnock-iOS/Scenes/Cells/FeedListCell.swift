//
//  FeedListCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/22.
//

import UIKit

class FeedListCell: BaseCollectionViewCell {

  // MARK: - Constants

  private enum Metric {
    static let headerViewHeight = 50.f

    static let profileImageViewWidth = 32.f
    static let profileImageViewHeight = 32.f

    static let configureButtonWidth = 40.f

    static let stackViewLeadingMargin = 15.f
    static let stackViewTrailingMargin = -25.f

    static let imageScrollViewTopMargin = 10.f

    static let postContentViewTopMargin = 15.f
    static let postContentViewLeadingMargin = 15.f
    static let postContentViewTrailingMargin = -15.f
    static let postContentViewBottomMargin = -15.f

    static let contentlabelBottomMargin = -15.f

    static let likeButtonLeadingMargin = 10.f
    
    static let commentsButtonLeadingMargin = 10.f

  }

  // MARK: - UIs

  private let headerView = UIView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .purple
  }

  private lazy var stackView = UIStackView(arrangedSubviews: [
    self.userIdLabel,
    self.postDateLabel]
  ).then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.axis = .vertical
    $0.alignment = .fill
    $0.distribution = .fill
  }

  private lazy var profileImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .red
    $0.layer.cornerRadius = 16
    $0.clipsToBounds = true
  }

  private let userIdLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = "sungmin_kim94"
  }

  private let postDateLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = "1시간전"
  }

  private let configureButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .yellow
    $0.setTitleColor(.black, for: .normal)
    $0.setTitle("•••", for: .normal)
    $0.contentHorizontalAlignment = .right
  }
  private let imageScrollView = UIScrollView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.isPagingEnabled = true
    $0.backgroundColor = .orange
  }

  private let postContentView = UIView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
  }

  private let contentLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.numberOfLines = 2
    $0.backgroundColor = .systemPink
    $0.textAlignment = .natural
    $0.text = "패키지 상품을 받았을때의 기쁨 후엔 늘 골치아픈 쓰레기와 분리수거의 노동시간이 뒤따릅니다다 다다다다ㅏ따다다다ㅏ다다다다다다다다ㅏ다다다다ㅏ다ㅏ"
  }

  let likeButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .blue
  }

  let commentsButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .gray
  }

  // MARK: - Configure

  override func setupConstraints() {
    [self.headerView].addSubViews(self.contentView)
    [self.profileImageView, self.stackView, self.configureButton].addSubViews(headerView)
    [self.imageScrollView].addSubViews(self.contentView)
    [self.postContentView].addSubViews(self.contentView)
    [self.contentLabel, self.likeButton, self.commentsButton].addSubViews(self.postContentView)

    NSLayoutConstraint.activate([
      self.headerView.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor),
      self.headerView.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor),
      self.headerView.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor),
      self.headerView.heightAnchor.constraint(equalToConstant: Metric.headerViewHeight),

      self.profileImageView.centerYAnchor.constraint(equalTo: self.headerView.centerYAnchor),
      self.profileImageView.leadingAnchor.constraint(equalTo: self.headerView.leadingAnchor),
      self.profileImageView.widthAnchor.constraint(equalToConstant: Metric.profileImageViewWidth),
      self.profileImageView.heightAnchor.constraint(equalToConstant: Metric.profileImageViewHeight),

      self.configureButton.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor),
      self.configureButton.widthAnchor.constraint(equalToConstant: Metric.configureButtonWidth),
      self.configureButton.centerYAnchor.constraint(equalTo: self.headerView.centerYAnchor),

      self.stackView.centerYAnchor.constraint(equalTo: self.headerView.centerYAnchor),
      self.stackView.leadingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor, constant: Metric.stackViewLeadingMargin),
      self.stackView.trailingAnchor.constraint(equalTo: self.configureButton.leadingAnchor, constant: Metric.stackViewTrailingMargin),

      self.imageScrollView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: Metric.imageScrollViewTopMargin),
      self.imageScrollView.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor),
      self.imageScrollView.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor),
      self.imageScrollView.heightAnchor.constraint(equalTo: self.contentView.widthAnchor),

      self.postContentView.topAnchor.constraint(equalTo: self.imageScrollView.bottomAnchor, constant: Metric.postContentViewTopMargin),
      self.postContentView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: Metric.postContentViewLeadingMargin),
      self.postContentView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: Metric.postContentViewTrailingMargin),
      self.postContentView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: Metric.postContentViewBottomMargin),

      self.contentLabel.topAnchor.constraint(equalTo: self.postContentView.topAnchor),
      self.contentLabel.leadingAnchor.constraint(equalTo: self.postContentView.leadingAnchor),
      self.contentLabel.trailingAnchor.constraint(equalTo: self.postContentView.trailingAnchor),
      self.contentLabel.bottomAnchor.constraint(equalTo: self.likeButton.topAnchor, constant: Metric.contentlabelBottomMargin),

      self.likeButton.bottomAnchor.constraint(equalTo: self.postContentView.bottomAnchor),
      self.likeButton.leadingAnchor.constraint(equalTo: self.postContentView.leadingAnchor),

      self.commentsButton.topAnchor.constraint(equalTo: self.likeButton.topAnchor),
      self.commentsButton.bottomAnchor.constraint(equalTo: self.postContentView.bottomAnchor),
      self.commentsButton.leadingAnchor.constraint(equalTo: self.likeButton.trailingAnchor, constant: Metric.commentsButtonLeadingMargin)
    ])
  }
}
