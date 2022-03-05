//
//  ChallengeViewController.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/02/26.
//

import UIKit

protocol ChallengeViewProtocol: AnyObject {
  var interactor: ChallengeInteractorProtocol? { get set }
}

final class ChallengeViewController: BaseViewController<ChallengeView> {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
}
