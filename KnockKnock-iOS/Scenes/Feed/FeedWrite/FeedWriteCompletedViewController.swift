//
//  FeedWriteCompletedViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/24.
//

import UIKit

final class FeedWriteCompletedViewController: BaseViewController<FeedWriteCompletedView> {

  // MARK: - Life cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    self.containerView.playLottie()
  }
}
