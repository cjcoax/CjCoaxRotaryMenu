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

class CjCoaxSnap: UISnapBehavior {
    var cjcoaxIdentifier: String?
}

class CjCoaxTrainAttachmentBehavior: UIDynamicBehavior {
    fileprivate var attachmentsToCenter = [CjCoaxAttachment]()
    fileprivate var attachmentsToAttributes = [CjCoaxAttachment]()
    fileprivate var snapAttributesToOriginalCenters = [CjCoaxSnap]()
    fileprivate var lengthFromCenter: CGFloat!
    fileprivate let toOtherIdPrefix = "toOther"
    fileprivate let toCenterIdPrefix = "toCenter"
    fileprivate let snapIdPrefix = "snapCenter"
    
    init(items: [UIDynamicItem], center: CGPoint, radius: CGFloat) {
        super.init()
        
        self.lengthFromCenter = radius
        
        
        //attach all items to center
        for (index, item) in items.enumerated() {
            let attachment = CjCoaxAttachment(item: item, attachedToAnchor: center)
            attachment.length = radius
            attachment.cjcoaxIdentifier = "\(toCenterIdPrefix)\(index)"
            self.attachmentsToCenter.append(attachment)
        
            //create snap attributes for when we 1.select an item, 2.trying to select again to go to full mode
            let snap = CjCoaxSnap(item: item, snapTo: item.center)
            snap.cjcoaxIdentifier = "\(snapIdPrefix)\(index)-\(item.center)"
            self.snapAttributesToOriginalCenters.append(snap)
            //but we are not adding it to child behavior yet
            
            self.addChildBehavior(attachment)
        }
        
        let gravity = CjCoaxGravity(items: items)
        gravity.cjcoaxIdentifier = "gravity"
        self.addChildBehavior(gravity)
        
        self.attachmentsToAttributes = self.attachToEachOther(items: items)
        for attachmentToAttribute in self.attachmentsToAttributes {
            self.addChildBehavior(attachmentToAttribute)
        }
        
    }
    
    // MARK:- public methods
    func disableTrainToAttributes() {

        for behavior in self.snapAttributesToOriginalCenters {
            if self.childBehaviors.contains(behavior) {
                self.removeChildBehavior(behavior)
            }
        }
        
        for attachmentToBehavior in self.attachmentsToAttributes {
            self.removeChildBehavior(attachmentToBehavior)
        }
        
        for behavior in self.attachmentsToCenter {
            behavior.length = 0.0
            behavior.frequency = 1.2
            behavior.damping = 0.5
        }
    }
    
    
    func enableTrainToAttributes() {
        
        for behavior in self.attachmentsToAttributes {
            self.addChildBehavior(behavior)
        }
        
        print("snap behaviors")
        for behavior in self.snapAttributesToOriginalCenters {
            self.addChildBehavior(behavior)
            print("behavior: \(behavior.snapPoint)")
        }
        print("end snap behaviors")
        
        for behavior in self.attachmentsToCenter {
            behavior.length = lengthFromCenter
            behavior.frequency = 0
            behavior.damping = 0
        }
        
        for behavior in self.childBehaviors {
            print("id: \(behavior.value(forKey: "cjcoaxIdentifier") ?? "--")")
        }
    }
    
    
    
    // MARK:- private methids
    fileprivate func attachToEachOther(items: [UIDynamicItem]) -> [CjCoaxAttachment] {
        var result = [CjCoaxAttachment]()
        //attach all items to each other (train behavior)
        for idx in 0..<items.count-1 {
            let attachment = CjCoaxAttachment(item: items[idx], attachedTo: items[idx+1])
            attachment.cjcoaxIdentifier = "\(toOtherIdPrefix)->\(idx)-to-\(idx+1)"
            result.append(attachment)
        }
        
        if let firstItem = items.first, let lastItem = items.last {
            let lastAttachment = CjCoaxAttachment(item: lastItem, attachedTo: firstItem)
            lastAttachment.cjcoaxIdentifier = "\(toOtherIdPrefix)->\(items.count-1)-to-\(0)"
            result.append(lastAttachment)
        }
        
        return result
    }
}








