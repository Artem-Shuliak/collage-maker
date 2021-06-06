//
//  CollageView.swift
//  collage-maker
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
    
    // MARK: - Lifecycle
    
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
        backgroundColor = .systemBackground
    }
    
    private func layoutViews() {
        NSLayoutConstraint.activate([
            MainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            MainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            MainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            MainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }

    // MARK: - Collage Construction Functions
    
    // constructs collage view based on datasource images
    func constructCollage(completion: @escaping () -> Void) {
        
        let dispatchGroup = DispatchGroup()
        MainStackView.removeAll()
        
        // number of images in the collage
        guard let numberOfItems = self.datasource?.numberOfItems() else { return }
        
        // images per row
        let itemsperRow = 2
        // array which holds collage Rows
        var rowStackViews = [UIStackView]()
        
        for row in stride(from: 0, to: numberOfItems, by: itemsperRow) {
            
            // create stackview for each row
            let rowStack = UIStackView()
            rowStack.alignment = .fill
            rowStack.distribution = .fillProportionally
            rowStack.axis = .horizontal
            rowStack.spacing = spacing
            
            for item in row ..< min(row + itemsperRow, numberOfItems) {
                
                // create image inside a row
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                imageView.layer.cornerRadius = 4
                
                // add image to the row's StackView
                rowStack.addArrangedSubview(imageView)
                
                // request image for a specified index
                // using DispatchGroup to Queue all of the asynchonous image fetching before presenting collage
                dispatchGroup.enter()
                datasource?.ImageforIndex(indexPath: item) { image in
                    defer { dispatchGroup.leave() }
                    DispatchQueue.main.async { imageView.image = image }
                }
                
            }
            rowStackViews.append(rowStack)
        }
        
        // append all of the rows to the main StackView when all of the images are fecthed.
        dispatchGroup.notify(queue: .main) { [weak self] in
            rowStackViews.forEach { self?.MainStackView.addArrangedSubview($0)}
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
