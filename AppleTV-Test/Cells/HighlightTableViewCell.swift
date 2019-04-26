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
            selectCenterCell = true
        }
    }
    var delegate: HighlightSelectedDelegate?
    var selectCenterCell: Bool = false
    let firstItemIndexPath = IndexPath(item: 1, section: 0)
    
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        if let cell = collectionView.cellForItem(at: firstItemIndexPath) as? BigImageCollectionViewCell, selectCenterCell {
            return [cell]
        }
        return super.preferredFocusEnvironments
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        focusStyle = .custom

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 60
        
        collectionView.backgroundColor = .clear
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "BigImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "bigCollectionViewCellId")
        collectionView.clipsToBounds = false
        collectionView.remembersLastFocusedIndexPath = true
        collectionView.isScrollEnabled = false
    }
    
    private lazy var motionEffectGroup: UIMotionEffectGroup = {
        let horizontalAxisMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontalAxisMotionEffect.minimumRelativeValue = -8.0
        horizontalAxisMotionEffect.maximumRelativeValue = 8
        
        let verticalAxisMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        verticalAxisMotionEffect.minimumRelativeValue = -8.0
        verticalAxisMotionEffect.maximumRelativeValue = 8
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontalAxisMotionEffect, verticalAxisMotionEffect]
        
        return group
    }()
}

extension HighlightTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        if let indexPath = context.nextFocusedIndexPath, !collectionView.isScrollEnabled {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }

        if selectCenterCell && mediaItems.count > 1 {
            collectionView.scrollToItem(at: firstItemIndexPath, at: .centeredHorizontally, animated: true)
            selectCenterCell = false
        }
        
        if let indexPath = context.nextFocusedIndexPath, let cell = collectionView.cellForItem(at: indexPath) as? BigImageCollectionViewCell {
            coordinator.addCoordinatedAnimations({() -> Void in
                cell.cellFocused(true)
                cell.addMotionEffect(self.motionEffectGroup)
            }, completion: nil)
        }
        if let indexPath = context.previouslyFocusedIndexPath, let cell = collectionView.cellForItem(at: indexPath) as? BigImageCollectionViewCell {
            coordinator.addCoordinatedAnimations({() -> Void in
                cell.cellFocused(false)
                cell.removeMotionEffect(self.motionEffectGroup)
            }, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = delegate {
            delegate.highlightSelected(movie: mediaItems[indexPath.row % mediaItems.count])
        }
    }
}

extension HighlightTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaItems.count * 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "bigCollectionViewCellId", for: indexPath) as! BigImageCollectionViewCell
        if let posterPath = self.mediaItems[indexPath.row % mediaItems.count].posterURL {
            collectionViewCell.image.kf.setImage(with: posterPath)
        }
        collectionViewCell.cellTitle.text = mediaItems[indexPath.row % mediaItems.count].title ?? mediaItems[indexPath.row % mediaItems.count].name
        return collectionViewCell
    }
}

extension HighlightTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 1200, height: 700)
    }
}
