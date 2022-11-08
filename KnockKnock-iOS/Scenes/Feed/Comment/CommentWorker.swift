//
//  CommentWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/13.
//

import Foundation

protocol CommentWorkerProtocol {
  func getAllComments(completionHandler: @escaping ([Comment]) -> Void)
}

final class CommentWorker: CommentWorkerProtocol {
  private let repository: CommentRepositoryProtocol

  init(repository: CommentRepositoryProtocol){
    self.repository = repository
  }

  func getAllComments(completionHandler: @escaping ([Comment]) -> Void) {
    self.repository.getComments(completionHandler: { result in
      completionHandler(result)
    })
  }
}
