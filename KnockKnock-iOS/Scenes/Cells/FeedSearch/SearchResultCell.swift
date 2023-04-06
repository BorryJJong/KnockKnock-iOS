//
//  SearchResultCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/30.
//

import UIKit

import Then
import SnapKit
import KKDSKit

final class SearchResultCell: BaseCollectionViewCell {

  // MARK: - Constants

  private enum Metric {
    static let imageViewTopMargin = 5.f
    static let imageViewLeadingMargin = 20.f
    static let imageViewWidth = 52.f

    static let dataLabelLeadingMargin = 20.f
    static let dataLabelTrailingMargin = -10.f

    static let deleteButtonTrailingMargin = -20.f
  }

  // MARK: - UIs

  private let imageView = UIImageView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 26
    $0.clipsToBounds = true
  }

  private let dataLabel = UILabel().then {
    $0.text = "검색 결과"
    $0.numberOfLines = 1
  }

  private let deleteButton = UIButton().then {
    $0.setImage(KKDS.Image.ic_close_10_gr, for: .normal)
  }

  // MARK: - Bind

  func bind(tap: SearchTap, isLogSection: Bool, keyword: SearchKeyword) {
    self.imageView.backgroundColor = .white
    self.deleteButton.isHidden = !isLogSection
    self.dataLabel.text = keyword.keyword

    switch tap {
    case .popular:
      let category = SearchTap(rawValue: keyword.category)

      switch category {
      case .account:
        self.imageView.image = KKDS.Image.ic_person_24

      case .tag:
        self.imageView.image = KKDS.Image.ic_search_tag_52

      case .place:
        self.imageView.image = KKDS.Image.ic_search_location_52

      default:
        self.imageView.backgroundColor = KKDS.Color.gray30
        self.imageView.image = nil
      }

    case .account:
      self.imageView.image = KKDS.Image.ic_person_24

    case .tag:
      self.imageView.image = KKDS.Image.ic_search_tag_52

    case .place:
      self.imageView.image = KKDS.Image.ic_search_location_52
    }
    
  }

  // MARK: - Configure

  override func setupConstraints() {
    [self.imageView, self.dataLabel, self.deleteButton].addSubViews(self.contentView)

    self.imageView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview().inset(Metric.imageViewTopMargin)
      $0.leading.equalToSuperview().offset(Metric.imageViewLeadingMargin)
      $0.width.height.equalTo(Metric.imageViewWidth)
    }

    self.dataLabel.snp.makeConstraints {
      $0.centerY.equalTo(self.imageView.snp.centerY)
      $0.leading.equalTo(self.imageView.snp.trailing).offset(Metric.dataLabelLeadingMargin)
      $0.trailing.equalTo(self.deleteButton.snp.leading).offset(Metric.dataLabelTrailingMargin)
    }

    self.deleteButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(Metric.deleteButtonTrailingMargin)
      $0.centerY.equalTo(self.imageView.snp.centerY)
    }
  }
}
