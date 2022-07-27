//
//  FeedDetailView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/23.
//

import UIKit

import KKDSKit
import Then

class FeedDetailView: UIView {

  // MARK: - Properties

  private let commentTextViewPlaceholder = "댓글을 입력하세요..."

  // MARK: - Constants

  private enum Metric {

    static let postCollectionViewBottomMargin = -80.f

    static let imageNumberLabelTopMargin = 15.f
    static let imageNumberLabelTrailingMargin = -18.f
    static let imageNumberLabelWidth = 50.f

    static let imagePageControlBottomMargin = -10.f

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
  }

  // MARK: - UIs

  let postCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then {
      $0.scrollDirection = .horizontal
    }).then {
      $0.translatesAutoresizingMaskIntoConstraints = false
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

  private let commentInputView = UIView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .white
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.white.cgColor
    $0.layer.masksToBounds = false
    $0.layer.shadowColor = UIColor.black.cgColor
    $0.layer.shadowOpacity = 0.05
    $0.layer.shadowOffset = CGSize(width: 0, height: -3)
  }

  let likeButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setImage(KKDS.Image.ic_like_24_off, for: .normal)
    $0.setImage(KKDS.Image.ic_like_24_on, for: .selected)
  }

  lazy var commentTextView = UITextView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = self.commentTextViewPlaceholder
    $0.textColor = .gray50
    $0.font = .systemFont(ofSize: 15, weight: .regular)
    $0.autocorrectionType = .no
    $0.spellCheckingType = .no
  }

  let registButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setTitle("등록", for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 15
    $0.backgroundColor = .green50
    $0.setTitleColor(.white, for: .normal)
  }

  // MARK: - Initailize

  init() {
    super.init(frame: .zero)
    self.setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: - Configure

  func setPlaceholder() {
    if self.commentTextView.text == self.commentTextViewPlaceholder {
      self.commentTextView.text = nil
      self.commentTextView.textColor = .black
    } else if self.commentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
      self.commentTextView.text = self.commentTextViewPlaceholder
      self.commentTextView.textColor = .gray50
    }
  }

  // MARK: - Constraints

  func setupConstraints() {
    [self.postCollectionView].addSubViews(self)

    NSLayoutConstraint.activate([
      self.postCollectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
      self.postCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      self.postCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      self.postCollectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: Metric.postCollectionViewBottomMargin)
    ])

    [self.commentInputView, self.likeButton, self.commentTextView, self.registButton].addSubViews(self)

    NSLayoutConstraint.activate([
      self.commentInputView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
      self.commentInputView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
      self.commentInputView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
      self.commentInputView.topAnchor.constraint(equalTo: self.commentTextView.topAnchor, constant: Metric.commentInputViewTopMargin),

      self.likeButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.likeButtonLeadingMargin),
      self.likeButton.centerYAnchor.constraint(equalTo: self.commentTextView.centerYAnchor),

      self.commentTextView.heightAnchor.constraint(equalToConstant: Metric.commentTextViewHeight),
      self.commentTextView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: Metric.commentTextViewBottomMargin),
      self.commentTextView.trailingAnchor.constraint(equalTo: self.registButton.leadingAnchor, constant: Metric.commentTextViewTrailingMargin),
      self.commentTextView.leadingAnchor.constraint(equalTo: self.likeButton.trailingAnchor, constant: Metric.commentTextViewLeadingMargin),

      self.registButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.registButtonTrailingMargin),
      self.registButton.bottomAnchor.constraint(equalTo: self.commentTextView.bottomAnchor),
      self.registButton.widthAnchor.constraint(equalToConstant: Metric.registButtonWidth),
      self.registButton.heightAnchor.constraint(equalToConstant: Metric.registButtonHeight)
    ])
  }

  func setPostCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    // section 1: Contents(images, context, tag, shopAddress)

    let estimatedWidth: CGFloat = 50
    let estimatedHeigth: CGFloat = 300

    let contentsHeaderSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .estimated(estimatedHeigth)
    )

    let contentsHeader = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: contentsHeaderSize,
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top
    )

    let contentsFooterSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .estimated(estimatedHeigth)
    )

    let contentsFooter = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: contentsFooterSize,
      elementKind: UICollectionView.elementKindSectionFooter,
      alignment: .bottom
    )

    let tagItemSize = NSCollectionLayoutSize(
      widthDimension: .estimated(estimatedWidth),
      heightDimension: .absolute(25)
    )
    let tagItem = NSCollectionLayoutItem(layoutSize: tagItemSize)
    tagItem.contentInsets = NSDirectionalEdgeInsets(
      top: 2.5,
      leading: 0,
      bottom: 2.5,
      trailing: 0
    )

    let tagGroupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .estimated(estimatedHeigth)
    )
    let tagGroup = NSCollectionLayoutGroup.horizontal(
      layoutSize: tagGroupSize,
      subitems: [tagItem]
    )
    tagGroup.contentInsets = NSDirectionalEdgeInsets(
      top: 0,
      leading: 20,
      bottom: 0,
      trailing: 20
    )
    tagGroup.interItemSpacing = .fixed(5)
    
    let postContentsSection = NSCollectionLayoutSection(group: tagGroup)

    postContentsSection.boundarySupplementaryItems = [contentsHeader, contentsFooter]

    let layout = UICollectionViewCompositionalLayout(section: postContentsSection)

    return layout

  }
}
