//
//  HighlightTableViewCell.swift
//  AppleTV-Test
//
//  Created by José Ángel Herrán on 16/04/2019.
//  Copyright © 2019 Jose Angel Herran. All rights reserved.
//

import UIKit

protocol HighlightSelectedDelegate {
    func highlightSelected(movie: Media)
}

class HighlightTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var mediaItems: [Media] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    var delegate: HighlightSelectedDelegate?
    var selectCenterCell: Bool = true
    let firstItemIndexPath = IndexPath(item: 1, section: 0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        focusStyle = .custom

        let layout = LNZInfiniteCollectionViewLayout()
        layout.itemSize = CGSize(width: 1200, height: 700)
        layout.interitemSpacing = -30
        
        collectionView.backgroundColor = .clear
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "BigImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "bigCollectionViewCellId")
        collectionView.clipsToBounds = false
        collectionView.remembersLastFocusedIndexPath = true
        collectionView.isScrollEnabled = false
    }
}

extension HighlightTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        if let indexPath = context.nextFocusedIndexPath, !collectionView.isScrollEnabled {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        
        if let indexPath = context.nextFocusedIndexPath, let cell = collectionView.cellForItem(at: indexPath) as? BigImageCollectionViewCell {
            coordinator.addCoordinatedAnimations({() -> Void in
                cell.cellFocused(true)
                cell.addMotionEffect(motionEffectGroup)
            }, completion: nil)
        }
        if let indexPath = context.previouslyFocusedIndexPath, let cell = collectionView.cellForItem(at: indexPath) as? BigImageCollectionViewCell {
            coordinator.addCoordinatedAnimations({() -> Void in
                cell.cellFocused(false)
                cell.removeMotionEffect(motionEffectGroup)
            }, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = delegate {
            delegate.highlightSelected(movie: mediaItems[indexPath.row])
        }
    }
}

extension HighlightTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "bigCollectionViewCellId", for: indexPath) as! BigImageCollectionViewCell
        if let posterPath = self.mediaItems[indexPath.row].posterURL {
            collectionViewCell.image.kf.setImage(with: posterPath)
        }
        collectionViewCell.cellTitle.text = mediaItems[indexPath.row].title ?? mediaItems[indexPath.row].name
        return collectionViewCell
    }
}
