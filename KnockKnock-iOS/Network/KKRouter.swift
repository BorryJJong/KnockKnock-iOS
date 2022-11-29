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

  case socialLogin(loginInfo: Parameters)
  case signUp(userInfo: Parameters)

  case getChallengeResponse
  case getChallengeDetail(id: Int)

  case getChallengeTitles
  case getPromotions
  case getFeedMain(page: Int, take: Int, challengeId: Int)
  case requestShopAddress(query: String)
  case getFeedBlogPost(page: Int, take: Int, feedId: Int, challengeId: Int)
  case getFeed(id: Int)
  case postFeedLike(id: Int)

  case getComment(id: Int)
  case postAddComment(comment: Parameters)

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
        .getComment:
      return .get

    case .postFeedLike,
         .socialLogin,
         .signUp,
         .postAddComment:
      return .post
    }
  }

  var path: String {
    switch self {

    case .socialLogin: return "users/social-login"
    case .signUp: return "users/sign-up"
    case .getChallengeResponse: return "challenges"
    case .getChallengeDetail(let id): return "challenges/\(id)"
    case .getFeedMain: return "feed/main"
    case .getChallengeTitles: return "challenges/titles"
    case .getPromotions: return "promotions"
    case .requestShopAddress: return "keyword.json"
    case .getFeedBlogPost: return "feed/blog-post"
    case .getFeed(let id): return "feed/\(id)"

    case .postFeedLike(let id): return "like/feed/\(id)"

    case .getComment(let id): return "feed/\(id)/comment"
    case .postAddComment: return "feed/comment"

    }
  }

  var parameters: Parameters? {
    switch self {

    case let .socialLogin(loginInfo):
      return loginInfo

    case let .signUp(userInfo):
      return userInfo

    case  .getChallengeDetail,
        .getChallengeResponse,
        .getChallengeTitles,
        .getFeed,
        .getPromotions,
        .postFeedLike,
        .getComment:

      return nil

    case let .requestShopAddress(query):
      return [ "query": query ]

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
    }
  }

  func asURLRequest() throws -> URLRequest {
    let url = baseURL.appendingPathComponent(path)
    var request = URLRequest(url: url)
    request.method = method

    switch method {
    case .get:
      switch self {

      case .getChallengeDetail, .getFeed, .getPromotions, .getComment:
        break

      case .requestShopAddress:
        request = try URLEncoding.default.encode(request, with: parameters)
        request.setValue(API.KAKAO_REST_API_KEY, forHTTPHeaderField: "Authorization")

      default:
        request = try URLEncoding.default.encode(request, with: parameters)
      }

    case .post, .patch, .delete:
      switch self {
      case .postFeedLike:
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
