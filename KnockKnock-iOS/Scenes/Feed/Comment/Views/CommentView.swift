//
//  CommentsView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/13.
//

import UIKit

import KKDSKit
import Then
import SnapKit

class CommentView: UIView {

  // MARK: - Constants

  private enum Placeholder {
    static let noText = "댓글을 입력하세요..."
    static let noLoggedIn = "로그인이 필요합니다."
  }

  private enum Metric {
    static let headerViewHeight = 100.f
    static let headerViewTrailingMargin = -10.f

    static let exitButtonTrailingMargin = -10.f

    static let commentCollectionViewLeadingMargin = 20.f
    static let commentCollectionViewTrailingMargin = -20.f
    static let commentCollectionViewBottomMargin = 70.f

    static let commentInputViewTopMargin = -20.f

    static let commentTextViewHeight = 34.f
    static let commentTextViewBottomMargin = -19.f
    static let commentTextViewTrailingMargin = -70.f
    static let commentTextViewLeadingMargin = 20.f

    static let registButtonTrailingMargin = -20.f
    static let registButtonBottomMargin = -15.f
    static let registButtonWidth = 50.f
    static let registButtonHeight = 30.f
  }

  // MARK: - UIs

  private let headerView = UIView().then {
    $0.backgroundColor = .white
  }

  let contentView = UIView()

  private let titleLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = "댓글"
    $0.font = .systemFont(ofSize: 17, weight: .bold)
  }

  let exitButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setImage(KKDS.Image.ic_close_24_bk, for: .normal)
  }

  let commentCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then{
      $0.scrollDirection = .vertical
    }).then {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.backgroundColor = .clear
      $0.contentInset = .init(
        top: 0,
        left: 0,
        bottom: Metric.commentCollectionViewBottomMargin,
        right: 0
      )
    }

  let commentInputView = UIView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .white
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.white.cgColor
    $0.layer.masksToBounds = false
    $0.layer.shadowColor = UIColor.black.cgColor
    $0.layer.shadowOpacity = 0.05
    $0.layer.shadowOffset = CGSize(width: 0, height: -3)
  }

  lazy var commentTextView = UITextView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.textColor = .gray50
    $0.font = .systemFont(ofSize: 15, weight: .regular)
    $0.autocorrectionType = .no
    $0.spellCheckingType = .no
  }

  let registButton = KKDSSmallButton().then {
    $0.setTitle("등록", for: .normal)
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

  func setCommentComponets(isLoggedIn: Bool) {
    self.commentTextView.isEditable = isLoggedIn
    self.registButton.isEnabled = isLoggedIn

    guard isLoggedIn else {
      self.commentTextView.text = Placeholder.noLoggedIn
      return
    }

    if self.commentTextView.text == Placeholder.noText ||
      self.commentTextView.text == Placeholder.noLoggedIn {

      self.commentTextView.text = nil
      self.commentTextView.textColor = .black

    } else if self.commentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {

      self.registButton.isEnabled = false

      self.commentTextView.text = Placeholder.noText
      self.commentTextView.textColor = .gray50
    }
  }

  // MARK: - Constraints

  func setupConstraints() {
    [self.contentView].addSubViews(self)
    [self.commentCollectionView].addSubViews(self.contentView)
    [self.commentInputView, self.commentTextView, self.registButton].addSubViews(self.contentView)
    [self.headerView].addSubViews(self)
    [self.titleLabel, self.exitButton].addSubViews(self.headerView)

    self.headerView.snp.makeConstraints {
      $0.top.leading.equalToSuperview()
      $0.trailing.equalTo(self.safeAreaLayoutGuide).offset(Metric.headerViewTrailingMargin)
      $0.height.equalTo(Metric.headerViewHeight)
    }

    self.exitButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(Metric.exitButtonTrailingMargin)
      $0.centerY.equalTo(self.safeAreaLayoutGuide.snp.top).offset(25)
    }

    self.titleLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalTo(self.safeAreaLayoutGuide.snp.top).offset(25)
    }

    self.contentView.snp.makeConstraints {
      $0.top.equalTo(self.headerView.snp.bottom)
      $0.trailing.leading.bottom.equalTo(self.safeAreaLayoutGuide)
    }

    self.commentCollectionView.snp.makeConstraints {
      $0.top.equalTo(self.headerView.snp.bottom)
      $0.leading.trailing.equalTo(self.contentView)
      $0.bottom.equalTo(self.contentView)
    }

    self.commentInputView.snp.makeConstraints {
      $0.bottom.trailing.leading.equalTo(self.contentView)
      $0.top.equalTo(self.commentTextView.snp.top).offset(Metric.commentInputViewTopMargin)
    }

    self.commentTextView.snp.makeConstraints {
      $0.height.equalTo(Metric.commentTextViewHeight)
      $0.bottom.equalTo(self.contentView).offset(Metric.commentTextViewBottomMargin)
      $0.trailing.equalTo(self.contentView).offset(Metric.commentTextViewTrailingMargin)
      $0.leading.equalTo(self.contentView).offset(Metric.commentTextViewLeadingMargin)
    }

    self.registButton.snp.makeConstraints {
      $0.trailing.equalTo(self.contentView).offset(Metric.registButtonTrailingMargin)
      $0.bottom.equalTo(self.commentTextView)
      $0.width.equalTo(Metric.registButtonWidth)
      $0.height.equalTo(Metric.registButtonHeight)
    }
  }
  
  func commentCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    let estimatedHeigth: CGFloat = 100

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
    commentSection.interGroupSpacing = 15
    commentSection.contentInsets = NSDirectionalEdgeInsets(
      top: 0,
      leading: 20,
      bottom: 15,
      trailing: 20
    )

    let layout = UICollectionViewCompositionalLayout(section: commentSection)

    return layout
  }
}
