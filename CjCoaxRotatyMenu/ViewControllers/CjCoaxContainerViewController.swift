//
//  ContainerViewController.swift
//  CjCoaxRotatyMenu
//
//  Created by Amir Rezvani on 7/8/17.
//  Copyright © 2017 Amir Rezvani. All rights reserved.
//

import UIKit

public class CjCoaxContainerViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var isFirstLoad = true
    var circularLayout: CjCoaxCircularLayout!
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.isFirstLoad {
            self.isFirstLoad = false
            self.circularLayout = self.collectionView.collectionViewLayout as! CjCoaxCircularLayout
            self.circularLayout.delegate = self
            self.circularLayout.invalidateLayout()
            self.collectionView.reloadData()
            
            let menuCellNib = UINib(nibName: CjCoaxConstants.NibNames.menuCell,
                                    bundle: Bundle(for: CjCoaxContainerViewController.self))
            
            self.collectionView.register(menuCellNib,
                forCellWithReuseIdentifier: CjCoaxConstants.reusableIdentifiers.menuReusableId)
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
        return UICollectionViewCell()
    }
}


extension CjCoaxContainerViewController: CjCoaxCircularLayoutDelegate {
    public func sizeForCollectionViewCells(_ collectionView: UICollectionView) -> CGSize {
        return CGSize(width: 20, height: 20)
    }
}
