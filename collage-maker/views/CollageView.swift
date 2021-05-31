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
    func constructCollage() {
        
        MainStackView.removeAll()
        guard let numberOfItems = datasource?.numberOfItems() else { return }
        let itemsperRow = 2
        
        DispatchQueue.main.async {
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
                    
                    self.datasource?.ImageforIndex(indexPath: item, completion: { image in
                        DispatchQueue.main.async {
                            imageView.image = image
                        }
                    })
                    
                }
                self.MainStackView.addArrangedSubview(rowStack)
            }
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
