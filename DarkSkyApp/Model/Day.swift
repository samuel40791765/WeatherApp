//
//  Day.swift
//  DarkSkyApp
//
//  Created by Samuel Chiang on 11/27/19.
//  Copyright © 2019 Samuel Chiang. All rights reserved.
//

import Foundation

extension Date {
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

}


class Day {
    var DayDate: String
    var icontext: String
    var DaySunriseTime: String
    var DaySunsetTime: String
    
    init(DayTime: String, IconText: String, DaySunriseTime: String, DaySunsetTime: String) {
        let DayTimeDate = Date(timeIntervalSince1970: TimeInterval(integerLiteral: Int64(DayTime)!))
        let DaySunriseDate = Date(timeIntervalSince1970: TimeInterval(integerLiteral: Int64(DaySunriseTime)!))
        let DaySunsetDate = Date(timeIntervalSince1970: TimeInterval(integerLiteral: Int64(DaySunsetTime)!))
        self.DayDate = DayTimeDate.toString(dateFormat: "MM/dd/yyyy")
        self.icontext = IconText
        self.DaySunriseTime = DaySunriseDate.toString(dateFormat: "HH:mm")
        self.DaySunsetTime = DaySunsetDate.toString(dateFormat: "HH:mm")
    }
}
