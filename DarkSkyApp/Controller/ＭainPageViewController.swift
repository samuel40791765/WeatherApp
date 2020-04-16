//
//  PageViewController.swift
//  DarkSkyApp
//
//  Created by Samuel Chiang on 11/25/19.
//  Copyright © 2019 Samuel Chiang. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner
import CoreLocation

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
}

class MainPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, CLLocationManagerDelegate {
    var locationManager: CLLocationManager!
    var pageController: UIPageViewController!
    var controllers = [CityViewController]()
    var currentindex = 0
    var curLocationRes = JSON()
    var curCity: String = ""
    var curLongitude: Double = 0
    var curLatitude: Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
//        global.favorites = defaults.array(forKey: "favorites") as! [String]
//        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
//        pageController.dataSource = self
//        pageController.delegate = self
//
//        addChild(pageController)
//        view.addSubview(pageController.view)
//
//        let views = ["pageController": pageController.view] as [String: AnyObject]
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[pageController]|", options: [], metrics: nil, views: views))
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[pageController]|", options: [], metrics: nil, views: views))
//
//        for _ in 0..<global.favorites.count+1 {
//            let vc = CityViewController()
//            controllers.append(vc)
//        }
//        getCurrentLocationData()
//
//        print(global.favorites)
//        for i in 0..<global.favorites.count {
//            self.getLongLat(cityindex: i + 1, input_city: global.favorites[i])
//        }
//        pageController.setViewControllers([controllers[0]], direction: .forward, animated: false)
        
    }
    
    func getLocation(){
        //let latitude: Double?
        print(self.locationManager?.location)
        if let location = self.locationManager?.location {
            self.curLatitude =  Double(location.coordinate.latitude)
            self.curLongitude = Double(location.coordinate.longitude)
            print(self.curLatitude)
            print(self.curLongitude)
        } else {
           self.curLatitude = 0
          self.curLongitude = 0
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

        print("location error is = \(error.localizedDescription)")

    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
         
         var locationArray = locations as NSArray
         var locationObj = locationArray.lastObject as! CLLocation
         var coord = locationObj.coordinate
            
         print(Double(coord.latitude))
         print(Double(coord.longitude))
         
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        pageController.willMove(toParent: nil)
        pageController.view.removeFromSuperview()
        pageController.removeFromParent()
        controllers.removeAll()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        SwiftSpinner.show("Loading Favorites...")
        getLocation()
        if let favs = defaults.array(forKey: "favorites") as? [String]{
            global.favorites = favs
        }
        
        //global.favorites = defaults.array(forKey: "favorites") as! [String]
       pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
       pageController.dataSource = self
       pageController.delegate = self

       addChild(pageController)
       view.addSubview(pageController.view)
        pageController.view.translatesAutoresizingMaskIntoConstraints = false
        
       let views = ["pageController": pageController.view] as [String: AnyObject]
        pageController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1.0).isActive = true
        pageController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1.0).isActive = true
