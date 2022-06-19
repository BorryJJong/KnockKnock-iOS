//
//  File.swift
//  
//
//  Created by sangwon yoon on 2022/06/19.
//

import UIKit

public extension KKDS {
    enum Image { }
}

public extension KKDS.Image {
  static var ic_down_20_gr: UIImage             { .load(name: "ic_down_20_gr") }
  static var ic_location_20: UIImage            { .load(name: "ic_location_20") }
  static var ic_select_20: UIImage              { .load(name: "ic_select_20") }
  static var ic_up_20_gr: UIImage               { .load(name: "ic_up_20_gr") }
  static var ic_card_list_20_off: UIImage       { .load(name: "ic_card_list_20_off") }
  static var ic_card_list_20_on: UIImage        { .load(name: "ic_card_list_20_on") }
  static var ic_checkbox_20_off: UIImage        { .load(name: "ic_checkbox_20_off") }
  static var ic_checkbox_20_on: UIImage         { .load(name: "ic_checkbox_20_on") }
  static var ic_img_close_20_gr: UIImage        { .load(name: "ic_img_close_20_gr") }
  static var ic_list_20_off: UIImage            { .load(name: "ic_list_20_off") }
  static var ic_list_20_on: UIImage             { .load(name: "ic_list_20_on") }
  static var ic_more_20_gr: UIImage             { .load(name: "ic_more_20_gr") }
  static var ic_more_img_20_off: UIImage        { .load(name: "ic_more_img_20_off") }
  static var ic_more_img_20_on: UIImage         { .load(name: "ic_more_img_20_on") }
  static var ic_more_img_20_wh: UIImage         { .load(name: "ic_more_img_20_wh") }
  static var ic_post_camera_24_gr: UIImage      { .load(name: "ic_post_camera_24_gr") }
}

extension UIImage {
  public static func load(name: String) -> UIImage {
    guard let image = UIImage(named: name, in: KKDS.bundle, compatibleWith: nil) else {
      assert(false, "\(name) 이미지 로드 실패")
      return UIImage()
    }
    return image
  }
}
