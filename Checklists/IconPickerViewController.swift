//
//  IconPickerViewController.swift
//  Checklists
//
//  Created by 庄鸣真 on 2016/10/11.
//  Copyright © 2016年 Frank Zhuang. All rights reserved.
//

import UIKit

//协议就是为了和别人交流
protocol IconPickerViewControllerDelegate: class {
    func iconPicker(_picker: IconPickerViewController, didPick iconName: String)
}

class IconPickerViewController: UITableViewController {
    weak var delegate: IconPickerViewControllerDelegate?
    
    let icons = [ "No Icon", "Appointments", "Birthdays", "Chores", "Drinks", "Folder", "Groceries", "Inbox", "Photos", "Trips" ]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)
        let iconName = icons[indexPath.row]
        cell.textLabel!.text = iconName
        cell.imageView!.image = UIImage(named: iconName)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = delegate {
            let iconName = icons[indexPath.row]
            //delegate 回传选择的图片名
            delegate.iconPicker(_picker: self, didPick: iconName)
        }
    }
}
