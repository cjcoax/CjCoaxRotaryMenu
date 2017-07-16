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
    fileprivate var attachmentsToAttbibuteLength: CGFloat?
    
    fileprivate let items: [UIDynamicItem]
    
    init(items: [UIDynamicItem], center: CGPoint, radius: CGFloat) {
        self.items = items
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
            snap.damping = 0.4
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
    func logInfo() {
        if let _ = self.attachmentsToAttbibuteLength {
            return
        }
        self.attachmentsToAttbibuteLength = self.attachmentsToAttributes[0].length
    }
    
    func disableTrainToAttributes() {

        for behavior in self.snapAttributesToOriginalCenters {
            if self.childBehaviors.contains(behavior) {
                self.removeChildBehavior(behavior)
            }
        }
        
        for attachmentToBehavior in self.attachmentsToAttributes {
//            attachmentToBehavior.length = 0
//            attachmentToBehavior.frequency = 1.2
//            attachmentToBehavior.damping = 0.5
            self.removeChildBehavior(attachmentToBehavior)
        }
        
        for behavior in self.attachmentsToCenter {
            behavior.length = 0.0
            behavior.frequency = 4.0//4.0
            behavior.damping = 0.00//0.9
        }
        
        print("func disableTrainToAttributes() {")
        for behavior in self.childBehaviors {
            print("id: \(behavior.value(forKey: "cjcoaxIdentifier") ?? "--")")
            if type(of: behavior) == CjCoaxAttachment.self {
                print("length: \((behavior as! CjCoaxAttachment).length)")
                print("anchor point: \((behavior as! CjCoaxAttachment).anchorPoint)")
            }
        }
    }
    
    
    func enableTrainToAttributes() {
        for behavior in self.snapAttributesToOriginalCenters {
            self.addChildBehavior(behavior)
        }
        
        for behavior in self.attachmentsToCenter {
            behavior.length = lengthFromCenter
            behavior.frequency = 0
            behavior.damping = 0
        }
        
//        for behavior in self.attachmentsToAttributes {
//            behavior.length = self.attachmentsToAttbibuteLength!
//            behavior.frequency = 0
//            behavior.damping = 0
//        }
//        for attachmentToAttribute in self.attachmentsToAttributes {
//            if let attachmentsToAttbibuteLength = self.attachmentsToAttbibuteLength {
//                attachmentToAttribute.length = attachmentsToAttbibuteLength
//            }
//            self.addChildBehavior(attachmentToAttribute)
//        }
        
        print("func enableTrainToAttributes() {")
        for behavior in self.childBehaviors {
            print("id: \(behavior.value(forKey: "cjcoaxIdentifier") ?? "--")")
        }
    }
    
    func recreateAttachments() {
        for snap in self.snapAttributesToOriginalCenters {
            if self.childBehaviors.contains(snap) {
                self.removeChildBehavior(snap)
            }
        }
        
        for attachment in self.attachmentsToAttributes {
            if self.childBehaviors.contains(attachment) {
                return
            }
            self.addChildBehavior(attachment)
//            attachmentToBehavior.length = 0
//            attachmentToBehavior.frequency = 1.2
//            attachmentToBehavior.damping = 0.5
        }
        
        print("func recreateAttachments() {")
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








