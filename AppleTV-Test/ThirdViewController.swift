//
//  ThirdViewController.swift
//  AppleTV-Test
//
//  Created by José Ángel Herrán on 11/04/2019.
//  Copyright © 2019 Jose Angel Herran. All rights reserved.
//

import UIKit
import Kingfisher

class ThirdViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var filmTitle: UILabel!
    @IBOutlet weak var originalTitle: UILabel!
    @IBOutlet weak var overview: UILabel!
    
    var mediaItem: Media?
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let item = mediaItem {
            poster.kf.setImage(with: item.posterURL)
            filmTitle.text = item.title ?? item.name
            originalTitle.text = "\(item.originalTitle ?? item.originalName ?? "") - \(item.originalLanguage ?? "") - \(item.releaseDate?.toString() ?? item.firstAirDate?.toString() ?? "")"
            overview.text = item.overview
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
