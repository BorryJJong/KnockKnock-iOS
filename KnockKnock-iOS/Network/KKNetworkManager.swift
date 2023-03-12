//
//  NetworkManager.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/07.
//

import Foundation

import Alamofire

final class KKNetworkManager {
  typealias Success<T> = ((T) -> Void)
  typealias Failure<T> = ((T?, _ error: Error) -> Void)

  static let shared = KKNetworkManager()

  var session: Session

  let interceptor = KKRequestInterceptor(userDefaultsService: UserDefaultsService())
  let apiLogger = APIEventLogger()

  /// SessionTaskError 메세지
  var sessionTaskErrorMessage = "서버와의 연결이 불안정합니다."

  private init() {
    session = Session(
      interceptor: interceptor,
      eventMonitors: [apiLogger]
    )
  }

  func request<T>(
    object: T.Type,
    router: KKRouter,
    success: @escaping Success<T>,
    failure: @escaping Failure<T>
  ) where T: Decodable {

    session.request(router)
      .validate(statusCode: 200..<300)
      .responseDecodable(of: object) { response in

        switch response.result {

        case .success:
          guard let decodedData = response.value else { return }
          success(decodedData)

        case .failure(let err):
          failure(response.value, err)
        }
      }
  }

  func asyncRequest<T: Decodable>(
    object: T.Type,
    router: KKRouter
  ) async throws -> T {

   let response = session
    .request(router)
    .validate(statusCode: 200..<500)
    .serializingDecodable(object)

    switch await response.result {
    case .success(let value):
      return value
    case .failure(let err):
      throw err
    }
  }

  func upload<T>(
    object: T.Type,
    router: KKRouter,
    success: @escaping Success<T>,
    failure: @escaping Failure<T>
  ) where T: Decodable {

    session.upload(
      multipartFormData: router.multipart,
      with: router
    ).validate(statusCode: 200..<300)
     .responseDecodable(of: object) { response in

        switch response.result {

        case .success:
          guard let decodedData = response.value else { return }
          success(decodedData)

        case .failure(let err):
          failure(response.value, err)
        }
      }
  }
}
