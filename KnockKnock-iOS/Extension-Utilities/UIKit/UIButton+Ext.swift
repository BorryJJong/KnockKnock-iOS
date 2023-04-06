//
//  UIButton+Ext.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/22.
//

import UIKit

extension UIButton {

  /// image와 title를 수직 배치 하기 위한 메소드
  /// spacing: image, title 사이 간격
  func alignTextBelow(spacing: CGFloat) {
    guard let image = self.imageView?.image,
          let titleLabel = self.titleLabel,
          let titleText = titleLabel.text else { return }

    let titleSize = titleText.size(withAttributes: [
      NSAttributedString.Key.font: titleLabel.font as Any
    ])
    titleEdgeInsets = UIEdgeInsets(
      top: spacing,
      left: -image.size.width,
      bottom: -image.size.height,
      right: 0
    )
    imageEdgeInsets = UIEdgeInsets(
      top: -(titleSize.height + spacing),
      left: 0,
      bottom: 0,
      right: -titleSize.width
    )
  }
}

// MARK: - UIButton event를 closure를 이용하여 정의하기

extension UIButton {

  public typealias UIButtonTargetClosure = (UIButton) -> Void

  private class UIButtonClosureWrapper: NSObject {
    let closure: UIButtonTargetClosure
    init(_ closure: @escaping UIButtonTargetClosure) {
      self.closure = closure
    }
  }

  private struct AssociatedKeys {
    static var targetClosure = "targetClosure"
  }

  private var targetClosure: UIButtonTargetClosure? {
    get {
      guard let closureWrapper = objc_getAssociatedObject(
        self,
        &AssociatedKeys.targetClosure) as? UIButtonClosureWrapper else { return nil }

      return closureWrapper.closure
    }
    set(newValue) {
      guard let newValue = newValue else { return }

      objc_setAssociatedObject(
        self,
        &AssociatedKeys.targetClosure,
        UIButtonClosureWrapper(newValue),
        objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
      )
    }
  }

  @objc func closureAction() {
    guard let targetClosure = targetClosure else { return }
    targetClosure(self)
  }

  public func addAction(
    for event: UIButton.Event,
    closure: @escaping UIButtonTargetClosure
  ) {
    targetClosure = closure

    addTarget(
      self,
      action: #selector(UIButton.closureAction),
      for: event
    )
  }
}
