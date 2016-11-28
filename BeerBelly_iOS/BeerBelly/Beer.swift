//
//  Beer.swift
//  BeerBelly
//
//  Created by Soo Rin Park on 11/28/16.
//  Copyright © 2016 Soo Rin Park. All rights reserved.
//

import Foundation

class Beer {
    
    var beerId: String
    var beerName: String
    var beerStyle: String
    var beerDesc: String?
    
    init(beerId: String, beerName: String, beerStyle: String, beerDesc: String?) {
    
        self.beerId = beerId
        self.beerName = beerName
        self.beerStyle = beerStyle
        self.beerDesc = beerDesc
    
    }
}
