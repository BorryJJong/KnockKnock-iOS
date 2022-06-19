//
//  CollectionReusableView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/18.
//

import UIKit

class FooterCollectionReusableView: UICollectionReusableView {

  // MARK: - Constants

  enum Metric {
    static let viewMoreButtonHeight = 40.f
  }

  // MARK: - UIs

  let viewMoreButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setTitle("+ 더보기", for: .normal)
    $0.setTitleColor(.gray80, for: .normal)
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.gray30?.cgColor
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
