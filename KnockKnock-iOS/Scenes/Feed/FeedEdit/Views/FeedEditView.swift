//
//  FeedEditView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/12/18.
//

import UIKit

import KKDSKit
import SnapKit
import Then

final class FeedEditView: UIView {

  // MARK: - Constants

  private enum Metric {

    static let buttonCornerRadius = 5.f

    static let tagTopMargin = 25.f
    static let tagLeadingMargin = 20.f
    static let tagTrailingMargin = -60.f
    static let tagHeigth = 40.f

    static let promotionTopMargin = 25.f
    static let promotionLeadingMargin = 20.f
    static let promotionTrailingMargin = -60.f

    static let shopTopMargin = 25.f
    static let shopLeadingMargin = 20.f
    static let shopTrailingMargin = -60.f

    static let selectButtonHeight = 65.f

    static let selectImageTopMargin = 5.f
    static let selectImageTrailingMargin = -20.f

    static let separatorHeight = 1.f
    static let separatorWidthMargin = -40.f

    static let contentTextViewTopMargin = 20.f
    static let contentTextViewLeadingMargin = 20.f
    static let contentTextViewTrailingMargin = -20.f
    static let contentTextViewBottomMargin = -20.f

    static let doneButtonHeight = 45.f
    static let doneButtonBottomMargin = -10.f
    static let doneButtonleadingMargin = 20.f
    static let doneButtonTrailingMargin = -20.f
  }

  // MARK: - UI

  private let tagLabel = UILabel().then {
    $0.text = "#태그"
    $0.font = .systemFont(ofSize: 14)
    $0.tintColor = .black
  }

  let tagSelectButton = UIButton().then {
    $0.setImage(KKDS.Image.ic_left_10_gr, for: .normal)
    $0.contentHorizontalAlignment = .right
    $0.contentVerticalAlignment = .center
    $0.backgroundColor = .clear
  }

  private lazy var tagSeparateLineView = UIView().then {
    $0.backgroundColor = .gray20
  }

  private let promotionLabel = UILabel().then {
    $0.text = "프로모션"
    $0.font = .systemFont(ofSize: 14)
    $0.tintColor = .black
  }

  let promotionSelectButton = UIButton().then {
    $0.setImage(KKDS.Image.ic_left_10_gr, for: .normal)
    $0.contentHorizontalAlignment = .right
    $0.contentVerticalAlignment = .center
    $0.backgroundColor = .clear
  }

  private let promotionSeparateLineView = UIView().then {
    $0.backgroundColor = .gray20
  }

  private let shopNameLabel = UILabel().then {
    $0.text = "매장명 (선택)"
    $0.font = .systemFont(ofSize: 14)
    $0.tintColor = KKDS.Color.black

    if let text = $0.text {
      let attributedText = NSMutableAttributedString(string: text)

      attributedText.addAttribute(
        .foregroundColor,
        value: KKDS.Color.gray40,
        range: (text as NSString).range(of: "(선택)")
      )
      $0.attributedText = attributedText
    }
  }

  let shopSearchButton = UIButton().then {
    $0.setImage(KKDS.Image.ic_left_10_gr, for: .normal)
    $0.contentHorizontalAlignment = .right
    $0.contentVerticalAlignment = .center
    $0.backgroundColor = .clear
  }

  private let shopNameSeparateLineView = UIView().then {
    $0.backgroundColor = .gray20
  }

  private let shopAddressLabel = UILabel().then {
    $0.text = "매장주소 (선택)"
    $0.font = .systemFont(ofSize: 14)
    $0.tintColor = KKDS.Color.black

    if let text = $0.text {
      let attributedText = NSMutableAttributedString(string: text)

      attributedText.addAttribute(
        .foregroundColor,
        value: KKDS.Color.gray40,
        range: (text as NSString).range(of: "(선택)")
      )
      $0.attributedText = attributedText
    }
  }

