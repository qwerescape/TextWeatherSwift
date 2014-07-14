//
//  ViewController.swift
//  TextWeather
//
//  Created by Chao Qu on 2014-06-04.
//  Copyright (c) 2014 Chao Qu. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
protocol DisplayDelegate {
    func receivedWeatherData(data: WeatherData)
}
class DisplayViewController: UIViewController, CLLocationManagerDelegate, DisplayDelegate, MKReverseGeocoderDelegate{
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
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: AnyObject[]!){
        NSLog("located")
        manager.stopUpdatingLocation()
        if let loc: CLLocation = locations[0] as? CLLocation {
            let lat = loc.coordinate.latitude
            let lng = loc.coordinate.longitude
            let reverseGeoCoder: MKReverseGeocoder = MKReverseGeocoder(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng))
            reverseGeoCoder.delegate = self
            reverseGeoCoder.start()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!){
        NSLog("Error getting location coordinates");
    }
    
    func receivedWeatherData(data: WeatherData) {
        let newString = defaultText.stringByReplacingOccurrencesOfString("{location}", withString: data.city, options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        text.attributedText = NSAttributedString(string: newString)
    }
    
    func reverseGeocoder(geocoder: MKReverseGeocoder!, didFindPlacemark placemark: MKPlacemark!) {
        let (lat,lng) = (placemark.location.coordinate.latitude, placemark.location.coordinate.longitude)
        let weatherService = WeatherService()
        weatherService.displayDelegate = self
        weatherService.getCurrentWeatherFor(latitude: lat, longitude: lng, cityName: placemark.locality)
    }
    
    // There are at least two types of errors:
    //   - Errors sent up from the underlying connection (temporary condition)
    //   - Result not found errors (permanent condition).  The result not found errors
    //     will have the domain MKErrorDomain and the code MKErrorPlacemarkNotFound
    func reverseGeocoder(geocoder: MKReverseGeocoder!, didFailWithError error: NSError!) {
        NSLog("Error reverse geocoding")
    }

}

