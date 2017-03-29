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
import Spruce

let BREWERYDB_API_KEY = "d8604749e9fbcca807d465e753a72478" //dev
//let BREWERYDB_API_KEY = "fd9b5015d33721dd7bf301ea019b2fb9" //release

let baseURL = "http://api.brewerydb.com/v2/"

class BrewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, GMSMapViewDelegate {

    @IBOutlet weak var gmapView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    let locationManager = CLLocationManager()
    var mapView: GMSMapView!
    var didFindMyLocation = false
    var markers = [GMSMarker]()
    var bounds = GMSCoordinateBounds()
    var currentLocation: CLLocation!
    var currentLocationReceived: Bool = false
    
    var selectedStyleId: String!
    var cityText: String?
    var stateText: String?
    var zipText: String?
    
    var brewURL: String!
    
    var brewData = [Brewery]()
    var brewIdList = [String]()
    var beerData = [String:[Beer]]()
    
    var selectedBrewId: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        selectedBrewId = ""
        self.navigationController?.navigationBar.isHidden = false;
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sortFunction1 = LinearSortFunction(direction: .topToBottom, interObjectDelay: 0.025)
        view.spruce.animate([.fadeIn, .expand(.slightly)], sortFunction: sortFunction1)
        
        createMap()
        
        activityIndicatorView.startAnimating()
        view.bringSubview(toFront: activityIndicatorView)

        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let sortFunction2 = LinearSortFunction(direction: .topToBottom, interObjectDelay: 0.025)
        self.tableView.spruce.animate([.fadeIn, .expand(.slightly)], sortFunction: sortFunction2)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100; //Set this to any value that works for you.
        
        createBrewURL()
        //getBrewData()
        
