//
//  ChallengeDetailHeaderCollectionReusableView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/21.
//

import UIKit

import Then
import KKDSKit

class ChallengeDetailHeaderCollectionReusableView: UICollectionReusableView {

  // MARK: - Constants

  private enum Metric {
    static let participantViewTopMargin = -15.f
    static let participantViewTrailingMargin = -55.f
    static let participantViewHeight = 45.f

    static let participantImageViewLeadingMargin = 20.f
    static let participantImageViewTopMargin = 20.f

    static let participantLabelViewTopMargin = 15.f
    static let participantLabelViewLeadingMargin = 5.f

    static let participantSeperatorViewHeight = 1.f
    static let participantSeperatorViewLeadingMargin = 20.f
    static let participantSeperatorViewTrailingMargin = -20.f
    static let participantSeperatorViewTopMargin = 15.f

    static let titleLabelTopMargin = 15.f
    static let titleLabelLeadingMargin = 20.f
    static let titleLabelTrailingMargin = -20.f

    static let summaryLabelTopMargin = 15.f
    static let summaryLabelLeadingMargin = 20.f
    static let summaryLabelTrailingMargin = -20.f

    static let summarySeperatorViewHeight = 1.f
    static let summarySeperatorViewLeadingMargin = 20.f
    static let summarySeperatorViewTrailingMargin = -20.f
    static let summarySeperatorViewTopMargin = 40.f

    static let wayHeaderLabelLeadingMargin = 20.f
    static let wayHeaderLabelTopMargin = 20.f

    static let wayLabelTopMargin = 10.f
    static let wayLabelLeadingMargin = 20.f
    static let wayLabelTrailingMargin = -20.f
    static let wayLabelHeight = 130.f
  }

  // MARK: - UIs

