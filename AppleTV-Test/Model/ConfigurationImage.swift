//
//  ConfigurationImage.swift
//  AppleTV-Test
//
//  Created by José Ángel Herrán on 23/04/2019.
//  Copyright © 2019 Jose Angel Herran. All rights reserved.
//

import Foundation

struct ConfigurationImage: Codable {
    let baseUrl: String?
    let secureBaseUrl: String?
    let backdropSizes: Array<String>?
    let logoSizes: Array<String>?
    let posterSizes: Array<String>?
    let profileSizes: Array<String>?
    let stillSizes: Array<String>?
    
    enum CodingKeys: String, CodingKey {
        case baseUrl = "base_url"
        case secureBaseUrl = "secure_base_url"
        case backdropSizes = "backdrop_sizes"
        case logoSizes = "logo_sizes"
        case posterSizes = "poster_sizes"
        case profileSizes = "profile_sizes"
        case stillSizes = "still_sizes"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        baseUrl = try values.decodeIfPresent(String.self, forKey: .baseUrl)
        secureBaseUrl = try values.decodeIfPresent(String.self, forKey: .secureBaseUrl)
        backdropSizes = try values.decodeIfPresent([String].self, forKey: .backdropSizes)
        logoSizes = try values.decodeIfPresent([String].self, forKey: .logoSizes)
        posterSizes = try values.decodeIfPresent([String].self, forKey: .posterSizes)
        profileSizes = try values.decodeIfPresent([String].self, forKey: .profileSizes)
        stillSizes = try values.decodeIfPresent([String].self, forKey: .stillSizes)
    }
}
