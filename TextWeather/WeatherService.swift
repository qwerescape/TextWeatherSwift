//
//  WeatherService.swift
//  TextWeather
//
//  Created by Chao Qu on 2014-06-08.
//  Copyright (c) 2014 Chao Qu. All rights reserved.
//

import UIKit
class WeatherService: NSObject {
    var displayDelegate: DisplayDelegate? = nil
    var cityName: String? = nil;
    
    private func getTodayWeather(data:NSData){
        var e: NSErrorPointer = nil
        let jsonData: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: e) as NSDictionary
        //daily forecast
        if let today = ((jsonData["daily"] as? NSDictionary)?["data"] as? NSArray)?[0] as? NSDictionary {
            let min = today["temperatureMin"] as Double
            let max = today["temperatureMax"] as Double
            let condition = today["summary"] as String
            if let current = jsonData["currently"] as? NSDictionary {
                let currentTemp = current["temperature"] as Double
                let windSpeed = current["windSpeed"] as Double
                var weatherData = RemoteWeatherData(high: max, low: min, current: currentTemp, wind: windSpeed, condition: condition, city:cityName!)
                if displayDelegate != nil {
                    displayDelegate!.receivedWeatherData(weatherData)
                }
            }
        }
    }
    
    func getCurrentWeatherFor(latitude lat: Double, longitude lng: Double, cityName city: String){
        cityName = city;
        let request = NSURLRequest(URL: NSURL(string: NSString(format: "https://api.forecast.io/forecast/272c50e5cbaead39cdaa744c9a2d69e9/%f,%f", lat, lng)),
            cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy,
            timeoutInterval:30.0)
        let remoteWeatherServiceDelegate = RemoteWeatherServiceDelegate(getTodayWeather, {(data: CLongLong) in
            NSLog("I don't care")
        })
        remoteWeatherServiceDelegate.startConnection(request: request)
    }
    
    private func parseYesterdayWeather(data: NSData){
        var e: NSErrorPointer = nil
        let jsonData: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: e) as NSDictionary
        if let yesterday = ((jsonData["daily"] as? NSDictionary)?["data"] as? NSArray)?[0] as? NSDictionary {
            let min = yesterday["temperatureMin"] as Double
            let max = yesterday["temperatureMax"] as Double
            var index = (Int(NSDate().timeIntervalSince1970 / 3600) % 24) + NSTimeZone.localTimeZone().secondsFromGMT/3600
            if index < 0 {
                index = index + 24;
            }
            NSLog("index is %d", index)
            if let yesterdayAtThisTime = ((jsonData["hourly"] as? NSDictionary)?["data"] as? NSArray)?[index] as? NSDictionary{
                let hourlyTemp = yesterdayAtThisTime["apparentTemperature"] as Double
                let yesterdayWeatherData = RemoteWeatherData(high: max, low: min, current: hourlyTemp, wind: 0, condition: nil, city: nil)
                displayDelegate!.receivedYesterdayWeather("\(max) / \(min)", compare: "hotter");
            }
        }
    }
    
    func getYesterdayWeatherFor(latitude lat: Double, longitude lng: Double){
        //get yesterday's unix time stamp
        let yesterday = NSDate().dateByAddingTimeInterval(-(24*3600)).timeIntervalSince1970
        NSLog("yesterday time is: %f", yesterday)
        let request = NSURLRequest(URL: NSURL(string: NSString(format: "https://api.forecast.io/forecast/272c50e5cbaead39cdaa744c9a2d69e9/%f,%f,%.0f", lat, lng, yesterday)),
            cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy,
            timeoutInterval:30.0)
        
        let remoteWeatherServiceDelegate = RemoteWeatherServiceDelegate(parseYesterdayWeather, {(data: CLongLong) in
            NSLog("I don't care")
        })
        remoteWeatherServiceDelegate.startConnection(request: request)
        
    }
}
