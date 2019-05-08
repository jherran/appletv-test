//
//  NavigationController.swift
//  AppleTV-Test
//
//  Created by José Ángel Herrán on 08/05/2019.
//  Copyright © 2019 Jose Angel Herran. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.title = segue.identifier
    }
}
