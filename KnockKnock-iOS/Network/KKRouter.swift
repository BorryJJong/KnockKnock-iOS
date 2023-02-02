//
//  Router.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/08.
//

import Foundation

import Alamofire
import UIKit

enum KKRouter: URLRequestConvertible {

  typealias Parameters = [String: Any]

  var baseURL: URL {
    switch self {
    case .requestShopAddress:
      return URL(string: API.KAKAO_LOCAL_URL)!
    default:
      return URL(string: API.BASE_URL)!
    }
  }

  // MARK: - APIs

  // Home
  case getHotPost(challengeId: Int)

  // Account
  case postSocialLogin(signInInfo: Parameters)
  case postSignUp(userInfo: RegisterInfo)
  case deleteWithdraw
  case postLogOut

  // Challenge
  case getChallenges(sort: String)
  case getChallengeDetail(id: Int)

  // Feed Write, Main
  case getChallengeTitles
  case getPromotions
  case requestShopAddress(query: String, page: Int, size: Int)
  case getFeedMain(page: Int, take: Int, challengeId: Int)
  case postFeed(postData: FeedWrite)

  // Feed List, Detail
  case getFeedBlogPost(page: Int, take: Int, feedId: Int, challengeId: Int)
  case getFeed(id: Int)
  case deleteFeed(id: Int)

  // Like
  case postFeedLike(id: Int)
  case deleteFeedLike(id: Int)
  case getLikeList(id: Int)

  // Comment
  case getComment(id: Int)
  case postAddComment(comment: Parameters)
  case deleteComment(id: Int)

  // MARK: - HTTP Method

  var method: HTTPMethod {
    switch self {
    case .getChallenges,
         .getFeedBlogPost,
         .getFeedMain,
         .getFeed,
         .getChallengeTitles,
         .getPromotions,
         .getChallengeDetail,
         .requestShopAddress,
         .getLikeList,
         .getHotPost,
         .getComment:
      return .get

    case .postSocialLogin,
         .postSignUp,
         .postLogOut,
         .postAddComment,
         .postFeed,
         .postFeedLike:
      return .post

    case .deleteFeed,
         .deleteWithdraw,
         .deleteFeedLike,
         .deleteComment:
      return .delete
    }
  }

  // MARK: - Path

  var path: String {
    switch self {

    // Account
    case .postSocialLogin: return "users/social-login"
    case .postSignUp: return "users/sign-up"
    case .postLogOut: return "users/logout"
    case .deleteWithdraw: return "users"

    // Home
    case .getHotPost: return "home/hot-post"

    // Challenge
    case .getChallenges: return "challenges"
    case .getChallengeDetail(let id): return "challenges/\(id)"

    // Feed Write, Main
    case .getFeedMain: return "feed/main"
    case .getChallengeTitles: return "challenges/titles"
    case .getPromotions: return "promotions"
    case .requestShopAddress: return "keyword.json"
    case .postFeed: return "feed"

    // Feed List, Detail
    case .getFeedBlogPost: return "feed/blog-post"
    case .getFeed(let id): return "feed/\(id)"
    case .deleteFeed(let id): return "feed/\(id)"

    // Like
    case .postFeedLike(let id): return "like/feed/\(id)"
    case .deleteFeedLike(let id): return "like/feed/\(id)"
    case .getLikeList(let id): return "like/feed/\(id)"

    // Comment
    case .getComment(let id): return "feed/\(id)/comment"
    case .postAddComment: return "feed/comment"
    case .deleteComment(let id): return "feed/comment/\(id)"

    }
  }

  // MARK: - Parameters

