//
//  AddressCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/21.
//

import UIKit

final class AdressCell: BaseTableViewCell<Void> {

  // MARK: - Constants

  private enum Metric {
    static let iconImageViewBottomMargin = -15.f
    static let iconImageViewLeadingMargin = 20.f

    static let addressLabelLeadingMargin = 10.f
  }

  // MARK: - UI

  let iconImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = UIImage(named: "ic_search_location")
  }

  let addressLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = .systemFont(ofSize: 14)
  }

  // MARK: - Bind

  func bind(address: String) {
    self.addressLabel.text = address
  }

  // MARK: - Constraints

  override func setupConstraints() {
    [self.iconImageView, self.addressLabel].addSubViews(self)

    NSLayoutConstraint.activate([
      iconImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
      iconImageView.bottomAnchor.constraint(
        equalTo: self.contentView.bottomAnchor,
        constant: Metric.iconImageViewBottomMargin
      ),
      iconImageView.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor),
      iconImageView.heightAnchor.constraint(equalTo: self.iconImageView.widthAnchor, multiplier: 1),

      addressLabel.leadingAnchor.constraint(equalTo: self.iconImageView.trailingAnchor, constant: Metric.addressLabelLeadingMargin),
      addressLabel.centerYAnchor.constraint(equalTo: self.iconImageView.centerYAnchor)
    ])
  }

}
