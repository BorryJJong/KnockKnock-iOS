//
//  FeedSearchResultHeaderReusableView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/30.
//

import UIKit

import Then
import SnapKit

class FeedSearchResultHeaderReusableView: UICollectionReusableView {

  // MARK: - UIs

  private let headerLabel = UILabel().then {
    $0.text = "최근 검색"
    $0.font = .systemFont(ofSize: 15)
    $0.textColor = .gray80
  }

  let deleteLogButton = UIButton().then {
    $0.setTitle("전체 삭제", for: .normal)
    $0.setTitleColor(.gray60, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 15)
  }

  // MARK: - Initialize

  override init(frame: CGRect) {
    super.init(frame: .zero)
    self.setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Configure

  private func setupConstraints() {
    [self.headerLabel, self.deleteLogButton].addSubViews(self)

    self.headerLabel.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-5)
      $0.leading.equalToSuperview()
    }

    self.deleteLogButton.snp.makeConstraints {
      $0.centerY.equalTo(self.headerLabel.snp.centerY)
      $0.trailing.equalToSuperview()
    }
  }
}
