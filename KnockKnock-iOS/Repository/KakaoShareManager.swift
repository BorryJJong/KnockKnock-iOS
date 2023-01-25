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
  func sharePost(feedData: FeedShare?) -> (Bool, ErrorType?)
  func shareChallenge(challengeData: ChallengeDetail?) -> (Bool, ErrorType?)
}

final class KakaoShareManager: KakaoShareManagerProtocol {

  /// 챌린지 공유하기 이벤트
  ///
  /// - Returns: (Bool: 공유하기 성공 여부, ErrorType?: 에러 타입)
  func shareChallenge(challengeData: ChallengeDetail?) -> (Bool, ErrorType?) {

    let isSuccess = true

    guard let data = challengeData else { return (!isSuccess, ErrorType.unowned) }

    if ShareApi.isKakaoTalkSharingAvailable(){

      let appLink = Link(iosExecutionParams: [ShareURL.challenge: "\(data.challenge.id)"])

      let button = Button(title: "앱에서 보기", link: appLink)

      if let imageUrl = URL(string: data.content.image ??  "https://ecode.s3.ap-northeast-2.amazonaws.com/feed/1674532084081v3bgfbrzrzs.webp") {

        let content = Content(title: "\(data.challenge.title)",
                              imageUrl: imageUrl,
                              description: data.challenge.subTitle,
                              link: appLink)

        let template = FeedTemplate(content: content, buttons: [button])

        guard let templateJsonData = (try? SdkJSONEncoder.custom.encode(template)),
              let templateJsonObject = SdkUtils.toJsonObject(templateJsonData) else {
          return (!isSuccess, ErrorType.unowned)
        }

        ShareApi.shared.shareDefault(templateObject: templateJsonObject) { (linkResult, error) in
          guard error == nil else { return }
          guard let linkResult = linkResult else { return }

          UIApplication.shared.open(linkResult.url, options: [:], completionHandler: nil)
        }

      } else {

        let template = TextTemplate(
          text: "\(data.challenge.title)",
          link: appLink
        )

        guard let templateJsonData = (try? SdkJSONEncoder.custom.encode(template)),
              let templateJsonObject = SdkUtils.toJsonObject(templateJsonData) else {
          return (!isSuccess, ErrorType.unowned)
        }

        ShareApi.shared.shareDefault(templateObject: templateJsonObject) { (linkResult, error) in
          guard error == nil else { return }
          guard let linkResult = linkResult else { return }

          UIApplication.shared.open(linkResult.url, options: [:], completionHandler: nil)
        }
      }

      return (isSuccess, nil)

    } else {
      return (!isSuccess, ErrorType.no_kakaotalk_installation)
    }
  }

  /// 게시글 공유하기 이벤트
  ///
  /// - Returns: (Bool: 공유하기 성공 여부, ErrorType?: 에러 타입)
  func sharePost(feedData: FeedShare?) -> (Bool, ErrorType?) {
    let isSuccess = true

    guard let data = feedData else { return (!isSuccess, ErrorType.unowned) }

    let likeCount = Int(data.likeCount.filter { $0.isNumber }) ?? 0
    let commentCount = Int(data.commentCount.filter { $0.isNumber }) ?? 0

    if ShareApi.isKakaoTalkSharingAvailable(){

      let appLink = Link(iosExecutionParams: [ShareURL.feed: "\(data.id)"])

      let button = Button(title: "앱에서 보기", link: appLink)

      if let imageUrl = URL(string: data.imageUrl) {
        let content = Content(title: "\(data.nickname)님의 게시물",
                              imageUrl: imageUrl,
                              description: data.content,
                              link: appLink)

        let social = Social(likeCount: likeCount, commentCount: commentCount)

        let template = FeedTemplate(content: content, social: social, buttons: [button])

        guard let templateJsonData = (try? SdkJSONEncoder.custom.encode(template)),
              let templateJsonObject = SdkUtils.toJsonObject(templateJsonData) else {
          return (!isSuccess, ErrorType.unowned)
        }

        ShareApi.shared.shareDefault(templateObject: templateJsonObject) { (linkResult, error) in
          guard error == nil else { return }
          guard let linkResult = linkResult else { return }

          UIApplication.shared.open(linkResult.url, options: [:], completionHandler: nil)
        }

      } else {
        let template = TextTemplate(
          text: "\(data.nickname)님의 게시물",
          link: appLink
        )

        guard let templateJsonData = (try? SdkJSONEncoder.custom.encode(template)),
              let templateJsonObject = SdkUtils.toJsonObject(templateJsonData) else {
          return (!isSuccess, ErrorType.unowned)
        }

        ShareApi.shared.shareDefault(templateObject: templateJsonObject) { (linkResult, error) in
          guard error == nil else { return }
          guard let linkResult = linkResult else { return }

          UIApplication.shared.open(linkResult.url, options: [:], completionHandler: nil)
        }
      }

      return (isSuccess, nil)
      
    } else {
      return (!isSuccess, ErrorType.no_kakaotalk_installation)
    }
  }
}