  private let shopAddressSeparateLineView = UIView().then {
    $0.backgroundColor = .gray20
  }

  private lazy var doneBarButton = UIBarButtonItem(
    barButtonSystemItem: .done,
    target: nil,
    action: #selector(self.doneBarButtonDidTap)
  ).then {
    $0.tintColor = KKDS.Color.green50
  }

  private let flexibleSpaceButton = UIBarButtonItem(
    barButtonSystemItem: .flexibleSpace,
    target: nil,
    action: nil
  )

  private lazy var toolbar = UIToolbar().then {
    $0.sizeToFit()
    $0.setItems([
      self.flexibleSpaceButton,
      self.flexibleSpaceButton,
      self.doneBarButton
    ], animated: false
    )
  }

  lazy var contentTextView = UITextView().then {
    $0.textColor = .black
    $0.font = .systemFont(ofSize: 14)
    $0.inputAccessoryView = self.toolbar
  }

  let doneButton = KKDSLargeButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setTitle("수정", for: .normal)
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

  func bind(data: FeedDetail?) {
    guard let challenges = data?.challenges
      .map({ $0.title })
      .joined(separator: ", ")
    else { return }

    self.setTag(tag: challenges)

    if let promotions = data?.promotions
      .map({ $0.title })
      .joined(separator: ", ") {

      self.setPromotion(promotion: promotions)
    }

    self.contentTextView.text = data?.feed.content

    guard let storeName = data?.feed.storeName,
          let storeAddress = data?.feed.storeAddress else { return }

    self.setAddress(name: storeName, address: storeAddress)
  }

  func setTag(tag: String) {
    self.tagLabel.text = tag
  }

  func setPromotion(promotion: String) {
    if promotion == "" {
      self.promotionLabel.text = "프로모션"
    } else {
      self.promotionLabel.text = promotion
    }
  }

  func setAddress(name: String, address: String) {
    self.shopNameLabel.text = name
    self.shopAddressLabel.text = address
  }

  // MARK: - Configure

  @objc private func doneBarButtonDidTap(_ sender: UIBarButtonItem) {
    self.endEditing(true)
  }

