//
//  RecomendarViewController.swift
//  AppleTV-Test
//
//  Created by José Ángel Herrán on 06/05/2019.
//  Copyright © 2019 Jose Angel Herran. All rights reserved.
//

import UIKit

class RecomendarViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = title?.capitalized
    }
}
