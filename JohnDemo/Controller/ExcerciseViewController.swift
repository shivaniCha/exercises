//
//  ViewController.swift
//  JohnDemo
//
//  Created by mac_5 on 15/06/19.
//  Copyright © 2019 mac_5. All rights reserved.
//

import UIKit

class ExcerciseViewController: UIViewController {

    @IBOutlet weak var dataTableView: UITableView!
    
    var excerciseItems : [String] = []
    var DictItems = [String : Any]()
    var selectedIndex = Int()
    var selectedType = String()
    var selectedSection : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.value(forKey: "ExcerciseArray") != nil {
            excerciseItems = UserDefaults.standard.value(forKey: "ExcerciseArray") as! [String]
        }else if UserDefaults.standard.value(forKey: "SetDataArray") != nil {
            DictItems = UserDefaults.standard.value(forKey: "SetDataArray") as! [String:Any]
        }
        dataTableView.reloadData()
    }
    
    //MARK: Supproted Function
    func manageData(index : Int) -> [String]{
        
        if UserDefaults.standard.value(forKey: "SetDataArray") as? [String : Any] != nil {
            var listArray = UserDefaults.standard.value(forKey: "SetDataArray") as! [String : Any]
            if listArray["\(index)"] != nil {
                return listArray["\(index)"] as! [String]
            }
        }
        return [String]()
    }
    func deleteDataManager(index : Int,array: [String:Any]){
        (selectedSection == index) ? (selectedSection = -1) : (selectedSection = selectedSection)
        
        var dataArray = array
        for index in 0..<array.count{
            if let value = array[String(index + 1)] {
                if (value as AnyObject).count != 0{
                    dataArray[String(index)] = value
                    dataArray[String(index+1)] = [String]()
                }
            }
        }
        UserDefaults.standard.set(dataArray, forKey: "SetDataArray")
    }
    
    //MARK: Button Event
    @IBAction func addExcercise(_ sender: Any) {
        
        let title : Int = UserDefaults.standard.object(forKey: "addexcericese") as! Int
        UserDefaults.standard.set(title + 1, forKey: "addexcericese")
        
        //Add Excercise here
        excerciseItems.append("Excercise #\(title)")
        
        UserDefaults.standard.set(excerciseItems, forKey: "ExcerciseArray")
        if UserDefaults.standard.value(forKey: "ExcerciseArray") != nil {
            excerciseItems = UserDefaults.standard.value(forKey: "ExcerciseArray") as! [String]
        }
        if excerciseItems.count > 0 {
            dataTableView.isHidden = false
        }else{
            dataTableView.isHidden = true
        }
        dataTableView.reloadData()
    }

     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "add" {
            let data = manageData(index: Int(selectedIndex))
            
            let view = segue.destination as? AddExerciseViewController
            view?.selectedIndex = selectedIndex
            view?.titleExcercise = excerciseItems[Int(selectedIndex)]
            view?.indexCount = data.count + 1
            view?.excerciseDelegate = self
        }
     }
}



extension ExcerciseViewController : UITableViewDelegate, UITableViewDataSource{
    //MARK:- Tableview Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        (excerciseItems.count == 0) ? (tableView.isHidden = true) : (tableView.isHidden = false)
        
        return excerciseItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "section") as! DataTableViewCell
        
        cell.deleteButton.tag = section
        cell.setTypeButton.tag = section
        cell.expandButton.tag = section
        
        cell.setName.text = "Excericse #\(section+1)"
        cell.setTypeButton.addTarget(self, action: #selector(addItemButton(_:)), for: .touchUpInside)
        cell.deleteButton.addTarget(self, action: #selector(deleteExcerciseButton(_:)), for: .touchUpInside)
        cell.expandButton.addTarget(self, action: #selector(expandButton(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedSection ==  section{
            
            return (manageData(index: section).count == 0) ? 1 : manageData(index: section).count
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = manageData(index: indexPath.section)
        
        var identifierCell = "cell"
        if data.count == 0{
            identifierCell = "nodata"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifierCell) as! SetListTableViewCell
        
        if data.count != 0{
            let valueArray = data[indexPath.row].split(separator: ",")
            
//            let value = String(valueArray[1])
            cell.setLabel.text = "set #\(indexPath.row+1)"
            if valueArray[0] == "W"{
                cell.typeView.backgroundColor = UIColor.orange
            }else{
                cell.typeView.backgroundColor = UIColor.blue
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var SetListArray = [String:Any]()
        var valueArray = [String]()
        if UserDefaults.standard.value(forKey: "SetDataArray") as? [String : Any] != nil {
            SetListArray = UserDefaults.standard.value(forKey: "SetDataArray") as! [String : Any]
            if SetListArray["\(indexPath.section)"] != nil {
                valueArray = SetListArray["\(indexPath.section)"] as! [String]
            }
        }
        
        //Hide button when no data cell
        if valueArray.count == 0 {
            return []
        }
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            valueArray.remove(at: indexPath.row)
            UserDefaults.standard.set([String(indexPath.section) : valueArray], forKey: "SetDataArray")
            
            self.dataTableView.reloadData()
        }
        
        let share = UITableViewRowAction(style: .normal, title: "Change Type") { (action, indexPath) in
            // share item at indexPath
            let type = valueArray[indexPath.row].split(separator: ",")
            
            valueArray.remove(at: indexPath.row)
            
            if type[0] == "R" {
                valueArray.insert("W,\(type[1])", at: 0)
            }else{
                valueArray.append("R,\(type[1])")
            }
            
            SetListArray[String(indexPath.section)] = valueArray
            UserDefaults.standard.set(SetListArray, forKey: "SetDataArray")
            self.dataTableView.reloadData()
        }
        
        share.backgroundColor = UIColor.orange
        
        return [delete, share]
    }
    
    @objc func addItemButton(_ sender:UIButton) {
        selectedIndex = sender.tag
        self.performSegue(withIdentifier: "add", sender: self)
    }
    
    @objc func deleteExcerciseButton(_ sender:UIButton) {
        
        excerciseItems.remove(at: sender.tag)
        UserDefaults.standard.set(excerciseItems, forKey: "ExcerciseArray")
        
        var SetListArray = [String:Any]()
        if UserDefaults.standard.value(forKey: "SetDataArray") as? [String : Any] != nil {
            SetListArray = UserDefaults.standard.value(forKey: "SetDataArray") as! [String : Any]
        }
        SetListArray[String(sender.tag)] = [String]()
        deleteDataManager(index: sender.tag,array: SetListArray)
        
        dataTableView.reloadData()

    }
    
    @objc func expandButton(_ sender:UIButton) {
        if selectedSection != sender.tag{
            selectedSection = sender.tag
        }else{
            selectedSection = -1
        }
        dataTableView.reloadData()
    }
}


extension ExcerciseViewController : addExerciseViewControllerDelegate{
     //MARK:- AddExercise delegate
    
    func addExerciseViewController( didAddExecise index: Int){
        selectedSection = index
        dataTableView.reloadData()
    }
}


class DataTableViewCell: UITableViewCell {
    //MARK:- DataTableViewCell
    
    @IBOutlet weak var setName: UILabel!
    @IBOutlet weak var setTypeButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var expandButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backView.layer.cornerRadius = 10.0
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOpacity = 0.5
        backView.layer.shadowOffset = .zero
        backView.layer.shadowRadius = 3
        
        setTypeButton.layer.cornerRadius = 5
        deleteButton.layer.cornerRadius = 5
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class SetListTableViewCell: UITableViewCell {
    //MARK:- SetListTableViewCell
    
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var typeView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
