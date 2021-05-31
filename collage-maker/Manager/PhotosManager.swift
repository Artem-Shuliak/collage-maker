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
    private init() {}
    
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
                    guard let imageArray = self?.imageArray else { return }
                    if imageArray.count < 2000 {
                        self?.imageArray.append(ImagePickerModel(asset: object))
                    }
                    completion()
                }
            }
        }
    }
    
    
    func loadImage(asset: PHAsset, targetSize: CGSize = PHImageManagerMaximumSize, isSynchonous: Bool, completion: @escaping (UIImage) -> Void) {
        
        let options = PHImageRequestOptions()
        options.isSynchronous = isSynchonous ? true : false
        
        manager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { image, _ in
            guard let image = image else { return }
            completion(image)
        }
    }

    
    func selectImage(indexPath: IndexPath, completion: () -> Void) {
        
        if selectedImages.count < 10 {
            
            imageArray[indexPath.row].isSelected.toggle()
        
                if imageArray[indexPath.row].isSelected {
                   selectedImages.append(imageArray[indexPath.row])
                    completion()
                } else {
                   selectedImages.removeAll { $0 == imageArray[indexPath.row] }
                    completion()
                }
        }
    }

}



