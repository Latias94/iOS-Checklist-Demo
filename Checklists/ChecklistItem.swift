//
//  ChecklistItem.swift
//  Checklists
//
//  Created by 庄鸣真 on 2016/9/24.
//  Copyright © 2016年 Frank Zhuang. All rights reserved.
//

import Foundation
import UserNotifications
class ChecklistItem: NSObject, NSCoding {
    var text = ""
    var checked = false
    var dueDate = Date()
    var shouldRemind = false
    var itemID: Int
    
    func toggleChecked(){
        checked = !checked
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
        aCoder.encode(dueDate, forKey: "DueDate")
        aCoder.encode(shouldRemind, forKey: "ShouldRemind")
        aCoder.encode(itemID, forKey: "ItemID")
    }
    
    func scheduleNotification() {
        removeNotification()
        if shouldRemind && dueDate > Date() {
            // 1
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = text
            content.sound = UNNotificationSound.default()
            
            // 2 
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.month, .day, .hour, .minute], from: dueDate)
            // 3 
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            // 4 
            let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
            // 5
            let center = UNUserNotificationCenter.current()
            center.add(request)
        
            print("Scheduled notification \(request) for itemID \(itemID)")
        
        }
        
    }
    
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
    }
    
    //NSCoder protocol
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "Text") as! String
        checked = aDecoder.decodeBool(forKey: "Checked")
        dueDate = aDecoder.decodeObject(forKey: "DueDate") as! Date
        shouldRemind = aDecoder.decodeBool(forKey: "ShouldRemind")
        itemID = aDecoder.decodeInteger(forKey: "ItemID")
        super.init()
    }
    
    //just keep compiler happy....
    override init() {
        itemID = DataModel.nextChecklistItemID()
        super.init()
    }

    
    //用户删掉 item 或者删掉整个 checklist ,对象被删除了就移除通知
    deinit {
        removeNotification()
    }
}


