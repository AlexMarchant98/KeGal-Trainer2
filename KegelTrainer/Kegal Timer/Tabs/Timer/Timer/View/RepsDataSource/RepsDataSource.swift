//
//  RepsDataSource.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 19/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation
import UIKit

protocol RepsDataSourceDelegate {
    func allRepsCompleted()
}

class RepsDataSource: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let reps: [Int]
    let repsPerSet: Int
    let collectionView: UICollectionView
    let delegate: RepsDataSourceDelegate
    
    var currentRep: Int
    
    init(
        reps: [Int],
        repsPerSet: Int,
        collectionView: UICollectionView,
        delegate: RepsDataSourceDelegate) {
        
        self.reps = reps
        self.repsPerSet = repsPerSet
        self.collectionView = collectionView
        self.delegate = delegate
        
        self.currentRep = 0
    }
    
    func updateCurrentRep(by increment: Int) {
        
        let nextRep = self.currentRep + increment
        
        if(nextRep >= self.repsPerSet) {
            self.currentRep = 0
            self.delegate.allRepsCompleted()
        } else {
            
            if (increment < 0) {
                if(currentRep > 0) {
                    self.currentRep = nextRep
                }
            } else {
                self.currentRep = nextRep
            }
        }
        
        focusCollectionView()
    }
    
    func resetReps() {
        self.currentRep = 0
        
        focusCollectionView()
    }
    
    func focusCollectionView()
    {
        self.collectionView.reloadData()
        self.collectionView.reloadItems(at: generateIndexPaths())
        self.collectionView.scrollToItem(
            at: IndexPath(item: currentRep, section: 0),
            at: UICollectionView.ScrollPosition.centeredHorizontally,
            animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.backgroundColor = UIColor.clear
        return reps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch reps[indexPath.row] - 1 {
        case currentRep + 3:
            return CGSize(width: 56.2 / 4, height: 56.2)
        case currentRep + 2:
            return CGSize(width: 56.2 / 3, height: 56.2)
        case currentRep + 1:
            return CGSize(width: 56.2 / 2, height: 56.2)
        case currentRep:
            return CGSize(width: 56.2, height: 56.2)
        case currentRep - 1:
            return CGSize(width: 56.2 / 2, height: 56.2)
        case currentRep - 2:
            return CGSize(width: 56.2 / 3, height: 56.2)
        case currentRep - 3:
            return CGSize(width: 56.2 / 4, height: 56.2)
        default:
            return CGSize(width: 56.2 / 4, height: 56.2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.repCollectionViewCellReuseIdentifier, for: indexPath) as! RepCollectionViewCell
        
        let mask = CAShapeLayer()
        let path = UIBezierPath(arcCenter: CGPoint(x: cell.bounds.midX, y: cell.bounds.midY),
                                radius: cell.bounds.width / 2,
                                startAngle: -CGFloat.pi / 2,
                                endAngle: 2 * .pi,
                                clockwise: true)
        
        path.close()
        
        mask.frame = cell.bounds
        mask.path = path.cgPath
        
        var alpha = 1.0
        var color = UIColor.white
        var size = 0.0
        
        switch reps[indexPath.row] - 1 {
        case currentRep + 3:
            size = Constants.fontSize / 4
        case currentRep + 2:
            size = Constants.fontSize / 3
        case currentRep + 1:
            size = Constants.fontSize / 2
        case currentRep:
            color = .green
            size = Constants.fontSize
        case currentRep - 1:
            color = .green
            size = Constants.fontSize / 2
            alpha = 0.75
        case currentRep - 2:
            color = .green
            size = Constants.fontSize / 3
            alpha = 0.50
        case currentRep - 3:
            color = .green
            size = Constants.fontSize / 4
            alpha = 0.25
        default:
            color = .clear
            alpha = 0
        }
        
        cell.layer.mask = mask
        cell.repCount.textColor = .workoutBackgroundColor
        cell.repCount.text = String(reps[indexPath.row])
        cell.repCount.font = UIFont(name: "Quicksand-SemiBold", size: CGFloat(size))
        cell.contentView.backgroundColor = color
        cell.contentView.alpha = CGFloat(alpha)
        cell.backgroundColor = UIColor.clear
        cell.alpha = cell.contentView.alpha
        
        return cell
    }
    
    private func generateIndexPaths() -> [IndexPath]
    {
        var indexPaths = [IndexPath]()
        
        if(currentRep - 5 >= 0)
        {
            indexPaths.append(IndexPath(row: currentRep - 5, section: 0))
        }
        if(currentRep - 4 >= 0)
        {
            indexPaths.append(IndexPath(row: currentRep - 4, section: 0))
        }
        if(currentRep - 3 >= 0)
        {
            indexPaths.append(IndexPath(row: currentRep - 3, section: 0))
        }
        if(currentRep - 2 >= 0)
        {
            indexPaths.append(IndexPath(row: currentRep - 2, section: 0))
        }
        if(currentRep - 1 >= 0)
        {
            indexPaths.append(IndexPath(row: currentRep - 1, section: 0))
        }
        
        indexPaths.append(IndexPath(row: currentRep, section: 0))
        
        if(currentRep + 1 < self.repsPerSet)
        {
            indexPaths.append(IndexPath(row: currentRep + 1, section: 0))
        }
        if(currentRep + 2 < self.repsPerSet)
        {
            indexPaths.append(IndexPath(row: currentRep + 2, section: 0))
        }
        if(currentRep + 3 < self.repsPerSet)
        {
            indexPaths.append(IndexPath(row: currentRep + 3, section: 0))
        }
        
        return indexPaths
    }
}
