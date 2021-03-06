//
//  UILabel+Ext.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/23.
//

import UIKit

extension UILabel {

  // MARK: Line height 설정

  func setLineHeight(fontSize: CGFloat, content: String) {
    let style = NSMutableParagraphStyle()
    let lineHeight = fontSize * 1.6
    style.minimumLineHeight = lineHeight
    style.maximumLineHeight = lineHeight

    self.attributedText = NSAttributedString(string: content,
    attributes: [
      .paragraphStyle: style,
      .font: UIFont.systemFont(ofSize: fontSize, weight: .regular)
    ])
  }

  // MARK: - "...더보기"

/// label의 폰트, 사이즈를 계산해서 최종적으로 화면에 보여질 글자의 길이를 저장할 변수
  var visibleTextLength: Int {

    let font: UIFont = self.font
    let mode: NSLineBreakMode = self.lineBreakMode
    let labelWidth: CGFloat = self.frame.size.width
    let labelHeight: CGFloat = self.frame.size.height
    let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)

    if let myText = self.text {

      let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
      let attributedText = NSAttributedString(
        string: myText,
        attributes: attributes as? [NSAttributedString.Key: Any])

      let boundingRect: CGRect = attributedText.boundingRect(
        with: sizeConstraint,
        options: .usesLineFragmentOrigin,
        context: nil)

      if boundingRect.size.height > labelHeight {
        var index: Int = 0
        var prev: Int = 0
        let characterSet = CharacterSet.whitespacesAndNewlines
        repeat {
          prev = index
          if mode == NSLineBreakMode.byCharWrapping {
            index += 1
          } else {
            index = (myText as NSString).rangeOfCharacter(
              from: characterSet,
              options: [],
              range: NSRange(
                location: index + 1,
                length: myText.count - index - 1)).location
          }
        } while index != NSNotFound && index < myText.count && (myText as NSString)
          .substring(to: index)
          .boundingRect(
            with: sizeConstraint,
            options: .usesLineFragmentOrigin,
            attributes: attributes as? [NSAttributedString.Key: Any], context: nil)
          .size
          .height <= labelHeight

        return prev
      }
    }

    if self.text == nil {
      return 0
    } else {
      return self.text!.count
    }
  }

  /// 덧 붙일 텍스트의 길이만큼 trailing 값을 추가하는 함수
  func addTrailing(
    with trailingText: String,
    moreText: String,
    moreTextFont: UIFont,
    moreTextColor: UIColor
  ) {

    let readMoreText: String = trailingText + moreText

    if self.visibleTextLength == 0 { return }

    let lengthForVisibleString: Int = self.visibleTextLength

    if let myText = self.text {

      let mutableString: String = myText
      let trimmedString: String? = (mutableString as NSString).replacingCharacters(
        in: NSRange(
          location: lengthForVisibleString,
          length: myText.count - lengthForVisibleString
        ), with: "")

      let readMoreLength: Int = (readMoreText.count)

      guard let safeTrimmedString = trimmedString else { return }

      if safeTrimmedString.count <= readMoreLength { return }

      let trimmedForReadMore: String = (safeTrimmedString as NSString)
        .replacingCharacters(
          in: NSRange(
            location: safeTrimmedString.count - readMoreLength,
            length: readMoreLength)
          , with: ""
        ) + trailingText

      let answerAttributed = NSMutableAttributedString(
        string: trimmedForReadMore,
        attributes: [NSAttributedString.Key.font: self.font as Any]
      )

      let readMoreAttributed = NSMutableAttributedString(
        string: moreText,
        attributes: [NSAttributedString.Key.font: moreTextFont,
                     NSAttributedString.Key.foregroundColor: moreTextColor]
      )
      answerAttributed.append(readMoreAttributed)
      self.attributedText = answerAttributed
    }
  }
}
