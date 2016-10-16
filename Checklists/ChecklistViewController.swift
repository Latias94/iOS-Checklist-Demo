//
//  ViewController.swift
//  Checklists
//
//  Created by 庄鸣真 on 2016/9/23.
//  Copyright © 2016年 Frank Zhuang. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
//    var items: [ChecklistItem]
    var checklist: Checklist!
    
    //自动从stroyboard读取
//    required init?(coder aDecoder: NSCoder) {
////        items = [ChecklistItem]()//初始化
//        super.init(coder: aDecoder)
////        loadChecklistItems()
//        
////        print("Documents folder is \(documentsDirectory())")
////        print("Data file path is \(dataFilePath())")
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //这里的checklist是从prepare中的sender传送过来的,title就是标题变量，直接赋值修改。
        title = checklist.name
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //告诉这个UITableView界面上共有多少个row
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    //viewController是数据源，需要的时候再按方法取数据
    //根据UITableView和cell索引值返回UITableViewCell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath) //精准定位！
        let item = checklist.items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
    
    //点击row触发事件
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {//根据行找到cell
            let item = checklist.items[indexPath.row]
            item.toggleChecked() //改变状态尽量在对象类中创建方法完成
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true) //取消选择row 灰行变白
//        saveChecklistItems()
    }
    
    //删除行 同时删除数据和行
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        checklist.items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
//        saveChecklistItems()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            //有Navigation Controller 包着
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self //接收delegate
        } else if segue.identifier == "EditItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
    
    //根据每一项的checked属性控制cell中的✓
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        label.textColor = view.tintColor
        if item.checked {
//            cell.accessoryType = .checkmark
            label.text = "√"
        } else {
//            cell.accessoryType = .none
            label.text = ""
        }
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem){
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = "\(item.text)"
    }
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        dismiss(animated: true, completion: nil)
//        saveChecklistItems()
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = checklist.items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        dismiss(animated: true, completion: nil)
//        saveChecklistItems()
    }
    
//    func documentsDirectory() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return paths[0]
//    }
//    
//    func dataFilePath() -> URL {
//        return documentsDirectory().appendingPathComponent("Checklists.plist")
//    }
//    
//    func saveChecklistItems() {
//        let data = NSMutableData()
//        let archiver = NSKeyedArchiver(forWritingWith: data) //创建plist文件
//        archiver.encode(items, forKey: "ChecklistItems")
//        archiver.finishEncoding()
//        data.write(to: dataFilePath(), atomically: true)
//    }
//    
//    func loadChecklistItems() {
//        let path = dataFilePath()
//        //读取Checklist.plist放进data try?是尝试创建Data对象
//        if let data = try? Data(contentsOf: path) {
//            
//            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
//            items = unarchiver.decodeObject(forKey: "ChecklistItems") as! [ChecklistItem]
//            
//            unarchiver.finishDecoding()
//        }
//    }
    
//    @IBAction func addItem() {
//        let newRowIndex = items.count
//        
//        let item = ChecklistItem()
//        item.text = "I am a new row"
//        item.checked = false
//        items.append(item)
//        
//        let indexPath = IndexPath(row: newRowIndex, section: 0)
//        let indexPaths = [indexPath]
//        tableView.insertRows(at: indexPaths, with: .automatic) //由于可以插入多行 所以是数组形式 “with: .automatic”是动画
//    }
    
}

