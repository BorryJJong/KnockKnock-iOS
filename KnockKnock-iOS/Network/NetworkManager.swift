//
//  NetworkManager.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/07.
//

import Foundation

import Alamofire

struct APIService {
  func getChallenges(callback: @escaping ([Challenges]) -> Void) {
    let URL = "http://13.209.245.135:3000/challenges"

    AF.request(
      URL,
      method: .get
    ).responseData { response in
      switch response.result {
      case .success(let result):
        do {
          let getInstanceData = try JSONDecoder().decode([Challenges].self, from: result)
          callback(getInstanceData)
        } catch {
          print(error.localizedDescription)
        }
      case .failure(let error):
        print(error)
      }
    }
  }
}
