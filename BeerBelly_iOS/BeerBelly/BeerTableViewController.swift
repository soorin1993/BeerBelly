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
        
        var beerStyleId = Int((beerData?[indexPath.row].beerStyle)!)
        var beerStyleName = styleList[beerStyleId!]

        beerStyleList.append(beerStyleName)
        cell.cell_beerStyle.setTitle(beerStyleName, for: .normal)

        //var buttonTitle = cell.cell_beerStyle.titleLabel?.text
        cell.cell_beerStyle.tag = beerStyleId!
        cell.cell_beerStyle.addTarget(self, action: #selector(openURL), for: .touchUpInside)

        cell.cell_beerDesc.text = beerData?[indexPath.row].beerDesc

        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(red: 0.878, green: 0.686, blue: 0.345, alpha: 1)
        cell.selectedBackgroundView = bgColorView
        
        return cell
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
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    

    

}
