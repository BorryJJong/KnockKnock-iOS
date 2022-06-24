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

// MARK: - Icon size 20

public extension KKDS.Image {
  static var ic_down_20_gr: UIImage               { .load(name: "ic_down_20_gr") }
  static var ic_location_20: UIImage              { .load(name: "ic_location_20") }
  static var ic_select_20: UIImage                { .load(name: "ic_select_20") }
  static var ic_up_20_gr: UIImage                 { .load(name: "ic_up_20_gr") }
  static var ic_card_list_20_off: UIImage         { .load(name: "ic_card_list_20_off") }
  static var ic_card_list_20_on: UIImage          { .load(name: "ic_card_list_20_on") }
  static var ic_checkbox_20_off: UIImage          { .load(name: "ic_checkbox_20_off") }
  static var ic_checkbox_20_on: UIImage           { .load(name: "ic_checkbox_20_on") }
  static var ic_img_close_20_gr: UIImage          { .load(name: "ic_img_close_20_gr") }
  static var ic_list_20_off: UIImage              { .load(name: "ic_list_20_off") }
  static var ic_list_20_on: UIImage               { .load(name: "ic_list_20_on") }
  static var ic_more_20_gr: UIImage               { .load(name: "ic_more_20_gr") }
  static var ic_more_img_20_off: UIImage          { .load(name: "ic_more_img_20_off") }
  static var ic_more_img_20_on: UIImage           { .load(name: "ic_more_img_20_on") }
  static var ic_more_img_20_wh: UIImage           { .load(name: "ic_more_img_20_wh") }
  static var ic_post_camera_24_gr: UIImage        { .load(name: "ic_post_camera_24_gr") }
}

// MARK: - Icon Size 24

public extension KKDS.Image {
  static var ic_back_24_bk: UIImage               { .load(name: "ic_back_24_bk") }
  static var ic_back_24_wh: UIImage               { .load(name: "ic_back_24_wh") }
  static var ic_balloon_24_gr: UIImage            { .load(name: "ic_balloon_24_gr") }
  static var ic_camera_24_gr: UIImage             { .load(name: "ic_camera_24_gr") }
  static var ic_close_24_bk: UIImage              { .load(name: "ic_close_24_bk") }
  static var ic_gnb_home_24_bk: UIImage           { .load(name: "ic_gnb_home_24_bk") }
  static var ic_gnb_home_24_wh: UIImage           { .load(name: "ic_gnb_home_24_wh") }
  static var ic_gnb_share_24_bk: UIImage          { .load(name: "ic_gnb_share_24_bk") }
  static var ic_gnb_share_24_wh: UIImage          { .load(name: "ic_gnb_share_24_wh") }
  static var ic_input_close_24_gr: UIImage        { .load(name: "ic_input_close_24_gr") }
  static var ic_input_warning_24_rd: UIImage      { .load(name: "ic_input_warning_24_rd") }
  static var ic_like_24_off: UIImage              { .load(name: "ic_like_24_off") }
  static var ic_like_24_on: UIImage               { .load(name: "ic_like_24_on") }
  static var ic_person_24: UIImage                { .load(name: "ic_person_24") }
  static var ic_post_camera_24_gr: UIImage        { .load(name: "ic_post_camera_24_gr") }
  static var ic_search_24_bk: UIImage             { .load(name: "ic_search_24_bk") }
  static var ic_search_24_gr: UIImage             { .load(name: "ic_search_24_gr") }
  static var ic_search_24_wh: UIImage             { .load(name: "ic_search_24_wh") }
  static var ic_set_24_bk: UIImage                { .load(name: "ic_set_24_bk") }
}

// MARK: - Tab

public extension KKDS.Image {
  static var ic_bottom_challenge_27_off: UIImage  { .load(name: "ic_bottom_challenge_27_off") }
  static var ic_bottom_challenge_27_on: UIImage   { .load(name: "ic_bottom_challenge_27_on") }
  static var ic_bottom_home_27_off: UIImage       { .load(name: "ic_bottom_home_27_off") }
  static var ic_bottom_home_27_on: UIImage        { .load(name: "ic_bottom_home_27_on") }
  static var ic_bottom_my_27_off: UIImage         { .load(name: "ic_bottom_my_27_off") }
  static var ic_bottom_my_27_on: UIImage          { .load(name: "ic_bottom_my_27_on") }
  static var ic_bottom_search_27_off: UIImage     { .load(name: "ic_bottom_search_27_off") }
  static var ic_bottom_search_27_on: UIImage      { .load(name: "ic_bottom_search_27_on") }
  static var ic_bottom_store_27_off: UIImage      { .load(name: "ic_bottom_store_27_off") }
  static var ic_bottom_store_27_on: UIImage       { .load(name: "ic_bottom_store_27_on") }
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
