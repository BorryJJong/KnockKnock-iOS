//
//  PhotoCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/21.
//

import UIKit

import Then

final class PhotoCell: UICollectionViewCell {

  // MARK: - UI

  let thumnailImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.layer.cornerRadius = 5
  }
  
  let deleteButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setImage(#imageLiteral(resourceName:"ic_input_cancel"), for: .normal)
  }
}
