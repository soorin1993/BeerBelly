//
//  Brewery.swift
//  BeerBelly
//
//  Created by Soo Rin Park on 11/28/16.
//  Copyright © 2016 Soo Rin Park. All rights reserved.
//

import Foundation
import UIKit

class Brewery {

    var brewId: String = ""
    var brewName: String = ""
    var brewDesc: String = ""
    var brewStreet: String = ""
    var brewCityStateZip: String = ""
    var brewWeb: String = ""
    var brewPhone: String = ""
    var brewImg: UIImage?
    var brewLong: Double = 0.0
    var brewLat: Double = 0.0
    
    init(brewId: String, brewName: String, brewDesc: String, brewStreet: String, brewCityStateZip: String, brewWeb: String, brewPhone: String, brewImgURL: String, brewLong: Double, brewLat: Double) {
    
        self.brewId = brewId
        self.brewName = brewName
        self.brewDesc = brewDesc
        self.brewStreet = brewStreet
        self.brewCityStateZip = brewCityStateZip
        self.brewWeb = brewWeb
        self.brewPhone = brewPhone
        
        if let url = URL(string: brewImgURL) {
            if let data = try? Data(contentsOf: url) {
                self.brewImg = UIImage(data: data)

            } //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            else {
                self.brewImg = UIImage(named: "beer_icon")!
            }
        }
        self.brewLong = brewLong
        self.brewLat = brewLat
        
    }
}
