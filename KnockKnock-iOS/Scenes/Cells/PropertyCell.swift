//
//  PropertyCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/20.
//

import UIKit

final class PropertyCell: BaseTableViewCell {

  // MARK: - Properties

  private enum Metric {
    static let propertyLabelLeftMargin = 20.f
    static let checkButtonRightMargin = -20.f
  }

  // MARK: - UI

  let propertyLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.tintColor = .black
  }

  let checkButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setImage(#imageLiteral(resourceName: "ic_checkbox_off"), for: .normal)
    $0.setImage(#imageLiteral(resourceName: "ic_checkbox_on"), for: .selected)
  }

  // MARK: - Configure

  override func setupConstraints() {
    [self.propertyLabel, self.checkButton].addSubViews(self.contentView)

    NSLayoutConstraint.activate([
      self.propertyLabel.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
      self.propertyLabel.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: Metric.propertyLabelLeftMargin),

      self.checkButton.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
      self.checkButton.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: Metric.checkButtonRightMargin)
    ])
  }

}
