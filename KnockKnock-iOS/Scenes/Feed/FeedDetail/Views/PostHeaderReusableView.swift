//
//  PostCollectionHeaderReusableView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/27.
//

import UIKit
import KKDSKit

final class PostHeaderReusableView: UICollectionReusableView {

  // MARK: - Constants

  private enum Metric {
    static let imageScrollViewBottomMargin = 0.f

    static let imageNumberLabelTopMargin = 15.f
    static let imageNumberLabelTrailingMargin = -18.f
    static let imageNumberLabelWidth = 50.f

    static let imagePageControlBottomMargin = -10.f

    static let promotionIconImageViewTopMargin = 20.f
    static let promotionIconImageViewLeadingMargin = 20.f
    static let promotionIconImageViewWidth = 24.f
    static let promotionIconImageViewHeight = 24.f

    static let promotionSeparatorViewLeadingMargin = 10.f
    static let promotionSeparatorViewWidth = 1.f
    static let promotionSeparatorViewHeight = 8.f

    static let promotionLabelLeadingMargin = 10.f
    static let promotionLabelTrailingMargin = -20.f

    static let contentSeparatorViewTopMargin = 20.f
    static let contentSeparatorViewLeadingMargin = 20.f
    static let contentSeparatorViewTrailingMargin = -20.f
    static let contentSeparatorViewHeight = 1.f

    static let commentInputViewTopMargin = -20.f

    static let likeButtonLeadingMargin = 20.f

    static let commentTextViewHeight = 34.f
    static let commentTextViewBottomMargin = -19.f
    static let commentTextViewTrailingMargin = -10.f
    static let commentTextViewLeadingMargin = 10.f

    static let registButtonTrailingMargin = -20.f
    static let registButtonBottomMargin = -15.f
    static let registButtonWidth = 50.f
    static let registButtonHeight = 30.f

    static let contentLabelTopMargin = 20.f
    static let contentLabelLeadingMargin = 20.f
    static let contentLabelTrailingMargin = -20.f
    static let contentLabelBottomMargin = -20.f
  }

  // MARK: - UIs

