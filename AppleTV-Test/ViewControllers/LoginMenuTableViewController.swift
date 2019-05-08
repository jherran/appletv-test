//
//  LoginMenuTableViewController.swift
//  AppleTV-Test
//
//  Created by José Ángel Herrán on 29/04/2019.
//  Copyright © 2019 Jose Angel Herran. All rights reserved.
//

import UIKit

class LoginMenuTableViewController: UITableViewController {
    
    let menuItems = ["Cuenta", "Item", "Recomendar", "Seguir", "Cerrar Sesión"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let nav = navigationController, let firstItem = menuItems.first {
            nav.performSegue(withIdentifier: firstItem.lowercased(), sender: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = menuItems[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if let indexPath = context.nextFocusedIndexPath {
            print(menuItems[indexPath.row])
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(menuItems[indexPath.row]) tapped!")
        if let nav = navigationController {
            nav.performSegue(withIdentifier: menuItems[indexPath.row].lowercased(), sender: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}

