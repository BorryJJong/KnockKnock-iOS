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
  
  case socialLogin(loginInfo: Parameters)
  case signUp(userInfo: Parameters)
  
  case getChallengeResponse
  case getChallengeDetail(id: Int)
  
  case getChallengeTitles
  case getPromotions
  case getFeedMain(page: Int, take: Int, challengeId: Int)
  case requestShopAddress(query: String, page: Int, size: Int)
  case getFeedBlogPost(page: Int, take: Int, feedId: Int, challengeId: Int)
  case getFeed(id: Int)
  
  case getComment(id: Int)
  case postAddComment(comment: Parameters)
  case postFeed(postData: FeedWrite)
  
  case getLikeList(id: Int)
  
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
      
    case .socialLogin,
        .signUp,
        .postFeed,
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
    case .getComment(let id): return "feed/\(id)/comment"
    case .postAddComment: return "feed/comment"
    case .getLikeList(let id): return "like/feed/\(id)"
    case .postFeed: return "feed"
    }
  }
  
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
        .postFeed,
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
    }
  }
  
  var multipart: MultipartFormData {
    
    switch self {
    case .postFeed(let feedWriteForm):
      
      let multipartFormData = MultipartFormData()

      let userId = "\(feedWriteForm.userId)".data(using: .utf8) ?? Data()
      let content = feedWriteForm.content.data(using: .utf8) ?? Data()
      let storeAddress = feedWriteForm.storeAddress.data(using: .utf8) ?? Data()
      let locationX = feedWriteForm.locationX.data(using: .utf8) ?? Data()
      let locationY = feedWriteForm.locationY.data(using: .utf8) ?? Data()
      let scale = feedWriteForm.scale.data(using: .utf8) ?? Data()
      let promotions = feedWriteForm.promotions.data(using: .utf8) ?? Data()
      let challenges = feedWriteForm.challenges.data(using: .utf8) ?? Data()
      let images = feedWriteForm.images.map { $0.pngData() ?? Data() }
      
      multipartFormData.append(userId, withName: "userId")
      multipartFormData.append(content, withName: "content")
      multipartFormData.append(storeAddress, withName: "storeAddress")
      multipartFormData.append(locationX, withName: "locationX")
      multipartFormData.append(locationY, withName: "locationY")
      multipartFormData.append(scale, withName: "scale")
      multipartFormData.append(promotions, withName: "promotions")
      multipartFormData.append(challenges, withName: "challenges")
      
      images.forEach {
        multipartFormData.append($0, withName: "images", fileName: "\($0).png", mimeType: "image/png")
      }
      
      return multipartFormData
      
    default:
      return MultipartFormData()
    }
  }
  
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

      case .postFeed:
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
