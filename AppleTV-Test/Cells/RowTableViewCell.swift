//
//  RowTableViewCell.swift
//  AppleTV-Test
//
//  Created by José Ángel Herrán on 16/04/2019.
//  Copyright © 2019 Jose Angel Herran. All rights reserved.
//

import UIKit

protocol ItemSelectedDelegate {
    func itemSelected(movie: Media)
}

class RowTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var mediaItems: [Media] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    var delegate: ItemSelectedDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        focusStyle = .custom

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 80
        
        collectionView.backgroundColor = .clear
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collectionViewCellId")
        collectionView.clipsToBounds = false
        collectionView.remembersLastFocusedIndexPath = true
    }
}

extension RowTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        if let indexPath = context.nextFocusedIndexPath, let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell {
            coordinator.addCoordinatedAnimations({() -> Void in
                cell.cellFocused(true)
                cell.addMotionEffect(motionEffectGroup)
            }, completion: nil)
        }
        if let indexPath = context.previouslyFocusedIndexPath, let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell {
            coordinator.addCoordinatedAnimations({() -> Void in
                cell.cellFocused(false)
                cell.removeMotionEffect(motionEffectGroup)
            }, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = delegate {
            delegate.itemSelected(movie: mediaItems[indexPath.row])
        }
    }
}

extension RowTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCellId", for: indexPath) as! ImageCollectionViewCell
        if let posterPath = self.mediaItems[indexPath.row].posterURL {
            collectionViewCell.image.kf.setImage(with: posterPath)
        }
        collectionViewCell.cellTitle.text = mediaItems[indexPath.row].title ?? mediaItems[indexPath.row].name
        return collectionViewCell
    }
}

extension RowTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 335, height: 445)
    }
}
