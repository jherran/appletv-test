//
//  Configuration.swift
//  AppleTV-Test
//
//  Created by José Ángel Herrán on 23/04/2019.
//  Copyright © 2019 Jose Angel Herran. All rights reserved.
//

import Foundation

let baseUrl = "https://api.themoviedb.org/3"
var apiKey: String = ""
var imageBaseUrl: String?
var imageWidth = "w500"
let configurationURL = URL(string: "\(baseUrl)/configuration?\(apiKey)")!
let discoverFilmsURL = URL(string: "\(baseUrl)/discover/movie/?sort_by=popularity.desc&\(apiKey)")!
let discoverTVURL = URL(string: "\(baseUrl)/discover/tv/?sort_by=popularity.desc&\(apiKey)")!
