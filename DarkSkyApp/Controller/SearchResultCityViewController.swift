//
//  SearchResultCityViewController.swift
//  DarkSkyApp
//
//  Created by Samuel Chiang on 12/2/19.
//  Copyright © 2019 Samuel Chiang. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SwiftSpinner

class SearchResultCityViewController: UIViewController {
    var citycontroller: CityViewController!
    
    override func viewDidLoad() {
        SwiftSpinner.show("Fetching Weather Details for " + global.currentMainCity + "...")
        let citycontroller = CityViewController()
        self.addChild(citycontroller)
        self.view.addSubview(citycontroller.view)
        
        self.getLongLat()
        
        // Do any additional setup after loading the view.
    }
    private func getLongLat() {
        let map_array = global.searchCity.components(separatedBy: ", ")
        print(map_array)
        var input_link = ""
        if 1 == map_array.count{
           input_link = "https://weather-node2019.appspot.com/maps?street=" + "&city=&state=" + map_array[0]
        }
        else{
            input_link = "https://weather-node2019.appspot.com/maps?street=" + "&city=" + map_array[0] + "&state=" + map_array[1]
        }
               
        input_link = input_link.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        print(input_link)
//        if(2 < map_array.count) {
//            input_link += map_array[2]
//        }
            Alamofire.request(input_link).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "OK") {
                    self.getWeather(cityname: global.currentMainCity, longitude: swiftyJsonVar["results"][0]["geometry"]["location"]["lng"].stringValue, latitude: swiftyJsonVar["results"][0]["geometry"]["location"]["lat"].stringValue)
                }
            }
        }
    
    }
    
    private func getWeather(cityname: String, longitude: String, latitude: String) {
        let input_link = "https://weather-node2019.appspot.com/darksky?longitude=" + longitude + "&latitude=" + latitude
            Alamofire.request(input_link).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                //print(swiftyJsonVar)
                global.currentMainJSON = swiftyJsonVar
                let controller = self.children[0] as! CityViewController
                //print(controller)
                controller.setCityViewDataAndViews(citysearchstring: global.searchCity,cityname: global.currentMainCity, jsondata: swiftyJsonVar)
                SwiftSpinner.hide()
            }
            else {
                SwiftSpinner.hide()
            }
        }
    
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