//       view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[pageController]|", options: [], metrics: nil, views: views))
//       view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[pageController]|", options: [], metrics: nil, views: views))

       for _ in 0..<global.favorites.count+1 {
           let vc = CityViewController()
           controllers.append(vc)
       }
       getCurrentLocationData()
       
       print(global.favorites)
       for i in 0..<global.favorites.count {
           self.getLongLat(cityindex: i + 1, input_city: global.favorites[i])
       }
       pageController.setViewControllers([controllers[0]], direction: .forward, animated: false)
    }
    
    private func getCurrentLocationData() {
        
        let location = CLLocation(latitude: curLatitude, longitude: curLongitude)
        location.fetchCityAndCountry { city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            print(city + ", " + country)  // Rio de Janeiro, Brazil
            self.getWeather(cityindex: 0,cityname: city, longitude: String(self.curLongitude), latitude: String(self.curLatitude))
        }
        
//        Alamofire.request("https://ipapi.co/json/").responseJSON { (responseData) -> Void in
//            if((responseData.result.value) != nil) {
//                let swiftyJsonVar = JSON(responseData.result.value!)
//                //print(swiftyJsonVar)
//                self.getWeather(cityindex: 0,cityname: swiftyJsonVar["city"].stringValue, longitude: String(self.curLongitude), latitude: String(self.curLatitude))
//                if let resData = swiftyJsonVar.array {
//                    print(resData)
//                    self.curLocationRes = resData as! [[String:AnyObject]]
//                    print(self.curLocationRes)
//                }
//                if self.curLocationRes != nil {
//                    let longstring = self.curLocationRes["longitude"] as? String ?? "nil"
//                    let latstring = self.curLocationRes["latitude"] as? String ?? "nil"
//                    self.getWeather(longitude: longstring, latitude: latstring)
//                    self.DayTableView.reloadData()
//
//                }
//            }
//        }
    }
    
    private func getLongLat(cityindex: Int, input_city: String) {
            let map_array = input_city.components(separatedBy: ", ")
            //print(map_array)
             var input_link = ""
           if 1 == map_array.count{
              input_link = "https://weather-node2019.appspot.com/maps?street=&city=&state=" + map_array[0]
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
                    //print(swiftyJsonVar)
                    if(swiftyJsonVar["status"].stringValue == "OK") {
                        self.getWeather(cityindex: cityindex, cityname: map_array[0], longitude: swiftyJsonVar["results"][0]["geometry"]["location"]["lng"].stringValue, latitude: swiftyJsonVar["results"][0]["geometry"]["location"]["lat"].stringValue)
                    }
                }
            }
        
        }
    
    private func getWeather(cityindex: Int, cityname: String, longitude: String, latitude: String) {
            let input_link = "https://weather-node2019.appspot.com/darksky?longitude=" + longitude + "&latitude=" + latitude
                Alamofire.request(input_link).responseJSON { (responseData) -> Void in
                if((responseData.result.value) != nil) {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    print(cityindex)
                    if (cityindex==0){
                        self.controllers[cityindex].setCityViewDataAndViews(citysearchstring: cityname,cityname: cityname, jsondata: swiftyJsonVar)
                        self.controllers[cityindex].hideFavoritebutton()
                    }
                    else{
                        self.controllers[cityindex].setCityViewData(citysearchstring: global.favorites[cityindex-1],cityname: cityname, jsondata: swiftyJsonVar)
                        self.controllers[cityindex].pageindex = cityindex
                    }
                    if(cityindex == self.controllers.count-1) {
                        SwiftSpinner.hide()
                    }
//                    self.jsonforcontrollers[cityindex] = swiftyJsonVar
//                    self.citynames[cityindex] = cityname
//                    if let resData = swiftyJsonVar.arrayObject {
//                        self.curLocationRes = resData as! [[String:AnyObject]]
//                        
//                    }
//                    if self.curLocationRes.count > 0 {
//                        self.DayTableView.reloadData()
//                    }
                }
            }
        
        }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let ownviewcontroller = viewController as! CityViewController
        if let index = controllers.firstIndex(of: ownviewcontroller) {
            if index > 0 {
                return controllers[index - 1]
            } else {
                return nil
            }
        }

        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let ownviewcontroller = viewController as! CityViewController
        if let index = controllers.firstIndex(of: ownviewcontroller) {
            if index < controllers.count - 1 {
                return controllers[index + 1]
            } else {
                return nil
            }
        }

        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.controllers.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return self.currentindex
    }
}
    
// MARK: UIPageViewControllerDataSource
//
//extension MainPageViewController: UIPageViewControllerDataSource {
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        return nil
//    }
//    
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        return nil
//    }
    
    
//    private(set) lazy var orderedViewControllers: [UIViewController] = {
//        return [self.newColoredViewController(color: "Green"),
//                self.newColoredViewController(color: "Red"),
//                self.newColoredViewController(color: "Blue")]
//    }()
//
//    private func newColoredViewController(color: String) -> UIViewController {
//        return UIStoryboard(name: "Main", bundle: nil) .
//            instantiateViewController(withIdentifier: "\(color)ViewController")
//    }
//    
//    
//    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
//        return orderedViewControllers.count
//    }
//
//    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
//        guard let firstViewController = viewControllers?.first,
//            let firstViewControllerIndex = orderedViewControllers[firstViewController] else {
//                return 0
//        }
//        
//        return firstViewControllerIndex
//    }
//    
//}
