//
//  FeedListCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/22.
//

import UIKit

import KKDSKit

class FeedListCell: BaseCollectionViewCell {

  // MARK: - Constants

  private enum Metric {

    static let imageScrollViewTopMargin = 10.f
    static let imageScrollViewBottomMargin = -15.f

    static let imageNumberLabelTopMargin = 15.f
    static let imageNumberLabelTrailingMargin = -18.f
    static let imageNumberLabelWidth = 50.f

    static let imagePageControlBottomMargin = -10.f

    static let contentLabelLeadingMargin = 15.f
    static let contentLabelTrailingMargin = -15.f
    static let contentLabelBottomMargin = -10.f
    static let contentLabelHeight = 40.f

    static let likeButtonBottomMargin = -15.f
    static let likeButtonLeadingMargin = 15.f
    
    static let commentsButtonLeadingMargin = 10.f
    static let commentsButtonBottomMargin = -15.f
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

  let postContentView = UIView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .white
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 5
    $0.layer.masksToBounds = false
    $0.layer.shadowColor = UIColor.black.cgColor
    $0.layer.shadowOpacity = 0.1
    $0.layer.shadowOffset = CGSize(width: 0, height: 10)
    $0.layer.shadowRadius = 5
  }

  let contentLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.numberOfLines = 0
    $0.backgroundColor = .white
    $0.font = UIFont(name: "Apple SD Gothic Neo", size: 13)
  }

  let likeButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setImage(KKDS.Image.ic_like_24_off, for: .normal)
    $0.setImage(KKDS.Image.ic_like_24_on, for: .selected)
    $0.setTitle(" 0", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
    $0.contentHorizontalAlignment = .center
    $0.semanticContentAttribute = .forceLeftToRight
  }

  let commentsButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setImage(KKDS.Image.ic_balloon_24_gr, for: .normal)
    $0.setTitle(" 0", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
    $0.contentHorizontalAlignment = .center
    $0.semanticContentAttribute = .forceLeftToRight
  }

  // MARK: - Bind

  func bind(feedList: FeedListPost) {
    if feedList.isLike {
      self.likeButton.isSelected = true
      self.likeButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
    } else {
      self.likeButton.isSelected = false
      self.likeButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
    }

    self.likeButton.setTitle(" \(feedList.blogLikeCount)", for: .normal)
    self.commentsButton.setTitle(" \(feedList.blogCommentCount)", for: .normal)

    self.imageScrollView.subviews.forEach{
      $0.removeFromSuperview()
    }

    self.contentLabel.text = feedList.content
    self.setImageView(
      images: feedList.blogImages,
      scale: feedList.imageScale
    )

    if feedList.blogImages.count > 1 {
      self.imageNumberLabel.isHidden = false
      self.imagePageControl.isHidden = false
      self.imagePageControl.numberOfPages = feedList.blogImages.count
      self.imageNumberLabel.text = "1/\(feedList.blogImages.count)"
    } else {
      self.imageNumberLabel.isHidden = true
      self.imagePageControl.isHidden = true
    }
    
    guard let contentTextLength = self.contentLabel.text?.count
    else {
      return
    }

    if contentTextLength > 1 {
      DispatchQueue.main.async {
        self.contentLabel.addTrailing(
          with: "... ",
          moreText: "더보기",
          moreTextFont: .systemFont(ofSize: 13),
          moreTextColor: UIColor.gray
        )
      }
    }
  }

  private func setImageView(
    images: [FeedImage],
    scale: String
  ) {
    for index in 0..<images.count {

      let imageView = UIImageView()
      imageView.setImageFromStringUrl(
        url: "https://dy-yb.github.io/images/profile.jpg", // images[index].fileUrl
        defaultImage: KKDS.Image.ic_no_data_60
      )
      imageView.contentMode = .scaleAspectFill
      imageView.layer.cornerRadius = 5
      imageView.clipsToBounds = true

      let imageSizeType = ImageScaleType(rawValue: scale)
      let width = self.contentView.frame.width
      let xPosition = width * CGFloat(index)

      imageView.frame = imageSizeType?.imageSize(
        xPosition: xPosition,
        width: width
      ) ?? CGRect.init()

      self.imageScrollView.contentSize.width = width * CGFloat(index+1)
      self.imageScrollView.addSubview(imageView)
    }
  }

  // MARK: - Configure

  override func setupConfigure() {
    self.setCellShadow()
  }

  private func setCellShadow() {
    self.do {
      $0.clipsToBounds = true
      $0.layer.cornerRadius = 5
      $0.layer.masksToBounds = false
      $0.layer.shadowColor = UIColor.black.cgColor
      $0.layer.shadowOpacity = 0.1
      $0.layer.shadowOffset = CGSize(width: 0, height: 10)
      $0.layer.shadowRadius = 5
    }
  }

  override func setupConstraints() {
    [self.imageScrollView, self.imageNumberLabel, self.imagePageControl].addSubViews(self.contentView)
    [self.contentLabel, self.likeButton, self.commentsButton].addSubViews(self.contentView)

    NSLayoutConstraint.activate([
      self.imageScrollView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
      self.imageScrollView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
      self.imageScrollView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
      self.imageScrollView.bottomAnchor.constraint(equalTo: self.contentLabel.topAnchor, constant: Metric.imageScrollViewBottomMargin),

      self.imageNumberLabel.widthAnchor.constraint(equalToConstant: Metric.imageNumberLabelWidth),
      self.imageNumberLabel.topAnchor.constraint(equalTo: self.imageScrollView.topAnchor, constant: Metric.imageNumberLabelTopMargin),
      self.imageNumberLabel.trailingAnchor.constraint(equalTo: self.imageScrollView.trailingAnchor, constant: Metric.imageNumberLabelTrailingMargin),

      self.imagePageControl.bottomAnchor.constraint(equalTo: self.imageScrollView.bottomAnchor, constant: Metric.imagePageControlBottomMargin),
      self.imagePageControl.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),

      self.contentLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: Metric.contentLabelLeadingMargin),
      self.contentLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: Metric.contentLabelTrailingMargin),
      self.contentLabel.bottomAnchor.constraint(equalTo: self.likeButton.topAnchor, constant: Metric.contentLabelBottomMargin),
      self.contentLabel.heightAnchor.constraint(equalToConstant: Metric.contentLabelHeight),

      self.likeButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: Metric.likeButtonBottomMargin),
      self.likeButton.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: Metric.likeButtonLeadingMargin),

      self.commentsButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: Metric.commentsButtonBottomMargin),
      self.commentsButton.leadingAnchor.constraint(equalTo: self.likeButton.trailingAnchor, constant: Metric.commentsButtonLeadingMargin)
    ])
  }
}

// MARK: - ScrollView delegate

extension FeedListCell: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    self.imagePageControl.currentPage = Int(round(imageScrollView.contentOffset.x / UIScreen.main.bounds.width))
    self.imageNumberLabel.text = "\(imagePageControl.currentPage + 1)/\(imagePageControl.numberOfPages)"
  }
}
