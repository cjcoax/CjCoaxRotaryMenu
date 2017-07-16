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
    fileprivate var attachmentsToOriginalCenters = [CjCoaxAttachment]()
    fileprivate var gravityAttribute: CjCoaxGravity!
    
    fileprivate var lengthFromCenter: CGFloat!
    fileprivate let toOtherIdPrefix = "toOther"
    fileprivate let toCenterIdPrefix = "toCenter"
    fileprivate let snapIdPrefix = "snapCenter"
    fileprivate let toOriginalCenterPrefix = "toOriginalCenter"
    
    
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
            snap.damping = 0.6
            self.snapAttributesToOriginalCenters.append(snap)
            //but we are not adding it to child behavior yet
            
            
            let attachmentToOriginalCenter = CjCoaxAttachment(item: item, attachedToAnchor: item.center)
            attachmentToOriginalCenter.cjcoaxIdentifier = "\(toOriginalCenterPrefix)\(index)-\(item.center)"
            attachmentToOriginalCenter.length = 0.0
            attachmentToOriginalCenter.frequency = 2.0
            attachmentToOriginalCenter.damping = 0.8
            self.attachmentsToOriginalCenters.append(attachmentToOriginalCenter)
            
            self.addChildBehavior(attachment)
        
        }
        
        self.gravityAttribute = CjCoaxGravity(items: items)
        self.gravityAttribute.cjcoaxIdentifier = "gravity"
        self.addChildBehavior(self.gravityAttribute)
        
        self.attachmentsToAttributes = self.attachToEachOther(items: items)
        for attachmentToAttribute in self.attachmentsToAttributes {
            self.addChildBehavior(attachmentToAttribute)
        }
        
        
        
    }
    
    // MARK:- public methods
    func logInfo() {
        

    }
    
    
    /**
     disables train attributes so items will attach to center
     */
    func disableTrainToAttributes() {
        
        //remove any snap
//        for behavior in self.snapAttributesToOriginalCenters {
//            if self.childBehaviors.contains(behavior) {
//                self.removeChildBehavior(behavior)
//            }
//        }
        
        
        for attachment in self.attachmentsToOriginalCenters {
            self.removeChildBehavior(attachment)
        }
        
        for attachmentToBehavior in self.attachmentsToAttributes {
            self.removeChildBehavior(attachmentToBehavior)
        }
        
        for behavior in self.attachmentsToCenter {
            behavior.length = 0.0
            behavior.frequency = 5.0//4.0//4.0
            behavior.damping = 0.4//0.1//0.9
        }
        
        print("func disableTrainToAttributes() {")
        for behavior in self.childBehaviors {
            print("\(behavior.value(forKey: "cjcoaxIdentifier") ?? "--")")
            if type(of: behavior) == CjCoaxAttachment.self {
                print("length: \((behavior as! CjCoaxAttachment).length)")
                print("anchor point: \((behavior as! CjCoaxAttachment).anchorPoint)")
            }
        }
    }
    
    
    /*
     enableTrainToAttributes along with recreateAttachments are used to re-enable train around a center
     */
    func enableTrainToAttributes() {
//        for behavior in self.snapAttributesToOriginalCenters {
//            self.addChildBehavior(behavior)
//        }
        
        for behavior in self.attachmentsToCenter {
            self.removeChildBehavior(behavior)
        }
        
        self.removeChildBehavior(self.gravityAttribute)
        
        
        for behavior in self.attachmentsToOriginalCenters {
            self.addChildBehavior(behavior)
        }
        
        
        
        
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
        
        for behavior in self.attachmentsToOriginalCenters {
            if self.childBehaviors.contains(behavior) {
                self.removeChildBehavior(behavior)
            }
        }
        
        
        for attachment in self.attachmentsToAttributes {
            if self.childBehaviors.contains(attachment) {
                return
            }
            self.addChildBehavior(attachment)
        }
        
        for behavior in self.attachmentsToCenter {
            behavior.length = lengthFromCenter
            behavior.frequency = 0
            behavior.damping = 0
            self.addChildBehavior(behavior)
        }
        
        self.addChildBehavior(self.gravityAttribute)
        
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








