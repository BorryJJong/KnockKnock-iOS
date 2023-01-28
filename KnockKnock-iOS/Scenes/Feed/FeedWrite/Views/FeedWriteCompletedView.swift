//
//  FeedWriteCompletedView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/24.
//

import UIKit

import Then
import Lottie
import KKDSKit
import SnapKit

final class FeedWriteCompletedView: UIView {

  // MARK: - UIs

  var doneIndicatorView = LottieAnimationView(name: "zero_waste_done").then {
    $0.contentMode = .scaleAspectFit
    $0.loopMode = .playOnce
  }

  let doneHeaderLabel = UILabel().then {
    $0.text = "게시글 등록이 완료되었습니다!"
    $0.font = .systemFont(ofSize: 20, weight: .heavy)
  }

  let doneLabel = UILabel().then {
    $0.text = "또 다른 챌린지에도 도전해보세요."
    $0.font = .systemFont(ofSize: 13, weight: .regular)
    $0.textColor = KKDS.Color.gray70
  }

  // MARK: - Initialize

  init() {
    super.init(frame: .zero)
    self.setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: - Configure

  func playLottie() {
    self.doneIndicatorView.play()
  }

  // MARK: - Constraints

  private func setupConstraints() {

    [self.doneIndicatorView].addSubViews(self)
    [self.doneHeaderLabel].addSubViews(self)
    [self.doneLabel].addSubViews(self)

    self.doneLabel.snp.makeConstraints {
      $0.bottom.equalTo(self.snp.centerY).offset(-50)
      $0.centerX.equalTo(self)
    }

    self.doneHeaderLabel.snp.makeConstraints {
      $0.bottom.equalTo(self.doneLabel.snp.top).offset(-15)
      $0.centerX.equalTo(self)
    }

    self.doneIndicatorView.snp.makeConstraints {
      $0.bottom.equalTo(doneHeaderLabel.snp.top).offset(-25)
      $0.centerX.equalTo(self)
      $0.width.height.equalTo(150)
    }
  }

}

