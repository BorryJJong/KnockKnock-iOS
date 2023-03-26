//
//  AlertView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/28.
//

import UIKit

import SnapKit
import KKDSKit
import Then

final class AlertView: UIView {

  // MARK: - Properties

  private var content: String?

  // MARK: - Constants

  private enum Metric {
    static let alertViewLeadingMargin = 20.f
    static let alertViewBottomMargin = 20.f

    static let contentLabelTopMargin = 30.f
    static let contentLabelTrailingMargin = 20.f

    static let confirmButtonTrailingMargin = -20.f
    static let confirmButtonTopMargin = 40.f
    static let confirmButtonHeight = 30.f

    static let cancelButtonTrailingMargin = -30.f
    static let cancelButtonHeight = 30.f
  }

  // MARK: - UIs

  private let alertView = UIView().then {
    $0.backgroundColor = KKDS.Color.gray10
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 10
  }

  private let contentLabel = UILabel().then {
    $0.numberOfLines = 0
    $0.font = .systemFont(ofSize: 14, weight: .medium)
  }

  let cancelButton = UIButton().then {
    $0.setTitle("취소", for: .normal)
    $0.setTitleColor(KKDS.Color.gray60, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
    $0.tag = 0
  }

  let confirmButton = UIButton().then {
    $0.setTitle("확인", for: .normal)
    $0.setTitleColor(KKDS.Color.green40, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
    $0.tag = 1
  }

  // MARK: - Initialize

  init() {
    super.init(frame: .zero)
    self.setupConstraints()
    self.configure()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: - Bind

  func bind(content: String, isCancelActive: Bool) {
    let attrString = NSMutableAttributedString(string: content)
    let paragraphStyle = NSMutableParagraphStyle()

    paragraphStyle.lineSpacing = 4
    attrString.addAttribute(
      NSAttributedString.Key.paragraphStyle,
      value: paragraphStyle,
      range: NSMakeRange(
        0,
        attrString.length
      )
    )

    self.contentLabel.attributedText = attrString
    self.cancelButton.isHidden = !isCancelActive
  }

  // MARK: - Constraints

  private func configure() {
    self.backgroundColor = .clear
  }

  private func setupConstraints() {
    [self.alertView].addSubViews(self)
    [self.contentLabel, self.cancelButton, self.confirmButton].addSubViews(self.alertView)

    self.alertView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(Metric.alertViewLeadingMargin)
      $0.bottom.equalTo(self.cancelButton.snp.bottom).offset(Metric.alertViewBottomMargin)
    }

    self.contentLabel.snp.makeConstraints {
      $0.top.equalTo(self.alertView.snp.top).offset(Metric.contentLabelTopMargin)
      $0.trailing.leading.equalToSuperview().inset(Metric.contentLabelTrailingMargin)
    }

    self.confirmButton.snp.makeConstraints {
      $0.top.equalTo(self.contentLabel.snp.bottom).offset(Metric.confirmButtonTopMargin)
      $0.trailing.equalToSuperview().offset(Metric.confirmButtonTrailingMargin)
      $0.height.equalTo(Metric.confirmButtonHeight)
    }

    self.cancelButton.snp.makeConstraints {
      $0.top.equalTo(self.confirmButton)
      $0.trailing.equalTo(self.confirmButton.snp.leading).offset(Metric.cancelButtonTrailingMargin)
      $0.height.equalTo(Metric.cancelButtonHeight)
    }
  }
}
