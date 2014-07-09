//
//  WeatherService.swift
//  TextWeather
//
//  Created by Chao Qu on 2014-06-08.
//  Copyright (c) 2014 Chao Qu. All rights reserved.
//

import UIKit

class WeatherService: NSObject {
    let remoteWeatherServiceDelegate: RemoteWeatherServiceDelegate
    
    init() {
        remoteWeatherServiceDelegate = RemoteWeatherServiceDelegate()
        super.init()
        remoteWeatherServiceDelegate.finishedCallback = getTodayWeather
        remoteWeatherServiceDelegate.progressCallback = {(data: CLongLong) in
            NSLog("don't really care")
        }
    }
    
    func getCurrentWeatherFor(latitude lat: Double, longitude lng: Double){
        let request = NSURLRequest(URL: NSURL(string: NSString(format: "https://api.forecast.io/forecast/272c50e5cbaead39cdaa744c9a2d69e9/%f,%f", lat, lng)),
            cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy,
            timeoutInterval:30.0)
        remoteWeatherServiceDelegate.startConnection(request: request)
    }
    
    func getTodayWeather(data:NSData){
        var e: NSErrorPointer = nil
        let jsonData: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: e) as NSDictionary
        //daily forecast
        if let today = ((jsonData["daily"] as? NSDictionary)?["data"] as? NSArray)?[0] as? NSDictionary {
            let min = today["temperatureMin"].doubleValue
            let max = today["temperatureMax"].doubleValue
            let condition = today["summary"].stringValue
            if let current = jsonData["currently"] as? NSDictionary {
                let currentTemp = current["temperature"].doubleValue
                let windSpeed = current["windSpeed"].doubleValue
                let weatherData = WeatherData(high: max, low: min, current: currentTemp, wind: windSpeed, condition: condition)
            }
        }
        //[self updateWeather];

    }
}
