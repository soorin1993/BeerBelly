//
//  MainView.swift
//  BeerBelly
//
//  Created by Soo Rin Park on 3/29/17.
//  Copyright © 2017 Soo Rin Park. All rights reserved.
//

import Foundation
import UIKit

class MainView: UIView {
    
    @IBOutlet weak var beerBellyIcon: UIImageView!
    @IBOutlet weak var beerBellyTitle: UILabel!

    @IBOutlet weak var styleTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipcodeTextField: UITextField!
    
    @IBOutlet weak var startButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       
    }
    
}
