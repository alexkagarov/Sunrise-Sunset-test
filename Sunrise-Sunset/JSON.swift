//
//  JSON.swift
//  Sunrise-Sunset
//
//  Created by Alex Kagarov on 5/11/19.
//  Copyright © 2019 Alex Kagarov. All rights reserved.
//

import Foundation
import WebKit

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
                let mainVC = MainViewController()
                mainVC.sunriseLbl?.text = sunrise
                mainVC.sunsetLbl?.text = sunset
            }
        } catch let error {
            print("Error: \(error)")
        }
    }
    task.resume()
}
