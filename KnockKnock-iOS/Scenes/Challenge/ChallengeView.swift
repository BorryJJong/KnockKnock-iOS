//
//  ChallengeView.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/03/05.
//

import UIKit

final class ChallengeView: UIView {
  
  // MARK: - UI
  
  private let collectionView = UICollectionView()
  
  init() {
    super.init(frame: .zero)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}
