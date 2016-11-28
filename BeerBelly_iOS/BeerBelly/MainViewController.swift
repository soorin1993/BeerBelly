//
//  ViewController.swift
//  BeerBelly
//
//  Created by Soo Rin Park on 11/17/16.
//  Copyright © 2016 Soo Rin Park. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var styleTextField: UITextField!
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    
    @IBOutlet weak var drinkButton: UIButton!
    
    let styleList = ["something",
                     "other",
                     "than"]
    
    let stateList = ["Alaska",
                  "Alabama",
                  "Arkansas",
                  "American Samoa",
                  "Arizona",
                  "California",
                  "Colorado",
                  "Connecticut",
                  "District of Columbia",
                  "Delaware",
                  "Florida",
                  "Georgia",
                  "Guam",
                  "Hawaii",
                  "Iowa",
                  "Idaho",
                  "Illinois",
                  "Indiana",
                  "Kansas",
                  "Kentucky",
                  "Louisiana",
                  "Massachusetts",
                  "Maryland",
                  "Maine",
                  "Michigan",
                  "Minnesota",
                  "Missouri",
                  "Mississippi",
                  "Montana",
                  "North Carolina",
                  " North Dakota",
                  "Nebraska",
                  "New Hampshire",
                  "New Jersey",
                  "New Mexico",
                  "Nevada",
                  "New York",
                  "Ohio",
                  "Oklahoma",
                  "Oregon",
                  "Pennsylvania",
                  "Puerto Rico",
                  "Rhode Island",
                  "South Carolina",
                  "South Dakota",
                  "Tennessee",
                  "Texas",
                  "Utah",
                  "Virginia",
                  "Virgin Islands",
                  "Vermont",
                  "Washington",
                  "Wisconsin",
                  "West Virginia",
                  "Wyoming"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let phColor = UIColor(red:0.90, green:0.73, blue:0.44, alpha:1.0)
        
        styleTextField.attributedPlaceholder = NSAttributedString(string:"Choose a style",
                                                               attributes:[NSForegroundColorAttributeName: phColor])
        cityTextField.attributedPlaceholder = NSAttributedString(string:"City",
                                                                  attributes:[NSForegroundColorAttributeName: phColor])
        stateTextField.attributedPlaceholder = NSAttributedString(string:"State",
                                                                  attributes:[NSForegroundColorAttributeName: phColor])
        zipTextField.attributedPlaceholder = NSAttributedString(string:"Zipcode",
                                                                  attributes:[NSForegroundColorAttributeName: phColor])
        
        styleTextField.delegate = self
        stateTextField.delegate = self
        
        let stylePickerView = UIPickerView(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 250))
        let statePickerView = UIPickerView(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 250))
        
        stylePickerView.delegate = self
        statePickerView.delegate = self
        
        stylePickerView.tag = 1
        statePickerView.tag = 2
    
        styleTextField.inputView = stylePickerView
        stateTextField.inputView = statePickerView
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.blue
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MainViewController.donePicker))
        doneButton.tintColor = UIColor.darkGray
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MainViewController.donePicker))
        cancelButton.tintColor = UIColor.darkGray
        
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        styleTextField.inputAccessoryView = toolBar
        cityTextField.inputAccessoryView = toolBar
        stateTextField.inputAccessoryView = toolBar
        zipTextField.inputAccessoryView = toolBar

        drinkButton.layer.cornerRadius = 5
        drinkButton.contentEdgeInsets = UIEdgeInsetsMake(10.0, 30.0, 10.0, 30.0);
        
    }
    
    func donePicker() {
        
        styleTextField.resignFirstResponder()
        cityTextField.resignFirstResponder()
        stateTextField.resignFirstResponder()
        zipTextField.resignFirstResponder()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return false to ignore.
    {
        textField.resignFirstResponder()
        return true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return styleList.count
        }
        
        if pickerView.tag == 2 {
            return stateList.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return styleList[row]
        }
        
        if pickerView.tag == 2 {
            return stateList[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            styleTextField.text = styleList[row]
        }
        
        if pickerView.tag == 2 {
            stateTextField.text = stateList[row]
        }
    }

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

