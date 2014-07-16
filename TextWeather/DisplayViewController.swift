//
//  ViewController.swift
//  TextWeather
//
//  Created by Chao Qu on 2014-06-04.
//  Copyright (c) 2014 Chao Qu. All rights reserved.
//

import UIKit
import CoreLocation
protocol DisplayDelegate {
    func receivedWeatherData(data: WeatherData)
}
class DisplayViewController: UIViewController, CLLocationManagerDelegate, DisplayDelegate{
    @IBOutlet var text: UILabel
    var defaultText = "Hello you are in {location}, today's high is {high}, and today's low is {low}, and today's wind is {wind} and today's feel like is {current}"
    var locationManager: CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        text.attributedText = NSAttributedString(string: "Locating you...")
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 20000
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization();
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!){
        NSLog("located")
        manager.stopUpdatingLocation()
        if let loc: CLLocation = locations[0] as? CLLocation {
            let lat = loc.coordinate.latitude
            let lng = loc.coordinate.longitude
            let reverseGeoCoder: CLGeocoder = CLGeocoder()
            reverseGeoCoder.reverseGeocodeLocation(loc) {
                (resultArray, error)-> Void in
                if resultArray.count <= 0 {
                    //check error
                    NSLog("Error occurred because of %s", error.description)
                } else {
                    let placemark = resultArray[0] as CLPlacemark
                    let weatherService = WeatherService()
                    weatherService.displayDelegate = self
                    weatherService.getCurrentWeatherFor(latitude: lat, longitude: lng, cityName: placemark.locality)
                }
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!){
        NSLog("Error getting location coordinates");
    }
    
    func receivedWeatherData(data: WeatherData) {
        let newString = defaultText
        //        UIColor *specialFontColor=[UIColor colorWithRed:0.87 green:0.352 blue:0.371 alpha:1];
        let specialCharStyle = [NSBackgroundColorAttributeName: UIColor(red: 0.87, green: 0.352, blue: 0.371, alpha: 1)]
        let city = NSAttributedString(string: data.city, attributes: specialCharStyle)
        var attrWeatherText = NSMutableAttributedString(string: defaultText)
        let cityRange = (attrWeatherText.string as NSString).rangeOfString("{location}")
        attrWeatherText.addAttributes(specialCharStyle, range: cityRange)
        attrWeatherText.replaceCharactersInRange(cityRange, withAttributedString: city)
        text.attributedText = attrWeatherText
    }
}

