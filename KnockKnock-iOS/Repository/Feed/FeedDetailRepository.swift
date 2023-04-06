//
//  FeedDetailRepository.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/02/22.
//

import Foundation

import Alamofire

protocol FeedDetailRepositoryProtocol {

  func requestDeleteFeed(
    feedId: Int,
    completionHandler: @escaping (ApiResponse<Bool>?) -> Void
  )

  func requestFeedDetail(
    feedId: Int,
    completionHandler: @escaping (ApiResponse<FeedDetail>?) -> Void
  )

  func requestHidePost(
    feedId: Int,
    completionHandler: @escaping (ApiResponse<Bool>?) -> Void
  )

  func requestReportPost(
    feedId: Int,
    reportType: ReportType,
    completionHandler: @escaping (ApiResponse<Bool>?) -> Void
  )
  
  func requestBlockUser(userId: Int) async -> ApiResponse<Bool>?
}

final class FeedDetailRepository: FeedDetailRepositoryProtocol {

  typealias OnCompletionHandler = (ApiResponse<Bool>?) -> Void

  // MARK: - Feed detail APIs

  /// 게시글 상세 조회
  func requestFeedDetail(
    feedId: Int,
    completionHandler: @escaping (ApiResponse<FeedDetail>?) -> Void
  ) {

    KKNetworkManager
      .shared
      .request(
        object: ApiResponse<FeedDetailDTO>.self,
        router: .getFeed(id: feedId),
        success: { response in

          let result = ApiResponse(
            code: response.code,
            message: response.message,
            data: response.data?.toDomain()
          )
          completionHandler(result)

        }, failure: { response, error in

          guard let response = response else {
            completionHandler(nil)
            return
          }

          let result = ApiResponse(
            code: response.code,
            message: response.message,
            data: response.data?.toDomain()
          )
          completionHandler(result)
          print(error.localizedDescription)
        }
      )
  }

  /// 게시글 삭제
  func requestDeleteFeed(
    feedId: Int,
    completionHandler: @escaping OnCompletionHandler
  ) {

    KKNetworkManager
      .shared
      .request(
        object: ApiResponse<Bool>.self,
        router: .deleteFeed(id: feedId),
        success: { response in

          let result = ApiResponse(
            code: response.code,
            message: response.message,
            data: response.code == 200
          )
          completionHandler(result)

        }, failure: { response, error in

          guard let response = response else {
            completionHandler(nil)
            return
          }

          let result = ApiResponse(
            code: response.code,
            message: response.message,
            data: response.code == 200
          )
          completionHandler(result)
          print(error.localizedDescription)
        }
      )
  }

  /// 게시글 숨기기
  func requestHidePost(
    feedId: Int,
    completionHandler: @escaping OnCompletionHandler
  ) {
    KKNetworkManager
      .shared
      .request(
        object: ApiResponse<Bool>.self,
        router: .postHideBlogPost(id: feedId),
        success: { response in

          let result = ApiResponse(
            code: response.code,
            message: response.message,
            data: response.code == 200
          )
          completionHandler(result)

        }, failure: { response, error in

          guard let response = response else {
            completionHandler(nil)
            return
          }

          let result = ApiResponse(
            code: response.code,
            message: response.message,
            data: response.code == 200
          )
          completionHandler(result)
          print(error.localizedDescription)
        }
      )
  }

  /// 게시글 신고
  func requestReportPost(
    feedId: Int,
    reportType: ReportType,
    completionHandler: @escaping OnCompletionHandler
  ) {

    KKNetworkManager
      .shared
      .request(
        object: ApiResponse<Bool>.self,
        router: .postReportBlogPost(
          id: feedId,
          reportType: reportType.rawValue
        ),
        success: { response in

          let result = ApiResponse(
            code: response.code,
            message: response.message,
            data: response.code == 200
          )
          completionHandler(result)

        }, failure: { response, error in

          guard let response = response else {
            completionHandler(nil)
            return
          }

          let result = ApiResponse(
            code: response.code,
            message: response.message,
            data: response.code == 200
          )
          completionHandler(result)
          print(error.localizedDescription)
        }
      )
  }

  func requestBlockUser(userId: Int) async -> ApiResponse<Bool>? {

    do {
      let result = try await KKNetworkManager
        .shared
        .asyncRequest(
          object: ApiResponse<Bool>.self,
          router: .postBlockUser(id: userId)
        )

      guard let data = result.value else { return nil }

      return ApiResponse(
        code: data.code,
        message: data.message,
        data: data.code == 200
      )
    } catch {

      print(error.localizedDescription)
      return nil
    }

  }
}
