//
//  CjCoaxRotaryMenuDelegate.swift
//  CjCoaxRotaryMenu
//
//  Created by Amir Rezvani on 7/10/17.
//  Copyright © 2017 Amir Rezvani. All rights reserved.
//

import UIKit

/**
 pass desired diameter for each menu item to the control
 */
protocol CjCoaxRotaryMenuDelegate: class {
    func menuItemDiameter() -> CGFloat
}


extension CjCoaxRotaryMenuDelegate {
    func menuItemDiameter() -> CGFloat {
        return 50
    }
}
