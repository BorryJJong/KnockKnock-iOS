//
//  PropertyCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/20.
//

import UIKit
import KKDSKit

final class PropertyCell: BaseTableViewCell {
  
  // MARK: - Properties
  
  private enum Metric {
    static let propertyLabelTopMargin = 15.f
    static let propertyLabelBottomMargin = -15.f
    static let propertyLabelLeadingMargin = 20.f
    static let checkImageTrailingMargin = -20.f
  }

  private lazy var isCheck: Bool = false {
    didSet {
      let propertyLabelColor = isCheck ? UIColor.black : UIColor.green50
      let checkImage = isCheck ? KKDS.Image.ic_checkbox_20_off : KKDS.Image.ic_checkbox_20_on

      self.propertyLabel.textColor = propertyLabelColor
      self.checkImageView.image = checkImage
    }
  }
  
  // MARK: - UI
  
  let propertyLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.textColor = .black
    $0.font = .systemFont(ofSize: 14)
  }
  
  let checkImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = UIImage(named: "ic_checkbox_off")
  }
  
  // MARK: - Bind

//  override func setSelected(_ selected: Bool, animated: Bool) {
//    super.setSelected(selected, animated: animated)
//    self.isCheck.toggle()
//  }

  func bind(content: String, isSelected: Bool) {
    self.propertyLabel.text = content

    let propertyLabelColor = isSelected ? UIColor.green50 : UIColor.black
    let checkImage = isSelected ?  KKDS.Image.ic_checkbox_20_on : KKDS.Image.ic_checkbox_20_off

    self.propertyLabel.textColor = propertyLabelColor
    self.checkImageView.image = checkImage

  }

  // MARK: - Configure
  
  override func setupConstraints() {
    [self.propertyLabel, self.checkImageView].addSubViews(self.contentView)

    NSLayoutConstraint.activate([
      self.propertyLabel.centerYAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.centerYAnchor),
      self.propertyLabel.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor, constant: Metric.propertyLabelTopMargin),
      self.propertyLabel.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor, constant: Metric.propertyLabelBottomMargin),
      self.propertyLabel.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor, constant: Metric.propertyLabelLeadingMargin),
      
      self.checkImageView.centerYAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.centerYAnchor),
      self.checkImageView.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor, constant: Metric.checkImageTrailingMargin)
    ])
  }
}
