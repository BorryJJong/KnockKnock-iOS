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

  private let cancelButton = UIButton().then {
    $0.setTitle("취소", for: .normal)
    $0.setTitleColor(.gray60, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
  }

  private let confirmButton = UIButton().then {
    $0.setTitle("확인", for: .normal)
    $0.setTitleColor(.green40, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
  }

  // MARK: - Initialize

  init() {
    super.init(frame: .zero)
    self.setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: - Configure

  private func setupConstraints() {
    self.dimmedView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    self.alertView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
      $0.height.equalTo(130)
    }
  }
}
