//
//  UIView+Extension.swift
//  BannerCollectionViewDemo
//
//  Created by Zignuts Technolab on 18/05/23.
//

import UIKit

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}
