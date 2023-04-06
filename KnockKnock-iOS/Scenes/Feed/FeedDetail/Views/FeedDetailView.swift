//
//  FeedDetailView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/23.
//

import UIKit

import KKDSKit
import SnapKit
import Then

final class FeedDetailView: UIView {

  // MARK: - Constants

  private enum Placeholder {
    static let noText = "댓글을 입력하세요..."
    static let noLoggedIn = "로그인이 필요합니다."
  }

  private enum Metric {

    static let postCollectionViewBottomMargin = 80.f

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

    static let placeholderLabelLeadingMargin = 5.f

    static let registButtonTrailingMargin = -20.f
    static let registButtonBottomMargin = -15.f
    static let registButtonWidth = 50.f
    static let registButtonHeight = 30.f
  }

  // MARK: - UIs

  let navigationView = FeedDetailNavigationBarView()

  let postCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then {
      $0.scrollDirection = .horizontal
    }).then {
      $0.backgroundColor = .clear
      $0.contentInset = .init(
        top: 0,
        left: 0,
        bottom: Metric.postCollectionViewBottomMargin,
        right: 0
      )
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

  let commentInputView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.white.cgColor
    $0.layer.masksToBounds = false
    $0.layer.shadowColor = UIColor.black.cgColor
    $0.layer.shadowOpacity = 0.05
    $0.layer.shadowOffset = CGSize(width: 0, height: -3)
  }

  let likeButton = UIButton().then {
    $0.setImage(KKDS.Image.ic_like_24_off, for: .normal)
    $0.setImage(KKDS.Image.ic_like_24_on, for: .selected)
  }

  let placeholderLabel = UILabel().then {
    $0.text = Placeholder.noText
    $0.textColor = KKDS.Color.gray50
    $0.font = .systemFont(ofSize: 15, weight: .regular)
  }

  lazy var commentTextView = UITextView().then {
    $0.textColor = .black
    $0.tintColor = .black
    $0.font = .systemFont(ofSize: 15, weight: .regular)
    $0.autocorrectionType = .no
    $0.spellCheckingType = .no
  }

  let registButton = KKDSSmallButton().then {
    $0.setTitle("등록", for: .normal)
    $0.isEnabled = false
  }

  // MARK: - Initailize

  init() {
    super.init(frame: .zero)
    self.setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: - Bind

  func bind(isLike: Bool) {
    self.likeButton.isSelected = isLike
  }

  func setCommentComponets(isLoggedIn: Bool) {
    self.commentTextView.isEditable = isLoggedIn

    guard isLoggedIn else {
      self.placeholderLabel.text = Placeholder.noLoggedIn
      return
    }
    self.placeholderLabel.text = Placeholder.noText
  }

  func setLikeButton(isHidden: Bool) {
    self.likeButton.isHidden = isHidden

    if !isHidden {
      self.commentTextView.snp.updateConstraints {
        $0.leading.equalTo(self.likeButton.snp.trailing).offset(Metric.commentTextViewLeadingMargin)
      }
    }
  }

  // MARK: - Constraints

  func setupConstraints() {
    [self.postCollectionView].addSubViews(self)

    self.postCollectionView.snp.makeConstraints {
      $0.top.bottom.equalTo(self.safeAreaLayoutGuide)
      $0.leading.trailing.equalTo(self)
    }

    [self.commentInputView, self.likeButton, self.commentTextView, self.registButton].addSubViews(self)
    [self.placeholderLabel].addSubViews(self)

    self.commentInputView.snp.makeConstraints {
      $0.top.equalTo(self.commentTextView).offset(Metric.commentInputViewTopMargin)
      $0.bottom.leading.trailing.equalTo(self.safeAreaLayoutGuide)
    }

    self.likeButton.snp.makeConstraints {
      $0.leading.equalTo(self.safeAreaLayoutGuide).offset(Metric.likeButtonLeadingMargin)
      $0.centerY.equalTo(self.commentTextView)
    }

    self.commentTextView.snp.makeConstraints {
      $0.height.equalTo(Metric.commentTextViewHeight)
      $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(Metric.commentTextViewBottomMargin)
      $0.trailing.equalTo(self.registButton.snp.leading).offset(Metric.commentTextViewTrailingMargin)
      $0.leading.equalTo(self.likeButton.snp.trailing).offset(Metric.commentTextViewLeadingMargin)
    }

    self.placeholderLabel.snp.makeConstraints {
      $0.leading.equalTo(self.commentTextView).offset(Metric.placeholderLabelLeadingMargin)
      $0.bottom.top.equalTo(self.commentTextView)
    }

    self.registButton.snp.makeConstraints {
      $0.trailing.equalTo(self.safeAreaLayoutGuide).offset(Metric.registButtonTrailingMargin)
      $0.bottom.equalTo(self.commentTextView.snp.bottom)
      $0.width.equalTo(Metric.registButtonWidth)
      $0.height.equalTo(Metric.registButtonHeight)
    }
  }

  func createDefaultSection() -> NSCollectionLayoutSection {
    let defaultItemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalWidth(1)
    )
    let defaultItem = NSCollectionLayoutItem(layoutSize: defaultItemSize)

    let defaultGroupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalWidth(1)
    )
    let defaultGroup = NSCollectionLayoutGroup.horizontal(
      layoutSize: defaultGroupSize,
      subitems: [defaultItem]
    )

    let defaultSection = NSCollectionLayoutSection(group: defaultGroup)

    return defaultSection
  }

  func setPostCollectionViewLayout() -> UICollectionViewCompositionalLayout {

    let layout = UICollectionViewCompositionalLayout {(section: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

      let section = FeedDetailSection(rawValue: section)

      switch section {
      case .content:
        return self.setContentsSectionLayout()

      case .like:
        return self.setLikeSectionLayout()

      case .comment:
        return self.setCommentSectionLayout()

      default:
        return self.createDefaultSection()
      }
    }
    return layout
  }

  /// Contents section(images, context, tag, shopAddress)
  func setContentsSectionLayout() -> NSCollectionLayoutSection {

    let estimatedWidth: CGFloat = 100
    let estimatedHeigth: CGFloat = 15

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
      heightDimension: .estimated(estimatedHeigth)
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

    return postContentsSection

  }

  /// Like Section
  func setLikeSectionLayout() -> NSCollectionLayoutSection {

    let estimatedHeigth: CGFloat = 100

    let reactHeaderSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .estimated(estimatedHeigth)
    )

    let reactHeader = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: reactHeaderSize,
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top
    )

    let reactFooterSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .absolute(1)
    )

    let reactFooter = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: reactFooterSize,
      elementKind: UICollectionView.elementKindSectionFooter,
      alignment: .bottom
    )

    let likeEstimatedWidth: CGFloat = 1
    let likeEstimatedHeigth: CGFloat = 1

    let likeItemSize = NSCollectionLayoutSize(
      widthDimension: .estimated(likeEstimatedWidth),
      heightDimension: .estimated(likeEstimatedHeigth)
    )
    let likeItem = NSCollectionLayoutItem(layoutSize: likeItemSize)

    let likeGroupSize = NSCollectionLayoutSize(
      widthDimension: .estimated(likeEstimatedWidth),
      heightDimension: .estimated(likeEstimatedHeigth)
    )
    let likeGroup = NSCollectionLayoutGroup.horizontal(
      layoutSize: likeGroupSize,
      subitems: [likeItem]
    )

    let likeSection = NSCollectionLayoutSection(group: likeGroup)
    likeSection.boundarySupplementaryItems = [reactHeader, reactFooter]
    likeSection.orthogonalScrollingBehavior = .continuous
    likeSection.interGroupSpacing = 12
    likeSection.contentInsets = NSDirectionalEdgeInsets(
      top: 10,
      leading: 20,
      bottom: 10,
      trailing: 0
    )

    return likeSection
  }

  /// Comments Section
  func setCommentSectionLayout() -> NSCollectionLayoutSection {

    let estimatedHeigth: CGFloat = 100

    let reactHeaderSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .estimated(estimatedHeigth)
    )

    let reactHeader = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: reactHeaderSize,
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top
    )

    let commentItemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .estimated(estimatedHeigth)
    )
    let commentItem = NSCollectionLayoutItem(layoutSize: commentItemSize)

    let commentGroupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .estimated(estimatedHeigth)
    )
    let commentGroup = NSCollectionLayoutGroup.vertical(
      layoutSize: commentGroupSize,
      subitems: [commentItem]
    )

    let commentSection = NSCollectionLayoutSection(group: commentGroup)
    commentSection.boundarySupplementaryItems = [reactHeader]
    commentSection.interGroupSpacing = 15
    commentSection.contentInsets = NSDirectionalEdgeInsets(
      top: 15,
      leading: 20,
      bottom: 15,
      trailing: 20
    )

    return commentSection
  }
}
