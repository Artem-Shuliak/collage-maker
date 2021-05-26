//
//  ImagePickerController.swift
//  collage-maker
//
//  Created by Artem Chouliak on 5/25/21.
//

import UIKit
import Photos

protocol ImagePickerDelegate: AnyObject {
    func imagePickerButtonTapped(images: [UIImage])
}

class ImagePickerController: UIViewController {
    
    // PhotosManager
    let photosManager = PhotosManager.shared
    //data passing delegate
    var delegate: ImagePickerDelegate?
    
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .infinite, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        return cv
    }()
    
    let collageButton: customButton = {
        let button = customButton()
        button.setTitle("Create Collage", for: .normal)
        button.addTarget(self, action: #selector(imagePickerButtonTapped) , for: .touchUpInside)
        button.isButtonActive(isActive: false)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
        configureNavBar()
        layoutItems()
        populateWidthPhotos()
    }
    
    func configureItems() {
        view.backgroundColor = .white
        view.addSubview(collageButton)
        view.addSubview(collectionView)
        
        collectionView.register(ImagePickerCellCollectionViewCell.self, forCellWithReuseIdentifier: ImagePickerCellCollectionViewCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func configureNavBar() {
        title = "Select Images"
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissViewController))
        navigationItem.rightBarButtonItem = cancelButton
    }
    
    func layoutItems() {
        // layout button
        NSLayoutConstraint.activate([
            collageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collageButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            collageButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // layout collectionView
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: collageButton.topAnchor, constant: -20)
        ])
    }
    
    func populateWidthPhotos() {
        photosManager.loadPhotos {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
}

// MARK: -  CollectionView DataSource/Delegate Methods


extension ImagePickerController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photosManager.imageArray.count
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagePickerCellCollectionViewCell.reuseIdentifier, for: indexPath) as! ImagePickerCellCollectionViewCell
        
        let imageModel = photosManager.imageArray[indexPath.row]
        cell.configureCell(imageModel: imageModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectImage(indexPath: indexPath)
        updateButton()
    }
    
    // performs action when imagePicker Button is tapped
    @objc func imagePickerButtonTapped() {
        delegate?.imagePickerButtonTapped(images: photosManager.selectedImages)
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: -  CollectionView DelegateFlowLayout Methods

extension ImagePickerController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemsPerRow = 3
        let paddingSpace = sectionInsets.left * CGFloat(itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / CGFloat(itemsPerRow)
        
        return CGSize(width: widthPerItem , height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets { return sectionInsets }
}

// MARK: -  ImagePickerController Additional Methods

extension ImagePickerController {
    
    @objc func dismissViewController() {
         dismiss(animated: true, completion: nil)
     }
    
    // Checks if an image has already been added to selectedImages Array and adds it
    func selectImage(indexPath: IndexPath) {
        photosManager.selectImage(indexPath: indexPath) {
            collectionView.reloadItems(at: [indexPath])
        }
    }
    
    func updateButton() {
        if photosManager.selectedImages.count > 1 {
            collageButton.isButtonActive(isActive: true)
            collageButton.setTitle("Create Collage width \(photosManager.selectedImages.count) Photos", for: .normal)
        } else {
            collageButton.isButtonActive(isActive: false)
            collageButton.setTitle("Create Collage width \(photosManager.selectedImages.count) Photos", for: .normal)
        }
    }
    
}



