//
//  UIViewExtension.swift
//  AppleTV-Test
//
//  Created by José Ángel Herrán on 23/04/2019.
//  Copyright © 2019 Jose Angel Herran. All rights reserved.
//

import UIKit

extension UIView {
    func cellFocused(_ focused: Bool) {
        var scale: CGFloat = 1.0
        var shadowColor: CGColor = UIColor.clear.cgColor
        
        if focused {
            scale = 1.1
            shadowColor = UIColor.black.cgColor
        }
        
        self.transform = CGAffineTransform(scaleX: scale, y: scale)
        self.layer.shadowColor = shadowColor
        self.layer.shadowOffset = CGSize(width: 0, height: 15)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 15
    }
}
