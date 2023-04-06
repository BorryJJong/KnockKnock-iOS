//
//  CollectionReusableView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/18.
//

import UIKit

import KKDSKit

class FeedMainFooterCollectionReusableView: UICollectionReusableView {

  // MARK: - Constants

  enum Metric {
    static let viewMoreButtonHeight = 40.f
  }

  // MARK: - UIs

  let viewMoreButton = KKDSMiddleButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setTitle("+ 더보기", for: .normal)
  }

  // MARK: - Initailize

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: - Constraints

  func setupConstraints() {
    [self.viewMoreButton].addSubViews(self)

    NSLayoutConstraint.activate([
      self.viewMoreButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
      self.viewMoreButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
      self.viewMoreButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
      self.viewMoreButton.heightAnchor.constraint(equalToConstant: Metric.viewMoreButtonHeight)
    ])
  }
}
