//
//  BeerTableViewController.swift
//  BeerBelly
//
//  Created by Soo Rin Park on 12/13/16.
//  Copyright © 2016 Soo Rin Park. All rights reserved.
//

import UIKit

class BeerTableViewController: UITableViewController {

    var beerData: [Beer]?
    var selectedBeerName: String?
    var beerStyleList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100; //Set this to any value that works for you.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerData!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "beerTableViewCell", for: indexPath) as! BeerTableViewCell
        
        cell.cell_beerName.text = beerData?[indexPath.row].beerName
        
        if let beerStyleId = Int((beerData?[indexPath.row].beerStyle)!) {
            
            var beerStyleName = styleList[beerStyleId]
            beerStyleList.append(beerStyleName)
            cell.cell_beerStyle.setTitle(beerStyleName, for: .normal)
            
            cell.cell_beerStyle.tag = beerStyleId
            cell.cell_beerStyle.addTarget(self, action: #selector(openURL), for: .touchUpInside)

        }
        else {
            cell.cell_beerStyle.setTitle("Style Unknown", for: .normal)
        }
        
        cell.cell_beerDesc.text = beerData?[indexPath.row].beerDesc

        let templateImage = UIImage(named:"yes_beer")?.withRenderingMode(.alwaysTemplate)
        let srmVal = beerData?[indexPath.row].beerSRM
        cell.cell_beerIcon.image = templateImage
        cell.cell_beerIcon.tintColor = getBeerSRMColor(SRM: srmVal!)
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(red: 0.878, green: 0.686, blue: 0.345, alpha: 1)
        cell.selectedBackgroundView = bgColorView
        
        return cell
    }
    
    func getBeerSRMColor(SRM: Int) -> UIColor {
        
        var beerColor = UIColor()
        
        if (SRM == 0 || SRM == 1 || SRM == 2) {
            beerColor = UIColor.paleStrawColor()
        }
        
        else if (SRM == 3) {
            beerColor = UIColor.strawColor()
        }
        
        else if (SRM == 4) {
            beerColor = UIColor.paleGoldColor()
        }
        
        else if (SRM == 5 || SRM == 6) {
            beerColor = UIColor.deepGoldColor()
        }
        
        else if (SRM == 7 || SRM == 8 || SRM == 9) {
            beerColor = UIColor.paleAmberColor()
        }
        
        else if (SRM == 10 || SRM == 11 || SRM == 12) {
            beerColor = UIColor.mediumAmberColor()
        }
        
        else if (SRM == 13 || SRM == 14 || SRM == 15) {
            beerColor = UIColor.deepAmberColor()
        }
        
        else if (SRM == 16 || SRM == 17 || SRM == 18) {
            beerColor = UIColor.amberBrownColor()
        }

        else if (SRM == 19 || SRM == 20) {
            beerColor = UIColor.beerBrownColor()
        }
        
        else if (SRM >= 21 && SRM <= 24) {
            beerColor = UIColor.rubyBrownColor()
        }
        
        else if (SRM >= 25 && SRM <= 30) {
            beerColor = UIColor.deepBrownColor()
        }
            
        else if (SRM >= 31 && SRM <= 40) {
            beerColor = UIColor.beerBlackColor()
        }
            
        else {
            return UIColor.gray
        }
        
        return beerColor
    }

    func openURL(sender: UIButton) {
        selectedBeerName = styleList[sender.tag]
        performSegue(withIdentifier: "beerToWebSegue", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "beerToWebSegue") {
            let webViewController = segue.destination as! WebViewController
            webViewController.beerStyleName = selectedBeerName
        }
    }
}

public extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

