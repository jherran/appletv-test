//
//  FirstViewController.swift
//  AppleTV-Test
//
//  Created by José Ángel Herrán on 10/04/2019.
//  Copyright © 2019 Jose Angel Herran. All rights reserved.
//

import UIKit
import Kingfisher

class FirstViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var popularMovies: [Media] = [] {
        didSet {
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
    }
    var popularTV: [Media] = [] {
        didSet {
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
    }
    
    var focusedCollectionView: UICollectionView?
    
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        if let focused = focusedCollectionView {
            return [focused]
        }
        return super.preferredFocusEnvironments
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "RowTableViewCell", bundle: nil), forCellReuseIdentifier: "rowCell")
        
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
            
            do {
                guard let result = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                    print("error trying to convert data to JSON")
                    return
                }
                
                guard let images = result["images"] as? [String: Any] else {
                    print("Could not get images from JSON")
                    return
                }
                
                guard let imBaseUrl = images["secure_base_url"] as? String else {
                    print("Could not get images from JSON")
                    return
                }
                
                imageBaseUrl = imBaseUrl
                
                self.getFromAPI(with: discoverFilmsURL)
                self.getFromAPI(with: discoverTVURL)

            } catch  {
                print("error trying to convert data to JSON")
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

extension FirstViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 486
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0, 2:
            return "Discover popular movies"
        case 1, 3:
            return "Discover popular tv shows"
        default:
            return nil
        }
    }
}

extension FirstViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        var num = 0
        if popularMovies.count > 0 {
            num += 2
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "rowCell", for: indexPath) as? RowTableViewCell
        cell?.delegate = self
        switch indexPath.section {
        case 0, 2:
            cell?.mediaItems = popularMovies
        case 1, 3:
            cell?.mediaItems = popularTV
        default:
            cell?.mediaItems = []
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if let indexPath = context.nextFocusedIndexPath, let cell = tableView.cellForRow(at: indexPath) as? RowTableViewCell {
            focusedCollectionView = cell.collectionView
            updateFocusIfNeeded()
            setNeedsFocusUpdate()
        }
    }
}

extension FirstViewController: ItemSelectedDelegate {
    func itemSelected(movie: Media) {
        performSegue(withIdentifier: "filmSegue", sender: movie)
    }
}
