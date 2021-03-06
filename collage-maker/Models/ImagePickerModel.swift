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
    var isSelected: Bool = false
    
    static func == (lhs: ImagePickerModel, rhs: ImagePickerModel) -> Bool {
        return lhs.asset == rhs.asset
    }
    
}
