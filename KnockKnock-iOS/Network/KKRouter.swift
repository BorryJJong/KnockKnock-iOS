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

  case getChallengeResponse
  case getChallengeDetail(id: Int)
  case getChallengeTitles
  case getPromotions
  case getFeedMain(page: Int, take: Int, challengeId: Int)
  case requestShopAddress(query: String)
  case getFeedBlogPost(page: Int, take: Int, feedId: Int, challengeId: Int)
  case getFeed(id: Int)

  var method: HTTPMethod {
    switch self {
    case .getChallengeResponse,
        .getFeedBlogPost,
        .getFeedMain,
        .getFeed,
        .getChallengeTitles,
        .getPromotions,
        .getChallengeDetail,
        .requestShopAddress:
      return .get
    }
  }

  var path: String {
    switch self {
    case .getChallengeResponse: return "challenges"
    case .getChallengeDetail(let id): return "challenges/\(id)"
    case .getFeedMain: return "feed/main"
    case .getChallengeTitles: return "challenges/titles"
    case .getPromotions: return "promotions"
    case .requestShopAddress: return "keyword.json"
    case .getFeedBlogPost: return "feed/blog-post"
    case .getFeed(let id): return "feed/\(id)"
    }
  }

  var parameters: Parameters? {
    switch self {
    case  .getChallengeDetail,
        .getChallengeResponse,
        .getChallengeTitles,
        .getFeed,
        .getPromotions:
      return nil

    case let .requestShopAddress(query):
      return ["query": query]

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
    }
  }

  func asURLRequest() throws -> URLRequest {
    let url = baseURL.appendingPathComponent(path)
    var request = URLRequest(url: url)
    request.method = method

    switch method {
    case .get:
      switch self {
      case .getChallengeDetail, .getFeed, .getPromotions:
        break

      case .requestShopAddress:
        request = try URLEncoding.default.encode(request, with: parameters)
        request.setValue(API.KAKAO_REST_API_KEY, forHTTPHeaderField: "Authorization")
        
      default:
        request = try URLEncoding.default.encode(request, with: parameters)
      }
    case .post, .patch, .delete:
      request = try JSONEncoding.default.encode(request, with: parameters)
      request.setValue("application/json", forHTTPHeaderField: "Accept")
    default:
      break
    }
    return request
  }
}
