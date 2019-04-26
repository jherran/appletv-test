//
//  CollectionViewCellExtension.swift
//  AppleTV-Test
//
//  Created by José Ángel Herrán on 23/04/2019.
//  Copyright © 2019 Jose Angel Herran. All rights reserved.
//

import UIKit

extension ImageCollectionViewCell {
    func cellFocused(_ focused: Bool) {
        var scale: CGFloat = 1.0
        var shadowColor: CGColor = UIColor.clear.cgColor
        
        if focused {
            scale = 1.1
            shadowColor = UIColor.black.cgColor
            cellTitle.backgroundColor = .white
            cellTitle.textColor = .black
        } else {
            cellTitle.backgroundColor = .black
            cellTitle.textColor = .white
        }
        
        self.transformCell(with: scale, scaleY: scale, shadowColor: shadowColor, offset: CGSize(width: 0, height: 15))
    }
}

extension TextCollectionViewCell {
    func cellFocused(_ focused: Bool) {
        var scale: CGFloat = 1.0
        var shadowColor: CGColor = UIColor.clear.cgColor
        
        if focused {
            scale = 1.1
            shadowColor = UIColor.black.cgColor
            self.backgroundColor = .white
            cellTitle.textColor = .black
        } else {
            self.backgroundColor = .black
            cellTitle.textColor = .white
        }

        self.transformCell(with: scale, scaleY: scale, shadowColor: shadowColor, offset: CGSize(width: 0, height: 15))
    }
}

extension UICollectionViewCell {
    func transformCell(with scaleX: CGFloat, scaleY: CGFloat, shadowColor: CGColor, offset: CGSize) {
        self.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        self.layer.shadowColor = shadowColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 15
    }
}

