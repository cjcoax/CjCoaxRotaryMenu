//
//  CircularLayout.swift
//  CjCoaxRotaryMenu
//
//  Created by Amir Rezvani on 7/8/17.
//  Copyright © 2017 Amir Rezvani. All rights reserved.
//

import UIKit

@objc public protocol CjCoaxCircularLayoutDelegate {
    func sizeForCollectionViewCells(_ collectionView: UICollectionView) -> CGSize
}

class CjCoaxCircularLayout: UICollectionViewLayout {
    weak var delegate: CjCoaxCircularLayoutDelegate?
    
    fileprivate var cachedAttributes: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    fileprivate var attributeValuesAtFirstLoad: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    fileprivate var animator: UIDynamicAnimator!
    fileprivate var trainBehavior: CjCoaxTrainAttachmentBehavior?
    fileprivate var dragBehavior: UIAttachmentBehavior?
    fileprivate var attachmentAttributes: UICollectionViewLayoutAttributes?
    fileprivate var selected: Bool = false
    fileprivate var isFirstLoad: Bool = true
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.animator = UIDynamicAnimator(collectionViewLayout: self)
        self.animator.delegate = self
    }
    
    
    // MARK:- internal methods
    func startDragging(_ point: CGPoint) {
        let attributes = getClosestAttributesToPoint(point)
        self.attachmentAttributes = attributes
        
        if let dragBehavior = self.dragBehavior {
            self.animator.removeBehavior(dragBehavior)
        }
        
        dragBehavior = UIAttachmentBehavior(item: self.attachmentAttributes!,
                                              attachedToAnchor: point)
        self.animator.addBehavior(dragBehavior!)
    }
    
    func changeSelectionState(item: Int) {
        if let dragBehavior = self.dragBehavior {
            self.animator.removeBehavior(dragBehavior)
        }
        self.selected = !self.selected
        if let dragBehavior = self.dragBehavior {
            self.animator.removeBehavior(dragBehavior)
        }
        
        if self.selected {
            self.collapseLayoutForSelectedItem(item: item)
        } else {
            self.expandLayoutForSelectedItem(item: item)
        }
    }
    
    
    
    func updateDragLocation(_ point: CGPoint) {
        guard let dragBehavior = self.dragBehavior else {
            return
        }
        dragBehavior.anchorPoint = point
    }
    
    
    // MARK:- overrides
    override func prepare() {
        guard let collectionView = self.collectionView,
                let delegate = self.delegate else {
            return
        }
        
        assert(collectionView.numberOfSections == 1, "Circular layout only supports 1 section")
        
        let numberOfItemsInCollectionView = collectionView.numberOfItems(inSection: 0)
        
        //find angle between items
        let angle: CGFloat = CGFloat(Double.pi) * 2.0 / CGFloat(numberOfItemsInCollectionView)
        
        let o = CGPoint(x: collectionView.bounds.midX,
                        y: collectionView.bounds.midY)
        let itemSize = delegate.sizeForCollectionViewCells(collectionView)
        let radius: CGFloat = (
            min(collectionView.frame.width, collectionView.frame.height) -
            max(itemSize.width, itemSize.height))/2.0
        

        
        if self.cachedAttributes.isEmpty {
            for idx in 0..<numberOfItemsInCollectionView {
                let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: idx, section: 0))
                attributes.frame.size = itemSize
                
                if cachedAttributes.isEmpty {
                    attributes.center = CGPoint(x: o.x - radius, y: o.y)
                } else {
                    let p = cachedAttributes.last!.center
                    let newX = cos(angle) * (p.x - o.x) - sin(angle) * (p.y - o.y) + o.x
                    let newY = sin(angle) * (p.x - o.x) + cos(angle) * (p.y - o.y) + o.y
                    let center = CGPoint(x: newX, y: newY)
                    
                    attributes.center = center
                }
                self.cachedAttributes.append(attributes)
                
                if self.isFirstLoad {
                    self.attributeValuesAtFirstLoad = self.cachedAttributes
                }
                print(attributes.center)
            }
            
            if self.trainBehavior == nil {
                self.trainBehavior = CjCoaxTrainAttachmentBehavior(items: self.cachedAttributes,
                                              center: o,
                                              radius: radius)
            }
            
            
        
            if self.animator.behaviors.contains(self.trainBehavior!) {
               self.animator.removeBehavior(self.trainBehavior!)
            }
            self.animator.addBehavior(self.trainBehavior!)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.cachedAttributes
    }
    
    // MARK:- private section
    fileprivate func getClosestAttributesToPoint(_ point: CGPoint) -> UICollectionViewLayoutAttributes {
        var minDistance = distanceBetweenPoint(point, point2: self.cachedAttributes[0].center)
        var minDistanceAttributes = self.cachedAttributes[0]
        
        for attributesIdx in 1..<self.cachedAttributes.count {
            let currentDistance = distanceBetweenPoint(point, point2: self.cachedAttributes[attributesIdx].center)
            if currentDistance < minDistance {
                minDistance = currentDistance
                minDistanceAttributes = self.cachedAttributes[attributesIdx]
            }
        }
        
        return minDistanceAttributes
    }
    
    fileprivate func distanceBetweenPoint(_ point1: CGPoint, point2: CGPoint) -> CGFloat {
        return sqrt(pow(point1.x - point2.x, 2) + pow(point1.y - point2.y, 2))
    }
    
    fileprivate func collapseLayoutForSelectedItem(item: Int) {
        guard let trainBehavior = self.trainBehavior else {
            return
        }
        let attributes = self.cachedAttributes[item]
        trainBehavior.disableTrainToAttributes()
        attributes.zIndex = 1
    }
    
    
    fileprivate func expandLayoutForSelectedItem(item: Int) {
        guard let trainBehavior = self.trainBehavior else {
            return
        }
        trainBehavior.enableTrainToAttributes()
    }
    
}



extension CjCoaxCircularLayout: UIDynamicAnimatorDelegate {
    public func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        print("paused")
        if !self.selected {
            self.trainBehavior?.logInfo()
            self.trainBehavior?.recreateAttachments()
        }
        
    }
}
