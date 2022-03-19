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
    static let photoAddButtonLeftMargin = 20.f

    static let tagTopMargin = 25.f
    static let tagLeftMargin = 20.f
    static let tagRightMargin = -60.f
    static let tagHeigth = 40.f

    static let promotionTopMargin = 25.f
    static let promotionLeftMargin = 20.f
    static let promotionRightMargin = -60.f

    static let shopTopMargin = 25.f
    static let shopLeftMargin = 20.f
    static let shopRightMargin = -60.f

    static let selectButtonHeight = 40.f

    static let selectImageTopMargin = 5.f
    static let selectImageRightMargin = -20.f

    static let seperatorHeight = 1.f
    static let seperatorWidthMargin = -40.f
  }

  // MARK: - UI

  private let photoAddButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setImage(#imageLiteral(resourceName: "ic_feed_photo"), for: .normal)
    $0.setTitle("0/5", for: .normal)
    $0.setTitleColor(.gray60, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 14)
    $0.contentVerticalAlignment = .center
    $0.contentHorizontalAlignment = .center
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.gray80?.cgColor
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

  private let promotionSelectButton = UIButton().then {
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

  private let shopSearchButton = UIButton().then {
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
    [
      self.photoAddButton,
      self.tagLabel,
      self.tagSelectImageView,
      self.tagSelectButton,
      self.tagSeperateLineView,
      self.promotionLabel,
      self.promotionSelectImageView,
      self.promotionSelectButton,
      self.promotionSeperateLineView,
      self.shopLabel,
      self.shopSearchImageView,
      self.shopSearchButton,
      self.shopSearchSeperateLineView,
      self.contentTextView,
      self.doneButton
    ].addSubViews(self)

    NSLayoutConstraint.activate([
      photoAddButton.heightAnchor.constraint(equalToConstant: Metric.photoAddButtonHeight),
      photoAddButton.widthAnchor.constraint(equalToConstant: Metric.photoAddButtonWidth),
      photoAddButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: Metric.photoAddButtonTopMargin),
      photoAddButton.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: Metric.photoAddButtonLeftMargin),

      tagLabel.topAnchor.constraint(equalTo: self.photoAddButton.bottomAnchor, constant: Metric.tagTopMargin),
      tagLabel.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: Metric.tagLeftMargin),
      tagLabel.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: Metric.tagRightMargin),

      tagSelectImageView.topAnchor.constraint(equalTo: self.tagLabel.topAnchor, constant: Metric.selectImageTopMargin),
      tagSelectImageView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: Metric.selectImageRightMargin),

      tagSelectButton.topAnchor.constraint(equalTo: self.tagLabel.topAnchor),
      tagSelectButton.leftAnchor.constraint(equalTo: self.tagLabel.leftAnchor),
      tagSelectButton.rightAnchor.constraint(equalTo: self.tagSelectImageView.rightAnchor),
      tagSelectButton.heightAnchor.constraint(equalToConstant: Metric.selectButtonHeight),

      tagSeperateLineView.topAnchor.constraint(equalTo: self.tagSelectButton.bottomAnchor),
      tagSeperateLineView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      tagSeperateLineView.heightAnchor.constraint(equalToConstant: Metric.seperatorHeight),
      tagSeperateLineView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, constant: Metric.seperatorWidthMargin),

      promotionLabel.topAnchor.constraint(equalTo: self.tagSeperateLineView.bottomAnchor, constant: Metric.promotionTopMargin),
      promotionLabel.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: Metric.promotionLeftMargin),
      promotionLabel.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: Metric.promotionRightMargin),

      promotionSelectImageView.topAnchor.constraint(equalTo: self.promotionLabel.topAnchor, constant: Metric.selectImageTopMargin),
      promotionSelectImageView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: Metric.selectImageRightMargin),

      promotionSelectButton.topAnchor.constraint(equalTo: self.promotionLabel.topAnchor),
      promotionSelectButton.leftAnchor.constraint(equalTo: self.promotionLabel.leftAnchor),
      promotionSelectButton.rightAnchor.constraint(equalTo: self.promotionSelectImageView.rightAnchor),
      promotionSelectButton.heightAnchor.constraint(equalToConstant: Metric.selectButtonHeight),

      promotionSeperateLineView.topAnchor.constraint(equalTo: self.promotionSelectButton.bottomAnchor),
      promotionSeperateLineView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      promotionSeperateLineView.heightAnchor.constraint(equalToConstant: Metric.seperatorHeight),
      promotionSeperateLineView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, constant: Metric.seperatorWidthMargin),

      shopLabel.topAnchor.constraint(equalTo: self.promotionSeperateLineView.bottomAnchor, constant: Metric.shopTopMargin),
      shopLabel.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: Metric.shopLeftMargin),
      shopLabel.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: Metric.shopRightMargin),

      shopSearchImageView.topAnchor.constraint(equalTo: self.shopLabel.topAnchor, constant: Metric.selectImageTopMargin),
      shopSearchImageView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: Metric.selectImageRightMargin),
      
      shopSearchButton.topAnchor.constraint(equalTo: self.shopLabel.topAnchor),
      shopSearchButton.leftAnchor.constraint(equalTo: self.shopLabel.leftAnchor),
      shopSearchButton.rightAnchor.constraint(equalTo: self.shopSearchImageView.rightAnchor),
      shopSearchButton.heightAnchor.constraint(equalToConstant: Metric.selectButtonHeight),

      shopSearchSeperateLineView.topAnchor.constraint(equalTo: self.shopSearchButton.bottomAnchor),
      shopSearchSeperateLineView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      shopSearchSeperateLineView.heightAnchor.constraint(equalToConstant: Metric.seperatorHeight),
      shopSearchSeperateLineView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, constant: Metric.seperatorWidthMargin),

      contentTextView.topAnchor.constraint(equalTo: self.shopSearchSeperateLineView.bottomAnchor, constant: 20),
      contentTextView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 20),
      contentTextView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -20),
      contentTextView.heightAnchor.constraint(equalToConstant: 300),

      doneButton.heightAnchor.constraint(equalToConstant: 45),
      doneButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10),
      doneButton.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 20),
      doneButton.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -20)
    ])
  }
}

extension UIButton {
  func alignTextBelow(spacing: CGFloat) {
    guard let image = self.imageView?.image else { return }
    guard let titleLabel = self.titleLabel else { return }
    guard let titleText = titleLabel.text else { return }

    let titleSize = titleText.size(withAttributes: [
      NSAttributedString.Key.font: titleLabel.font as Any
    ])
    titleEdgeInsets = UIEdgeInsets(top: spacing, left: -image.size.width, bottom: -image.size.height, right: 0)
    imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0, bottom: 0, right: -titleSize.width)
  }
}
