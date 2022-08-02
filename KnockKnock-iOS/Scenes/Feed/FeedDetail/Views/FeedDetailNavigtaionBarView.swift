//
//  FeedDetailNavigtaionBarView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/02.
//

import UIKit

import Then
import KKDSKit

final class FeedDetailNavigationBarView: UIView {

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
    $0.image = KKDS.Image.ic_person_24
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

  // MARK: - Bind

  func bind(feed: Feed) {
    self.userIdLabel.text = "\(feed.userId)"
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

  func setupConstraints() {
    [self.profileImageView, self.stackView].addSubViews(self)

    NSLayoutConstraint.activate([
      self.profileImageView.centerYAnchor.constraint(equalTo: self.stackView.centerYAnchor),
      self.profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      self.profileImageView.widthAnchor.constraint(equalToConstant: Metric.profileImageViewWidth),
      self.profileImageView.heightAnchor.constraint(equalToConstant: Metric.profileImageViewHeight),

      self.stackView.topAnchor.constraint(equalTo: self.topAnchor),
      self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      self.stackView.leadingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor, constant: Metric.stackViewLeadingMargin),
      self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Metric.stackViewTrailingMargin)
    ])
  }
}
