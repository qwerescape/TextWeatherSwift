//
//  AppDelegate.swift
//  TextWeather
//
//  Created by Chao Qu on 2014-06-04.
//  Copyright (c) 2014 Chao Qu. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        // Override point for customization after application launch.
        let defaultWeatherTexts = ["Hello you are in {location}, today's high is {high}, and today's low is {low}, and today's wind is {wind} and today's feel like is {current}, and today is {condition}",
            "Hello beautiful, how is {location} looking today? Let me tell you how it's looking today, today's high is {high}, and today's low is {low}, and today's wind is {wind} and today's feel like is {current}",
            "{location}, high is {high}, low is {low}, wind is {wind} and feel like is {current}"]
        if NSUserDefaults.standardUserDefaults().objectForKey("AvailableTexts") == nil {
            NSUserDefaults.standardUserDefaults().setObject(defaultWeatherTexts, forKey: "AvailableTexts")
            NSUserDefaults.standardUserDefaults().setObject(defaultWeatherTexts[1], forKey: "UserText")
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

