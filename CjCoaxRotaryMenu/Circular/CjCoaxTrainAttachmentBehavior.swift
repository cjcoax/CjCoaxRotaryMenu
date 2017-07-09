//
//  CjCoaxTrainAttachmentBehavior.swift
//  CjCoaxRotaryMenu
//
//  Created by Amir Rezvani on 7/8/17.
//  Copyright © 2017 Amir Rezvani. All rights reserved.
//

import UIKit

class CjCoaxTrainAttachmentBehavior: UIDynamicBehavior {
    fileprivate var attachmentsToCenter = [UIAttachmentBehavior]()
    fileprivate var attachmentsToAttributes = [UIAttachmentBehavior]()
    fileprivate var lengthFromCenter: CGFloat!
    
    init(items: [UIDynamicItem], center: CGPoint, radius: CGFloat) {
        super.init()
        
        self.lengthFromCenter = radius
        
        
        //attach all items to center
        for item in items {
            let attachment = UIAttachmentBehavior(item: item, attachedToAnchor: center)
            attachment.length = radius
            self.attachmentsToCenter.append(attachment)
            self.addChildBehavior(attachment)
        }
        
        //attach all items to each other (train behavior)
        for idx in 1..<items.count {
            let attachment = UIAttachmentBehavior(item: items[idx], attachedTo: items[idx-1])
            self.attachmentsToAttributes.append(attachment)
            self.addChildBehavior(attachment)
        }
        
        if let firstItem = items.first, let lastItem = items.last {
            let lastAttachment = UIAttachmentBehavior(item: firstItem, attachedTo: lastItem)
            self.addChildBehavior(lastAttachment)
        }
        
        let gravity = UIGravityBehavior(items: items)
        self.addChildBehavior(gravity)
    }
    
    
    func disableTrainToAttributes() {
        for behavior in self.attachmentsToAttributes {
            self.removeChildBehavior(behavior)
        }
        
        for behavior in self.attachmentsToCenter {
            behavior.length = 0
            behavior.frequency = 3.0
            behavior.damping = 0.8
        }
    }
    
    
    func enableTrainToAttributes() {
        for behavior in self.attachmentsToAttributes {
            self.addChildBehavior(behavior)
        }
        
        for behavior in self.attachmentsToCenter {
            behavior.length = lengthFromCenter
            behavior.frequency = 0
            behavior.damping = 0
        }
    }
}








