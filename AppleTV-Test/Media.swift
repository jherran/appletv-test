//
//  Media.swift
//  AppleTV-Test
//
//  Created by José Ángel Herrán on 16/04/2019.
//  Copyright © 2019 Jose Angel Herran. All rights reserved.
//

import Foundation

let baseUrl = "https://api.themoviedb.org/3"
let apiKey = "api_key=fbf2dc4ff2edbff917459ed4515b26ba"
var imageBaseUrl: String?
let imageWidth = "w500"
let configurationURL = URL(string: "\(baseUrl)/configuration?\(apiKey)")!
let discoverFilmsURL = URL(string: "\(baseUrl)/discover/movie/?sort_by=popularity.desc&\(apiKey)")!
let discoverTVURL = URL(string: "\(baseUrl)/discover/tv/?sort_by=popularity.desc&\(apiKey)")!

struct Media: Codable {
    let posterURL: URL?
    let adult: Bool?
    let overview: String?
    let releaseDate: Date?
    let genreIds: Array<Int>?
    let id: Int?
    let originalTitle: String?
    let originalLanguage: String?
    let title: String?
    let backdropPath: String?
    let popularity: Double?
    let voteCount: Int?
    let video: Bool?
    let voteAverage: Double?
    // only TV Shows
    let firstAirDate: Date?
    let originCountry: Array<String>?
    let name: String?
    let originalName: String?

    enum CodingKeys: String, CodingKey {
        case posterURL = "poster_path"
        case adult
        case overview
        case releaseDate = "release_date"
        case genreIds = "genre_ids"
        case id
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case title
        case backdropPath = "backdrop_path"
        case popularity
        case voteCount = "vote_count"
        case video
        case voteAverage = "vote_average"
        // only TV Shows
        case firstAirDate = "first_air_date"
        case originCountry = "origin_country"
        case name
        case originalName = "original_name"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let base = imageBaseUrl, let posterPath = try values.decodeIfPresent(String.self, forKey: .posterURL) {
            posterURL = URL(string: "\(base)\(imageWidth)\(posterPath)?\(apiKey)")
        } else {
            posterURL = nil
        }

        adult = try values.decodeIfPresent(Bool.self, forKey: .adult)
        overview = try values.decodeIfPresent(String.self, forKey: .overview)
        releaseDate = try values.decodeIfPresent(Date.self, forKey: .releaseDate)
        genreIds = try values.decodeIfPresent([Int].self, forKey: .genreIds)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        originalTitle = try values.decodeIfPresent(String.self, forKey: .originalTitle)
        originalLanguage = try values.decodeIfPresent(String.self, forKey: .originalLanguage)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        backdropPath = try values.decodeIfPresent(String.self, forKey: .backdropPath)
        popularity = try values.decodeIfPresent(Double.self, forKey: .popularity)
        voteCount = try values.decodeIfPresent(Int.self, forKey: .voteCount)
        video = try values.decodeIfPresent(Bool.self, forKey: .video)
        voteAverage = try values.decodeIfPresent(Double.self, forKey: .voteAverage)
        
        // only TV Shows
        firstAirDate = try values.decodeIfPresent(Date.self, forKey: .firstAirDate)
        originCountry = try values.decodeIfPresent([String].self, forKey: .originCountry)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        originalName = try values.decodeIfPresent(String.self, forKey: .originalName)
    }
}

extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

extension Date {
    func toString() -> String? {
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy"
        return df.string(from: self)
    }
}

