//
//  NoticeDetailView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/02.
//

import UIKit

import SnapKit
import KKDSKit
import Then

final class NoticeDetailView: UIView {

  // MARK: - UIs

  private let titleLabel = UILabel().then {
    $0.text = "NEW 챌린지 제로웨이스트 도전"
    $0.font = .systemFont(ofSize: 20, weight: .bold)
    $0.textColor = KKDS.Color.black
  }

  private let dateLabel = UILabel().then {
    $0.text = "2022.10.29"
    $0.font = .systemFont(ofSize: 13, weight: .medium)
    $0.textColor = KKDS.Color.gray70
  }

  private let separatorLineView = UIView().then {
    $0.backgroundColor = .gray20
  }

  private let contentTextView = UITextView().then {
    let style = NSMutableParagraphStyle().then {
      $0.lineSpacing = 5
      $0.alignment = .left
    }

    let attributes = [
      NSAttributedString.Key.paragraphStyle: style,
      NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium)
    ]
    $0.typingAttributes = attributes

    $0.text = "안녕하세요. 녹녹 입니다.\n\n항상 녹녹을 이용해주시는 고객님들께 진심으로 감사드립니다. 새로운 챌린지가 업데이트되어 공지드립니다.\n\n자세한 사항은 아래를 참고 해주세요.\n\n제로웨이스트 (Zero-waste) 는 말 그대로 쓰레기(Waste) 배출량이 0(zero)인, 다시 말하자면 '쓰레기가 나오지 않도록 노력하는 생활습관'을 뜻합니다. 기존의 환경보호 운동과 차이점이라 하면 제로웨이스트는 일상생활 속에서 발생하는 쓰레기(플라스틱, 일회용 용기 등)를 최소화하는 데 초점을 맞춘 라이프스타일의 관점에서 자주 쓰는 용어입니다.\n\n제로웨이스트 (Zero-waste) 는 말 그대로 쓰레기(Waste) 배출량이 0(zero)인, 다시 말하자면 '쓰레기가 나오지 않도록 노력하는 생활습관'을 뜻합니다. 기존의 환경보호 운동과 차이점이라 하면 제로웨이스트는 일상생활 속에서 발생하는 쓰레기(플라스틱, 일회용 용기 등)를 최소화하는 데 초점을 맞춘 라이프스타일의 관점에서 자주 쓰는 용어입니다.\n\n안녕하세요. 녹녹 입니다.\n\n항상 녹녹을 이용해주시는 고객님들께 진심으로 감사드립니다. 새로운 챌린지가 업데이트되어 공지드립니다.\n\n자세한 사항은 아래를 참고 해주세요.\n\n제로웨이스트 (Zero-waste) 는 말 그대로 쓰레기(Waste) 배출량이 0(zero)인, 다시 말하자면 '쓰레기가 나오지 않도록 노력하는 생활습관'을 뜻합니다. 기존의 환경보호 운동과 차이점이라 하면 제로웨이스트는 일상생활 속에서 발생하는 쓰레기(플라스틱, 일회용 용기 등)를 최소화하는 데 초점을 맞춘 라이프스타일의 관점에서 자주 쓰는 용어입니다.\n\n제로웨이스트 (Zero-waste) 는 말 그대로 쓰레기(Waste) 배출량이 0(zero)인, 다시 말하자면 '쓰레기가 나오지 않도록 노력하는 생활습관'을 뜻합니다. 기존의 환경보호 운동과 차이점이라 하면 제로웨이스트는 일상생활 속에서 발생하는 쓰레기(플라스틱, 일회용 용기 등)를 최소화하는 데 초점을 맞춘 라이프스타일의 관점에서 자주 쓰는 용어입니다."
    $0.textColor = KKDS.Color.black
    $0.textContainerInset = .init(top: 20, left: 20, bottom: 20, right: 20)
  }

  // MARK: - Initialize

  override init(frame: CGRect) {
    super.init(frame: .zero)
    self.setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Configure

  private func setupConstraints() {
    [self.titleLabel, self.dateLabel, self.separatorLineView, self.contentTextView].addSubViews(self)

    self.titleLabel.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
    }

    self.dateLabel.snp.makeConstraints {
      $0.top.equalTo(self.titleLabel.snp.bottom).offset(5)
      $0.leading.equalTo(self.safeAreaLayoutGuide).offset(20)
    }

    self.separatorLineView.snp.makeConstraints {
      $0.height.equalTo(1)
      $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
      $0.top.equalTo(self.dateLabel.snp.bottom).offset(20)
    }

    self.contentTextView.snp.makeConstraints {
      $0.top.equalTo(self.separatorLineView.snp.bottom)
      $0.bottom.leading.trailing.equalTo(self.safeAreaLayoutGuide)
    }
  }

}