  var parameters: Parameters? {
    switch self {

    case let .getHotPost(challengeId):
      return [ "challengeId": challengeId ]

    case let .postSocialLogin(signInInfo):
      return signInInfo

    case let .getChallenges(sort):
      return [ "sort": sort ]

    case let .requestShopAddress(query, page, size):
      return [
        "query": query,
        "page": page,
        "size": size
      ]

    case let .getFeedMain(page, take, challengeId):
      return [
        "page": page,
        "take": take,
        "challengeId": challengeId
      ]

    case let .getFeedBlogPost(page, take, feedId, challengeId):
      return [
        "page": page,
        "take": take,
        "feedId": feedId,
        "challengeId": challengeId
      ]

    case let .postAddComment(comment):
      return comment

    case .getChallengeDetail,
         .getChallengeTitles,
         .getFeed,
         .getPromotions,
         .getLikeList,
         .getComment,
         .postFeedLike,
         .postFeed,
         .postLogOut,
         .postSignUp,
         .deleteFeedLike,
         .deleteComment,
         .deleteFeed,
         .deleteWithdraw:
      return nil
    }
  }

  var multipart: MultipartFormData {

    switch self {
    case .postFeed(let feedWriteForm):

      let multipartFormData = MultipartFormData()

      let content = feedWriteForm.content.data(using: .utf8) ?? Data()
      let storeAddress = feedWriteForm.storeAddress?.data(using: .utf8)
      let storeName = feedWriteForm.storeName?.data(using: .utf8)
      let locationX = feedWriteForm.locationX.data(using: .utf8) ?? Data()
      let locationY = feedWriteForm.locationY.data(using: .utf8) ?? Data()
      let scale = feedWriteForm.scale.data(using: .utf8) ?? Data()
      let promotions = feedWriteForm.promotions.data(using: .utf8) ?? Data()
      let challenges = feedWriteForm.challenges.data(using: .utf8) ?? Data()
      let images = feedWriteForm.images.map { $0.pngData() ?? Data() }

      multipartFormData.append(content, withName: "content")
      if let storeName = storeName,
         let storeAddress = storeAddress {
        multipartFormData.append(storeAddress, withName: "storeAddress")
        multipartFormData.append(storeName, withName: "storeName")
      }
      multipartFormData.append(locationX, withName: "locationX")
      multipartFormData.append(locationY, withName: "locationY")
      multipartFormData.append(scale, withName: "scale")
      multipartFormData.append(promotions, withName: "promotions")
      multipartFormData.append(challenges, withName: "challenges")

      images.forEach {
        multipartFormData.append($0, withName: "images", fileName: "\($0).png", mimeType: "image/png")
      }

      return multipartFormData

    case .postSignUp(let userInfo):
      let multipartFormData = MultipartFormData()

      let socialUuid = userInfo.socialUuid.data(using: .utf8) ?? Data()
      let socialType = userInfo.socialType.data(using: .utf8) ?? Data()
      let nickname = userInfo.nickname.data(using: .utf8) ?? Data()
      let image = userInfo.image.pngData() ?? Data()

      multipartFormData.append(socialUuid, withName: "socialUuid")
      multipartFormData.append(socialType, withName: "socialType")
      multipartFormData.append(nickname, withName: "nickname")
      multipartFormData.append(image, withName: "image", fileName: "\(image).png", mimeType: "image/png")

      return multipartFormData

    default:
      return MultipartFormData()
    }
  }

  // MARK: - URL Request

  func asURLRequest() throws -> URLRequest {
    let url = baseURL.appendingPathComponent(path)
    var request = URLRequest(url: url)
    request.method = method

    switch method {
    case .get:

      switch self {

      case .getChallengeDetail, .getFeed, .getPromotions, .getComment, .getLikeList:
        break

      case .requestShopAddress:
        request = try URLEncoding.default.encode(request, with: parameters)
        request.setValue(API.KAKAO_REST_API_KEY, forHTTPHeaderField: "Authorization")

      default:
        request = try URLEncoding.default.encode(request, with: parameters)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
      }

    case .post, .patch, .delete:

      switch self {

      case .deleteWithdraw, .postLogOut:
        request = try JSONEncoding.default.encode(request)
        
      case .postFeedLike, .deleteFeedLike, .deleteFeed, .deleteComment:
        request = try JSONEncoding.default.encode(request)
        request.setValue("application/json", forHTTPHeaderField: "Accept")

      case .postFeed, .postSignUp:
        request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")

      default:
        request = try JSONEncoding.default.encode(request)
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      }

    default:
      break
    }
    return request
  }
}