        tableView.tableFooterView = UIView()  // it's just 1 line, awesome!
    }
    
    //maps
    
    func createMap() {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: view.frame.width, height: 250), camera: camera)
        
        locationManager.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        locationManager.delegate = self
        mapView.settings.myLocationButton = true
        gmapView.addSubview(mapView)
    }
    
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude:(location?.coordinate.longitude)!, zoom:14)
        mapView.animate(to: camera)
        self.locationManager.stopUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getCurrentLocZip() {
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLocation = locationManager.location
            CLGeocoder().reverseGeocodeLocation(currentLocation, completionHandler: {
                (placemarks, error) -> Void in
                
                let placeMark = (placemarks?[0])! as CLPlacemark
                if let zip = placeMark.addressDictionary!["ZIP"] as? String {
                    self.zipText = zip
                }
                
                if let city = placeMark.addressDictionary!["City"] as? String {
                    self.cityText = city
                }
                
                if let state = placeMark.addressDictionary!["State"] as? String {
                    self.stateText = stateDic[state]
                }
                
                self.currentLocationReceived = true

            })
        
        }
        
    }
    
    func fitToMarkers() {
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
            getCurrentLocZip()
            if currentLocationReceived == true {
                brewURL = baseURL + "locations?key=" + BREWERYDB_API_KEY + "&postalCode=" + zipText!
                getBrewData()
            }
            else {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    self.brewURL = baseURL + "locations?key=" + BREWERYDB_API_KEY + "&postalCode=" + self.zipText!
                    self.getBrewData()
                })
            }
        }
        else if zipText != "" {
            brewURL = baseURL + "locations?key=" + BREWERYDB_API_KEY + "&postalCode=" + zipText!
            getBrewData()
        }
        else {
            if cityText != "" && stateText != "" {
            brewURL = baseURL + "locations?key=" + BREWERYDB_API_KEY + "&locality=" + cityText! + "&region=" + stateText!
                getBrewData()
            }
        }
    }
    
    func createBeerURL(brewId: String) -> String {
        var beerURL = baseURL + "brewery/" + brewId + "/beers?key=" + BREWERYDB_API_KEY
        return beerURL
    }
    
    func getBrewData() {

        Alamofire.request(brewURL).responseJSON { response in

            switch response.result {
            case .success:
        
                if let jsonData = response.result.value {
                    
                    var jsonObject = JSON(jsonData)
                    jsonObject = jsonObject["data"]
                    
                    if jsonObject == JSON.null {
                        if self.currentLocationReceived == true {
                            let alert = UIAlertController(title: "Error", message: "Welp no breweries in your zipcode. Doing a city wide search instead.", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
                                print(self.cityText!)
                                print(self.stateText!)
                                self.brewURL = baseURL + "locations?key=" + BREWERYDB_API_KEY + "&locality=" + self.cityText! + "&region=" + self.stateText!
                                self.getBrewData()
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        else {
                            let alert = UIAlertController(title: "Error", message: "No breweries were found.", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
                                self.navigationController?.popViewController(animated: true)
                                }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    
                    for (key,brewItem):(String, JSON) in jsonObject {
                        
                        if brewItem["isClosed"].stringValue == "Y" {
                            continue
                        }
                        
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
                        self.brewIdList.append(brewId)
                        
                        let brewDesc = brewObj["description"].stringValue
                        let brewImgURL = brewObj["images"]["icon"].stringValue
                        
                        
                        self.addMarker(longitude: brewLong, lattitude: brewLat, brewName: brewName)

                        var beerURL = self.createBeerURL(brewId: brewId)
                        self.getBeerData(brewId: brewId, beerURL: beerURL)
                        
                        let brew = Brewery(brewId: brewId, brewName: brewName, brewDesc: brewDesc, brewStreet: brewStreet, brewCityStateZip: brewCityStateZip, brewWeb: brewWeb, brewPhone: brewPhone, brewImgURL: brewImgURL, brewLong: brewLong, brewLat: brewLat)
                        self.brewData.append(brew)
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    self.fitToMarkers()
                    self.activityIndicatorView.stopAnimating()
                    self.activityIndicatorView.hidesWhenStopped = true
                    
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
    
    func getBeerData(brewId: String, beerURL: String) {
        
        Alamofire.request(beerURL).responseJSON { response in

            switch response.result {
                case .success:
                
                    if let jsonData = response.result.value {
                        
                        var jsonObject = JSON(jsonData)
                        jsonObject = jsonObject["data"]
                        
                        if jsonObject == JSON.null {
                            print("no beer found for: " + brewId)
                        }
                        
                        var brewBeerList = [Beer]()
                        for (key,beerItem):(String, JSON) in jsonObject {
                            
                            /*
                            if beerItem["availableId"].intValue == 3 {
                                continue
                            }*/
                            
                            let beerId = beerItem["id"].stringValue
                            let beerName = beerItem["name"].stringValue
                            let beerDesc = beerItem["description"].stringValue
                            let beerStyleId = beerItem["styleId"].stringValue
                            
                            let minSRM = Int(beerItem["style"]["srmMin"].stringValue)
                            let maxSRM = Int(beerItem["style"]["srmMax"].stringValue)
                            
                            var beerSRM = 100
                            
                            if (minSRM != nil && maxSRM != nil) {
                                beerSRM = minSRM! + (maxSRM! - minSRM!)/2
                            }
                            
                            let beer = Beer(beerId: beerId, beerName: beerName, beerStyle: beerStyleId, beerDesc: beerDesc, beerSRM: beerSRM)
                            
                            brewBeerList.append(beer)
                         }

                        self.beerData[brewId] = brewBeerList
                        
                    }
            case .failure(let error):
                print("couldn't find beer for: " + brewId)
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
        
        cell.cell_brewName.text = brewData[indexPath.row].brewName
        cell.cell_brewStreet.text = brewData[indexPath.row].brewStreet
        cell.cell_brewCityStateZip.text = brewData[indexPath.row].brewCityStateZip
        cell.cell_brewWeb.text = brewData[indexPath.row].brewWeb
        cell.cell_brewPhone.text = brewData[indexPath.row].brewPhone
        
        var brewId = brewData[indexPath.row].brewId
        var beerTemp = beerData[brewId]
        var styleFound = false
        
        if selectedStyleId != nil {
            for i in 0..<beerTemp!.count {
                var foundBeerStyle = (beerTemp?[i].beerStyle)!
                if (selectedStyleId == foundBeerStyle) {
                    styleFound = true
                }
            }
        }
        
        if styleFound {
            cell.cell_brewBeerImg.image = UIImage(named: "yes_beer")
        }
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(red: 0.878, green: 0.686, blue: 0.345, alpha: 1)
        cell.selectedBackgroundView = bgColorView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        var selectedBrewIndex = indexPath.row
        selectedBrewId = brewData[selectedBrewIndex].brewId
        
        if !(beerData[selectedBrewId]?.isEmpty)! {
            self.performSegue(withIdentifier: "brewToBeerSegue", sender: self)
        }
        
        else {
            let alert = UIAlertController(title: "Error", message: "No beer data was found.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "brewToBeerSegue") {
            let beerTableviewController = segue.destination as! BeerTableViewController
            beerTableviewController.beerData = beerData[selectedBrewId]
        }
        
    }

}
