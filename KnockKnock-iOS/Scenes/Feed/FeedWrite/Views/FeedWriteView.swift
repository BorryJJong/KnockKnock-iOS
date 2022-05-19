//
//  FeedWriteView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/17.
//

import UIKit

import Then

class FeedWriteView: UIView {

  // MARK: - Constants

  private enum Metric {
    static let photoAddButtonWidth = 65.f
    static let photoAddButtonHeight = 65.f
    static let photoAddButtonTopMargin = 20.f
    static let photoAddButtonLeadingMargin = 20.f

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
  }

  let photoAddButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setImage(#imageLiteral(resourceName: "ic_feed_photo"), for: .normal)
    $0.setTitle("0/5", for: .normal)
    $0.setTitleColor(.gray60, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 14)
    $0.contentVerticalAlignment = .center
    $0.contentHorizontalAlignment = .center
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.gray50?.cgColor
    $0.layer.cornerRadius = 5
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

  private let doneButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setTitle("등록 완료", for: .normal)
    $0.layer.cornerRadius = 5
    $0.backgroundColor = .gray40
  }

  init() {
    super.init(frame: .zero)
    self.setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  private func setupConstraints() {
    [self.photoAddButton].addSubViews(self)
    [self.tagLabel, self.tagSelectImageView, self.tagSelectButton, self.tagSeperateLineView].addSubViews(self)
    [self.promotionLabel, self.promotionSelectImageView, self.promotionSelectButton, self.promotionSeperateLineView].addSubViews(self)
    [self.shopLabel, self.shopSearchImageView, self.shopSearchButton, self.shopSearchSeperateLineView].addSubViews(self)
    [self.contentTextView, self.doneButton].addSubViews(self)

    NSLayoutConstraint.activate([
      photoAddButton.heightAnchor.constraint(equalToConstant: Metric.photoAddButtonHeight),
      photoAddButton.widthAnchor.constraint(equalToConstant: Metric.photoAddButtonWidth),
      photoAddButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: Metric.photoAddButtonTopMargin),
      photoAddButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.photoAddButtonLeadingMargin),

      tagLabel.topAnchor.constraint(equalTo: self.photoAddButton.bottomAnchor, constant: Metric.tagTopMargin),
      tagLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.tagLeadingMargin),
      tagLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.tagTrailingMargin),

      tagSelectImageView.topAnchor.constraint(equalTo: self.tagLabel.topAnchor, constant: Metric.selectImageTopMargin),
      tagSelectImageView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.selectImageTrailingMargin),

      tagSelectButton.topAnchor.constraint(equalTo: self.tagLabel.topAnchor),
      tagSelectButton.leadingAnchor.constraint(equalTo: self.tagLabel.leadingAnchor),
      tagSelectButton.trailingAnchor.constraint(equalTo: self.tagSelectImageView.trailingAnchor),
      tagSelectButton.heightAnchor.constraint(equalToConstant: Metric.selectButtonHeight),

      tagSeperateLineView.topAnchor.constraint(equalTo: self.tagSelectButton.bottomAnchor),
      tagSeperateLineView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      tagSeperateLineView.heightAnchor.constraint(equalToConstant: Metric.seperatorHeight),
      tagSeperateLineView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, constant: Metric.seperatorWidthMargin),

      promotionLabel.topAnchor.constraint(equalTo: self.tagSeperateLineView.bottomAnchor, constant: Metric.promotionTopMargin),
      promotionLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.promotionLeadingMargin),
      promotionLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.promotionTrailingMargin),

      promotionSelectImageView.topAnchor.constraint(equalTo: self.promotionLabel.topAnchor, constant: Metric.selectImageTopMargin),
      promotionSelectImageView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.selectImageTrailingMargin),

      promotionSelectButton.topAnchor.constraint(equalTo: self.promotionLabel.topAnchor),
      promotionSelectButton.leadingAnchor.constraint(equalTo: self.promotionLabel.leadingAnchor),
      promotionSelectButton.trailingAnchor.constraint(equalTo: self.promotionSelectImageView.trailingAnchor),
      promotionSelectButton.heightAnchor.constraint(equalToConstant: Metric.selectButtonHeight),

      promotionSeperateLineView.topAnchor.constraint(equalTo: self.promotionSelectButton.bottomAnchor),
      promotionSeperateLineView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      promotionSeperateLineView.heightAnchor.constraint(equalToConstant: Metric.seperatorHeight),
      promotionSeperateLineView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, constant: Metric.seperatorWidthMargin),

      shopLabel.topAnchor.constraint(equalTo: self.promotionSeperateLineView.bottomAnchor, constant: Metric.shopTopMargin),
      shopLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.shopLeadingMargin),
      shopLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.shopTrailingMargin),

      shopSearchImageView.topAnchor.constraint(equalTo: self.shopLabel.topAnchor, constant: Metric.selectImageTopMargin),
      shopSearchImageView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.selectImageTrailingMargin),
      
      shopSearchButton.topAnchor.constraint(equalTo: self.shopLabel.topAnchor),
      shopSearchButton.leadingAnchor.constraint(equalTo: self.shopLabel.leadingAnchor),
      shopSearchButton.trailingAnchor.constraint(equalTo: self.shopSearchImageView.trailingAnchor),
      shopSearchButton.heightAnchor.constraint(equalToConstant: Metric.selectButtonHeight),

      shopSearchSeperateLineView.topAnchor.constraint(equalTo: self.shopSearchButton.bottomAnchor),
      shopSearchSeperateLineView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      shopSearchSeperateLineView.heightAnchor.constraint(equalToConstant: Metric.seperatorHeight),
      shopSearchSeperateLineView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, constant: Metric.seperatorWidthMargin),

      contentTextView.topAnchor.constraint(equalTo: self.shopSearchSeperateLineView.bottomAnchor, constant: Metric.contentTextViewTopMargin),
      contentTextView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.contentTextViewLeadingMargin),
      contentTextView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.contentTextViewTrailingMargin),
      contentTextView.heightAnchor.constraint(equalToConstant: Metric.contentTextViewHeight),

      doneButton.heightAnchor.constraint(equalToConstant: Metric.doneButtonHeight),
      doneButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: Metric.doneButtonBottomMargin),
      doneButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.doneButtonleadingMargin),
      doneButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.doneButtonTrailingMargin)
    ])
  }
}
