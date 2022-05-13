//
//  ChallengeDetailCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/05/10.
//

import UIKit

final class ChallengeDetailCell: BaseTableViewCell {

  // MARK: - Constants

  private enum Metric {
    static let titleLabelTopMargin = 20.f
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
    $0.layer.cornerRadius = 10
  }

  private let contentsLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.textColor = .black
    $0.font = .systemFont(ofSize: 14, weight: .regular)
    $0.textAlignment = .natural
    $0.numberOfLines = 0
    $0.text = "모든 제품이 재사용되도록 자원 수명주기의 재 설계를 장려하는 폐기물 예방에 중점을 둔 원칙입니다. 목표는 쓰레기를 매립지, 소각로 또는 바다로 보내지 않는 것입니다. 실제로 사람들이 많이 사용하는 '종이컵'은 사용하는데에는 10분도 채 걸리지 않지만 썩는 데에는 무려 20년에서 50년이 걸린다고 합니다. 또 페트병이 분해되는데 걸리는 시간은 약 450~500년입니다. 그러니 플라스틱은 발명된지 약 100~150년 동안 단 한 개도 썩지 않았다는 것입니다. 이것들이 바다에 버려지고 땅에 계속 묻히게 된다면 지구는 머지않아 ‘쓰레기 섬’이 되어버릴 것입니다. 그러한 문제들을 조금이나마 늦추고 벗어나기 위해 많은 사람들이 ‘제로 웨이스트’ 에 관심을 가지고 실천하고 있습니다."
  }

  // MARK: - Bind

  override func setupConstraints() {
    [self.titleLabel, self.exampleImageView, self.contentsLabel].addSubViews(self.contentView)

    NSLayoutConstraint.activate([
      self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Metric.titleLabelTopMargin),
      self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
      self.titleLabel.heightAnchor.constraint(equalToConstant: Metric.titleLabelHeight),

      self.exampleImageView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: Metric.exampleImageViewTopMargin),
      self.exampleImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
      self.exampleImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
      self.exampleImageView.heightAnchor.constraint(equalToConstant: Metric.exampleImageViewHeight),

      self.contentsLabel.topAnchor.constraint(equalTo: self.exampleImageView.bottomAnchor, constant: Metric.contentsLabelTopMargin),
      self.contentsLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
      self.contentsLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
      self.contentsLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: Metric.contentsLabelBottomMargin),
    ])
  }
}
