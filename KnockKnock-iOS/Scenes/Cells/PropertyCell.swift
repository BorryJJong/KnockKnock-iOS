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
    static let propertyLabelTopMargin = 15.f
    static let propertyLabelBottomMargin = -15.f
    static let propertyLabelLeadingMargin = 20.f
    static let checkImageTrailingMargin = -20.f
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
  
  lazy var checkButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .clear
    $0.addTarget(self, action: #selector(checkButtonDidTap(_:)), for: .touchUpInside)
  }
  
  @objc func checkButtonDidTap(_ sender: UIButton) {
    if self.propertyLabel.textColor == .black {
      self.checkImageView.image = UIImage(named: "ic_checkbox_on")
      self.propertyLabel.textColor = .green50
    } else {
      self.checkImageView.image = UIImage(named: "ic_checkbox_off")
      self.propertyLabel.textColor = .black
    }
  }

  // MARK: - Bind

  func bind(content: String) {
    self.propertyLabel.text = content
  }

  // MARK: - Configure
  
  override func setupConstraints() {
    [self.propertyLabel, self.checkImageView, self.checkButton].addSubViews(self.contentView)

    NSLayoutConstraint.activate([
      self.propertyLabel.centerYAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.centerYAnchor),
      self.propertyLabel.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor, constant: Metric.propertyLabelTopMargin),
      self.propertyLabel.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor, constant: Metric.propertyLabelBottomMargin),
      self.propertyLabel.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor, constant: Metric.propertyLabelLeadingMargin),
      
      self.checkImageView.centerYAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.centerYAnchor),
      self.checkImageView.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor, constant: Metric.checkImageTrailingMargin),
      
      self.checkButton.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor),
      self.checkButton.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor),
      self.checkButton.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor),
      self.checkButton.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor)
    ])
  }
}
