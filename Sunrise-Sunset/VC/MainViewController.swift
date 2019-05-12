//
//  MainViewController.swift
//  Sunrise-Sunset
//
//  Created by Alex Kagarov on 5/11/19.
//  Copyright © 2019 Alex Kagarov. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces
import WebKit

class MainViewController: UIViewController, CLLocationManagerDelegate {
    
    let locMan = CLLocationManager()
    
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var coordinatesLbl: UILabel!
    @IBOutlet weak var sunriseLbl: UILabel!
    @IBOutlet weak var sunsetLbl: UILabel!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var input: UITextField!
    
    var curLat: Float = 0.0
    var curLng: Float = 0.0
    var locName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locMan.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locMan.delegate = self
            locMan.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
    }
    
    @IBAction func onClick(_ sender: UIButton) {
        locMan.startUpdatingLocation()
        
        guard let locValue: CLLocationCoordinate2D = locMan.location?.coordinate else {return}
        
        guard let location: CLLocation = locMan.location else {return}
        
        curLat = Float(locValue.latitude)
        curLng = Float(locValue.longitude)
        
        print("Current location: \(curLat); \(curLng)")
        
        getJSON(locLat: curLat, locLng: curLng)
        
        fetchCityAndCountry(from: location) { city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            self.locName = (city + ", " + country)
            self.locationName.text = self.locName
            print("Location name: \(self.locName)")
        }
        
        self.coordinatesLbl.text = ("\(self.curLat); \(self.curLng)")
        
        locMan.stopUpdatingLocation()
        
        
        
//        let alert = UIAlertController(title: "Update", message: "The information has been updated!", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//
    }
    
    func getJSON(locLat: Float, locLng: Float) {
        
        var sunrise = ""
        var sunset = ""
        
        let givenURL = ("https://api.sunrise-sunset.org/json?"+"lat=\(locLat)"+"&"+"lng=\(locLng)")
        guard let url = URL(string: givenURL) else {return}
        print("Request: \(url)")
        print("Location: [\(locLat); \(locLng)]")
        
        let task = URLSession.shared.dataTask(with: url) { (data,response,error) in
            if error != nil {
                print(error as Any)
                return
            }
            
            guard let data = data else {return}
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: AnyObject]
                
                let results = json["results"] as? [String:Any]
                
                sunrise = results!["sunrise"] as! String
                print("sunrise \(sunrise)")
                sunset = results!["sunset"] as! String
                print("sunset \(sunset)")
                
                let status = json["status"] as! String
                print("status: \(status)")
                
                DispatchQueue.main.async {
                    let mainVC = self
                    mainVC.sunriseLbl.text = ("sunrise: \(sunrise)")
                    mainVC.sunsetLbl.text = ("sunset: \(sunset)")
                }
            } catch let error {
                print("Error: \(error)")
            }
        }
        task.resume()
    }
}

func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
    CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
        completion(placemarks?.first?.locality,
                   placemarks?.first?.country,
                   error)
    }
}
