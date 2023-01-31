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
  func sharePost(feedData: FeedShare) -> (Bool, KakaoShareErrorType?)
  func shareChallenge(challengeData: ChallengeDetail) -> (Bool, KakaoShareErrorType?)
  func openKakaoShare<T: Encodable>(template: T?) -> (Bool, KakaoShareErrorType?)

  func generateTextTemplate(
    text: String,
    appLink: Link,
    shareQueryItemType: ShareQueryItemType
  ) -> TextTemplate
}

final class KakaoShareManager: KakaoShareManagerProtocol {

  /// 챌린지 공유하기 이벤트
  ///
  /// - Returns: (Bool: 공유하기 성공 여부, ErrorType?: 에러 타입)
  func shareChallenge(challengeData: ChallengeDetail) -> (Bool, KakaoShareErrorType?) {

    let appLink = Link(
      iosExecutionParams: [ShareQueryItemType.challenge.rawValue: "\(challengeData.challenge.id)"]
    )

    let button = Button(title: "앱에서 보기", link: appLink)

    if let image = challengeData.content.image,
       let imageUrl = URL(string: image) {

      let content = Content(
        title: "\(challengeData.challenge.title)",
        imageUrl: imageUrl,
        description: challengeData.challenge.subTitle,
        link: appLink
      )

      let feedTemplate = FeedTemplate(
        content: content,
        buttons: [button]
      )

      return self.openKakaoShare(template: feedTemplate)

    } else {

      let textTemplate = generateTextTemplate(
        text: challengeData.challenge.title,
        appLink: appLink,
        shareQueryItemType: .challenge
      )

      return self.openKakaoShare(template: textTemplate)
    }
  }

  /// 게시글 공유하기 이벤트
  ///
  /// - Returns: (Bool: 공유하기 성공 여부, ErrorType?: 에러 타입)
  func sharePost(feedData: FeedShare) -> (Bool, KakaoShareErrorType?) {

    var socialData: Social?

    if let like = feedData.likeCount,
       let comment = feedData.commentCount,
       let likeCount = Int(like.filter { $0.isNumber }),
       let commentCount = Int(comment.filter { $0.isNumber }) {

      socialData = Social(likeCount: likeCount, commentCount: commentCount)
    }

    let appLink = Link(iosExecutionParams: [ShareQueryItemType.feed.rawValue: "\(feedData.id)"])
    let button = Button(title: "앱에서 보기", link: appLink)

    // image 변환 실패시 textTemplate 사용
    if let imageUrl = URL(string: feedData.imageUrl) {

      let content = Content(title: "\(feedData.nickname)님의 게시글",
                            imageUrl: imageUrl,
                            description: feedData.content,
                            link: appLink)

      let feedTemplate = FeedTemplate(
        content: content,
        social: socialData,
        buttons: [button]
      )

      return self.openKakaoShare(template: feedTemplate)

    } else {

      let textTemplate = self.generateTextTemplate(
        text: feedData.nickname,
        appLink: appLink,
        shareQueryItemType: .feed
      )

      return self.openKakaoShare(template: textTemplate)

    }
  }

  /// FeedTemplate 생성에 오류 발생 시 textTemplate을 생성하여 리턴
  func generateTextTemplate(
    text: String,
    appLink: Link,
    shareQueryItemType: ShareQueryItemType
  ) -> TextTemplate {

    switch shareQueryItemType {

    case .feed:
      return TextTemplate(
        text: "\(text)님의 게시글",
        link: appLink
      )

    case .challenge:
      return TextTemplate(
        text: text,
        link: appLink
      )
    }
  }

  /// 생성된 템플릿을 받아 카카오 링크 api 실행
  ///
  /// - Returns: (Bool: 공유하기 성공 여부, ErrorType?: 에러 타입)
  func openKakaoShare<T: Encodable>(template: T?) -> (Bool, KakaoShareErrorType?) {

    if ShareApi.isKakaoTalkSharingAvailable(){

      guard let templateJsonData = (try? SdkJSONEncoder.custom.encode(template)),
            let templateJsonObject = SdkUtils.toJsonObject(templateJsonData) else {
        return (false, KakaoShareErrorType.unowned)
      }

      ShareApi.shared.shareDefault(templateObject: templateJsonObject) { (linkResult, error) in
        guard error == nil else { return }
        guard let linkResult = linkResult else { return }

        UIApplication.shared.open(linkResult.url, options: [:], completionHandler: nil)
      }

      return (true, nil)

    } else {

      return (false, KakaoShareErrorType.no_kakaotalk_installation)
    }
  }

}
