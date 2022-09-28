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

  case createFeed(Int)
  case updateFeed(Int)
  case getChallengeResponse
  case getChallengeTitles
  case getFeedMain(page: Int, take: Int, challengeId: Int)
  case requestShopAddress(query: String)

  var method: HTTPMethod {
    switch self {
    case .getChallengeResponse, .getFeedMain, .getChallengeTitles, .requestShopAddress: return .get
    case .createFeed: return .post
    case .updateFeed: return .patch
    }
  }

  var path: String {
    switch self {
    case .getChallengeResponse: return "challenges"
    case .createFeed, .updateFeed: return "feed"
    case .getFeedMain: return "feed/main"
    case .getChallengeTitles: return "challenges/titles"
    case .requestShopAddress: return "keyword.json"
    }
  }

  var parameters: Parameters? {
    switch self {
    case .getChallengeResponse, .getChallengeTitles:
      return nil
    case let .requestShopAddress(query):
      return ["query": query]
      
    case let .createFeed(id), let .updateFeed(id):
      return ["id": id]

    case let .getFeedMain(page, take, challengeId):
      return [
        "page": page,
        "take": take,
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
