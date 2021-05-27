//
//  PhotosManager.swift
//  collage-maker
//
//  Created by Artem Chouliak on 5/26/21.
//

import UIKit
import Photos

class PhotosManager {
    
    static let shared = PhotosManager()
    private init() { }
    
    let manager = PHImageManager.default()
    
    var imageArray = [ImagePickerModel]()
    var selectedImages = [ImagePickerModel]()
    
    func loadPhotos(completion: @escaping () -> Void) {
        
        imageArray.removeAll()
        selectedImages.removeAll()
        
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            
            if status == .authorized {
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                
                guard assets.count > 0 else {
                    print("You've got no photos!")
                    return
                }
                
                assets.enumerateObjects { object, _, _ in
                    self?.imageArray.append(ImagePickerModel(asset: object))
                    completion()
                }
            }
        }
    }
    
    func loadImage(asset: PHAsset, targetSize: CGSize = PHImageManagerMaximumSize) -> UIImage {
        var thumbnail = UIImage()
        manager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: nil) { image, _ in
            guard let image = image else { return }
            thumbnail = image
        }
        
        return thumbnail
    }
    
    
    func selectImage(indexPath: IndexPath, completion: () -> Void) {
        if selectedImages.count < 10 {
            
            imageArray[indexPath.row].isSelected.toggle()
        
                if self.imageArray[indexPath.row].isSelected {
                    self.selectedImages.append(imageArray[indexPath.row])
                    completion()
                } else {
                    completion()
                    self.selectedImages.removeAll { $0 == imageArray[indexPath.row] }
                }
        }
    }

}



