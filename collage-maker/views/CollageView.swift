//
//  CollageView.swift
//  collage-maker
//
//  Created by Artem Chouliak on 5/26/21.
//

import UIKit


protocol collageDatasource {
    func numberOfItems() -> Int
    func ImageforIndex(indexPath: Int) -> UIImage
}

class CollageView: UIView {
    
    var datasource: collageDatasource?
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        layoutViews()
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
    
    //    func constructCollage(imageArray: [UIImage]) {
    //        let chunckedImages = imageArray.chunked(into: 2)
    //        chunckedImages.forEach { row in
    //
    //            let rowStack = UIStackView()
    //            rowStack.alignment = .fill
    //            rowStack.distribution = .fillProportionally
    //            rowStack.axis = .horizontal
    //            rowStack.spacing = spacing
    //
    //
    //            row.forEach {
    //                let imageView = UIImageView(image: $0)
    //                imageView.contentMode = .scaleAspectFill
    //                imageView.clipsToBounds = true
    //                imageView.layer.cornerRadius = 4
    //                rowStack.addArrangedSubview(imageView)
    //            }
    //
    //            MainStackView.addArrangedSubview(rowStack)
    //        }
    //        layoutIfNeeded()
    //        }
    
    func constructCollage() {
        
        guard let numberOfItems = datasource?.numberOfItems() else { return }
        let itemsperRow = 2
        
        for row in stride(from: 0, to: numberOfItems, by: itemsperRow) {
            
            let rowStack = UIStackView()
            rowStack.alignment = .fill
            rowStack.distribution = .fillProportionally
            rowStack.axis = .horizontal
            rowStack.spacing = spacing
            
            for item in row ..< min(row + itemsperRow, numberOfItems) {
                
                guard let image = datasource?.ImageforIndex(indexPath: item) else { return }
                
                let imageView = UIImageView(image: image)
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

//extension Array {
//    func chunked(into size: Int) -> [[Element]] {
//        return stride(from: 0, to: count, by: size).map {
//            Array(self[$0 ..< Swift.min($0 + size, count)])
//        }
//    }
//}

