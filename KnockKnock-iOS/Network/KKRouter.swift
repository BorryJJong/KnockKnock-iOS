//
//  Router.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/08.
//

import Foundation

import Alamofire

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

  // MARK - APIs

  // Account
  case socialLogin(loginInfo: Parameters)
  case signUp(userInfo: Parameters)

  // Challenge
  case getChallengeResponse
  case getChallengeDetail(id: Int)

  // Feed Write, Main
  case getChallengeTitles
  case getPromotions
  case requestShopAddress(query: String, page: Int, size: Int)
  case getFeedMain(page: Int, take: Int, challengeId: Int)

  // Feed List, Detail
  case getFeedBlogPost(page: Int, take: Int, feedId: Int, challengeId: Int)
  case getFeed(id: Int)

  // Like
  case postFeedLike(id: Int)
  case postFeedLikeCancel(id: Int)
  case getLikeList(id: Int)

  // Comment
  case getComment(id: Int)
  case postAddComment(comment: Parameters)

  // MARK: - HTTP Method

  var method: HTTPMethod {
    switch self {
    case .getChallengeResponse,
        .getFeedBlogPost,
        .getFeedMain,
        .getFeed,
        .getChallengeTitles,
        .getPromotions,
        .getChallengeDetail,
        .requestShopAddress,
        .getLikeList,
        .getComment:
      return .get

    case .postFeedLike,
         .postFeedLikeCancel,
         .socialLogin,
         .signUp,
         .postAddComment:
      return .post
    }
  }

  // MARK: - Path

  var path: String {
    switch self {

    // Account
    case .socialLogin: return "users/social-login"
    case .signUp: return "users/sign-up"

    // Challenge
    case .getChallengeResponse: return "challenges"
    case .getChallengeDetail(let id): return "challenges/\(id)"

    // Feed Write, Main
    case .getFeedMain: return "feed/main"
    case .getChallengeTitles: return "challenges/titles"
    case .getPromotions: return "promotions"
    case .requestShopAddress: return "keyword.json"

    // Feed List, Detail
    case .getFeedBlogPost: return "feed/blog-post"
    case .getFeed(let id): return "feed/\(id)"

    // Like
    case .postFeedLike(let id): return "like/feed/\(id)"
    case .postFeedLikeCancel(let id): return "like/feed\(id)"
    case .getLikeList(let id): return "like/feed/\(id)"

    // Comment
    case .getComment(let id): return "feed/\(id)/comment"
    case .postAddComment: return "feed/comment"
    }
  }

  // MARK: - Parameters

  var parameters: Parameters? {
    switch self {

    case let .socialLogin(loginInfo):
      return loginInfo

    case let .signUp(userInfo):
      return userInfo

    case .getChallengeDetail,
        .getChallengeResponse,
        .getChallengeTitles,
        .getFeed,
        .getPromotions,
        .getLikeList,
        .getComment:

      return nil

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

    case  .getChallengeDetail,
        .getChallengeResponse,
        .getChallengeTitles,
        .getFeed,
        .getPromotions,
        .postFeedLike,
        .postFeedLikeCancel,
        .getComment:

      return nil
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
      }

    case .post, .patch, .delete:
      switch self {
      case .postFeedLike, .postFeedLikeCancel:
        request = try JSONEncoding.default.encode(request)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
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
