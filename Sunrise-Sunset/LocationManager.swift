//
//  LocationManager.swift
//  Sunrise-Sunset
//
//  Created by Alex Kagarov on 5/12/19.
//  Copyright © 2019 Alex Kagarov. All rights reserved.
//

import Foundation
import CoreLocation

func locationManager(_ manager: CLLocationManager){
    guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {return}
    guard let location: CLLocation = manager.location else {return}
    
    var curLat = Float(locValue.latitude)
    var curLng = Float(locValue.longitude)
    var locName = ""
    
    getJSON(locLat: curLat, locLng: curLng)
    
    print("Current location: \(locValue.latitude); \(locValue.longitude)")
    
    fetchCityAndCountry(from: location) { city, country, error in
        guard let city = city, let country = country, error == nil else { return }
        locName = (city + ", " + country)
        print("Location name: \(locName)")
    }
}

func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
    CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
        completion(placemarks?.first?.locality,
                   placemarks?.first?.country,
                   error)
    }
}
