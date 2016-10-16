//
//  Checklist.swift
//  Checklists
//
//  Created by 庄鸣真 on 2016/10/9.
//  Copyright © 2016年 Frank Zhuang. All rights reserved.
//

import UIKit

class Checklist: NSObject, NSCoding {
    var name = ""
    var items = [ChecklistItem]()
    var iconName: String

//    init(name: String) {
//        items = [ChecklistItem]()
//        self.name = name
//        iconName = "Appointments"
//        //不要icon可以=“No Icon”
//        super.init()
//    }

    convenience init(name: String) {
        self.init(name: name, iconName: "No Icon")
    }//直接调用下面的init 果然convenience!
    
    init(name: String, iconName: String) {
        items = [ChecklistItem]()
        self.name = name
        self.iconName = iconName
        super.init()
    }
    

    
    //从plist文件读取对象
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        items = aDecoder.decodeObject(forKey: "Items") as! [ChecklistItem]
        iconName = aDecoder.decodeObject(forKey: "IconName") as! String
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(items, forKey: "Items")
        aCoder.encode(iconName, forKey: "IconName")
        
    }
    
    func countUncheckedItems() -> Int {
        var count = 0
        for item in items where !item.checked {
            count += 1
        }
        return count
    }
}
