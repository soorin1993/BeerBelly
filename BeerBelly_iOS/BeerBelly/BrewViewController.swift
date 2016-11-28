//
//  BrewViewController.swift
//  BeerBelly
//
//  Created by Soo Rin Park on 11/27/16.
//  Copyright © 2016 Soo Rin Park. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire

let BREWERYDB_API_KEY = "607feb4f9ed4b2f7c22de45803eb238d" //dev
//let BREWERYDB_API_KEY = "fd9b5015d33721dd7bf301ea019b2fb9" //release

class BrewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var gmapView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var styleId: String?
    var cityText: String?
    var stateText: String?
    var zipText: String?
    
    var brewURL: String!
    var beerURL: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(styleId)
        print(cityText)
        print(stateText)
        print(zipText)
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: view.frame.width, height: 250), camera: camera)
        mapView.isMyLocationEnabled = true
        //gmapview = mapView
        gmapView.addSubview(mapView)
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    
        tableView.delegate = self
        tableView.dataSource = self
    
        checkFieldVals()
    }
    
    func checkFieldVals() {
        
        let baseURL = "http://api.brewerydb.com/v2/"
        
        if zipText != "" {
            brewURL = baseURL + "locations?key=" + BREWERYDB_API_KEY + "&postalCode=" + zipText!
        }
        
        else {
            if cityText != "" && stateText != "" {
            brewURL = baseURL + "locations?key=" + BREWERYDB_API_KEY + "&locality=" + cityText! + "&region=" + stateText!
            }
            else {
                let alert = UIAlertController(title: "Error", message: "Please enter both city and state for a city-wide search.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                    
                    self.navigationController?.popViewController(animated: true)
                    }
                ))
                self.present(alert, animated: true, completion: nil)
            }
        }

        print(brewURL)
  
    }
    
    func getBrewData() {
    
        Alamofire.request("https://httpbin.org/get").responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "brewTableViewCell", for: indexPath) as! BrewTableViewCell

        // Configure the cell...
        return cell
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
