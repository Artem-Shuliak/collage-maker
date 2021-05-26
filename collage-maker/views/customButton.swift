//
//  customButton.swift
//  collage-maker
//
//  Created by Artem Chouliak on 5/25/21.
//

import UIKit

class customButton: UIButton {
    
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ?.darkGray : .gray
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .gray
        layer.cornerRadius = 10
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isButtonActive(isActive: Bool) {
        alpha = isActive ? 1 : 0.7
        isUserInteractionEnabled = isActive ? true : false
        layoutIfNeeded()
    }
}
