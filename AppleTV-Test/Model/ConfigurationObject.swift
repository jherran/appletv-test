//
//  ConfigurationObject.swift
//  AppleTV-Test
//
//  Created by José Ángel Herrán on 23/04/2019.
//  Copyright © 2019 Jose Angel Herran. All rights reserved.
//

import Foundation

struct ConfigurationObject: Codable {
    let images: ConfigurationImage?
    let changeKeys: Array<String>?
    
    enum CodingKeys: String, CodingKey {
        case images
        case changeKeys = "change_keys"
    }
}
