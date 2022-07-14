//
//  CommentsView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/13.
//

import UIKit

import KKDSKit
import Then

class CommentView: UIView {

  // MARK: - UIs

  let commentCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then{
      $0.scrollDirection = .vertical
    }).then {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.backgroundColor = .yellow
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

  private let commentTextField = UITextField().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.placeholder = "댓글을 달아주세요..."
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

  // MARK: - Constraints

  func setupConstraints() {
    [self.commentCollectionView, self.commentInputView].addSubViews(self)
    [self.commentTextField, self.registButton].addSubViews(commentInputView)

    NSLayoutConstraint.activate([
      self.commentCollectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
      self.commentCollectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
      self.commentCollectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
      self.commentCollectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),

      self.commentInputView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
      self.commentInputView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
      self.commentInputView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
      self.commentInputView.heightAnchor.constraint(equalToConstant: 60),

      self.commentTextField.topAnchor.constraint(equalTo: self.commentInputView.topAnchor, constant: 20),
      self.commentTextField.bottomAnchor.constraint(equalTo: self.commentInputView.bottomAnchor, constant: -19),
      self.commentTextField.trailingAnchor.constraint(equalTo: self.commentInputView.trailingAnchor, constant: -70),
      self.commentTextField.leadingAnchor.constraint(equalTo: self.commentInputView.leadingAnchor, constant: 20),

      self.registButton.trailingAnchor.constraint(equalTo: self.commentInputView.trailingAnchor, constant: -20),
      self.registButton.bottomAnchor.constraint(equalTo: self.commentInputView.bottomAnchor, constant: -15),
      self.registButton.widthAnchor.constraint(equalToConstant: 50),
      self.registButton.heightAnchor.constraint(equalToConstant: 30)
    ])
  }
}
