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
    completionHandler: @escaping (FeedList) -> Void
  )
  func requestDeleteFeed(
    feedId: Int,
    completionHandler: @escaping (Bool) -> Void
  )
  func requestHidePost(
    feedId: Int,
    completionHandler: @escaping (Bool) -> Void
  )
  func requestReportPost(
    feedId: Int,
    reportType: ReportType,
    completionHandler: @escaping (Bool) -> Void
  )
}

final class FeedListRepository: FeedListRepositoryProtocol {

  typealias OnCompletionHandler = (Bool) -> Void

  // MARK: - Feed list APIs

  func requestFeedList(
    currentPage: Int,
    pageSize: Int,
    feedId: Int,
    challengeId: Int,
    completionHandler: @escaping (FeedList) -> Void
  ) {

      KKNetworkManager
        .shared
        .request(
          object: ApiResponse<FeedList>.self,
          router: .getFeedBlogPost(
            page: currentPage,
            take: pageSize,
            feedId: feedId,
            challengeId: challengeId
          ),
          success: { response in
            guard let data = response.data else {
              // no data error
              return
            }
            completionHandler(data)
          },
          failure: { response, error in
            print(error)
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

          let isSuccess = response.code == 200
          completionHandler(isSuccess)

        }, failure: { response, error in

          print(error)
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
          completionHandler(response.code == 200)
        },
        failure: { response, error in
          print(error)
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
          completionHandler(response.code == 200)
        },
        failure: { response, error in
          print(error)
        }
      )
  }
}