  private let mainImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = UIImage(named: "challenge")
  }

  private let participantView = UIView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .white
  }

  private let participantImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
    $0.contentMode = .scaleToFill
    $0.image = UIImage(named: "ic_person_24")
  }

  private let participantLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = "첫 번째 참여자가 되어보세요!"
    $0.textColor = .green50
    $0.font = .systemFont(ofSize: 13)
  }

  private let participantSeperatorView = UIView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .gray20
  }

  private let titleLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.tintColor = .black
    $0.text = "#GOGO 챌린지"
    $0.font = .systemFont(ofSize: 22, weight: .bold)
    $0.numberOfLines = 1
    $0.textAlignment = .left
  }

  private let summaryLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.numberOfLines = 0
    $0.textAlignment = .natural
  }

  private let summarySeperatorView = UIView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .gray20
  }

  private let wayHeaderLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = "실천방법"
    $0.font = .systemFont(ofSize: 17, weight: .bold)
    $0.textColor = .green50
  }

  private let waysStackView = UIStackView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.axis = .vertical
    $0.distribution = .fill
    $0.alignment = .leading
    $0.spacing = 10
    $0.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    $0.isLayoutMarginsRelativeArrangement = true
    $0.backgroundColor = .gray20
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 10
  }

  // MARK: - Initailize

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupConstraints()
    let ways = ["카페에서 음료 주문시 빨대 사용하지 않기",
                "쇼핑할때 장바구니 챙기기",
                "유리 제품 사용하기"]
    self.setWayStackView(ways: ways)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: - Bind

  func bind() {
    let content = "제로웨이스트 운동 (Zero-waste) 는 말 그대로 쓰레기(Waste) 배출량이 0(zero)인, 다시 말하자면 '쓰레기 없는 생활'을 추구하는 운동입니다. 기존의 환경보호 운동과 차이점이라 하면 제로웨이스트는 일상생활 속에서 발생하는 쓰레기(플라스틱, 일회용 용기 등)를 최소화하는 데 초점을 맞춘 라이프스타일의 관점에서 자주 쓰는 용어입니다."
    self.setSummeryLabel(content: content)
  }

  // MARK: - Configure

  private func setSummeryLabel(content: String) {
    let style = NSMutableParagraphStyle()
    let fontSize: CGFloat = 14
    let lineHeight = fontSize * 1.6
    style.minimumLineHeight = lineHeight
    style.maximumLineHeight = lineHeight

    self.summaryLabel.attributedText = NSAttributedString(string: content,
    attributes: [
      .paragraphStyle: style,
      .font: UIFont.systemFont(ofSize: 14, weight: .regular)
    ])
  }

  private func setWayStackView(ways: [String]) {
    let wayLabelFont = UIFont.systemFont(ofSize: 12, weight: .regular)
    let bulletImage = KKDS.Image.ic_bullet_3_gr

    for way in ways {
      let attributedString = NSMutableAttributedString(string: "")

      let imageAttachment = NSTextAttachment()
      imageAttachment.image = bulletImage
      imageAttachment.bounds = CGRect(
        x: 0,
        y: (wayLabelFont.capHeight - bulletImage.size.height).rounded() / 2,
        width: bulletImage.size.width,
        height: bulletImage.size.height
      )

      attributedString.append(NSAttributedString(attachment: imageAttachment))
      attributedString.append(NSAttributedString(string: "  \(way)"))

      let waysLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = wayLabelFont
        $0.attributedText = attributedString
        $0.numberOfLines = 0
        $0.textAlignment = .left
      }
      self.waysStackView.addArrangedSubview(waysLabel)
    }
  }

  func setupConstraints() {
    [self.participantImageView, self.participantLabel].addSubViews(self.participantView)
    [self.mainImageView, self.participantView, self.participantSeperatorView, self.titleLabel, self.summaryLabel, self.summarySeperatorView, self.wayHeaderLabel, self.waysStackView].addSubViews(self)

    NSLayoutConstraint.activate([
      self.mainImageView.topAnchor.constraint(equalTo: self.topAnchor),
      self.mainImageView.widthAnchor.constraint(equalTo: self.widthAnchor),
      self.mainImageView.heightAnchor.constraint(equalTo: self.widthAnchor),

      self.participantView.topAnchor.constraint(equalTo: self.mainImageView.bottomAnchor, constant: Metric.participantViewTopMargin),
      self.participantView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
      self.participantView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.participantViewTrailingMargin),
      self.participantView.heightAnchor.constraint(equalToConstant: Metric.participantViewHeight),

      self.participantImageView.topAnchor.constraint(equalTo: self.participantView.topAnchor, constant: Metric.participantImageViewTopMargin),
      self.participantImageView.leadingAnchor.constraint(equalTo: self.participantView.leadingAnchor, constant: Metric.participantImageViewLeadingMargin),

      self.participantLabel.centerYAnchor.constraint(equalTo: self.participantImageView.centerYAnchor),
      self.participantLabel.leadingAnchor.constraint(equalTo: self.participantImageView.trailingAnchor, constant: Metric.participantLabelViewLeadingMargin),
      self.participantLabel.trailingAnchor.constraint(equalTo: self.participantView.trailingAnchor),

      self.participantSeperatorView.heightAnchor.constraint(equalToConstant: Metric.participantSeperatorViewHeight),
      self.participantSeperatorView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.participantSeperatorViewLeadingMargin),
      self.participantSeperatorView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.participantSeperatorViewTrailingMargin),
      self.participantSeperatorView.topAnchor.constraint(equalTo: self.participantView.bottomAnchor, constant: Metric.participantSeperatorViewTopMargin),

      self.titleLabel.topAnchor.constraint(equalTo: self.participantSeperatorView.bottomAnchor, constant: Metric.titleLabelTopMargin),
      self.titleLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.titleLabelLeadingMargin),
      self.titleLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.titleLabelTrailingMargin),

      self.summaryLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: Metric.summaryLabelTopMargin),
      self.summaryLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.summaryLabelLeadingMargin),
      self.summaryLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.summaryLabelTrailingMargin),

      self.summarySeperatorView.heightAnchor.constraint(equalToConstant: Metric.summarySeperatorViewHeight),
      self.summarySeperatorView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.summarySeperatorViewLeadingMargin),
      self.summarySeperatorView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.summarySeperatorViewTrailingMargin),
      self.summarySeperatorView.topAnchor.constraint(equalTo: self.summaryLabel.bottomAnchor, constant: Metric.summarySeperatorViewTopMargin),

      self.wayHeaderLabel.topAnchor.constraint(equalTo: self.summarySeperatorView.bottomAnchor, constant: Metric.wayHeaderLabelTopMargin),
      self.wayHeaderLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.wayHeaderLabelLeadingMargin),

      self.waysStackView.topAnchor.constraint(equalTo: self.wayHeaderLabel.bottomAnchor, constant: Metric.wayLabelTopMargin),
      self.waysStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.wayLabelLeadingMargin),
      self.waysStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.wayLabelTrailingMargin),
      self.waysStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
}
