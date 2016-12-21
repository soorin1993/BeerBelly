//
//  ViewController.swift
//  BeerBelly
//
//  Created by Soo Rin Park on 11/17/16.
//  Copyright © 2016 Soo Rin Park. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

var styleList = [String]()

class MainViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    
    @IBOutlet weak var styleTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    
    @IBOutlet weak var drinkButton: UIButton!
    
    var selectedStyleId: String?
    
    let stateList = ["State",
                     "Alaska",
                  "Alabama",
                  "Arkansas",
                  "Arizona",
                  "California",
                  "Colorado",
                  "Connecticut",
                  "Delaware",
                  "Florida",
                  "Georgia",
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
                  "North Dakota",
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
                  "Rhode Island",
                  "South Carolina",
                  "South Dakota",
                  "Tennessee",
                  "Texas",
                  "Utah",
                  "Virginia",
                  "Vermont",
                  "Washington",
                  "Wisconsin",
                  "West Virginia",
                  "Wyoming"]
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true;
    }
    
    override func viewDidLoad() {
        
        styleTextField.delegate = self
        cityTextField.delegate = self
        stateTextField.delegate = self
        zipTextField.delegate = self
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        
        NotificationCenter.default.addObserver(self, selector:  #selector(MainViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        var styleURL = "http://api.brewerydb.com/v2/styles?key=" + BREWERYDB_API_KEY
        
        Alamofire.request(styleURL).responseJSON { response in
            
            switch response.result {
            case .success:
                
                if let jsonData = response.result.value {
                    
                    var jsonObject = JSON(jsonData)
                    jsonObject = jsonObject["data"]
                    
                    if jsonObject == JSON.null {
//                        let alert = UIAlertController(title: "Error", message: "No breweries were found.", preferredStyle: UIAlertControllerStyle.alert)
//                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
//                            self.navigationController?.popViewController(animated: true)
//                        }))
//                        self.present(alert, animated: true, completion: nil)
                        print("styles couldnt load")
                    }
                    
                    //print(jsonObject)
                    styleList.append("Choose a style")
                    
                    for (key,styleItem):(String, JSON) in jsonObject {
                        let styleName = styleItem["name"].stringValue
                        styleList.append(styleName)
                    }
                    
                }
                
            case .failure(let error):
//                let alert = UIAlertController(title: "Error", message: String(describing: error), preferredStyle: UIAlertControllerStyle.alert)
//                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
//                    self.navigationController?.popViewController(animated: true)
//                }))
//                self.present(alert, animated: true, completion: nil)
                print("style failure")
            }
        }

        
        
        let phColor = UIColor(red:0.90, green:0.73, blue:0.44, alpha:1.0)
        
        styleTextField.attributedPlaceholder = NSAttributedString(string:"Choose a style",
                                                               attributes:[NSForegroundColorAttributeName: phColor])
        cityTextField.attributedPlaceholder = NSAttributedString(string:"City",
                                                                  attributes:[NSForegroundColorAttributeName: phColor])
        stateTextField.attributedPlaceholder = NSAttributedString(string:"State",
                                                                  attributes:[NSForegroundColorAttributeName: phColor])
        zipTextField.attributedPlaceholder = NSAttributedString(string:"Zipcode",
                                                                  attributes:[NSForegroundColorAttributeName: phColor])
        
        let stylePickerView = UIPickerView(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 200))
        let statePickerView = UIPickerView(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 200))
        
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
        
        
        cityTextField.addTarget(self, action: #selector(cityOrStateTextFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        stateTextField.addTarget(self, action: #selector(cityOrStateTextFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        zipTextField.addTarget(self, action: #selector(zipTextFieldDidChange(_:)), for: UIControlEvents.editingChanged)

        //cityTextField.addTarget(self, action: #selector(MainViewController.cityOrStateTextFieldDidChange(sender:)), for: UIControlEvents.editingChanged)

        
        //cityTextField.addTarget(self, action: Selector(("cityOrStateTextFieldDidChange:")), for: .editingChanged)
        //stateTextField.addTarget(self, action: Selector(("cityOrStateTextFieldDidChange:")), for: .editingChanged)
        //zipTextField.addTarget(self, action: Selector(("zipTextFieldDidChange:")), for: .editingChanged)
    }
    
    func cityOrStateTextFieldDidChange(_ textField: UITextField){
        
        print("citystatechange")
        
    }
    
    func zipTextFieldDidChange(_ textField: UITextField){
        
        print("zipchange")
        
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
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
            selectedStyleId = String(row)
        }
        
        if pickerView.tag == 2 {
            stateTextField.text = stateList[row]
        }
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if zipTextField.text == "" && cityTextField.text == "" && stateTextField.text == "" {
            return true
        }
        
        else if zipTextField.text != "" {
            return true
        }
            
        else {
            if cityTextField.text != "" && stateTextField.text != "" {
                return true
            }
            else {
                let alert = UIAlertController(title: "Error", message: "Please enter both city and state for a city-wide search.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in return false }))
                present(alert, animated: true, completion: nil)
                return false
            }
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainToBrewSegue" {
            let brewViewController = segue.destination as! BrewViewController;
            
            brewViewController.selectedStyleId = selectedStyleId
            print(selectedStyleId)
            brewViewController.cityText = cityTextField.text
            brewViewController.stateText = stateTextField.text
            brewViewController.zipText = zipTextField.text
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func keyboardWillShow(notification: NSNotification) {
        print("up")
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        print("down")
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }

}

