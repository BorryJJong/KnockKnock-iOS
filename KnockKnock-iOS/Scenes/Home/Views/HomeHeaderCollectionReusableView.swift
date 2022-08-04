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

class HomeHeaderCollectionReusableView: UICollectionReusableView {

  // MARK: - Constants

  private enum Metric {
    static let headerLabelTopMargin = 45.f
    static let headerLabelBottomMargin = -20.f

    static let moreButtonTrailingMargin = -20.f
  }

  // MARK: - UIs

  let headerLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 20, weight: .bold)
    $0.text = "녹녹이 인증한 스토어"
  }

  let moreButton = UIButton().then {
    $0.setTitle("더보기", for: .normal)
    $0.setImage(KKDS.Image.ic_left_10_gr, for: .normal)
    $0.semanticContentAttribute = .forceRightToLeft
    $0.titleLabel?.font = .systemFont(ofSize: 13, weight: .light)
    $0.setTitleColor(.gray80, for: .normal)
  }

  // MARK: - Initailize

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: - Constraints

  func setupConstraints() {
    [self.headerLabel, self.moreButton].addSubViews(self)

    self.headerLabel.snp.makeConstraints {
      $0.leading.equalToSuperview()
      $0.top.equalToSuperview().offset(Metric.headerLabelTopMargin)
      $0.trailing.equalTo(self.moreButton)
      $0.bottom.equalToSuperview().offset(Metric.headerLabelBottomMargin)
    }

    self.moreButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(Metric.moreButtonTrailingMargin)
      $0.centerY.equalTo(self.headerLabel.snp.centerY)
    }
  }
}
