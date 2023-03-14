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
    
    static let promotionViewTopMargin = 10.f
    static let promotionViewLeadingMargin = 20.f

    static let promotionIconImageViewWidth = 24.f
    
    static let promotionSeparatorViewLeadingMargin = 10.f
    static let promotionSeparatorViewWidth = 1.f
    static let promotionSeparatorViewHeight = 8.f
    
    static let promotionLabelLeadingMargin = 10.f
    
    static let contentSeparatorViewTopMargin = 15.f
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
    $0.isPagingEnabled = true
    $0.showsHorizontalScrollIndicator = false
    $0.delegate = self
  }
  
  private let imagePageControl = UIPageControl().then {
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

  private let promotionView = UIView()

  private let promotionIconImageView = UIImageView().then {
    $0.image = KKDS.Image.ic_benefits_24_on
  }
  
  private let promotionSeparatorView = UIView().then {
    $0.backgroundColor = KKDS.Color.gray30
  }
  
  private let promotionLabel = UILabel().then {
    $0.numberOfLines = 0
    $0.textColor = KKDS.Color.black
    $0.lineBreakStrategy = .hangulWordPriority
  }
  
  private let contentSeparatorView = UIView().then {
    $0.backgroundColor = KKDS.Color.gray30
  }
  
  private let contentLabel = UILabel().then {
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
  
  func bind(feedData: FeedDetail) {

    if !feedData.promotions.isEmpty {
      let promotions = feedData.promotions.map { $0.title }.joined(separator: ", ")

      self.promotionLabel.setLineHeight(
        content: promotions,
        font: .systemFont(ofSize: 13, weight: .semibold)
      )
      self.setupPromotionViewConstraints()
    }

    self.contentLabel.setLineHeight(
      content: feedData.feed.content,
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
        stringUrl: images[index],
        defaultImage: KKDS.Image.ic_no_data_60
      )

      imageView.contentMode = .scaleAspectFill
      imageView.clipsToBounds = true
      
      let imageSizeType = ImageScaleType(rawValue: scale)
      let width = self.frame.width
      let xPosition = width * CGFloat(index)
      
      imageView.frame = CGRect(
        x: xPosition,
        y: 0,
        width: width,
        height: width
      )
      
      self.imageScrollView.contentSize.width = width * CGFloat(index+1)
      self.imageScrollView.addSubview(imageView)
    }
  }

  private func setupPromotionViewConstraints() {
    [self.promotionView].addSubViews(self)
    [self.promotionIconImageView, self.promotionSeparatorView, self.promotionLabel, self.contentSeparatorView].addSubViews(self.promotionView)

    self.promotionView.snp.makeConstraints  {
      $0.top.equalTo(self.imageScrollView.snp.bottom).offset(Metric.promotionViewTopMargin)
      $0.leading.trailing.equalTo(self).inset(Metric.promotionViewLeadingMargin)
      $0.bottom.equalTo(self.promotionLabel)
    }

    self.promotionIconImageView.snp.makeConstraints {
      $0.top.leading.equalTo(self.promotionView)
      $0.width.height.equalTo(Metric.promotionIconImageViewWidth)
    }

    self.promotionSeparatorView.snp.makeConstraints {
      $0.centerY.equalTo(self.promotionIconImageView)
      $0.leading.equalTo(self.promotionIconImageView.snp.trailing).offset(Metric.promotionSeparatorViewLeadingMargin)
      $0.width.equalTo(Metric.promotionSeparatorViewWidth)
      $0.height.equalTo(Metric.promotionSeparatorViewHeight)
    }

    self.promotionLabel.snp.makeConstraints {
      $0.leading.equalTo(self.promotionSeparatorView.snp.trailing).offset(Metric.promotionLabelLeadingMargin)
      $0.top.equalTo(self.promotionIconImageView)
      $0.trailing.equalTo(self.promotionView)
    }

    self.contentSeparatorView.snp.makeConstraints {
      $0.top.equalTo(self.promotionLabel.snp.bottom).offset(Metric.contentSeparatorViewTopMargin)
      $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(Metric.contentSeparatorViewLeadingMargin)
      $0.height.equalTo(Metric.contentSeparatorViewHeight)
    }

    self.contentLabel.snp.remakeConstraints {
      $0.top.equalTo(self.contentSeparatorView.snp.bottom).offset(Metric.contentLabelTopMargin)
      $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(Metric.contentLabelLeadingMargin)
      $0.bottom.equalTo(self).offset(Metric.contentLabelBottomMargin)
    }
  }
  
  private func setupConstraints() {
    [self.imageScrollView, self.imageNumberLabel, self.imagePageControl].addSubViews(self)
    [self.contentLabel].addSubViews(self)

    self.imageScrollView.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide)
      $0.leading.trailing.equalTo(self)
      $0.height.equalTo(self.imageScrollView.snp.width)
    }

    self.imageNumberLabel.snp.makeConstraints {
      $0.width.equalTo(Metric.imageNumberLabelWidth)
      $0.top.equalTo(self.imageScrollView.snp.top).offset(Metric.imageNumberLabelTopMargin)
      $0.trailing.equalTo(Metric.imageNumberLabelTrailingMargin)
    }

    self.imagePageControl.snp.makeConstraints {
      $0.bottom.equalTo(self.imageScrollView.snp.bottom).offset(Metric.imagePageControlBottomMargin)
      $0.centerX.equalTo(self)
    }

    self.contentLabel.snp.makeConstraints {
      $0.top.equalTo(self.imageScrollView.snp.bottom).offset(Metric.contentLabelTopMargin)
      $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(Metric.contentLabelLeadingMargin)
      $0.bottom.equalTo(self).offset(Metric.contentLabelBottomMargin)
    }
  }
}

extension PostHeaderReusableView: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    self.imagePageControl.currentPage = Int(round(imageScrollView.contentOffset.x / UIScreen.main.bounds.width))
    self.imageNumberLabel.text = "\(imagePageControl.currentPage + 1)/\(imagePageControl.numberOfPages)"
  }
}