  lazy var imageScrollView = UIScrollView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.isPagingEnabled = true
    $0.showsHorizontalScrollIndicator = false
    $0.delegate = self
  }

  private let imagePageControl = UIPageControl().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.currentPage = 0
    $0.pageIndicatorTintColor = UIColor(
      red: 255/255,
      green: 255/255,
      blue: 255/255,
      alpha: 0.5
    )
    $0.currentPageIndicatorTintColor = .white
    $0.hidesForSinglePage = true
  }

  private let imageNumberLabel = BasePaddingLabel(
    padding: UIEdgeInsets(
      top: 7,
      left: 15,
      bottom: 7,
      right: 15
    )).then {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.backgroundColor = UIColor(
        red: 34/255,
        green: 34/255,
        blue: 34/255,
        alpha: 0.5
      )
      $0.layer.cornerRadius = 14
      $0.clipsToBounds = true
      $0.text = "0/1"
      $0.font = .systemFont(ofSize: 12, weight: .semibold)
      $0.textColor = .white
      $0.isHidden = true
    }

  private let promotionIconImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = KKDS.Image.ic_benefits_24_on
  }

  private let promotionSeparatorView = UIView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = KKDS.Color.gray30
  }

  private let promotionLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.numberOfLines = 0
    $0.textColor = KKDS.Color.black
    $0.setLineHeight(
      content: "사은품 증정, 텀블러 할인, 쿠폰 증정, 사은품 증정, 텀블러 할인, 쿠폰 증정",
      font: .systemFont(ofSize: 13, weight: .semibold)
    )
    $0.lineBreakStrategy = .hangulWordPriority
  }

  private let contentSeparatorView = UIView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = KKDS.Color.gray30
  }

  private let contentLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.numberOfLines = 0
    $0.backgroundColor = .white
    $0.font = UIFont(name: "Apple SD Gothic Neo", size: 14)
  }

  // MARK: - Initailize

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: - Bind

  func bind(feedData: FeedDetailData) {
    self.contentLabel.setLineHeight(
      content: feedData.feed?.content ?? "",
      font: .systemFont(ofSize: 14, weight: .regular)
    )

    self.imageScrollView.subviews.forEach{
      $0.removeFromSuperview()
    }
    self.setImageView(
      images: feedData.images.map { $0.fileUrl },
      scale: "1:1"
    )

    if feedData.images.count > 1 {
      self.imageNumberLabel.isHidden = false
      self.imagePageControl.isHidden = false
      self.imagePageControl.numberOfPages = feedData.images.count
      self.imageNumberLabel.text = "1/\(feedData.images.count)"
    } else {
      self.imageNumberLabel.isHidden = true
      self.imagePageControl.isHidden = true
    }
  }

  private func setImageView(images: [String], scale: String) {
    for index in 0..<images.count {

      let imageView = UIImageView()
      imageView.setImageFromStringUrl(
        url: images[index],
        defaultImage: KKDS.Image.ic_no_data_60
      )
      imageView.contentMode = .scaleAspectFill
      imageView.clipsToBounds = true

      let imageSizeType = ImageScaleType(rawValue: scale)
      let width = self.frame.width
      let xPosition = width * CGFloat(index)

      imageView.frame = imageSizeType?.imageSize(
        xPosition: xPosition,
        width: width
      ) ?? CGRect.init()

      self.imageScrollView.contentSize.width = width * CGFloat(index+1)
      if index == 0 {
        self.imageScrollView.bottomConstraint?.constant = imageView.frame.height
      }
      self.imageScrollView.addSubview(imageView)
    }
  }

  private func setupConstraints() {
    [self.imageScrollView, self.imageNumberLabel, self.imagePageControl].addSubViews(self)
    [self.promotionIconImageView, self.promotionSeparatorView, self.promotionLabel].addSubViews(self)
    [self.contentSeparatorView, self.contentLabel].addSubViews(self)

    NSLayoutConstraint.activate([
      self.imageScrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
      self.imageScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      self.imageScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      self.imageScrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: Metric.imageScrollViewBottomMargin),

      self.imageNumberLabel.widthAnchor.constraint(equalToConstant: Metric.imageNumberLabelWidth),
      self.imageNumberLabel.topAnchor.constraint(equalTo: self.imageScrollView.topAnchor, constant: Metric.imageNumberLabelTopMargin),
      self.imageNumberLabel.trailingAnchor.constraint(equalTo: self.imageScrollView.trailingAnchor, constant: Metric.imageNumberLabelTrailingMargin),

      self.imagePageControl.bottomAnchor.constraint(equalTo: self.imageScrollView.bottomAnchor, constant: Metric.imagePageControlBottomMargin),
      self.imagePageControl.centerXAnchor.constraint(equalTo: self.centerXAnchor),

      self.promotionIconImageView.topAnchor.constraint(equalTo: self.imageScrollView.bottomAnchor, constant: Metric.promotionIconImageViewTopMargin),
      self.promotionIconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Metric.promotionIconImageViewLeadingMargin),
      self.promotionIconImageView.widthAnchor.constraint(equalToConstant: Metric.promotionIconImageViewWidth),
      self.promotionIconImageView.heightAnchor.constraint(equalToConstant: Metric.promotionIconImageViewHeight),

      self.promotionSeparatorView.centerYAnchor.constraint(equalTo: self.promotionIconImageView.centerYAnchor),
      self.promotionSeparatorView.leadingAnchor.constraint(equalTo: self.promotionIconImageView.trailingAnchor, constant: Metric.promotionSeparatorViewLeadingMargin),
      self.promotionSeparatorView.widthAnchor.constraint(equalToConstant: Metric.promotionSeparatorViewWidth),
      self.promotionSeparatorView.heightAnchor.constraint(equalToConstant: Metric.promotionSeparatorViewHeight),

      self.promotionLabel.leadingAnchor.constraint(equalTo: self.promotionSeparatorView.trailingAnchor, constant: Metric.promotionLabelLeadingMargin),
      self.promotionLabel.topAnchor.constraint(equalTo: self.promotionIconImageView.topAnchor),
      self.promotionLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.promotionLabelTrailingMargin),

      self.contentSeparatorView.topAnchor.constraint(equalTo: self.promotionLabel.bottomAnchor, constant: Metric.contentSeparatorViewTopMargin),
      self.contentSeparatorView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.contentSeparatorViewLeadingMargin),
      self.contentSeparatorView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.contentSeparatorViewTrailingMargin),
      self.contentSeparatorView.heightAnchor.constraint(equalToConstant: Metric.contentSeparatorViewHeight),

      self.contentLabel.topAnchor.constraint(equalTo: self.contentSeparatorView.bottomAnchor, constant: Metric.contentLabelTopMargin),
      self.contentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Metric.contentLabelLeadingMargin),
      self.contentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Metric.contentLabelTrailingMargin),
      self.contentLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: Metric.contentLabelBottomMargin)
    ])
  }
}

extension PostHeaderReusableView: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    self.imagePageControl.currentPage = Int(round(imageScrollView.contentOffset.x / UIScreen.main.bounds.width))
    self.imageNumberLabel.text = "\(imagePageControl.currentPage + 1)/\(imagePageControl.numberOfPages)"
  }
}
