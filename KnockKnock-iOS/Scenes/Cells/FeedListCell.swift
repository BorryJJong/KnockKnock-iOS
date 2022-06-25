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
    static let headerViewHeight = 50.f

    static let profileImageViewWidth = 32.f
    static let profileImageViewHeight = 32.f

    static let configureButtonWidth = 40.f

    static let stackViewLeadingMargin = 15.f
    static let stackViewTrailingMargin = -25.f

    static let imageScrollViewTopMargin = 10.f

    static let imageNumberLabelTopMargin = 15.f
    static let imageNumberLabelTrailingMargin = -18.f
    static let imageNumberLabelWidth = 50.f

    static let imagePageControlBottomMargin = -10.f

    static let postContentViewTopMargin = 15.f

    static let contentLabelLeadingMargin = 15.f
    static let contentLabelTrailingMargin = -15.f
    static let contentLabelTopMargin = 15.f
    static let contentLabelHeight = 40.f

    static let likeButtonBottomMargin = -15.f
    static let likeButtonLeadingMargin = 10.f
    
    static let commentsButtonLeadingMargin = 10.f
    static let commentsButtonBottomMargin = -15.f

  }

  // MARK: - UIs

  private let headerView = UIView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
  }

  private lazy var stackView = UIStackView(arrangedSubviews: [
    self.userIdLabel,
    self.postDateLabel]
  ).then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.axis = .vertical
    $0.alignment = .fill
    $0.distribution = .fill
  }

  private lazy var profileImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.layer.cornerRadius = 16
    $0.clipsToBounds = true
    $0.image = KKDS.Image.ic_person_24
  }

  private let userIdLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = .systemFont(ofSize: 13, weight: .bold)
    $0.text = "sungmin_kim94"
  }

  private let postDateLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.textColor = .gray70
    $0.font = .systemFont(ofSize: 12, weight: .light)
    $0.text = "1시간전"
  }

  private let configureButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setTitleColor(.black, for: .normal)
    $0.setImage(KKDS.Image.ic_more_20_gr, for: .normal)
    $0.contentHorizontalAlignment = .right
  }

  lazy var imageScrollView = UIScrollView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.isPagingEnabled = true
    $0.showsHorizontalScrollIndicator = false
    $0.delegate = self
  }

  private let imagePageControl = UIPageControl().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.currentPage = 0
    $0.pageIndicatorTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
    $0.currentPageIndicatorTintColor = .white
    $0.hidesForSinglePage = true
  }

  private let imageNumberLabel = BasePaddingLabel(
    padding: UIEdgeInsets(
      top: 7,
      left: 15,
      bottom: 7,
      right: 15
    )
  ).then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 0.5)
    $0.layer.cornerRadius = 14
    $0.clipsToBounds = true
    $0.text = "0/1"
    $0.font = .systemFont(ofSize: 12, weight: .semibold)
    $0.textColor = .white
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
    $0.text = "패키지 상품을 받았을때의 기쁨 후엔 늘 골치아픈 쓰레기와 분리수거의 노동시간이 뒤따릅니다. 패키지 상품을 받았을때의 기쁨 후엔 늘 골치아픈 쓰레기와 분리수거의 노동시간이 뒤따릅니다. "
  }

  let likeButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setImage(KKDS.Image.ic_like_24_off, for: .normal)
    $0.setTitle(" 0", for: .normal)
    $0.contentHorizontalAlignment = .center
    $0.semanticContentAttribute = .forceLeftToRight
  }

  let commentsButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setImage(KKDS.Image.ic_balloon_24_gr, for: .normal)
    $0.setTitle(" 0", for: .normal)
    $0.contentHorizontalAlignment = .center
    $0.semanticContentAttribute = .forceLeftToRight
  }

  // MARK: - Bind

  func bind() {
    // func bind(feed: Feed)
    //    self.userIdLabel.text = "\(feed.userId)"
    //    self.contentLabel.text = feed.content
    //    self.setImageSlider(images: feed.images)
    //    self.imagePageControl.numberOfPages = feed.images.count

    let images = ["challenge", "challenge", "challenge", "ic_feed_photo"]

    self.setImageSlider(images: images)
    self.imagePageControl.numberOfPages = images.count
    self.imageNumberLabel.text = "0/\(images.count)"

    guard let contentTextLength = self.contentLabel.text?.count else { return }

    if contentTextLength > 1 {
      DispatchQueue.main.async {
        self.contentLabel.addTrailing(with: "... ", moreText: "더보기", moreTextFont: .systemFont(ofSize: 13), moreTextColor: UIColor.gray)
      }
    }
  }

  func setImageSlider(images: [String]) {
    for index in 0..<images.count {

      let imageView = UIImageView()
      imageView.image = UIImage(named: images[index])
      imageView.contentMode = .scaleAspectFit
      imageView.layer.cornerRadius = 5
      imageView.clipsToBounds = true

      let xPosition = self.contentView.frame.width * CGFloat(index)

      imageView.frame = CGRect(x: xPosition,
                               y: 0,
                               width: self.contentView.frame.width,
                               height: self.contentView.frame.width)

      imageScrollView.contentSize.width = self.contentView.frame.width * CGFloat(index+1)
      imageScrollView.addSubview(imageView)
    }
  }

  // MARK: - Configure

  override func setupConstraints() {
    [self.headerView].addSubViews(self.contentView)
    [self.profileImageView, self.stackView, self.configureButton].addSubViews(headerView)
    [self.postContentView].addSubViews(self.contentView)
    [self.imageScrollView, self.imageNumberLabel, self.imagePageControl].addSubViews(self.postContentView)
    [self.contentLabel, self.likeButton, self.commentsButton].addSubViews(self.postContentView)

    NSLayoutConstraint.activate([
      self.headerView.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor),
      self.headerView.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor),
      self.headerView.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor),
      self.headerView.heightAnchor.constraint(equalToConstant: Metric.headerViewHeight),

      self.profileImageView.centerYAnchor.constraint(equalTo: self.headerView.centerYAnchor),
      self.profileImageView.leadingAnchor.constraint(equalTo: self.headerView.leadingAnchor),
      self.profileImageView.widthAnchor.constraint(equalToConstant: Metric.profileImageViewWidth),
      self.profileImageView.heightAnchor.constraint(equalToConstant: Metric.profileImageViewHeight),

      self.configureButton.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor),
      self.configureButton.widthAnchor.constraint(equalToConstant: Metric.configureButtonWidth),
      self.configureButton.centerYAnchor.constraint(equalTo: self.headerView.centerYAnchor),

      self.stackView.centerYAnchor.constraint(equalTo: self.headerView.centerYAnchor),
      self.stackView.leadingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor, constant: Metric.stackViewLeadingMargin),
      self.stackView.trailingAnchor.constraint(equalTo: self.configureButton.leadingAnchor, constant: Metric.stackViewTrailingMargin),

      self.postContentView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: Metric.postContentViewTopMargin),
      self.postContentView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
      self.postContentView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
      self.postContentView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),

      self.imageScrollView.topAnchor.constraint(equalTo: self.postContentView.topAnchor),
      self.imageScrollView.leadingAnchor.constraint(equalTo: self.postContentView.leadingAnchor),
      self.imageScrollView.trailingAnchor.constraint(equalTo: self.postContentView.trailingAnchor),
      self.imageScrollView.heightAnchor.constraint(equalTo: self.postContentView.widthAnchor),

      self.imageNumberLabel.widthAnchor.constraint(equalToConstant: Metric.imageNumberLabelWidth),
      self.imageNumberLabel.topAnchor.constraint(equalTo: self.imageScrollView.topAnchor, constant: Metric.imageNumberLabelTopMargin),
      self.imageNumberLabel.trailingAnchor.constraint(equalTo: self.imageScrollView.trailingAnchor, constant: Metric.imageNumberLabelTrailingMargin),

      self.imagePageControl.bottomAnchor.constraint(equalTo: self.imageScrollView.bottomAnchor, constant: Metric.imagePageControlBottomMargin),
      self.imagePageControl.centerXAnchor.constraint(equalTo: self.postContentView.centerXAnchor),

      self.contentLabel.topAnchor.constraint(equalTo: self.imageScrollView.bottomAnchor, constant: Metric.contentLabelTopMargin),
      self.contentLabel.leadingAnchor.constraint(equalTo: self.postContentView.leadingAnchor, constant: Metric.contentLabelLeadingMargin),
      self.contentLabel.trailingAnchor.constraint(equalTo: self.postContentView.trailingAnchor, constant: Metric.contentLabelTrailingMargin),

      self.contentLabel.heightAnchor.constraint(equalToConstant: Metric.contentLabelHeight),

      self.likeButton.bottomAnchor.constraint(equalTo: self.postContentView.bottomAnchor, constant: Metric.likeButtonBottomMargin),
      self.likeButton.leadingAnchor.constraint(equalTo: self.postContentView.leadingAnchor, constant: Metric.likeButtonLeadingMargin),

      self.commentsButton.bottomAnchor.constraint(equalTo: self.postContentView.bottomAnchor, constant: Metric.commentsButtonBottomMargin),
      self.commentsButton.leadingAnchor.constraint(equalTo: self.likeButton.trailingAnchor, constant: Metric.commentsButtonLeadingMargin)
    ])
  }
}

extension FeedListCell: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    self.imagePageControl.currentPage = Int(round(imageScrollView.contentOffset.x / UIScreen.main.bounds.width))
    self.imageNumberLabel.text = "\(imagePageControl.currentPage)/\(imagePageControl.numberOfPages)"
  }
}
