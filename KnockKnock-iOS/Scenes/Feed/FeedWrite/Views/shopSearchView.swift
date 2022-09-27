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
    static let cityRegionStackViewHeight = 40.f
    static let cityRegionStackViewTopMargin = 20.f
    static let cityRegionStackViewLeadingMargin = 20.f
    static let cityRegionStackViewTrailingMargin = -20.f
    static let cityRegionStackViewSpacing = 5.f

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
    $0.placeholder = "시/도 전체"
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.gray30?.cgColor
    $0.layer.cornerRadius = 5
    $0.tintColor = .clear
  }

  let regionTextField = UITextField().then {
    $0.placeholder = "구/동 전체"
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.gray30?.cgColor
    $0.layer.cornerRadius = 5
    $0.tintColor = .clear
  }

  lazy var cityRegionStackView = UIStackView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.axis = .horizontal
    $0.spacing = Metric.cityRegionStackViewSpacing
    $0.distribution = .fillEqually
    $0.addArrangedSubview(self.cityTextField)
    $0.addArrangedSubview(self.regionTextField)
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

  let seperatorLineView = UIView().then {
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

  let statusImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = UIImage(named: "ic_feed_shopSearch")
  }

  let statusLabel = UILabel().then {
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

  // MARK: - Configure

  private func setupConfigure() {
    self.addTextFieldPadding(self.cityTextField)
    self.addTextFieldPadding(self.regionTextField)
  }

  private func addTextFieldPadding(_ textField: UITextField) {
    let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
    textField.leftView = leftPaddingView
    textField.leftViewMode = .always

    let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: textField.frame.height))
    let iconView = UIImageView(frame: CGRect(x: 0, y: -5, width: 10, height: 10))
    iconView.image = KKDS.Image.ic_down_10_bk
    rightPaddingView.addSubview(iconView)

    textField.rightView = rightPaddingView
    textField.rightViewMode = .always
  }

  // MARK: - Constraints

  private func setupConstraints() {
    [self.cityRegionStackView, self.addressTextField, self.addressSearchButton, self.seperatorLineView, self.statusStackView, self.resultTableView].addSubViews(self)

    NSLayoutConstraint.activate([
      self.cityRegionStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: Metric.cityRegionStackViewTopMargin),
      self.cityRegionStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.cityRegionStackViewLeadingMargin),
      self.cityRegionStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.cityRegionStackViewTrailingMargin),
      self.cityRegionStackView.heightAnchor.constraint(equalToConstant: Metric.cityRegionStackViewHeight),

      self.addressTextField.heightAnchor.constraint(equalToConstant: Metric.addressTextFieldHeight),
      self.addressTextField.topAnchor.constraint(equalTo: self.cityRegionStackView.bottomAnchor, constant: Metric.addressTextFieldTopMargin),
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
