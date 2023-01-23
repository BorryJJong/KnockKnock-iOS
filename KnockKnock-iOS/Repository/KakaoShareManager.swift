//
//  KakaoShareManager.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/23.
//

import UIKit

import KakaoSDKShare
import KakaoSDKTemplate
import KakaoSDKCommon

protocol KakaoShareManagerProtocol {
  func sharePost(feedData: FeedList.Post?) -> Bool
}

final class KakaoShareManager: KakaoShareManagerProtocol {

  func sharePost(feedData: FeedList.Post?) -> Bool {
    let isSuccess = true

    guard let data = feedData,
          let postImage = data.blogImages.first,
          let likeCount = Int(data.blogLikeCount.filter { $0.isNumber }),
          let commentCount = Int(data.blogCommentCount.filter { $0.isNumber })
    else { return !isSuccess }

    // 추후에 worker로 빼기
    if ShareApi.isKakaoTalkSharingAvailable(){

      let appLink = Link(iosExecutionParams: ["feedDetail": "\(data.id)"])

      let button = Button(title: "앱에서 보기", link: appLink)

      let content = Content(title: "\(data.userName)님의 게시물",
                            imageUrl: URL(string: postImage.fileUrl)!,
                            description: data.content,
                            link: appLink)

      let social = Social(likeCount: likeCount,
                          commentCount: commentCount)

      let template = FeedTemplate(content: content, social: social, buttons: [button])

      guard let templateJsonData = (try? SdkJSONEncoder.custom.encode(template)),
            let templateJsonObject = SdkUtils.toJsonObject(templateJsonData) else {
        return !isSuccess
      }

      ShareApi.shared.shareDefault(templateObject: templateJsonObject) { (linkResult, error) in
        guard error == nil else { return }
        guard let linkResult = linkResult else { return }

        UIApplication.shared.open(linkResult.url, options: [:], completionHandler: nil)
      }

      return isSuccess

    } else {

      return !isSuccess

    }
  }
}
