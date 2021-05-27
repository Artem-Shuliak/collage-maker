//
//  ViewController.swift
//  collage-maker
//
//  Created by Artem Chouliak on 5/25/21.
//

import UIKit

class ViewController: UIViewController {
    
    private var imageArray: [ImagePickerModel]? {
        didSet {
            imagesAreSelected()
        }
    }

    let collageButton: customButton = {
        let button = customButton()
        button.setTitle("Pick Photos", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped) , for: .touchUpInside)
        return button
    }()

    let emptyCollageLabel: UILabel = {
        let label = UILabel()
        label.text = "No Images Has Been Selected"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var collageView: CollageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
        layoutItems()
    }
    
    func configureItems() {
        view.addSubview(collageButton)
        view.backgroundColor = .white
        imagesAreSelected()
    }

    func layoutItems() {
        NSLayoutConstraint.activate([
            collageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collageButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            collageButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
}

extension ViewController: ImagePickerDelegate {
    
    func imagePickerButtonTapped(selectedImageModels: [ImagePickerModel]) {
        self.imageArray = selectedImageModels
    }
    
}

extension ViewController {
    
    @objc func buttonTapped() {
        // Image Picker Controller
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        
        // embded Image Picker Controller inside Navigation Controller
        let secondNavigationController = UINavigationController(rootViewController: imagePickerController)
        navigationController?.present(secondNavigationController, animated: true, completion: nil)
    }
    
    func convertToImages() {
        // do smth here
    }
    
    func imagesAreSelected() {
        
        if imageArray == nil {
            collageView?.removeFromSuperview()
            view.addSubview(emptyCollageLabel)
            
            NSLayoutConstraint.activate([
                emptyCollageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                emptyCollageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        } else {
            emptyCollageLabel.removeFromSuperview()
            
            if let collageView = collageView {
                collageView.constructCollage()
            } else {
                collageView = CollageView()
                collageView?.datasource = self
                guard let collageView = collageView else { return }
                
                collageView.translatesAutoresizingMaskIntoConstraints = false
                collageView.clipsToBounds = true
                view.addSubview(collageView)
                
                NSLayoutConstraint.activate([
                    collageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                    collageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
                    collageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                    collageView.bottomAnchor.constraint(equalTo: collageButton.topAnchor, constant: -10),
                ])
                
                collageView.constructCollage()
            }
        }
    }
}

extension ViewController: collageDatasource {
    func numberOfItems() -> Int {
        guard let imageArray = imageArray else { return 0 }
        return imageArray.count
    }
    
    func ImageforIndex(indexPath: Int) -> UIImage {
        guard let imageArray = imageArray else { return UIImage() }
        let imageObject = imageArray[indexPath]
        let image = PhotosManager.shared.loadImage(asset: imageObject.asset, targetSize: CGSize(width: view.bounds.width, height: view.bounds.height))
        return image
    }
}


//#if DEBUG
//import SwiftUI
//
//@available(iOS 13, *)
//struct ViewController_Preview: PreviewProvider {
//    static var previews: some View {
//        ViewController().showPreview()
//    }
//}
//#endif

