//
//  FeedWriteView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/17.
//

import UIKit
import KKDSKit

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

    static let selectButtonHeight = 40.f

    static let selectImageTopMargin = 5.f
    static let selectImageTrailingMargin = -20.f

    static let seperatorHeight = 1.f
    static let seperatorWidthMargin = -40.f

    static let contentTextViewTopMargin = 20.f
    static let contentTextViewLeadingMargin = 20.f
    static let contentTextViewTrailingMargin = -20.f
    static let contentTextViewHeight = 300.f

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
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .clear
  }

  let photoAddButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
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
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = "#태그"
    $0.tintColor = .black
  }

  lazy var tagSelectButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .clear
  }

  private let tagSelectImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = UIImage(named: "ic_feed_left")
  }

  private lazy var tagSeperateLineView = UIView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .gray20
  }

  private let promotionLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = "프로모션"
    $0.tintColor = .black
  }

  let promotionSelectButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.tintColor = .clear
  }

  private let promotionSelectImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = UIImage(named: "ic_feed_left")
  }

  private lazy var promotionSeperateLineView = UIView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .gray20
  }

  private let shopLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = "매장주소(검색)"
    $0.tintColor = .black
  }

  let shopSearchButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.tintColor = .clear
  }

  private let shopSearchImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = UIImage(named: "ic_feed_left")
  }

  private lazy var shopSearchSeperateLineView = UIView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .gray20
  }

  let contentTextView = UITextView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.textColor = .gray40
    $0.font = .systemFont(ofSize: 14)
    $0.text = "내용을 입력해주세요. (글자수 1,000자 이내)"
  }

  let doneButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setTitle("등록", for: .normal)
    $0.layer.cornerRadius = Metric.buttonCornerRadius
    $0.backgroundColor = .green50
  }

  let alertView = AlertView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.isHidden = true
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

  func bind(propertyType: PropertyType, content: String) {
    switch propertyType {
    case .tag:
      self.tagLabel.text = content
    case .promotion:
      self.promotionLabel.text = content
    case .address:
      self.shopLabel.text = content
    }
  }

  func showAlertView(isDone: Bool) {
    self.alertView.isHidden = false
    
    let content = isDone ? "게시글 등록을 완료 하시겠습니까?" : "사진, 태그, 프로모션, 내용은 필수 입력 항목입니다."

    self.alertView.bind(
      content: content,
      isCancelActive: isDone
    )
  }

  // MARK: - Constraints

  private func setupConstraints() {
    [self.photoAddButton, self.photoCollectionView].addSubViews(self)
    [self.tagLabel, self.tagSelectImageView, self.tagSelectButton, self.tagSeperateLineView].addSubViews(self)
    [self.promotionLabel, self.promotionSelectImageView, self.promotionSelectButton, self.promotionSeperateLineView].addSubViews(self)
    [self.shopLabel, self.shopSearchImageView, self.shopSearchButton, self.shopSearchSeperateLineView].addSubViews(self)
    [self.contentTextView, self.doneButton].addSubViews(self)
    [self.alertView].addSubViews(self)

    NSLayoutConstraint.activate([
      self.photoAddButton.heightAnchor.constraint(equalToConstant: Metric.photoAddButtonHeight),
      self.photoAddButton.widthAnchor.constraint(equalToConstant: Metric.photoAddButtonWidth),
      self.photoAddButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: Metric.photoAddButtonTopMargin),
      self.photoAddButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.photoAddButtonLeadingMargin),

      self.photoCollectionView.topAnchor.constraint(equalTo: self.photoAddButton.topAnchor, constant: Metric.photoCollectionViewTopMargin),
      self.photoCollectionView.bottomAnchor.constraint(equalTo: self.photoAddButton.bottomAnchor),
      self.photoCollectionView.leadingAnchor.constraint(equalTo: self.photoAddButton.trailingAnchor, constant: Metric.photoCollectionViewLeadingMargin),
      self.photoCollectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),

      self.tagLabel.topAnchor.constraint(equalTo: self.photoAddButton.bottomAnchor, constant: Metric.tagTopMargin),
      self.tagLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.tagLeadingMargin),
      self.tagLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.tagTrailingMargin),

      self.tagSelectImageView.topAnchor.constraint(equalTo: self.tagLabel.topAnchor, constant: Metric.selectImageTopMargin),
      self.tagSelectImageView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.selectImageTrailingMargin),

      self.tagSelectButton.topAnchor.constraint(equalTo: self.tagLabel.topAnchor),
      self.tagSelectButton.leadingAnchor.constraint(equalTo: self.tagLabel.leadingAnchor),
      self.tagSelectButton.trailingAnchor.constraint(equalTo: self.tagSelectImageView.trailingAnchor),
      self.tagSelectButton.heightAnchor.constraint(equalToConstant: Metric.selectButtonHeight),

      self.tagSeperateLineView.topAnchor.constraint(equalTo: self.tagSelectButton.bottomAnchor),
      self.tagSeperateLineView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      self.tagSeperateLineView.heightAnchor.constraint(equalToConstant: Metric.seperatorHeight),
      self.tagSeperateLineView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, constant: Metric.seperatorWidthMargin),

      self.promotionLabel.topAnchor.constraint(equalTo: self.tagSeperateLineView.bottomAnchor, constant: Metric.promotionTopMargin),
      self.promotionLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.promotionLeadingMargin),
      self.promotionLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.promotionTrailingMargin),

      self.promotionSelectImageView.topAnchor.constraint(equalTo: self.promotionLabel.topAnchor, constant: Metric.selectImageTopMargin),
      self.promotionSelectImageView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.selectImageTrailingMargin),

      self.promotionSelectButton.topAnchor.constraint(equalTo: self.promotionLabel.topAnchor),
      self.promotionSelectButton.leadingAnchor.constraint(equalTo: self.promotionLabel.leadingAnchor),
      self.promotionSelectButton.trailingAnchor.constraint(equalTo: self.promotionSelectImageView.trailingAnchor),
      self.promotionSelectButton.heightAnchor.constraint(equalToConstant: Metric.selectButtonHeight),

      self.promotionSeperateLineView.topAnchor.constraint(equalTo: self.promotionSelectButton.bottomAnchor),
      self.promotionSeperateLineView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      self.promotionSeperateLineView.heightAnchor.constraint(equalToConstant: Metric.seperatorHeight),
      self.promotionSeperateLineView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, constant: Metric.seperatorWidthMargin),

      self.shopLabel.topAnchor.constraint(equalTo: self.promotionSeperateLineView.bottomAnchor, constant: Metric.shopTopMargin),
      self.shopLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.shopLeadingMargin),
      self.shopLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.shopTrailingMargin),

      self.shopSearchImageView.topAnchor.constraint(equalTo: self.shopLabel.topAnchor, constant: Metric.selectImageTopMargin),
      self.shopSearchImageView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.selectImageTrailingMargin),
      
      self.shopSearchButton.topAnchor.constraint(equalTo: self.shopLabel.topAnchor),
      self.shopSearchButton.leadingAnchor.constraint(equalTo: self.shopLabel.leadingAnchor),
      self.shopSearchButton.trailingAnchor.constraint(equalTo: self.shopSearchImageView.trailingAnchor),
      self.shopSearchButton.heightAnchor.constraint(equalToConstant: Metric.selectButtonHeight),

      self.shopSearchSeperateLineView.topAnchor.constraint(equalTo: self.shopSearchButton.bottomAnchor),
      self.shopSearchSeperateLineView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      self.shopSearchSeperateLineView.heightAnchor.constraint(equalToConstant: Metric.seperatorHeight),
      self.shopSearchSeperateLineView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, constant: Metric.seperatorWidthMargin),

      self.contentTextView.topAnchor.constraint(equalTo: self.shopSearchSeperateLineView.bottomAnchor, constant: Metric.contentTextViewTopMargin),
      self.contentTextView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.contentTextViewLeadingMargin),
      self.contentTextView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.contentTextViewTrailingMargin),
      self.contentTextView.heightAnchor.constraint(equalToConstant: Metric.contentTextViewHeight),

      self.doneButton.heightAnchor.constraint(equalToConstant: Metric.doneButtonHeight),
      self.doneButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: Metric.doneButtonBottomMargin),
      self.doneButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.doneButtonleadingMargin),
      self.doneButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.doneButtonTrailingMargin),

      self.alertView.topAnchor.constraint(equalTo: self.topAnchor),
      self.alertView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      self.alertView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      self.alertView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    ])
  }
}
