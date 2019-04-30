//
//  PlayerViewController.swift
//  AppleTV-Test
//
//  Created by José Ángel Herrán on 10/04/2019.
//  Copyright © 2019 Jose Angel Herran. All rights reserved.
//

import UIKit
import Kingfisher

class PlayerViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var popularMovies: [Media] = [] {
        didSet {
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
    }
    
    var highlightPopularMovies: [Media] = []
    
    var popularTV: [Media] = [] {
        didSet {
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
    }
    
    var categories: [String] = ["SERIES", "PROGRAMAS", "NOTICIAS", "TELENOVELAS", "DOCUMENTALES"]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "HighlightTableViewCell", bundle: nil), forCellReuseIdentifier: "highlightCell")
        tableView.register(UINib(nibName: "RowTableViewCell", bundle: nil), forCellReuseIdentifier: "rowCell")
        tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "categoryCell")

        tableView.delegate = self
        tableView.dataSource = self
        tableView.remembersLastFocusedIndexPath = true
        
        getConfigurationFilmsAndTVShows()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "filmSegue" {
            let vc = segue.destination as? ThirdViewController
            vc?.mediaItem = sender as? Media
        }
    }
    
    func getConfigurationFilmsAndTVShows() {
        let urlRequest = URLRequest(url: configurationURL)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                print(error!)
                return
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }

            let decoder = JSONDecoder()
            let config = try? decoder.decode(ConfigurationObject.self, from: responseData)
            
            if let images = config?.images, let imBaseUrl = images.secureBaseUrl {
                imageBaseUrl = imBaseUrl
                if let size = images.posterSizes?.last {
                    imageWidth = size
                }
                self.getFromAPI(with: discoverFilmsURL)
                self.getFromAPI(with: discoverTVURL)
            } else {
                print("no results")
                return
            }
        }
        task.resume()
    }

    
    func getFromAPI(with url: URL) {
        
        let urlRequest = URLRequest(url: url)

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                print(error!)
                return
            }

            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMdd)
            let filmResponse = try? decoder.decode(ResponseObject.self, from: responseData)
            
            if let films = filmResponse?.results {
                if url == discoverFilmsURL {
                    self.popularMovies = films
                    
                    self.highlightPopularMovies = self.popularMovies
                    if let _ = self.highlightPopularMovies.last {
                        let lastMovie = self.highlightPopularMovies.removeLast()
                        self.highlightPopularMovies.insert(lastMovie, at: 0)
                    }
                    
                } else if url == discoverTVURL {
                    self.popularTV = films
                }
            } else {
                print("no results")
                return
            }
        }
        task.resume()
    }
}

extension PlayerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 760
        case 1:
            return 355
        default:
            return 486
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0, 1:
            return nil
        case 2, 4:
            return "Discover popular movies"
        case 3, 5:
            return "Discover popular tv shows"
        default:
            return nil
        }
    }
}

extension PlayerViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        var num = 0
        if categories.count > 0 {
            num += 1
        }
        if popularMovies.count > 0 {
            num += 3
        }
        if popularTV.count > 0 {
            num += 2
        }
        return num
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "highlightCell", for: indexPath) as? HighlightTableViewCell
            cell?.delegate = self
            cell?.mediaItems = highlightPopularMovies
            cell?.backgroundColor = .red
            return cell!
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as? CategoryTableViewCell
            cell?.delegate = self
            cell?.categories = categories
            return cell!
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "rowCell", for: indexPath) as? RowTableViewCell
        cell?.delegate = self
        switch indexPath.section {
        case 2, 4:
            cell?.mediaItems = popularMovies
        case 3, 5:
            cell?.mediaItems = popularTV
        default:
            cell?.mediaItems = []
        }
        
        return cell!
    }
}

extension PlayerViewController: ItemSelectedDelegate {
    func itemSelected(movie: Media) {
        performSegue(withIdentifier: "filmSegue", sender: movie)
    }
}

extension PlayerViewController: CategorySelectedDelegate {
    func categoryDelegateSelected(category: String) {
        print("\(category) selected!")
    }
}

extension PlayerViewController: HighlightSelectedDelegate {
    func highlightSelected(movie: Media) {
        print("\(movie.title ?? "") selected!")
    }
}
