//
//  TimeUtilities.swift
//  ChatBot
//
//  Created by ITRMG on 2016-18-12.
//  Copyright © 2016 Schibsted. All rights reserved.
//

import Foundation

class TimeUtilities {
    
    static func currentHourMinSec() -> String {
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour , .Minute , .Second], fromDate: date)
        
        let hour =  components.hour
        let minute = components.minute
        let second = components.second
        
        let currentTime = "\(hour):\(minute):\(second)"
        
        return currentTime
    }
}