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
  func sharePost(feedData: FeedShare?) -> Bool
  func shareChallenge(challengeData: ChallengeDetail?) -> Bool
}

final class KakaoShareManager: KakaoShareManagerProtocol {

  func shareChallenge(challengeData: ChallengeDetail?) -> Bool {
    let isSuccess = true

    guard let data = challengeData else { return !isSuccess }

    if ShareApi.isKakaoTalkSharingAvailable(){

      let appLink = Link(iosExecutionParams: [ShareURL.challenge: "\(data.challenge.id)"])

      let button = Button(title: "앱에서 보기", link: appLink)

      let content = Content(title: "\(data.challenge.title)",
                            imageUrl: URL(string: data.content.image ??  "https://ecode.s3.ap-northeast-2.amazonaws.com/feed/1674532084081v3bgfbrzrzs.webp")!,
                            description: data.challenge.subTitle,
                            link: appLink)

      let template = FeedTemplate(content: content, buttons: [button])

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

  func sharePost(feedData: FeedShare?) -> Bool {
    let isSuccess = true

    guard let data = feedData else { return !isSuccess }

    let likeCount = Int(data.likeCount.filter { $0.isNumber }) ?? 0
    let commentCount = Int(data.commentCount.filter { $0.isNumber }) ?? 0

    if ShareApi.isKakaoTalkSharingAvailable(){

      let appLink = Link(iosExecutionParams: [ShareURL.feed: "\(data.id)"])

      let button = Button(title: "앱에서 보기", link: appLink)

      let content = Content(title: "\(data.nickname)님의 게시물",
                            imageUrl: URL(string: data.imageUrl)!,
                            description: data.content,
                            link: appLink)

      let social = Social(likeCount: likeCount, commentCount: commentCount)

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
