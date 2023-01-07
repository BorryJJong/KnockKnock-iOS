//
//  KKRequestInterceptor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/15.
//

import Foundation

import Alamofire

final class KKRequestInterceptor: RequestInterceptor {

  var userDefaultsService: UserDefaultsServiceType

  init(userDefaultsService: UserDefaultsServiceType) {
    self.userDefaultsService = userDefaultsService
  }

  func adapt(
    _ urlRequest: URLRequest,
    for session: Session,
    completion: @escaping (Result<URLRequest, Error>) -> Void
  ) {

    var request = urlRequest

    guard urlRequest.url?.absoluteString.hasPrefix(API.BASE_URL) == true,
          let accessToken = self.userDefaultsService.value(forkey: .accessToken) else {
      completion(.success(urlRequest))
      return
    }

    request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
    completion(.success(request))
  }

  func retry(
    _ request: Request,
    for session: Session,
    dueTo error: Error,
    completion: @escaping (RetryResult) -> Void
  ) {
    guard let response = request.task?.response as? HTTPURLResponse,
            response.statusCode == 401 else {
      completion(.doNotRetryWithError(error))
      return
    }

    // refresh token 인증 로직

  }
}
