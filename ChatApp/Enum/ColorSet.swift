//
//  UIcolor.swift
//  ChatApp
//
//  Created by t.koike on 2021/01/12.
//


import UIKit

enum ColorSet {
    
    static let primary = UIColor(rgbValue: 0x73C6B6)
    static let secondary = UIColor(rgbValue: 0xFFD6BA)
    
}

fileprivate extension UIColor {
    convenience init(rgbValue: UInt) {
        self.init(
            
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >>  8) / 255.0,
            blue:  CGFloat( rgbValue & 0x0000FF)        / 255.0,
            alpha: 1.0
            
        )
    }
}


