//
//  MenuCell.swift
//  CjCoaxRotatyMenu
//
//  Created by Amir Rezvani on 7/8/17.
//  Copyright © 2017 Amir Rezvani. All rights reserved.
//

import UIKit


class CjCoaxMenuCell: UICollectionViewCell {
    // MARK:- private properties
    @IBOutlet private weak var menuImage: UIImageView!
    
    // MARK:- public properties
    var cellImage: UIImage? {
        didSet {
            menuImage.image = cellImage
        }
    }
    
    // MARK:- overrides
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.black
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.makeCircular()
    }
    
    
    // MARK:- private methods
    func makeCircular() {
        self.layer.cornerRadius = min(self.frame.size.height,             self.frame.size.width)
        self.clipsToBounds = true
        self.layer.borderColor = UIColor(red: 255.0/255.0, green: 115.0/255.0, blue: 0.0, alpha: 1.0).cgColor
        self.layer.borderWidth = 1.0
    }
}





















