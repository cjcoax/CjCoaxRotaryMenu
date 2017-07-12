//
//  CjCoaxTrainAttachmentBehavior.swift
//  CjCoaxRotaryMenu
//
//  Created by Amir Rezvani on 7/8/17.
//  Copyright © 2017 Amir Rezvani. All rights reserved.
//

import UIKit

class CjCoaxAttachment: UIAttachmentBehavior {
    var cjcoaxIdentifier: String?
}

class CjCoaxGravity: UIGravityBehavior {
    var cjcoaxIdentifier: String?
}

class CjCoaxTrainAttachmentBehavior: UIDynamicBehavior {
    fileprivate var attachmentsToCenter = [CjCoaxAttachment]()
    fileprivate var attachmentsToAttributes = [CjCoaxAttachment]()
    fileprivate var lengthFromCenter: CGFloat!
    fileprivate let toOtherIdPrefix = "toOther"
    fileprivate let toCenterIdPrefix = "toCenter"
    
    
    init(items: [UIDynamicItem], center: CGPoint, radius: CGFloat) {
        super.init()
        
        self.lengthFromCenter = radius
        
        
        //attach all items to center
        for (index, item) in items.enumerated() {
            let attachment = CjCoaxAttachment(item: item, attachedToAnchor: center)
            attachment.length = radius
            attachment.cjcoaxIdentifier = "\(toCenterIdPrefix)\(index)"
            self.attachmentsToCenter.append(attachment)
            self.addChildBehavior(attachment)
        }
        
        //attach all items to each other (train behavior)
        for idx in 0..<items.count-1 {
            let attachment = CjCoaxAttachment(item: items[idx], attachedTo: items[idx+1])
            attachment.cjcoaxIdentifier = "\(toOtherIdPrefix)\(idx)-\(idx+1)"
            self.attachmentsToAttributes.append(attachment)
            self.addChildBehavior(attachment)
        }
        
        if let firstItem = items.first, let lastItem = items.last {
            let lastAttachment = CjCoaxAttachment(item: lastItem, attachedTo: firstItem)
            lastAttachment.cjcoaxIdentifier = "\(toOtherIdPrefix)\(items.count-1)-\(0)"
            self.attachmentsToAttributes.append(lastAttachment)
            self.addChildBehavior(lastAttachment)
        }
        
        print("followings are active attachments to other at the time of making")
        for attachment in self.attachmentsToAttributes {
            print(attachment.cjcoaxIdentifier ?? "--")
        }
        print("above are active attachments to other at the time of making")
        
        
        let gravity = CjCoaxGravity(items: items)
        gravity.cjcoaxIdentifier = "gravity"
        self.addChildBehavior(gravity)
    }
    
    
    func disableTrainToAttributes(selectedAttributeIndex: Int) {
        print("removing following behaviors")
        
        for behavior in self.attachmentsToAttributes {
            print(behavior.cjcoaxIdentifier ?? "--")
            self.removeChildBehavior(behavior)
        }
        print("removed above behaviors")
        
        
        for behavior in self.attachmentsToCenter {
            behavior.length = 0.2
            behavior.frequency = 2.0
            behavior.damping = 0.3
        }
        
        print("below are active behaviors")
        for behavior in self.childBehaviors {
            print(behavior.value(forKey: "cjcoaxIdentifier") ?? "--")
        }
        print("above are active behaviors")
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








