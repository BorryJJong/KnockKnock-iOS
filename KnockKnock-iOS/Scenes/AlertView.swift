//
//  AlertView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/28.
//

import UIKit

import SnapKit
import Then

final class AlertView: UIView {

  // MARK: - Constants

  private enum Metric {
    static let alertViewLeadingMargin = 20.f
    static let alertViewHeight = 130.f

    static let contentLabelTopMargin = 30.f
    static let contentLabelTrailingMargin = 20.f

    static let confirmButtonTrailingMargin = -20.f

    static let cancelButtonTrailingMargin = -30.f
  }

  // MARK: - UIs

  private let dimmedView = UIView().then {
    $0.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.2)
  }

  private let alertView = UIView().then {
    $0.backgroundColor = .white
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 5
  }

  private let contentLabel = UILabel().then {
    $0.text = "내용입니다."
    $0.font = .systemFont(ofSize: 14, weight: .medium)
  }

  let cancelButton = UIButton().then {
    $0.setTitle("취소", for: .normal)
    $0.setTitleColor(.gray60, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
    $0.tag = 0
  }

  let confirmButton = UIButton().then {
    $0.setTitle("확인", for: .normal)
    $0.setTitleColor(.green40, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
    $0.tag = 1
  }

  // MARK: - Initialize

  init() {
    super.init(frame: .zero)
    self.setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: - Bind

  func bind(content: String, isCancelActive: Bool) {
    self.cancelButton.isHidden = !isCancelActive
    self.contentLabel.text = content
  }

  // MARK: - Configure

  private func setupConstraints() {
    [self.dimmedView, self.alertView].addSubViews(self)
    [self.contentLabel, self.cancelButton, self.confirmButton].addSubViews(self.alertView)

    self.dimmedView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    self.alertView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(Metric.alertViewLeadingMargin)
      $0.height.equalTo(Metric.alertViewHeight)
    }

    self.contentLabel.snp.makeConstraints {
      $0.top.equalTo(self.alertView.snp.top).offset(Metric.contentLabelTopMargin)
      $0.trailing.leading.equalToSuperview().inset(Metric.contentLabelTrailingMargin)
    }

    self.confirmButton.snp.makeConstraints {
      $0.trailing.bottom.equalToSuperview().offset(Metric.confirmButtonTrailingMargin)
    }

    self.cancelButton.snp.makeConstraints {
      $0.trailing.equalTo(self.confirmButton.snp.leading).offset(Metric.cancelButtonTrailingMargin)
      $0.bottom.equalTo(self.confirmButton)
    }
  }
}
