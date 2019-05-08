//
//  CategoryTableViewCell.swift
//  AppleTV-Test
//
//  Created by José Ángel Herrán on 16/04/2019.
//  Copyright © 2019 Jose Angel Herran. All rights reserved.
//

import UIKit

protocol CategorySelectedDelegate {
    func categoryDelegateSelected(category: String)
}

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var categories: [String] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    var delegate: CategorySelectedDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        focusStyle = .custom

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 50
        
        collectionView.backgroundColor = UIColor(red: 29, green: 26, blue: 31, alpha: 0)
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "TextCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "textCollectionViewCellId")
        collectionView.clipsToBounds = false
        collectionView.remembersLastFocusedIndexPath = true
    }
}

extension CategoryTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        if let indexPath = context.nextFocusedIndexPath, let cell = collectionView.cellForItem(at: indexPath) as? TextCollectionViewCell {
            coordinator.addCoordinatedAnimations({() -> Void in
                cell.cellFocused(true)
                cell.addMotionEffect(motionEffectGroup)
            }, completion: nil)
        }
        if let indexPath = context.previouslyFocusedIndexPath, let cell = collectionView.cellForItem(at: indexPath) as? TextCollectionViewCell {
            coordinator.addCoordinatedAnimations({() -> Void in
                cell.cellFocused(false)
                cell.removeMotionEffect(motionEffectGroup)
            }, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = delegate {
            delegate.categoryDelegateSelected(category: categories[indexPath.row])
        }
    }
}

extension CategoryTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "textCollectionViewCellId", for: indexPath) as! TextCollectionViewCell
        collectionViewCell.cellTitle.text = categories[indexPath.row]
        return collectionViewCell
    }
}

extension CategoryTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 310, height: 175)
    }
}
