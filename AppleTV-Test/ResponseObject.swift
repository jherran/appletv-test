//
//  ResponseObject.swift
//  AppleTV-Test
//
//  Created by José Ángel Herrán on 16/04/2019.
//  Copyright © 2019 Jose Angel Herran. All rights reserved.
//

import Foundation

struct ResponseObject: Codable {
    let page: Int?
    let results: Array<Media>?
    let totalResults: Int?
    let totalPages: Int?
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}
