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
    func receivedWeatherData(data: RemoteWeatherData)
    func receivedYesterdayWeather(highLow: String, compare: String)
}
class DisplayViewController: UIViewController, CLLocationManagerDelegate, DisplayDelegate, NSTextStorageDelegate{
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var weatherTextView: UITextView!
    @IBOutlet weak var yesterday: UITextView!
    var weatherText = NSUserDefaults.standardUserDefaults().stringForKey("UserText")
    var locationManager: CLLocationManager!
    
    let specialFont = UIFont(name: "Avenir-Light", size: 20.0)
    let specialFontColor = UIColor(red: 0.87, green: 0.352, blue: 0.371, alpha: 1)
    let yesterdayFontColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    let normalFontColor = UIColor(red:0, green:0, blue:0, alpha:1)
    let normalFont = UIFont(name: "Avenir-Light", size: 20.0)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherTextView.textStorage.delegate = self
        
        //text.attributedText = NSAttributedString(string: "Locating you...")
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
                    weatherService.getYesterdayWeatherFor(latitude: lat, longitude: lng)
                    self.navigationController?.navigationBar.topItem?.title = placemark.locality.uppercaseString
                }
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!){
        NSLog("Error getting location coordinates");
    }
    
    func receivedWeatherData(data: RemoteWeatherData) {
        var attrWeatherText = NSMutableAttributedString(string: weatherText!)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7
        
        attrWeatherText.addAttributes([NSForegroundColorAttributeName: normalFontColor,
            NSFontAttributeName: normalFont,
            NSParagraphStyleAttributeName: paragraphStyle,
            NSKernAttributeName: NSNumber(int: 1)], range: NSMakeRange(0, attrWeatherText.length))
        //stylize special texts
        let specialCharStyle = [NSForegroundColorAttributeName: specialFontColor, NSFontAttributeName: specialFont!,NSParagraphStyleAttributeName: paragraphStyle] as Dictionary
        
        var specialDictionary: [String:NSAttributedString] = [:]
        let city = NSAttributedString(string: data.city!, attributes: specialCharStyle)
        specialDictionary["{location}"] = city
        let high = NSAttributedString(string: "\(data.high)", attributes: specialCharStyle)
        specialDictionary["{high}"] = high
        let low = NSAttributedString(string: "\(data.low)", attributes: specialCharStyle)
        specialDictionary["{low}"] = low
        let current = NSAttributedString(string: "\(data.current)", attributes: specialCharStyle)
        specialDictionary["{current}"] = current
        let wind = NSAttributedString(string: "\(data.wind)", attributes: specialCharStyle)
        specialDictionary["{wind}"] = wind
        let condition = NSAttributedString(string: "\(data.condition)", attributes: specialCharStyle)
        specialDictionary["{condition}"] = condition
        
        for (keyword, specialString) in specialDictionary {
            let range = (attrWeatherText.string as NSString).rangeOfString(keyword)
            if range.location != NSNotFound {
                attrWeatherText.replaceCharactersInRange(range, withAttributedString: specialString)
            }
        }
        
        weatherTextView.attributedText = attrWeatherText
    }
    
    func receivedYesterdayWeather(highLow: String, compare: String){
        var attrWeatherText = NSMutableAttributedString(string: "Yesterday was {highLow}, today is {compare}")
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        
        attrWeatherText.addAttributes([NSForegroundColorAttributeName: yesterdayFontColor,
            NSFontAttributeName: normalFont,
            NSParagraphStyleAttributeName: paragraphStyle,
            NSKernAttributeName: 1], range: NSMakeRange(0, attrWeatherText.length))
        
        //stylize special texts
        let specialCharStyle = [NSForegroundColorAttributeName: specialFontColor,
            NSFontAttributeName: specialFont!,
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        
        let highLow = NSAttributedString(string: highLow, attributes: specialCharStyle)
        var range = (attrWeatherText.string as NSString).rangeOfString("{highLow}")
        if range.location != NSNotFound {
            attrWeatherText.replaceCharactersInRange(range, withAttributedString: highLow)
        }
        
        let compareAttr = NSAttributedString(string: compare, attributes: specialCharStyle)
        range = (attrWeatherText.string as NSString).rangeOfString("{compare}")
        if range.location != NSNotFound {
            attrWeatherText.replaceCharactersInRange(range, withAttributedString: compareAttr)
        }
        
        yesterday.attributedText = attrWeatherText;
    }
    
    func textStorage(textStorage: NSTextStorage!, willProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
    }
}

