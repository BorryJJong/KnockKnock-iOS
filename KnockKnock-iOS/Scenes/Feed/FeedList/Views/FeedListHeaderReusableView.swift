//
//  FeedListHeaderReusableView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/25.
//

import UIKit

import KKDSKit

class FeedListHeaderReusableView: UICollectionReusableView {

  // MARK: - Constants

  private enum Metric {
    static let profileImageViewWidth = 32.f
    static let profileImageViewHeight = 32.f
    static let profileImageLeadingMargin = 20.f

    static let configureButtonWidth = 40.f
    static let configureButtonTrailingMargin = -20.f

    static let stackViewTopMargin = 10.f
    static let stackViewLeadingMargin = 15.f
    static let stackViewTrailingMargin = -25.f
  }

  // MARK: - UIs
  
  private lazy var stackView = UIStackView(arrangedSubviews: [
    self.userIdLabel,
    self.postDateLabel
  ]).then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.axis = .vertical
    $0.alignment = .fill
    $0.distribution = .fill
  }

  private lazy var profileImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.layer.cornerRadius = 16
    $0.clipsToBounds = true
  }

  private let userIdLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = .systemFont(ofSize: 13, weight: .bold)
    $0.text = "sungmin_kim94"
  }

  private let postDateLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.textColor = .gray70
    $0.font = .systemFont(ofSize: 12, weight: .light)
    $0.text = "1시간전"
  }

  let configureButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setTitleColor(.black, for: .normal)
    $0.setImage(KKDS.Image.ic_more_20_gr, for: .normal)
    $0.contentHorizontalAlignment = .right
  }

  // MARK: - Initailize

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: - Bind

  func bind(feed: FeedList.Post) {
    self.userIdLabel.text = "\(feed.id)" // feed.userName으로 변경할 것
    self.postDateLabel.text = feed.regDateToString
    self.profileImageView.setImageFromStringUrl(
      url: "https://dy-yb.github.io/images/profile.jpg", // feed.userImage
      defaultImage: KKDS.Image.ic_person_24
    )
  }

  // MARK: - Configure

  func setupConstraints() {
    [self.profileImageView, self.stackView, self.configureButton].addSubViews(self)

    NSLayoutConstraint.activate([
      self.profileImageView.centerYAnchor.constraint(equalTo: self.stackView.centerYAnchor),
      self.profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Metric.profileImageLeadingMargin),
      self.profileImageView.widthAnchor.constraint(equalToConstant: Metric.profileImageViewWidth),
      self.profileImageView.heightAnchor.constraint(equalToConstant: Metric.profileImageViewHeight),

      self.configureButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.configureButtonTrailingMargin),
      self.configureButton.widthAnchor.constraint(equalToConstant: Metric.configureButtonWidth),
      self.configureButton.centerYAnchor.constraint(equalTo: self.stackView.centerYAnchor),

      self.stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: Metric.stackViewTopMargin),
      self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      self.stackView.leadingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor, constant: Metric.stackViewLeadingMargin),
      self.stackView.trailingAnchor.constraint(equalTo: self.configureButton.leadingAnchor, constant: Metric.stackViewTrailingMargin)
    ])
  }
}
