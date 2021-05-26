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
//                let manager = PHImageManager.default()
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                
                guard assets.count > 0 else {
                    print("You've got no photos!")
                    return
                }
                
                assets.enumerateObjects { object, _, _ in
//                    manager.requestImage(for: object, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: nil) { image, _ in
//
//                        guard let image = image else { return }
//                        self.imageArray.append(ImagePickerModel(image: image))
//                        completion()
//                    }
                    let imageModel = ImagePickerModel(asset: object)
                    self.imageArray.append(imageModel)
                }
                
            }
        }
    }
    
    func selectImage(indexPath: IndexPath, completion: @escaping  () -> ()) {
        if selectedImages.count < 10 {
            
            imageArray[indexPath.row].isSelected.toggle()
            
            imageArray[indexPath.row].fullImage { image in
                print(image)
                if self.imageArray[indexPath.row].isSelected {
                    self.selectedImages.append(image)
                    completion()
                } else {
                    self.selectedImages.removeAll { $0 == image }
                    completion()
                }
            }
            
            
        }
    }

}


