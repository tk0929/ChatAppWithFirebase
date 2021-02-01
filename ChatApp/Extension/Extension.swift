//
//  Extension.swift
//  ChatApp
//
//  Created by t.koike on 2021/01/11.
//

import UIKit

extension UIImage {
    
    
    func resize(size: CGSize) -> UIImage? {
        
        let widthRatio = size.width / self.size.width
        let heightRatio = size.height / self.size.height
        let ratio = widthRatio < heightRatio ? widthRatio : heightRatio
        
        let resizeSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        UIGraphicsBeginImageContextWithOptions(resizeSize, false, 0.0)
        draw(in: CGRect(origin: .zero, size: resizeSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
        
        
        
    }
    
}





