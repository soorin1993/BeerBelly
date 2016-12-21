//
//  BeerTableViewCell.swift
//  BeerBelly
//
//  Created by Soo Rin Park on 12/13/16.
//  Copyright © 2016 Soo Rin Park. All rights reserved.
//

import UIKit

class BeerTableViewCell: UITableViewCell {

    @IBOutlet weak var cell_beerName: UILabel!
    @IBOutlet weak var cell_beerStyle: UIButton!
    @IBOutlet weak var cell_beerDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
