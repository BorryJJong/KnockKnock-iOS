//
//  shopSearchView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/20.
//

import UIKit

import Then
import KKDSKit
import SnapKit

final class ShopSearchView: UIView {

  // MARK: - Properties

  private enum Metric {
    static let cityTextFieldHeight = 40.f
    static let cityTextFieldTopMargin = 20.f
    static let cityTextFieldLeadingMargin = 20.f
    static let cityTextFieldTrailingMargin = -(2.5).f

    static let regionTextFieldHeight = 40.f
    static let regionTextFieldTopMargin = 20.f
    static let regionTextFieldLeadingMargin = (2.5).f
    static let regionTextFieldTrailingMargin = -20.f

    static let addressTextFieldTopMargin = 5.f
    static let addressTextFieldLeadingMargin = 20.f
    static let addressTextFieldTrailingMargin = -50.f
    static let addressTextFieldHeight = 40.f

    static let addressSearchButtonTrailingMargin = -20.f

    static let seperatorLineViewLeadingMargin = 20.f
    static let seperatorLineViewTrailingMargin = -20.f
    static let seperatorLineViewHeight = 1.f

    static let resultTableViewTopMargin = 20.f
    static let resultTableViewLeadingMargin = 20.f
    static let resultTableViewTrailingMargin = -20.f
  }

  private enum TextFieldTag: Int {
    case city = 1
    case county = 2
  }

  // MARK: - UI

  let cityLabel = UILabel().then {
    $0.text = "시/도 전체"
    $0.textColor = KKDS.Color.black
    $0.font = .systemFont(ofSize: 14, weight: .medium)
  }

  let cityButton = UIButton().then {
    $0.setImage(KKDS.Image.ic_down_10_bk, for: .normal)
    $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.gray30?.cgColor
    $0.layer.cornerRadius = 5
    $0.contentHorizontalAlignment = .trailing
    $0.backgroundColor = .clear
  }

  let countyLabel = UILabel().then {
    $0.text = "시/군/구 전체"
    $0.textColor = KKDS.Color.gray30
    $0.font = .systemFont(ofSize: 14, weight: .medium)
  }

  let countyButton = UIButton().then {
    $0.setImage(KKDS.Image.ic_down_10_gr, for: .normal)
    $0.contentHorizontalAlignment = .trailing
    $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.gray30?.cgColor
    $0.layer.cornerRadius = 5
    $0.backgroundColor = KKDS.Color.gray10
    $0.isEnabled = false
  }

