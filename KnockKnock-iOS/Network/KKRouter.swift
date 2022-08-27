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
    return URL(string: API.BASE_URL)!
  }

  case createFeed(Int)
  case updateFeed(Int)
  case getChallengeResponse
  case getChallengeTitles
  case getFeedMain(page: Int, take: Int, challengeId: Int)

  var method: HTTPMethod {
    switch self {
    case .getChallengeResponse, .getFeedMain, .getChallengeTitles: return .get
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
    }
  }

  var parameters: Parameters? {
    switch self {
    case .getChallengeResponse, .getChallengeTitles:
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
      request = try URLEncoding.default.encode(request, with: parameters)
    case .post, .patch, .delete:
      request = try JSONEncoding.default.encode(request, with: parameters)
      request.setValue("application/json", forHTTPHeaderField: "Accept")
    default:
      break
    }
    return request
  }
}
