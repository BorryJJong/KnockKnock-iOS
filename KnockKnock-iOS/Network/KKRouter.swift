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
      return URL(string: API.NAVER_GEOCODE_URL)!
    default:
      return URL(string: API.BASE_URL)!
    }
  }
  var naverID: String {
    return API.NAVER_CLIENT_ID
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
    case .requestShopAddress: return ""
    }
  }

  var parameters: Parameters? {
    switch self {
    case .getChallengeResponse, .getChallengeTitles, .requestShopAddress:
      return nil
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
        request.setValue(API.NAVER_CLIENT_ID, forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
        request.setValue(API.NAVER_CLIENT_SECRET, forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
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
