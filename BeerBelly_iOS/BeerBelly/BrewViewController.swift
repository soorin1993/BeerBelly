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
import SwiftyJSON

let BREWERYDB_API_KEY = "607feb4f9ed4b2f7c22de45803eb238d" //dev
//let BREWERYDB_API_KEY = "fd9b5015d33721dd7bf301ea019b2fb9" //release

let baseURL = "http://api.brewerydb.com/v2/"

class BrewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, GMSMapViewDelegate {

    @IBOutlet weak var gmapView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    var mapView: GMSMapView!
    var didFindMyLocation = false
    var markers = [GMSMarker]()
    var bounds = GMSCoordinateBounds()
    var currentLocation: CLLocation!

    
    var styleId: String?
    var cityText: String?
    var stateText: String?
    var zipText: String?
    
    var brewURL: String!
    var beerURL: String!
    
    var brewData = [Brewery]()
    var beerData = [Beer]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: view.frame.width, height: 250), camera: camera)

        locationManager.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        locationManager.delegate = self
        mapView.settings.myLocationButton = true
        gmapView.addSubview(mapView)

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100; //Set this to any value that works for you.
        
        createBrewURL()
        getBrewData()
    
    }
    
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude:(location?.coordinate.longitude)!, zoom:14)
        mapView.animate(to: camera)
        self.locationManager.stopUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLocation = locationManager.location
            print(currentLocation.coordinate.longitude)
        }
        
        CLGeocoder().reverseGeocodeLocation(currentLocation, completionHandler: {
            (placemarks, error) -> Void in
            
            let placeMark = (placemarks?[0])! as CLPlacemark
            if let zip = placeMark.addressDictionary!["ZIP"] as? String {
                print(zip)
                self.zipText = zip
                
            }
            
        })
    }
    
    func fitToMarkers() {
        print(markers.count)
        for marker in markers {
            bounds = bounds.includingCoordinate(marker.position)
        }
        let update = GMSCameraUpdate.fit(bounds, withPadding: 50)
        mapView.animate(with: update)
    }
    
    func addMarker(longitude: Double, lattitude: Double, brewName: String) {
    
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lattitude, longitude: longitude)
        marker.title = brewName
        marker.map = mapView
        markers.append(marker)
    }
    
    func createBrewURL() {
        
        if zipText == "" && cityText == "" && stateText == "" {
            self.brewURL = baseURL + "locations?key=" + BREWERYDB_API_KEY + "&postalCode=" + self.zipText!
        }
        else if zipText != "" {
            brewURL = baseURL + "locations?key=" + BREWERYDB_API_KEY + "&postalCode=" + zipText!
        }
        else {
            if cityText != "" && stateText != "" {
            brewURL = baseURL + "locations?key=" + BREWERYDB_API_KEY + "&locality=" + cityText! + "&region=" + stateText!
            }
        }
        //print(brewURL)
        
    }
    
    func createBeerURL() {
    }
    
    func getBrewData() {
        
        Alamofire.request(brewURL).responseJSON { response in
            //print(response.request)  // original URL request
            //print(response.response) // HTTP URL response
            //print(response.data)     // server data
            //print(response.result)   // result of response serialization
            
            switch response.result {
            case .success:
        
                if let jsonData = response.result.value {
                    
                    var jsonObject = JSON(jsonData)
                    jsonObject = jsonObject["data"]
                    
                    if jsonObject == JSON.null {
                        let alert = UIAlertController(title: "Error", message: "No breweries were found.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
                            self.navigationController?.popViewController(animated: true)
                            }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    //print(jsonObject)
                    
                    for (key,brewItem):(String, JSON) in jsonObject {
                        
                        let brewStreet = brewItem["streetAddress"].stringValue
                        let brewCity = brewItem["locality"].stringValue
                        let brewState = brewItem["region"].stringValue
                        let brewZip = brewItem["postalCode"].stringValue
                        
                        let brewCityStateZip  = brewCity + ", " + brewState + " " + brewZip
                        
                        let brewPhone = brewItem["phone"].stringValue
                        let brewLong = brewItem["longitude"].doubleValue
                        let brewLat = brewItem["latitude"].doubleValue
                        
                        let brewObj = brewItem["brewery"]
                        
                        let brewName = brewObj["name"].stringValue
                        let brewWeb = brewObj["website"].stringValue
                        let brewId = brewObj["id"].stringValue
                        let brewDesc = brewObj["description"].stringValue
                        let brewImgURL = brewObj["images"]["icon"].stringValue
                        
                        
                        self.addMarker(longitude: brewLong, lattitude: brewLat, brewName: brewName)
                        self.fitToMarkers()

                        let brew = Brewery(brewId: brewId, brewName: brewName, brewDesc: brewDesc, brewStreet: brewStreet, brewCityStateZip: brewCityStateZip, brewWeb: brewWeb, brewPhone: brewPhone, brewImgURL: brewImgURL, brewLong: brewLong, brewLat: brewLat)
                        
                        self.brewData.append(brew)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            
            case .failure(let error):
                let alert = UIAlertController(title: "Error", message: String(describing: error), preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)

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
        return brewData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "brewTableViewCell", for: indexPath) as! BrewTableViewCell

        // Configure the cell...
        
        cell.cell_brewName.text = brewData[indexPath.row].brewName
        cell.cell_brewStreet.text = brewData[indexPath.row].brewStreet
        cell.cell_brewCityStateZip.text = brewData[indexPath.row].brewCityStateZip
        cell.cell_brewWeb.text = brewData[indexPath.row].brewWeb
        cell.cell_brewPhone.text = brewData[indexPath.row].brewPhone
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    
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
