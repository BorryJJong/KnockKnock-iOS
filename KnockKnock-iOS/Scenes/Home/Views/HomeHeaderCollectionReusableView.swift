//
//  HomeHeaderCollectionReusableView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/03.
//

import UIKit

import Then
import SnapKit
import KKDSKit

final class HomeHeaderCollectionReusableView: UICollectionReusableView {

  // MARK: - Constants

  private enum Metric {
    static let headerLabelTopMargin = 45.f
    static let headerLabelBottomMargin = -20.f

    static let moreButtonTrailingMargin = -20.f
  }

  // MARK: - UIs

  private let headerLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 20, weight: .bold)
    $0.text = "녹녹이 인증한 스토어"
  }

  let moreButton = KKDSMoreButton()

  // MARK: - Initailize

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: - Bind

  func bind(section: HomeSection?) {

    switch section {
    case .store:
      self.headerLabel.text = "녹녹이 인증한 스토어"
      self.moreButton.isHidden = false

    case .tag:
      self.headerLabel.text = "오늘의 인기 게시글 🔥"
      self.moreButton.isHidden = true

    case .event:
      self.headerLabel.text = "더 특별한 이벤트 🎉"
      self.moreButton.isHidden = false

    default:
      self.headerLabel.text = ""
    }
  }

  // MARK: - Constraints

  private func setupConstraints() {
    [self.headerLabel, self.moreButton].addSubViews(self)

    self.headerLabel.snp.makeConstraints {
      $0.leading.equalToSuperview()
      $0.trailing.equalTo(self.moreButton)
    }

    self.moreButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(Metric.moreButtonTrailingMargin)
      $0.centerY.equalTo(self.headerLabel.snp.centerY)
    }
  }
}
