//
//  NoticeCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/10/31.
//

import UIKit

import Then
import SnapKit

final class NoticeCell: BaseCollectionViewCell {

  // MARK: - UIs

  private let titleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 15, weight: .bold)
    $0.text = "시스템 점검 안내"
    $0.numberOfLines = 1
  }

  private let dateLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 13, weight: .medium)
    $0.textColor = .gray70
    $0.text = "2022.10.24"
    $0.numberOfLines = 1
  }

  lazy var separatorLineView = UIView().then {
    $0.backgroundColor = .gray20
  }

  // MARK: - Configure

  override func setupConstraints() {
    [self.titleLabel, self.dateLabel, self.separatorLineView].addSubViews(self.contentView)

    self.titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(20)
    }

    self.dateLabel.snp.makeConstraints {
      $0.top.equalTo(self.titleLabel.snp.bottom).offset(3)
      $0.leading.trailing.equalToSuperview().inset(20)
    }

    self.separatorLineView.snp.makeConstraints {
      $0.height.equalTo(1)
      $0.top.equalTo(self.dateLabel.snp.bottom).offset(20)
      $0.bottom.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(20)
    }
  }
}