  let addressTextField = UITextField().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.placeholder = "매장주소 입력"
    $0.rightView = UIImageView(image: UIImage(named: "ic_input_cancle"))
    $0.rightViewMode = .whileEditing
    $0.font = .systemFont(ofSize: 14, weight: .medium)
  }

  lazy var addressSearchButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setImage(#imageLiteral(resourceName: "ic_search"), for: .normal)
  }

  private let seperatorLineView = UIView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .black
  }

  let resultTableView = UITableView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.separatorStyle = .none
    $0.rowHeight = UITableView.automaticDimension
    $0.registCell(type: AdressCell.self)
    $0.isHidden = true
    $0.contentInsetAdjustmentBehavior = .never
  }

  private let statusImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = UIImage(named: "ic_feed_shopSearch")
  }

  private let statusLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.textColor = .gray60
    $0.text = "매장주소를 검색해보세요."
  }

  lazy var statusStackView = UIStackView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.axis = .vertical
    $0.alignment = .center
    $0.spacing = 10
    $0.addArrangedSubview(statusImageView)
    $0.addArrangedSubview(statusLabel)
  }

  let cityDownIconView = UIImageView(
    frame: CGRect(
      x: 0,
      y: -5,
      width: 10,
      height: 10
    )
  ).then {
    $0.image = KKDS.Image.ic_down_10_bk
  }

  let countyDownIconView = UIImageView(
    frame: CGRect(
      x: 0,
      y: -5,
      width: 10,
      height: 10
    )
  ).then {
    $0.image = KKDS.Image.ic_down_10_gr
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

  func bind(isNoResult: Bool) {
    if isNoResult {
      self.resultTableView.isHidden = true
      self.statusImageView.image = KKDS.Image.ic_no_data_60
      self.statusLabel.text = "검색결과가 없습니다."
    } else {
      self.resultTableView.isHidden = false
    }
  }

  func setButtonStatus(isCitySelected: Bool) {
    self.countyButton.isEnabled = isCitySelected

    if self.countyButton.isEnabled {
      self.countyButton.backgroundColor = .white
      self.countyButton.setImage(KKDS.Image.ic_down_10_bk, for: .normal)

      if self.countyLabel.text == nil {
        self.countyLabel.textColor = KKDS.Color.gray30
      } else {
        self.countyLabel.textColor = KKDS.Color.black
      }
    } else {
      self.countyButton.backgroundColor = KKDS.Color.gray10
      self.countyLabel.textColor = KKDS.Color.gray30
      self.countyDownIconView.image = KKDS.Image.ic_down_10_gr
    }
  }

  // MARK: - Constraints

  private func setupConstraints() {
    [self.cityLabel, self.countyButton, self.countyLabel, self.cityButton,
     self.addressTextField, self.addressSearchButton,
     self.seperatorLineView, self.statusStackView, self.resultTableView].addSubViews(self)

    self.cityButton.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide).offset(Metric.cityTextFieldTopMargin)
      $0.trailing.equalTo(self.safeAreaLayoutGuide.snp.centerX)
      $0.leading.equalTo(self.safeAreaLayoutGuide).offset(Metric.cityTextFieldLeadingMargin)
      $0.height.equalTo(Metric.cityTextFieldHeight)
    }

    self.cityLabel.snp.makeConstraints {
      $0.top.trailing.height.equalTo(self.cityButton)
      $0.leading.equalTo(self.cityButton).offset(10)
    }

    self.countyButton.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide).offset(Metric.regionTextFieldTopMargin)
      $0.trailing.equalTo(self.safeAreaLayoutGuide).offset(Metric.regionTextFieldTrailingMargin)
      $0.leading.equalTo(self.safeAreaLayoutGuide.snp.centerX).offset(Metric.regionTextFieldLeadingMargin)
      $0.height.equalTo(Metric.regionTextFieldHeight)
    }

    self.countyLabel.snp.makeConstraints {
      $0.top.trailing.height.equalTo(self.countyButton)
      $0.leading.equalTo(self.countyButton).offset(10)
    }

    NSLayoutConstraint.activate([
      self.addressTextField.heightAnchor.constraint(equalToConstant: Metric.addressTextFieldHeight),
      self.addressTextField.topAnchor.constraint(equalTo: self.countyButton.bottomAnchor, constant: Metric.addressTextFieldTopMargin),
      self.addressTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.addressTextFieldLeadingMargin),
      self.addressTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.addressTextFieldTrailingMargin),

      self.addressSearchButton.centerYAnchor.constraint(equalTo: self.addressTextField.centerYAnchor),
      self.addressSearchButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.addressSearchButtonTrailingMargin),

      self.seperatorLineView.heightAnchor.constraint(equalToConstant: Metric.seperatorLineViewHeight),
      self.seperatorLineView.topAnchor.constraint(equalTo: self.addressTextField.bottomAnchor),
      self.seperatorLineView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.seperatorLineViewLeadingMargin),
      self.seperatorLineView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.seperatorLineViewTrailingMargin),

      self.resultTableView.topAnchor.constraint(equalTo: self.seperatorLineView.bottomAnchor, constant: Metric.resultTableViewTopMargin),
      self.resultTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.resultTableViewLeadingMargin),
      self.resultTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.resultTableViewTrailingMargin),
      self.resultTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),

      self.statusStackView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
      self.statusStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor)
    ])
  }
}
