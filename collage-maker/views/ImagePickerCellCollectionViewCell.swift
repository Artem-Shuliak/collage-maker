//
//  ImagePickerCellCollectionViewCell.swift
//  collage-maker
//
//  Created by Artem Chouliak on 5/25/21.
//

import UIKit

class ImagePickerCellCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ImagePickerCellCollectionViewCell"
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
        
    func configureCell(imageModel: ImagePickerModel) {
        imageView.image = imageModel.image
        viewforSelectedState(imageModel: imageModel)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureItems()
        layoutItems()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureItems() {
        addSubview(imageView)
        layer.cornerRadius = 4
        backgroundColor = .systemFill
    }
    
    func layoutItems() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            imageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
    }
    
}

extension ImagePickerCellCollectionViewCell {
    
    func viewforSelectedState(imageModel: ImagePickerModel) {
        if imageModel.isSelected == true {
            layer.borderWidth = 3
            layer.borderColor = UIColor.blue.cgColor
            layoutIfNeeded()
        } else {
            layer.borderWidth = 0
            layoutIfNeeded()
        }
    }
}