  func setContainerViewConstant(notification: Notification, isAppearing: Bool) {
    let userInfo = notification.userInfo

    if let keyboardFrame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
      let keyboardSize = keyboardFrame.cgRectValue
      let keyboardHeight = keyboardSize.height

      guard let animationDurationValue = userInfo?[
        UIResponder
          .keyboardAnimationDurationUserInfoKey
      ] as? NSNumber else { return }

      let viewBottomConstant = isAppearing
      ? -(keyboardHeight) + Metric.doneButtonHeight + -(Metric.doneButtonBottomMargin)
      : Metric.contentTextViewBottomMargin

      self.contentTextView.snp.updateConstraints {
        $0.bottom.equalTo(self.doneButton.snp.top).offset(viewBottomConstant)
      }

      UIView.animate(withDuration: animationDurationValue.doubleValue) {
        self.layoutIfNeeded()
      }
    }
  }

  // MARK: - Constraints

  private func setupConstraints() {
    [self.tagLabel, self.tagSelectButton, self.tagSeparateLineView].addSubViews(self)
    [self.promotionLabel, self.promotionSelectButton, self.promotionSeparateLineView].addSubViews(self)
    [self.shopAddressLabel, self.shopSearchButton, self.shopAddressSeparateLineView].addSubViews(self)
    [self.shopNameLabel, self.shopNameSeparateLineView].addSubViews(self)
    [self.contentTextView, self.doneButton].addSubViews(self)

    self.tagLabel.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide).offset(Metric.tagTopMargin)
      $0.leading.equalTo(self.safeAreaLayoutGuide).inset(Metric.tagLeadingMargin)
      $0.trailing.equalTo(self.safeAreaLayoutGuide).offset(Metric.tagTrailingMargin)
    }

    self.tagSelectButton.snp.makeConstraints {
      $0.centerY.equalTo(self.tagLabel)
      $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(Metric.tagLeadingMargin)
      $0.height.equalTo(Metric.selectButtonHeight)
    }

    self.tagSeparateLineView.snp.makeConstraints {
      $0.top.equalTo(self.tagSelectButton.snp.bottom)
      $0.height.equalTo(Metric.separatorHeight)
      $0.width.equalTo(self.safeAreaLayoutGuide).offset(Metric.separatorWidthMargin)
      $0.centerX.equalToSuperview()
    }

    self.promotionLabel.snp.makeConstraints {
      $0.top.equalTo(self.tagSeparateLineView.snp.bottom).offset(Metric.promotionTopMargin)
      $0.leading.equalTo(self.safeAreaLayoutGuide).inset(Metric.promotionLeadingMargin)
      $0.trailing.equalTo(self.safeAreaLayoutGuide).offset(Metric.promotionTrailingMargin)
    }

    self.promotionSelectButton.snp.makeConstraints {
      $0.centerY.leading.equalTo(self.promotionLabel)
      $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(Metric.tagLeadingMargin)
      $0.height.equalTo(Metric.selectButtonHeight)
    }

    self.promotionSeparateLineView.snp.makeConstraints {
      $0.top.equalTo(self.promotionSelectButton.snp.bottom)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(Metric.separatorHeight)
      $0.width.equalTo(self.safeAreaLayoutGuide).offset(Metric.separatorWidthMargin)
    }

    self.shopNameLabel.snp.makeConstraints {
      $0.top.equalTo(self.promotionSeparateLineView.snp.bottom).offset(Metric.shopTopMargin)
      $0.leading.equalTo(self.safeAreaLayoutGuide).inset(Metric.shopLeadingMargin)
      $0.trailing.equalTo(self.safeAreaLayoutGuide).offset(Metric.shopTrailingMargin)
    }

    self.shopSearchButton.snp.makeConstraints {
      $0.centerY.leading.equalTo(self.shopNameLabel)
      $0.trailing.equalTo(self.safeAreaLayoutGuide).offset(Metric.selectImageTrailingMargin)
      $0.height.equalTo(Metric.selectButtonHeight)
    }

    self.shopNameSeparateLineView.snp.makeConstraints {
      $0.top.equalTo(self.shopSearchButton.snp.bottom)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(Metric.separatorHeight)
      $0.width.equalTo(self.safeAreaLayoutGuide).offset(Metric.separatorWidthMargin)
    }

    self.shopAddressLabel.snp.makeConstraints {
      $0.top.equalTo(self.shopNameSeparateLineView.snp.bottom).offset(Metric.shopTopMargin)
      $0.leading.equalTo(self.safeAreaLayoutGuide).inset(Metric.shopLeadingMargin)
      $0.trailing.equalTo(self.safeAreaLayoutGuide).offset(Metric.shopTrailingMargin)
    }

    self.shopAddressSeparateLineView.snp.makeConstraints {
      $0.top.equalTo(self.shopAddressLabel.snp.centerY).offset(Metric.selectButtonHeight/2)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(Metric.separatorHeight)
      $0.width.equalTo(self.safeAreaLayoutGuide).offset(Metric.separatorWidthMargin)
    }

    self.contentTextView.snp.makeConstraints {
      $0.top.equalTo(self.shopAddressSeparateLineView.snp.bottom).offset(Metric.contentTextViewTopMargin)
      $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(Metric.contentTextViewLeadingMargin)
      $0.bottom.equalTo(self.doneButton.snp.top).offset(Metric.contentTextViewBottomMargin)
    }

    self.doneButton.snp.makeConstraints {
      $0.height.equalTo(Metric.doneButtonHeight)
      $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(Metric.doneButtonBottomMargin)
      $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(Metric.doneButtonleadingMargin)
    }
  }
}
