//
//  EventListView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/19.
//

import UIKit

import SnapKit
import KKDSKit
import Then

class EventListView: UIView {

  // MARK: - UIs

  let eventCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then {
      $0.scrollDirection = .vertical
      $0.minimumLineSpacing = 20
      $0.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
    }
  ).then {
    $0.backgroundColor = .clear
  }

  private let statusImageView = UIImageView().then {
    $0.image = KKDS.Image.ic_no_data_60
  }

  private let statusLabel = UILabel().then {
    $0.textColor = .gray60
    $0.text = "현재 진행중인 이벤트가 없습니다."
  }

  lazy var statusStackView = UIStackView().then {
    $0.axis = .vertical
    $0.alignment = .center
    $0.spacing = 10
    $0.addArrangedSubview(self.statusImageView)
    $0.addArrangedSubview(self.statusLabel)
  }

  // MARK: - Initailize

  init() {
    super.init(frame: .zero)
    self.setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: - Bind

  /// 이벤트 없음 상태 표시
  ///
  /// - Parameters:
  ///   - hasData: 이벤트 데이터 존재 여부(있음: true/ 없음: false)
  func showResult(hasData: Bool) {
    self.eventCollectionView.isHidden = !hasData
    self.statusStackView.isHidden = hasData
  }

  // MARK: - Configure

  private func setupConstraints() {
    [self.eventCollectionView, self.statusStackView].addSubViews(self)

    self.eventCollectionView.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
      $0.leading.trailing.bottom.equalTo(self)
    }

    self.statusStackView.snp.makeConstraints {
      $0.centerX.centerY.equalTo(self)
    }
  }
}
