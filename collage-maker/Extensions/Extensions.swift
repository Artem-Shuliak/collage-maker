//
//  Extensions.swift
//  collage-maker
//
//  Created by Artem Chouliak on 5/30/21.
//

import UIKit

extension UIView {

    func convertToImage(comletion: @escaping (UIImage) -> Void){
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        
        DispatchQueue.global(qos: .default).async {
           
            let image = renderer.image { rendererContext in
                DispatchQueue.main.sync {
                    self.layer.render(in: rendererContext.cgContext)
                }
            }
            comletion(image)
        }
    }
}
