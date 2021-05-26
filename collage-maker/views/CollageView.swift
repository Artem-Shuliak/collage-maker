//
//  CollageView.swift
//  collage-maker
//
//  Created by Artem Chouliak on 5/26/21.
//

import UIKit

class CollageView: UIView {

    var imageArray: [UIImage]
    let spacing = CGFloat(10)
    
    lazy var MainStackView: UIStackView = {
        let st = UIStackView()
        st.alignment = .fill
        st.axis = .vertical
        st.distribution = .fillProportionally
        st.translatesAutoresizingMaskIntoConstraints = false
        st.spacing = spacing
        return st
    }()
    
    init(imageArray: [UIImage]) {
        self.imageArray = imageArray
        super.init(frame: .infinite)
        setupViews()
        layoutViews()
        constructCollage()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(MainStackView)
    }
    
    func layoutViews() {
        NSLayoutConstraint.activate([
            MainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            MainStackView.topAnchor.constraint(equalTo: topAnchor),
            MainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            MainStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

    }
    
    func constructCollage() {
        let chunckedImages = imageArray.chunked(into: 2)
        chunckedImages.forEach { row in
        
            let rowStack = UIStackView()
            rowStack.alignment = .fill
            rowStack.distribution = .fillProportionally
            rowStack.axis = .horizontal
            rowStack.spacing = spacing
            
            
            row.forEach {
                let imageView = UIImageView(image: $0)
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                imageView.layer.cornerRadius = 4
                rowStack.addArrangedSubview(imageView)
            }
            
            MainStackView.addArrangedSubview(rowStack)
        }
        layoutIfNeeded()
        }
    }

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

