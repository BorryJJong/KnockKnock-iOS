//
//  AddressCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/21.
//

import UIKit

final class AdressCell: BaseTableViewCell {

  // MARK: - Properties

  private enum Metric {
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
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 7.5, left: 0, bottom: 7.5, right: 0))
  }

  override func setupConstraints() {
    [self.iconImageView, self.addressLabel].addSubViews(self)

    NSLayoutConstraint.activate([
      iconImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
      iconImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
      iconImageView.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor),

      addressLabel.leadingAnchor.constraint(equalTo: self.iconImageView.trailingAnchor, constant: Metric.addressLabelLeadingMargin),
      addressLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
    ])
  }

}
