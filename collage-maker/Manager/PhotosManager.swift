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
    
    var selectedImages = [UIImage]()
    var imageArray = [ImagePickerModel]()
    
    func loadPhotos(completion: @escaping () -> ()) {
        
        imageArray.removeAll()
        selectedImages.removeAll()
        
        PHPhotoLibrary.requestAuthorization { status in
            
            if status == .authorized {
                let manager = PHImageManager.default()
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                
                guard assets.count > 0 else {
                    print("You've got no photos!")
                    return
                }
                
                assets.enumerateObjects { object, _, _ in
                    manager.requestImage(for: object, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: nil) { image, _ in
                        
                        guard let image = image else { return }
                        self.imageArray.append(ImagePickerModel(image: image))
                        completion()
                    }
                }
                
            }
        }
    }
    
    func selectImage(indexPath: IndexPath, completion: () -> ()) {
        if selectedImages.count < 10 {
            
            imageArray[indexPath.row].isSelected.toggle()
            
            if imageArray[indexPath.row].isSelected {
                selectedImages.append(imageArray[indexPath.row].image)
                completion()
            } else {
                selectedImages.removeAll { $0 == imageArray[indexPath.row].image }
                completion()
            }
            
        }
    }

}


