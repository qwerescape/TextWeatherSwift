//
//  RemoteWeatherService.swift
//  TextWeather
//
//  Created by Chao Qu on 2014-06-08.
//  Copyright (c) 2014 Chao Qu. All rights reserved.
//

import UIKit

class RemoteWeatherServiceDelegate: NSObject, NSURLConnectionDataDelegate {
    let receivedData: NSMutableData
    var expectedResponseSize: CLongLong = 0
    var finishedCallback: ((NSData)->())?
    var progressCallback: ((CLongLong)->())?
    
    init() {
        self.receivedData = NSMutableData()
        super.init()
    }
    
    func startConnection(#request: NSURLRequest){
        let connection = NSURLConnection(request: request, delegate: self)
        connection.start()
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        receivedData.appendData(data)
        
    }
    
    func connection(connection: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        receivedData.length = 0
        expectedResponseSize = response.expectedContentLength
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!){
        finishedCallback!(receivedData)
    }
    
    func connection(connection: NSURLConnection!, didFailWithError error: NSError!){
        NSLog("Error occured while trying to connect")
    }
}
