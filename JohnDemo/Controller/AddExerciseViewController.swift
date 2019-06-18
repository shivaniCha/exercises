//
//  addExerciseViewController.swift
//  JohnDemo
//
//  Created by mac_5 on 18/06/19.
//  Copyright © 2019 mac_5. All rights reserved.
//

import UIKit
import iOSDropDown

protocol addExerciseViewControllerDelegate: class {
    func addExerciseViewController( didAddExecise index: Int)
}

class AddExerciseViewController: UIViewController {
    
    var excerciseDelegate: addExerciseViewControllerDelegate?
    var DictItems = [String : Any]()
    
    @IBOutlet weak var selectTypeTextField: DropDown!
    @IBOutlet weak var titalLabel: UILabel!

    var selectedIndex = Int()
    var titleExcercise : String = ""
    var indexCount : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectTypeTextField.isSearchEnable = false
        
        if UserDefaults.standard.value(forKey: "SetDataArray") != nil {
            DictItems = UserDefaults.standard.value(forKey: "SetDataArray") as! [String:Any]
        }
        managePopup()
        
        if UserDefaults.standard.object(forKey: titleExcercise) == nil{
            UserDefaults.standard.set(1, forKey: titleExcercise)
        }
        
        titalLabel.text = "Set #\(indexCount)"
    }
    
    //MARK: Manage Popup
    func managePopup(){
        selectTypeTextField.optionArray = ["Regular Set", "Warm-up Set"]
        selectTypeTextField.optionIds = [1,23,54,22]
        selectTypeTextField.rowBackgroundColor = UIColor.white
        selectTypeTextField.selectedRowColor = UIColor.lightGray
        
        selectTypeTextField.didSelect{(selectedText , index ,id) in
            self.selectTypeTextField.text = "\(selectedText)"
        }
    }
    
    //MARK: Button Event
    @IBAction func addSetAction(_ sender: Any) {
        var selectedArray = [String]()
        
        //Validate text empty
        if self.selectTypeTextField.text != ""{
            let title : Int = UserDefaults.standard.object(forKey: titleExcercise) as! Int
            UserDefaults.standard.set(title + 1, forKey: titleExcercise)
            
            if DictItems["\(selectedIndex)"] != nil {
                selectedArray = DictItems["\(selectedIndex)"] as! [String]
                if self.selectTypeTextField.text == "Regular Set" {
                    selectedArray.append("R,Set #\(title)")
                }else{
                    selectedArray.insert("W,Set #\(title)", at: 0)
                }
                
                DictItems.updateValue(selectedArray, forKey: "\(selectedIndex)")
            }else{
                if self.selectTypeTextField.text == "Regular Set" {
                    selectedArray.append("R,Set #\(title)")
                }else{
                    selectedArray.append("W,Set #\(title)")
                }
                DictItems["\(selectedIndex)"] = selectedArray
            }
            
            UserDefaults.standard.set(DictItems, forKey: "SetDataArray")
            
            excerciseDelegate?.addExerciseViewController(didAddExecise: selectedIndex)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func hideButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
