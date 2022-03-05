//
//  ChallengeRouter.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/03/03.
//

import UIKit

protocol ChallengeRouterProtocol: AnyObject {
  static func createChallenge() -> UIViewController
}

final class ChallengeRouter: ChallengeRouterProtocol {
  static func createChallenge() -> UIViewController {
    return UIViewController()
  }
}
