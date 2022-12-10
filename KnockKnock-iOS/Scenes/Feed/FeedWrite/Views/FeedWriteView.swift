//
//  FeedWriteView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/17.
//

import UIKit

import KKDSKit
import SnapKit
import Then

class FeedWriteView: UIView {

  // MARK: - Constants

  private enum Metric {

    static let buttonCornerRadius = 5.f

    static let photoAddButtonWidth = 65.f
    static let photoAddButtonHeight = 65.f
    static let photoAddButtonTopMargin = 20.f
    static let photoAddButtonLeadingMargin = 20.f

    static let photoCollectionViewTopMargin = -10.f
    static let photoCollectionViewLeadingMargin = 20.f

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

  let photoCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then {
      $0.scrollDirection = .horizontal
    }
  ).then {
    $0.backgroundColor = .clear
  }

  let photoAddButton = UIButton().then {
    $0.setImage(KKDS.Image.ic_post_camera_24_gr, for: .normal)
    $0.setTitle("0/5", for: .normal)
    $0.setTitleColor(.gray60, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 14)
    $0.contentVerticalAlignment = .center
    $0.contentHorizontalAlignment = .center
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.gray50?.cgColor
    $0.layer.cornerRadius = Metric.buttonCornerRadius
    $0.alignTextBelow(spacing: 0)
  }

  private let tagLabel = UILabel().then {
    $0.text = "#태그"
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

  let contentTextView = UITextView().then {
    $0.textColor = .gray40
    $0.font = .systemFont(ofSize: 14)
    $0.text = "내용을 입력해주세요. (글자수 1,000자 이내)"
  }

  private let doneButton = UIButton().then {
    $0.setTitle("등록 완료", for: .normal)
    $0.layer.cornerRadius = Metric.buttonCornerRadius
    $0.backgroundColor = .gray40
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

  func setTag(tag: String) {
    self.tagLabel.text = tag
  }

  func setPromotion(promotion: String) {
    self.promotionLabel.text = promotion
  }

  func setAddress(name: String, address: String) {
    self.shopNameLabel.text = name
    self.shopAddressLabel.text = address
  }

  // MARK: - Constraints

  private func setupConstraints() {
    [self.photoAddButton, self.photoCollectionView].addSubViews(self)
    [self.tagLabel, self.tagSelectButton, self.tagSeparateLineView].addSubViews(self)
    [self.promotionLabel, self.promotionSelectButton, self.promotionSeparateLineView].addSubViews(self)
    [self.shopAddressLabel, self.shopSearchButton, self.shopAddressSeparateLineView].addSubViews(self)
    [self.shopNameLabel, self.shopNameSeparateLineView].addSubViews(self)
    [self.contentTextView, self.doneButton].addSubViews(self)

    self.photoAddButton.snp.makeConstraints {
      $0.height.equalTo(Metric.photoAddButtonHeight)
      $0.width.equalTo(Metric.photoAddButtonWidth)
      $0.top.equalTo(self.safeAreaLayoutGuide).offset(Metric.photoAddButtonTopMargin)
      $0.leading.equalTo(self.safeAreaLayoutGuide).offset(Metric.photoAddButtonLeadingMargin)
    }

    self.photoCollectionView.snp.makeConstraints {
      $0.top.equalTo(self.photoAddButton).offset(Metric.photoCollectionViewTopMargin)
      $0.bottom.equalTo(self.photoAddButton)
      $0.leading.equalTo(self.photoAddButton).offset(Metric.photoCollectionViewLeadingMargin)
      $0.trailing.equalTo(self.safeAreaLayoutGuide)
    }

    self.tagLabel.snp.makeConstraints {
      $0.top.equalTo(self.photoAddButton.snp.bottom).offset(Metric.tagTopMargin)
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
