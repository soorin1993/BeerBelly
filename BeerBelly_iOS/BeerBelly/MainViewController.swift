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
var availableList = [String]()
let stateDic = ["State": "",
                "AK": "Alaska",
                "AL": "Alabama",
                "AR": "Arkansas",
                "AS": "American Samoa",
                "AZ": "Arizona",
                "CA": "California",
                "CO": "Colorado",
                "CT": "Connecticut",
                "DC": "District of Columbia",
                "DE": "Delaware",
                "FL": "Florida",
                "GA": "Georgia",
                "GU": "Guam",
                "HI": "Hawaii",
                "IA": "Iowa",
                "ID": "Idaho",
                "IL": "Illinois",
                "IN": "Indiana",
                "KS": "Kansas",
                "KY": "Kentucky",
                "LA": "Louisiana",
                "MA": "Massachusetts",
                "MD": "Maryland",
                "ME": "Maine",
                "MI": "Michigan",
                "MN": "Minnesota",
                "MO": "Missouri",
                "MP": "Northern Mariana Islands",
                "MS": "Mississippi",
                "MT": "Montana",
                "NA": "National",
                "NC": "North Carolina",
                "ND": "North Dakota",
                "NE": "Nebraska",
                "NH": "New Hampshire",
                "NJ": "New Jersey",
                "NM": "New Mexico",
                "NV": "Nevada",
                "NY": "New York",
                "OH": "Ohio",
                "OK": "Oklahoma",
                "OR": "Oregon",
                "PA": "Pennsylvania",
                "PR": "Puerto Rico",
                "RI": "Rhode Island",
                "SC": "South Carolina",
                "SD": "South Dakota",
                "TN": "Tennessee",
                "TX": "Texas",
                "UT": "Utah",
                "VA": "Virginia",
                "VI": "Virgin Islands",
                "VT": "Vermont",
                "WA": "Washington",
                "WI": "Wisconsin",
                "WV": "West Virginia",
                "WY": "Wyoming"]

class MainViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    
    @IBOutlet weak var styleTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    
    @IBOutlet weak var drinkButton: UIButton!
    
    var selectedStyleId: String?
    var stateList = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        
        styleTextField.delegate = self
        cityTextField.delegate = self
        stateTextField.delegate = self
        zipTextField.delegate = self
        
        super.viewDidLoad()
        
        stateList = Array(stateDic.values)
        stateList = stateList.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }

        
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        
        NotificationCenter.default.addObserver(self, selector:  #selector(MainViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        var styleURL = baseURL + "styles?key=" + BREWERYDB_API_KEY
        
        Alamofire.request(styleURL).responseJSON { response in
            
            switch response.result {
            case .success:
                
                if let jsonData = response.result.value {
                    
                    var jsonObject = JSON(jsonData)
                    jsonObject = jsonObject["data"]
                    
                    if jsonObject == JSON.null {
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
                print("style failure")
            }
        }
        
        var availableURL = baseURL + "menu/beer-availability?key=" + BREWERYDB_API_KEY
        Alamofire.request(availableURL).responseJSON { response in
            
            switch response.result {
            case .success:
                
                if let jsonData = response.result.value {
                    
                    var jsonObject = JSON(jsonData)
                    jsonObject = jsonObject["data"]
                    
                    if jsonObject == JSON.null {
                        print("styles couldnt load")
                    }
                    
                    availableList.append("n/a")
                    for (key,availItem):(String, JSON) in jsonObject {
                        let availName = availItem["name"].stringValue
                        availableList.append(availName)
                    }
                    
                }
                
            case .failure(let error):
                print("style failure")
            }
        }

        
        
        //let phColor = UIColor(red:0.90, green:0.73, blue:0.44, alpha:1.0)
        let phColor = UIColor.amberBrownColor()
        
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
        toolBar.tintColor = UIColor(red: 178.0/255.0, green: 27.0/255.0, blue: 3.0/255.0, alpha: 1.0)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MainViewController.donePicker))
        doneButton.tintColor = UIColor(red: 178.0/255.0, green: 27.0/255.0, blue: 3.0/255.0, alpha: 1.0)
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MainViewController.donePicker))
        cancelButton.tintColor = UIColor(red: 178.0/255.0, green: 27.0/255.0, blue: 3.0/255.0, alpha: 1.0)

        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.barTintColor = UIColor(red: 255.0/255.0, green: 239.0/255.0, blue: 204.0/255.0, alpha:1.0)
        
        styleTextField.inputAccessoryView = toolBar
        cityTextField.inputAccessoryView = toolBar
        stateTextField.inputAccessoryView = toolBar
        zipTextField.inputAccessoryView = toolBar
        
        drinkButton.layer.cornerRadius = 5
        drinkButton.contentEdgeInsets = UIEdgeInsetsMake(10.0, 30.0, 10.0, 30.0);
        
        
        cityTextField.addTarget(self, action: #selector(cityTextFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        zipTextField.addTarget(self, action: #selector(zipTextFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
        cityTextField.addTarget(self, action: #selector(textFieldTouched(_:)), for: UIControlEvents.touchDown)
        stateTextField.addTarget(self, action: #selector(textFieldTouched(_:)), for: UIControlEvents.touchDown)
        zipTextField.addTarget(self, action: #selector(textFieldTouched(_:)), for: UIControlEvents.touchDown)

    }
    
    func textFieldTouched(_ textField: UITextField) {
        view.endEditing(true)
    }
    
    func cityTextFieldDidChange(_ textField: UITextField){
        
        if cityTextField.text! == "" {
            zipTextField.isUserInteractionEnabled = true
            zipTextField.alpha = 1
            UIView.performWithoutAnimation {
                drinkButton.setTitle("MY LOCATION", for: .normal)
                drinkButton.layoutIfNeeded()
            }

        }
        else {
            zipTextField.isUserInteractionEnabled = false
            zipTextField.alpha = 0.5
            UIView.performWithoutAnimation {
                drinkButton.setTitle("DRINK!", for: .normal)
                drinkButton.layoutIfNeeded()
            }
        }
        
    }
    
    func zipTextFieldDidChange(_ textField: UITextField){
        
        if zipTextField.text! == "" {
            cityTextField.isUserInteractionEnabled = true
            stateTextField.isUserInteractionEnabled = true
            cityTextField.alpha = 1
            stateTextField.alpha = 1
            UIView.performWithoutAnimation {
                drinkButton.setTitle("MY LOCATION", for: .normal)
                drinkButton.layoutIfNeeded()
            }
        }
        else {
            cityTextField.isUserInteractionEnabled = false
            stateTextField.isUserInteractionEnabled = false
            cityTextField.alpha = 0.5
            stateTextField.alpha = 0.5
            UIView.performWithoutAnimation {
                drinkButton.setTitle("DRINK!", for: .normal)
                drinkButton.layoutIfNeeded()
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func donePicker(sender: UITextField) {
        /*
        styleTextField.resignFirstResponder()
        stateTextField.resignFirstResponder()
        cityTextField.resignFirstResponder()
        zipTextField.resignFirstResponder()
        */
        view.endEditing(true)

 }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when "return" key pressed. return false to ignore.
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
            
            if stateTextField.text! == "State" {
                zipTextField.isUserInteractionEnabled = true
                zipTextField.alpha = 1
                UIView.performWithoutAnimation {
                    drinkButton.setTitle("MY LOCATION", for: .normal)
                    drinkButton.layoutIfNeeded()
                }
            }
            else {
                zipTextField.isUserInteractionEnabled = false
                zipTextField.alpha = 0.5
                UIView.performWithoutAnimation {
                    drinkButton.setTitle("DRINK!", for: .normal)
                    drinkButton.layoutIfNeeded()
                }
            }
            
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
            brewViewController.cityText = cityTextField.text
            var stateText = stateTextField.text?.replacingOccurrences(of: " ", with: "+")

            brewViewController.stateText = stateText
            brewViewController.zipText = zipTextField.text
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }

}


