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
    var beerSRM: Int
    
    init(beerId: String, beerName: String, beerStyle: String, beerDesc: String?, beerSRM: Int) {
    
        self.beerId = beerId
        self.beerName = beerName
        self.beerStyle = beerStyle
        self.beerDesc = beerDesc
        self.beerSRM = beerSRM
    }
}
