//
//  CommentCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/13.
//

import UIKit

class CommentCell: BaseCollectionViewCell {

  // MARK: - UIs

  private let profileImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
  }

  private let userIdLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
  }

  private let commentLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
  }

  private let writtenDateLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
  }

  private let replyButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setTitle("댓글달기", for: .normal)
  }
}
