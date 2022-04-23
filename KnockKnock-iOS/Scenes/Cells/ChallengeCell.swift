//
//  ChallengeCell.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/03/06.
//

import UIKit

final class ChallengeCell: BaseTableViewCell {
  
  // MARK: - Constants
  
  private enum Metric {
    static let challengeHeight = 245.f
  }
 
  // MARK: - UI
  
  let challengeImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = UIImage(named: "challenge")
  }
  let titleLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = "#GOGO 챌린지"
    $0.numberOfLines = 1
    $0.textAlignment = .left
  }
  let contentsLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = "쓰레기를 줄이자는 의미의 제로웨이스트 운동이 활발해 지고있다. 제로웨이스트에 대해 좀 더 알아보자!"
    $0.numberOfLines = 0
    $0.textAlignment = .left
  }
  
  // MARK: - Bind
  
  func bind(data: Challenge) {
    self.titleLabel.text = data.title
    self.contentsLabel.text = data.contents
  }
  
  // MARK: - Configure
  
  override func setupConstraints() {
    [self.challengeImageView, self.titleLabel, self.contentsLabel].addSubViews(self.contentView)
    
    NSLayoutConstraint.activate([
      self.challengeImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
      self.challengeImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
      self.challengeImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
      self.challengeImageView.heightAnchor.constraint(equalToConstant: Metric.challengeHeight),
      
      self.titleLabel.topAnchor.constraint(equalTo: self.challengeImageView.bottomAnchor, constant: 10),
      self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
      self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
      
      self.contentsLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 5),
      self.contentsLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
      self.contentsLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
      self.contentsLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
    ])
  }
}
