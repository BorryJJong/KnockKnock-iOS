//
//  FeedSearchResultFooterReusableView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/31.
//

import UIKit

import Then
import SnapKit

class FeedSearchResultFooterReusableView: UICollectionReusableView {

  // MARK: - UIs

  private let lineView = UIView().then {
    $0.backgroundColor = .gray20
  }

  // MARK: - Initialize

  override init(frame: CGRect) {
    super.init(frame: .zero)
    self.setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Bind

  func bind(isHeader: Bool) {
    self.lineView.isHidden = isHeader
  }

  // MARK: - Configure

  private func setupConstraints() {
    [self.lineView].addSubViews(self)

    self.lineView.snp.makeConstraints {
      $0.trailing.leading.equalToSuperview()
      $0.top.equalToSuperview().offset(10)
      $0.bottom.equalToSuperview().offset(-15)
      $0.height.equalTo(1)
      $0.width.equalToSuperview()
    }
  }
}
