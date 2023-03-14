//
//  FeedListRepository.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/02/22.
//

import Foundation

import Alamofire

protocol FeedListRepositoryProtocol {
  func requestFeedList(
    currentPage: Int,
    pageSize: Int,
    feedId: Int,
    challengeId: Int,
    completionHandler: @escaping (ApiResponse<FeedList>?) -> Void
  )
  func requestDeleteFeed(
    feedId: Int,
    completionHandler: @escaping (ApiResponse<Bool>?) -> Void
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
}

final class FeedListRepository: FeedListRepositoryProtocol {

  typealias OnCompletionHandler = (ApiResponse<Bool>?) -> Void

  // MARK: - Feed list APIs

  func requestFeedList(
    currentPage: Int,
    pageSize: Int,
    feedId: Int,
    challengeId: Int,
    completionHandler: @escaping (ApiResponse<FeedList>?) -> Void
  ) {

      KKNetworkManager
        .shared
        .request(
          object: ApiResponse<FeedListDTO>.self,
          router: .getFeedBlogPost(
            page: currentPage,
            take: pageSize,
            feedId: feedId,
            challengeId: challengeId
          ),
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
}
