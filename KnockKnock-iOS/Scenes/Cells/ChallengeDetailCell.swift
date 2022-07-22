//
//  ChallengeDetailCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/05/10.
//

import UIKit

final class ChallengeDetailCell: BaseCollectionViewCell {

  // MARK: - Constants

  private enum Metric {
    static let titleLabelTopMargin = 40.f
    static let titleLabelHeight = 20.f

    static let exampleImageViewHeight = 200.f
    static let exampleImageViewTopMargin = 15.f

    static let contentsLabelTopMargin = 15.f
    static let contentsLabelBottomMargin = -20.f
  }

  // MARK: - UIs

  private let titleLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.textColor = .green50
    $0.font = .systemFont(ofSize: 17, weight: .bold)
    $0.textAlignment = .left
    $0.text = "제로웨이스트를 실천 해야하는 이유"
  }

  private let exampleImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = UIImage(named: "challenge")
    $0.contentMode = .scaleToFill
    $0.layer.cornerRadius = 5
    $0.clipsToBounds = true
  }

  private let contentsLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.textAlignment = .natural
    $0.numberOfLines = 0
    $0.sizeToFit()
  }

  // MARK: - Bind

  func bind(challengeContent: ChallengeContent) {
    self.titleLabel.text = challengeContent.title

    self.exampleImageView.image = challengeContent.image
      .flatMap { URL(string: $0) }
      .flatMap { try? Data(contentsOf: $0) }
      .flatMap { UIImage(data: $0) }
    ?? UIImage(named: "challenge")

    self.contentsLabel.setLineHeight(fontSize: 14, content: challengeContent.content)
  }

  // MARK: - Configure

  override func setupConstraints() {
    [self.titleLabel, self.exampleImageView, self.contentsLabel].addSubViews(self.contentView)

    NSLayoutConstraint.activate([
      self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Metric.titleLabelTopMargin),
      self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
      self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
      self.titleLabel.heightAnchor.constraint(equalToConstant: Metric.titleLabelHeight),

      self.exampleImageView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: Metric.exampleImageViewTopMargin),
      self.exampleImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
      self.exampleImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
      self.exampleImageView.heightAnchor.constraint(equalToConstant: Metric.exampleImageViewHeight),

      self.contentsLabel.topAnchor.constraint(equalTo: self.exampleImageView.bottomAnchor, constant: Metric.contentsLabelTopMargin),
      self.contentsLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
      self.contentsLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
      self.contentsLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: Metric.contentsLabelBottomMargin)
    ])
  }
}
