//
//  ViewController.swift
//  collage-maker
//
//  Created by Artem Chouliak on 5/25/21.
//

import UIKit

class ViewController: UIViewController {
    
    private var imageArray: [ImagePickerModel]? {
        didSet { imagesAreSelected() }
    }
    
    // MARK: - View Elements

    private let collageButton: customButton = {
        let button = customButton()
        button.setTitle("Pick Photos", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped) , for: .touchUpInside)
        return button
    }()

    private let emptyCollageLabel: UILabel = {
        let label = UILabel()
        label.text = "No Images Has Been Selected"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let shareButton: customButton = {
        let button = customButton()
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(shareButtonTapped) , for: .touchUpInside)
        button.tintColor = .white
        button.clipsToBounds = true
        button.isHidden = true
        return button
    }()
    
    private lazy var buttonsStack: UIStackView = {
        let st = UIStackView(arrangedSubviews: [collageButton, shareButton])
        st.alignment = .fill
        st.axis = .horizontal
        st.distribution = .fillProportionally
        st.translatesAutoresizingMaskIntoConstraints = false
        st.spacing = 10
        st.addArrangedSubview(collageButton)
        st.addArrangedSubview(shareButton)
        return st
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private var collageView: CollageView?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
        layoutItems()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        shareButton.layer.cornerRadius = 0.5 * shareButton.bounds.size.width
    }
    
    private func configureItems() {
        view.addSubview(buttonsStack)
        view.addSubview(activityIndicator)
        view.backgroundColor = .white
        imagesAreSelected()
        
    }
    
    private func layoutItems() {
        
        NSLayoutConstraint.activate([
            buttonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            buttonsStack.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            shareButton.widthAnchor.constraint(equalTo: buttonsStack.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
}

// MARK: - ImagePicker Delegate Methods

extension ViewController: ImagePickerDelegate {
    
    func imagePickerButtonTapped(selectedImageModels: [ImagePickerModel]) {
        imageArray = selectedImageModels
    }
    
}

// MARK: -  CollageView Datasource Methods

extension ViewController: collageDatasource {
    func numberOfItems() -> Int {
        guard let imageArray = imageArray else { return 0 }
        return imageArray.count
    }
    
    func ImageforIndex(indexPath: Int, completion: @escaping (UIImage) -> Void) {
        guard let imageArray = imageArray else { return }
        let imageObject = imageArray[indexPath]
        PhotosManager.shared.loadImage(asset: imageObject.asset, targetSize: CGSize(width: view.bounds.width, height: view.bounds.height), isSynchonous: false) { image in
            completion(image)
        }
    }
}


// MARK: - ViewController etxension methods

extension ViewController {
    
    @objc private func buttonTapped() {
        // Image Picker Controller
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        
        // embded Image Picker Controller inside Navigation Controller
        let secondNavigationController = UINavigationController(rootViewController: imagePickerController)
        navigationController?.present(secondNavigationController, animated: true, completion: nil)
    }
    
    @objc private func shareButtonTapped() {
        guard let collageView = collageView else { return }
        
        collageView.convertToImage() { [weak self] image in
            DispatchQueue.main.async {
                let shareSheetVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                self?.present(shareSheetVC, animated: true)
            }
        }
    }
            
    private func imagesAreSelected() {

        // show message that no images has been selected
        if imageArray == nil {
            collageView?.removeFromSuperview()
            view.addSubview(emptyCollageLabel)
            
            NSLayoutConstraint.activate([
                emptyCollageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                emptyCollageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
            
        } else {
            emptyCollageLabel.removeFromSuperview()
            activityIndicator.startAnimating()
            
            // checking if the user has previously instantiated collage, to reduce unecessary initialization.
            if let collageView = collageView {
                collageView.constructCollage() { [weak self] in
                    self?.activityIndicator.stopAnimating()
                }
                
            } else {
                setupCollageView()
                guard let collageView = collageView else { return }
                collageView.constructCollage() { [weak self] in
                    self?.activityIndicator.stopAnimating()
                }
            }
        
            // show share button
            shareButton.isHidden = false
        }
    }
    
    private func setupCollageView() {
        collageView = CollageView()
        guard let collageView = collageView else { return }
        collageView.datasource = self
        
        collageView.translatesAutoresizingMaskIntoConstraints = false
        collageView.clipsToBounds = true
        view.insertSubview(collageView, belowSubview: activityIndicator)
        
        NSLayoutConstraint.activate([
            collageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collageView.bottomAnchor.constraint(equalTo: collageButton.topAnchor),
        ])
    }

}



