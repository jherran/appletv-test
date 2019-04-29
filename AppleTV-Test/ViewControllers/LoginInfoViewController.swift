//
//  LoginInfoViewController.swift
//  AppleTV-Test
//
//  Created by José Ángel Herrán on 29/04/2019.
//  Copyright © 2019 Jose Angel Herran. All rights reserved.
//

import UIKit

class LoginInfoViewController: UIViewController {
    
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!

    let items = ["Nombre", "Apellidos", "Correo Electrónico", "Sexo", "Fecha de Nacimiento", "Ubicación"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerTitle.text = "Cuenta"
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension LoginInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
}

extension LoginInfoViewController: UITableViewDelegate {
    
}
