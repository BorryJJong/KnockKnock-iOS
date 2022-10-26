//
//  shopSearchView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/20.
//

import UIKit

import Then
import KKDSKit

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

  // MARK: - UI

  let cityTextField = UITextField().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.placeholder = "시/도 전체"
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.gray30?.cgColor
    $0.layer.cornerRadius = 5
    $0.tintColor = .clear
  }

  let cityButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .clear
  }

  let countyTextField = UITextField().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.placeholder = "시/군/구 전체"
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.gray30?.cgColor
    $0.layer.cornerRadius = 5
    $0.tintColor = .clear
  }

  let countyButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .clear
  }

  let addressTextField = UITextField().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.placeholder = "매장주소 입력"
    $0.rightView = UIImageView(image: UIImage(named: "ic_input_cancle"))
    $0.rightViewMode = .whileEditing
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

  // MARK: - Initialize

  init() {
    super.init(frame: .zero)
    self.setupConstraints()
    self.setupConfigure()
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

  // MARK: - Configure

  private func setupConfigure() {
    self.addTextFieldPadding(self.cityTextField)
    self.addTextFieldPadding(self.countyTextField)
  }

  private func addTextFieldPadding(_ textField: UITextField) {
    let leftPaddingView = UIView(
      frame: CGRect(
        x: 0,
        y: 0,
        width: 10,
        height: textField.frame.height
      ))
    textField.leftView = leftPaddingView
    textField.leftViewMode = .always

    let rightPaddingView = UIView(
      frame: CGRect(
        x: 0,
        y: 0,
        width: 20,
        height: textField.frame.height
      ))
    let iconView = UIImageView(
      frame: CGRect(
        x: 0,
        y: -5,
        width: 10,
        height: 10
      ))
    iconView.image = KKDS.Image.ic_down_10_bk
    rightPaddingView.addSubview(iconView)

    textField.rightView = rightPaddingView
    textField.rightViewMode = .always
  }

  // MARK: - Constraints

  private func setupConstraints() {
    [self.cityTextField, self.countyTextField, self.cityButton, self.countyButton,
     self.addressTextField, self.addressSearchButton,
     self.seperatorLineView, self.statusStackView, self.resultTableView].addSubViews(self)

    NSLayoutConstraint.activate([
      self.cityTextField.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: Metric.cityTextFieldTopMargin),
      self.cityTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor, constant: Metric.cityTextFieldTrailingMargin),
      self.cityTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.cityTextFieldLeadingMargin),
      self.cityTextField.heightAnchor.constraint(equalToConstant: Metric.cityTextFieldHeight),

      self.countyTextField.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: Metric.regionTextFieldTopMargin),
      self.countyTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.regionTextFieldTrailingMargin),
      self.countyTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor, constant: Metric.regionTextFieldLeadingMargin),
      self.countyTextField.heightAnchor.constraint(equalToConstant: Metric.regionTextFieldHeight),

      self.cityButton.topAnchor.constraint(equalTo: self.cityTextField.topAnchor),
      self.cityButton.leadingAnchor.constraint(equalTo: self.cityTextField.leadingAnchor),
      self.cityButton.trailingAnchor.constraint(equalTo: self.cityTextField.trailingAnchor),
      self.cityButton.bottomAnchor.constraint(equalTo: self.cityTextField.bottomAnchor),

      self.countyButton.topAnchor.constraint(equalTo: self.countyTextField.topAnchor),
      self.countyButton.leadingAnchor.constraint(equalTo: self.countyTextField.leadingAnchor),
      self.countyButton.trailingAnchor.constraint(equalTo: self.countyTextField.trailingAnchor),
      self.countyButton.bottomAnchor.constraint(equalTo: self.countyTextField.bottomAnchor),

      self.addressTextField.heightAnchor.constraint(equalToConstant: Metric.addressTextFieldHeight),
      self.addressTextField.topAnchor.constraint(equalTo: self.cityTextField.bottomAnchor, constant: Metric.addressTextFieldTopMargin),
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
