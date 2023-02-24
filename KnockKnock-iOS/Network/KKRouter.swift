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

  // MARK: - APIs

  // Home
  case getHotPost(challengeId: Int)
  case getHomeEvent

  // Account
  case postSocialLogin(socialUuid: String, socialType: String)
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
  case postHideBlogPost(id: Int)
  case postReportBlogPost(id: Int, reportType: String)
  case deleteFeed(id: Int)

  // Feed Edit
  case putFeed(id: Int, post: FeedEdit)

  // Like
  case postFeedLike(id: Int)
  case deleteFeedLike(id: Int)
  case getLikeList(id: Int)

  // Comment
  case getComment(id: Int)
  case postAddComment(comment: Parameters)
  case deleteComment(id: Int)

  // MY
  case getUsersDetail
  case getDuplicateNickname(nickname: String)
  case putUsers(nickname: String?, image: Data?)
  case getMyPage

  // MARK: - HTTP Method

  var method: HTTPMethod {
    switch self {

      // Home
    case .getHotPost,
         .getHomeEvent:
      return .get

    // Account
    case .postSocialLogin,
        .postSignUp,
        .postLogOut:
      return .post

    case .deleteWithdraw:
      return .delete

    // Challenge
    case .getChallenges,
         .getChallengeDetail:
      return .get

      // FeedWrite, Main
    case .getChallengeTitles,
        .getPromotions,
        .requestShopAddress,
        .getFeedMain:
      return .get

    case .postFeed:
      return .post

      // FeedList, Detail
    case .getFeedBlogPost,
        .getFeed:
      return .get

    case .postHideBlogPost,
         .postReportBlogPost:
      return .post

    case .deleteFeed:
      return .delete

      // Feed Edit
    case .putFeed:
      return .put

      // Like
    case .getLikeList:
      return .get

    case .postFeedLike:
      return .post

    case .deleteFeedLike:
      return .delete

      // Comment
    case .getComment:
      return .get

    case .postAddComment:
      return .post

    case .deleteComment:
      return .delete

      // My
    case .getUsersDetail,
         .getMyPage,
         .getDuplicateNickname:
      return .get

    case .putUsers:
      return .put
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
    case .getHotPost: return "hot-post"
    case .getHomeEvent: return "home-event"

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
    case .postHideBlogPost(let id): return "users/hide/blog-post/\(id)"
    case .postReportBlogPost(let id, _): return "users/report/blog-post/\(id)"

      // Feed Edit
    case .putFeed(let id, _): return "feed/\(id)"

      // Like
    case .postFeedLike(let id): return "like/feed/\(id)"
    case .deleteFeedLike(let id): return "like/feed/\(id)"
    case .getLikeList(let id): return "like/feed/\(id)"

      // Comment
    case .getComment(let id): return "feed/\(id)/comment"
    case .postAddComment: return "feed/comment"
    case .deleteComment(let id): return "feed/comment/\(id)"

      // My
    case .getUsersDetail: return "users/detail"
    case .getDuplicateNickname(let nickname): return "users/duplicate-nickname/\(nickname)"
    case .getMyPage: return "my-page"
    case .putUsers: return "users"

    }
  }

  // MARK: - Parameters

  var parameters: Parameters? {
    switch self {

      // Home
    case let .getHotPost(challengeId):
      return [ "challengeId": challengeId ]

    case .getHomeEvent:
      return nil

      // Account
    case let .postSocialLogin(socialUuid, socialType):
      return [
        "socialUuid": socialUuid,
        "socialType": socialType
      ]

    case .postLogOut,
         .postSignUp,
         .deleteWithdraw:
      return nil

     // Challenge
    case let .getChallenges(sort):
      return [ "sort": sort ]

    case .getChallengeDetail:
      return nil

      // FeedWrite, Main
    case .getChallengeTitles,
         .getPromotions,
         .postFeed:
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

      // FeedList, Detail
    case let .getFeedBlogPost(page, take, feedId, challengeId):
      return [
        "page": page,
        "take": take,
        "feedId": feedId,
        "challengeId": challengeId
      ]

    case let .postReportBlogPost(_, reportType):
      return [ "reportType": reportType ]

    case .getFeed,
         .postHideBlogPost,
         .deleteFeed:
      return nil

      // Feed Edit
    case let .putFeed(_, post):
      var params: [String: String] = [
        "promotions": post.promotions,
        "challenges": post.challenges,
        "content": post.content
      ]

      if let storeAddress = post.storeAddress,
         let storeName = post.storeName,
         let locationX = post.locationX,
         let locationY = post.locationY {
        
        params["storeAddress"] = storeAddress
        params["storeName"] = storeName
        params["locationX"] = locationX
        params["locationY"] = locationY
      }

      return params

      // Like
    case .getLikeList,
         .postFeedLike,
         .deleteFeedLike:
      return nil

      // Comment
    case let .postAddComment(comment):
      return comment

    case .getComment,
         .deleteComment:
      return nil

      // My
    case .getUsersDetail,
         .getMyPage,
         .getDuplicateNickname,
         .putUsers:
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
      let images = feedWriteForm.images

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
        multipartFormData.append(
          $0 ?? Data(),
          withName: "images",
          fileName: "\($0).png",
          mimeType: "image/png"
        )
      }

      return multipartFormData

    case .postSignUp(let userInfo):

      let multipartFormData = MultipartFormData()

      let socialUuid = userInfo.socialUuid.data(using: .utf8) ?? Data()
      let socialType = userInfo.socialType.data(using: .utf8) ?? Data()
      let nickname = userInfo.nickname.data(using: .utf8) ?? Data()
      let image = userInfo.image ?? Data()

      multipartFormData.append(socialUuid, withName: "socialUuid")
      multipartFormData.append(socialType, withName: "socialType")
      multipartFormData.append(nickname, withName: "nickname")
      multipartFormData.append(image, withName: "image", fileName: "\(image).png", mimeType: "image/png")

      return multipartFormData

    case let .putUsers(nickname, image):

      let multipartFormData = MultipartFormData()

      if let nickname = nickname,
         let nicknameData = nickname.data(using: .utf8) {
        multipartFormData.append(nicknameData, withName: "nickname")
      }

      if let image = image {
        multipartFormData.append(
          image,
          withName: "image",
          fileName: "\(image).png",
          mimeType: "image/png"
        )
      }

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

      case .getChallengeDetail,
           .getFeed,
           .getPromotions,
           .getComment,
           .getLikeList,
           .getUsersDetail,
           .getDuplicateNickname:
        break

      case .requestShopAddress:
        request = try URLEncoding.default.encode(request, with: parameters)
        request.setValue(API.KAKAO_REST_API_KEY, forHTTPHeaderField: "Authorization")

      default:
        request = try URLEncoding.default.encode(request, with: parameters)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
      }

    case .post, .patch, .delete, .put:

      switch self {

      case .postFeedLike,
           .postHideBlogPost,
           .postLogOut,
           .deleteFeedLike,
           .deleteFeed,
           .deleteWithdraw,
           .deleteComment:

        request = try JSONEncoding.default.encode(request)
        request.setValue("application/json", forHTTPHeaderField: "Accept")

      case .postFeed,
           .postSignUp,
           .putUsers:
        request.setValue("application/json", forHTTPHeaderField: "Accept")
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
