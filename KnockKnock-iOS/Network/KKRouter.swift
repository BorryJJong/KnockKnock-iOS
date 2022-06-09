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
    return URL(string: "http://13.209.245.135:3000/")!
  }

  case createFeed(id: Int)
  case updateFeed(id: Int)
  case getChallengeResponse

  var method: HTTPMethod {
    switch self {
    case .getChallengeResponse: return .get
    case .createFeed: return .post
    case .updateFeed: return .post
    }
  }

  var path: String {
    switch self {
    case .getChallengeResponse: return "challenges"
    case .createFeed: return "feed"
    case .updateFeed: return "feed"
    }
  }

  var parameters: Parameters? {
    switch self {
    case .getChallengeResponse:
      return nil
    case .createFeed(let id), .updateFeed(let id):
      return [ "id": id ]
    }
  }

  func asURLRequest() throws -> URLRequest {
    let url = baseURL.appendingPathComponent(path)
    var request = URLRequest(url: url)
    request.method = method

    return request
  }
}
