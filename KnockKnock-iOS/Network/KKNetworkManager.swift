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
  typealias Failure = ((_ error: Error) -> Void)

  static let shared = KKNetworkManager()

  func request<T>(
    object: T.Type,
    router: KKRouter,
    success: @escaping Success<T>,
    failure: @escaping Failure) where T: Decodable {
      AF.request(
        router,
        interceptor: KKRequestInterceptor()
      ).validate(statusCode: 200..<500)
        .responseDecodable(of: object) { response in
          switch response.result {
          case .success:
            guard let decodedData = response.value else { return }
            success(decodedData)
          case .failure(let err):
            failure(err)
          }
        }
    }
}
