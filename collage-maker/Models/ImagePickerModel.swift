//
//  ImagePickerModel.swift
//  collage-maker
//
//  Created by Artem Chouliak on 5/25/21.
//

import UIKit
import Photos

struct ImagePickerModel {
    let asset: PHAsset
    var isSelected: Bool = false
    
    func thumbnailImage(completion: @escaping (UIImage) -> ()) {
        let manager = PHImageManager.default()
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: nil) { image, _ in
            
            guard let image = image else { return }
            completion(image)
        }
    }
    
    
    func fullImage(completion: @escaping (UIImage) -> ()) {
        let manager = PHImageManager.default()
        manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: nil) { image, _ in
            
            guard let image = image else { return }
            completion(image)
        }
    }

}
