//
//  MenuCell.swift
//  CjCoaxRotaryMenu
//
//  Created by Amir Rezvani on 7/8/17.
//  Copyright © 2017 Amir Rezvani. All rights reserved.
//

import UIKit


class CjCoaxMenuCell: UICollectionViewCell {
    // MARK:- private properties
    @IBOutlet private weak var menuImage: UIImageView!
    @IBOutlet weak var lblIdentifier: UILabel!
    
    
    // MARK:- public properties
    var cellImage: UIImage? {
        didSet {
            menuImage.image = cellImage
        }
    }
    
    // MARK:- overrides
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.random()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.makeCircular()
    }
    
    
    // MARK:- private methods
    func makeCircular() {
        self.layer.cornerRadius = min(self.frame.size.height, self.frame.size.width)/2.0
        self.clipsToBounds = true
        self.layer.borderColor = UIColor(red: 255.0/255.0, green: 115.0/255.0, blue: 0.0, alpha: 1.0).cgColor
        self.layer.borderWidth = 1.0
    }
}


extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}


















