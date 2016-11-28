//
//  BrewTableViewCell.swift
//  BeerBelly
//
//  Created by Soo Rin Park on 11/27/16.
//  Copyright © 2016 Soo Rin Park. All rights reserved.
//

import UIKit

class BrewTableViewCell: UITableViewCell {

    
    @IBOutlet weak var someLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
