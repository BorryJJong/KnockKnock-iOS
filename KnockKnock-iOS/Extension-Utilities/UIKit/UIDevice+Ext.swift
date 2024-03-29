//
//  UIDevice+Ext.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/13.
//

import UIKit

extension UIDevice {

  /// 노치가 있는 디바이스에서 top, bottom safeAreaInset을 제외한 스크린의 전체 높이를 반환해주는 메소드
  func heightOfSafeArea(includeBottomInset: Bool = false) -> CGFloat {
    let rootView = UIApplication
      .shared
      .connectedScenes
      .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
      .first { $0.isKeyWindow }

    guard let rootView = rootView else { return 0 }

    let topInset = rootView.safeAreaInsets.top
    let bottomInset = rootView.safeAreaInsets.bottom

    if includeBottomInset {
      return rootView.bounds.height - topInset
    }
    return rootView.bounds.height - topInset - bottomInset
  }
}
