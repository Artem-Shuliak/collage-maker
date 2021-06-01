//
//  CollageView.swift
//  collage-maker
//
//  Created by Artem Chouliak on 5/26/21.
//

import UIKit


protocol collageDatasource: AnyObject {
    func numberOfItems() -> Int
    func ImageforIndex(indexPath: Int, completion: @escaping (UIImage) -> Void)
}

class CollageView: UIView {
    
    // collage View Datasource
    weak var datasource: collageDatasource?
    
    // spacing variable to configure collage
    let spacing: CGFloat
    
    // stackview holds images
    private lazy var MainStackView: UIStackView = {
        let st = UIStackView()
        st.alignment = .fill
        st.axis = .vertical
        st.distribution = .fillProportionally
        st.translatesAutoresizingMaskIntoConstraints = false
        st.spacing = spacing
        return st
    }()
    
    init(spacing: CGFloat = 10) {
        self.spacing = spacing
        super.init(frame: .infinite)
        setupViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(MainStackView)
        backgroundColor = .white
    }
    
    private func layoutViews() {
        NSLayoutConstraint.activate([
            MainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            MainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            MainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            MainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
    
    // constructs collage view based on datasource images
    func constructCollage(completion: @escaping () -> Void) {
        
        MainStackView.removeAll()
        
        // construct collage asynchronously in order to wait for the image conversion from the background thread
        DispatchQueue.main.async {
            
            // number of images in the collage
            guard let numberOfItems = self.datasource?.numberOfItems() else { return }
            
            // images per row
            let itemsperRow = 2
            
            for row in stride(from: 0, to: numberOfItems, by: itemsperRow) {
                
                let rowStack = UIStackView()
                rowStack.alignment = .fill
                rowStack.distribution = .fillProportionally
                rowStack.axis = .horizontal
                rowStack.spacing = self.spacing
                
                for item in row ..< min(row + itemsperRow, numberOfItems) {
                    
                    let imageView = UIImageView()
                    imageView.contentMode = .scaleAspectFill
                    imageView.clipsToBounds = true
                    imageView.layer.cornerRadius = 4
                    rowStack.addArrangedSubview(imageView)
                    
                    
                    // request image for a specified index
                    self.datasource?.ImageforIndex(indexPath: item, completion: { image in
                        DispatchQueue.main.async {
                            imageView.image = image
                        }
                    })
                    
                }
                
                self.MainStackView.addArrangedSubview(rowStack)
            }
            
            // communicate that the task has finished
            completion()
        }
    }
    
}

extension UIStackView {
    func removeAll() {
        for subview in self.arrangedSubviews {
            subview.removeFromSuperview()
        }
    }
}
