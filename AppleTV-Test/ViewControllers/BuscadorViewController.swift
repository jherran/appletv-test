//
//  BuscadorViewController.swift
//  AppleTV-Test
//
//  Created by José Ángel Herrán on 29/04/2019.
//  Copyright © 2019 Jose Angel Herran. All rights reserved.
//

import UIKit

class BuscadorViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSearch()
    }
    
    func addSearch() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.searchBarStyle = .prominent
        
        let searchContainer = UISearchContainerViewController(searchController: searchController)
        searchContainer.title = "Search"
        
        addChild(searchContainer)
        view.addSubview(searchContainer.view)
        searchContainer.didMove(toParent: self)
    }
    
}

extension BuscadorViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text ?? "")
    }
}
