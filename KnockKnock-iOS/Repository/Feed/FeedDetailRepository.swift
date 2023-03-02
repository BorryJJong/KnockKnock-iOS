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
    completionHandler: @escaping (Bool) -> Void
  )

  func requestFeedDetail(
    feedId: Int,
    completionHandler: @escaping (FeedDetail) -> Void
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

final class FeedDetailRepository: FeedDetailRepositoryProtocol {

  typealias OnCompletionHandler = (Bool) -> Void

  // MARK: - Feed detail APIs

  /// 게시글 상세 조회
  func requestFeedDetail(
    feedId: Int,
    completionHandler: @escaping (FeedDetail) -> Void
  ) {

    KKNetworkManager
      .shared
      .request(
        object: ApiResponseDTO<FeedDetail>.self,
        router: .getFeed(id: feedId),
        success: { response in
          guard let data = response.data else {
            // no data error
            return
          }
          completionHandler(data)
        },
        failure: { response in
          print(response)
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
        object: ApiResponseDTO<Bool>.self,
        router: .deleteFeed(id: feedId),
        success: { response in

          let isSuccess = response.code == 200
          completionHandler(isSuccess)

        }, failure: { error in

          print(error)
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
        object: ApiResponseDTO<Bool>.self,
        router: .postHideBlogPost(id: feedId),
        success: { response in
          completionHandler(response.code == 200)
        },
        failure: { error in
          print(error)
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
        object: ApiResponseDTO<Bool>.self,
        router: .postReportBlogPost(
          id: feedId,
          reportType: reportType.rawValue
        ),
        success: { response in
          completionHandler(response.code == 200)
        },
        failure: { error in
          print(error)
        }
      )
  }
}
