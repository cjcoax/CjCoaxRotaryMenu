//
//  ContainerViewController.swift
//  CjCoaxRotaryMenu
//
//  Created by Amir Rezvani on 7/8/17.
//  Copyright © 2017 Amir Rezvani. All rights reserved.
//

import UIKit

public class CjCoaxContainerViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var isFirstLoad = true
    var circularLayout: CjCoaxCircularLayout!
    var selectedIndexPath: IndexPath?
    weak var delegate: CjCoaxRotaryMenuDelegate?
    
    // MARK:- life cycle
    public override func viewDidLoad() {
        super.viewDidLoad()

        //register menu cells
        let menuCellNib = UINib(nibName: CjCoaxConstants.NibNames.menuCell,
                                bundle: Bundle(for: CjCoaxContainerViewController.self))
        
        self.collectionView.register(menuCellNib,
                                     forCellWithReuseIdentifier: CjCoaxConstants.reusableIdentifiers.menuReusableId)
    }
    
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.isFirstLoad {
            self.isFirstLoad = false
            self.circularLayout = self.collectionView.collectionViewLayout as! CjCoaxCircularLayout
            self.circularLayout.delegate = self
            self.circularLayout.invalidateLayout()
            self.collectionView.reloadData()
        }
    }
    
    // MARK:- actions
    @IBAction internal func collectionViewPanned(sender: UIPanGestureRecognizer) {
        let point = sender.location(in: self.collectionView)
        switch sender.state {
        case .began:
            //TODO: make logic change for appropriate closest cell
            /*  selectedIndexPath = collectionView.indexPath(for: closestCell())!
                fileprivate func closestCell() -> UICollectionViewCell {
                    return collectionView.cellForItem(at: IndexPath(item: 0, section: 0))!
                }
             */
            self.selectedIndexPath = IndexPath(item: 0, section: 0)
            self.circularLayout.startDragging(point)
        case .changed:
            self.circularLayout.updateDragLocation(point)
        default:
            break
        }
    }
}


extension CjCoaxContainerViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            CjCoaxConstants.reusableIdentifiers.menuReusableId,
                                                      for: indexPath)
        
        return cell
    }
}


extension CjCoaxContainerViewController: CjCoaxCircularLayoutDelegate {
    //instruct size of the menu item to the collection view
    public func sizeForCollectionViewCells(_ collectionView: UICollectionView) -> CGSize {
        guard let diameter = self.delegate?.menuItemDiameter() else {
            return CGSize(width: 50, height: 50)
        }
        
        return CGSize(width: diameter , height: diameter)
    }
}
