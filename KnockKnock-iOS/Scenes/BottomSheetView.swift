//
//  BottomSheetView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/05/11.
//

import UIKit

import Then

final class BottomSheetView: UIView {

  // MARK: - UIs

  let dimmedView = UIView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
  }

  let bottomSheetView = UIView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 10
    $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    $0.clipsToBounds = true
  }

  // MARK: - Initialize

  init() {
    super.init(frame: .zero)
    self.setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  func setupConstraints() {
    [self.dimmedView, self.bottomSheetView].addSubViews(self)
    
    NSLayoutConstraint.activate([
      self.dimmedView.topAnchor.constraint(equalTo: self.topAnchor),
      self.dimmedView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      self.dimmedView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      self.dimmedView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

      self.bottomSheetView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      self.bottomSheetView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      self.bottomSheetView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      self.bottomSheetView.heightAnchor.constraint(equalToConstant: 150),
    ])
  }
}
