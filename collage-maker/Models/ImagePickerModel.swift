//
//  ImagePickerModel.swift
//  collage-maker
//
//  Created by Artem Chouliak on 5/25/21.
//

import UIKit
import Photos

struct ImagePickerModel: Equatable {
    let asset: PHAsset
//    let image: UIImage
    var isSelected: Bool = false
}
