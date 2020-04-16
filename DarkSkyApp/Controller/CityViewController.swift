//
//  CityViewController.swift
//  DarkSkyApp
//
//  Created by Samuel Chiang on 11/25/19.
//  Copyright © 2019 Samuel Chiang. All rights reserved.
//

import UIKit
import SwiftyJSON
import Toast_Swift

class CityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var cityjson: JSON = JSON()
    var cityname: String = ""
    var citysearchstring: String = ""
    var pageindex: Int = 0
    @IBOutlet weak var MainCityView: UIView!
    @IBOutlet weak var WeatherImage: UIImageView!
    @IBOutlet weak var CurrentTemperature: UILabel!
    @IBOutlet weak var CurrentSummary: UILabel!
    @IBOutlet weak var CurrentCity: UILabel!
    @IBOutlet weak var CurrentHumidity: UILabel!
    @IBOutlet weak var CurrentWindSpeed: UILabel!
    @IBOutlet weak var CurrentVisibility: UILabel!
    @IBOutlet weak var CurrentPressure: UILabel!
    
    @IBOutlet weak var DayTableView: UITableView!
    @IBOutlet weak var favoritebutton: UIButton!
    
    var day_data = [Day]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DayTableView.register(UINib(nibName: "DayTableViewCell", bundle: nil), forCellReuseIdentifier: "DayTableViewCell")

        DayTableView.delegate = self
        DayTableView.dataSource = self
        DayTableView.rowHeight = 50.0
        
        let gestureRec = UITapGestureRecognizer(target: self, action:  #selector (self.showDetails (_:)))
        // here we add it to our custom view
        MainCityView.addGestureRecognizer(gestureRec)
        setViews()
        favoritebutton.addTarget(self, action:#selector(self.favorite_setup(sender: )), for: UIControl.Event.touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    @objc func favorite_setup(sender :UIButton) {
        //favoritebutton.isSelected = !favoritebutton.isSelected
        if (global.favorites.contains(self.citysearchstring)){
            
            if let index = global.favorites.firstIndex(where: {$0 == self.citysearchstring}) {
                global.favorites.remove(at: index)
                defaults.set(global.favorites, forKey: "favorites")
            }
            let favoriteimage = UIImage(named: "plus-circle")
            favoritebutton.setImage(favoriteimage, for: .normal)
            //print(self.parent?.parent)
            if(self.parent?.parent is MainPageViewController) {
                let pr = self.parent?.parent as! MainPageViewController
                pr.view.makeToast(self.cityname + " was removed from the Favorite List", duration: 1.5)
                pr.controllers.remove(at: pageindex)
                for i in 1..<pr.controllers.count {
                    pr.controllers[i].pageindex = i
                }
                var nexpage = pageindex
                if pr.controllers.count <= nexpage {
                    nexpage = 0
                }
                pr.pageController.setViewControllers([pr.controllers[nexpage]], direction: .forward, animated: true, completion: nil)
            }
            else{
                self.view.makeToast(self.cityname + " was removed from the Favorite List", duration: 1.5)
            }
        }
        else {
            self.view.makeToast(self.cityname + " was added to the Favorite List", duration: 1.5)
            global.favorites.append(self.citysearchstring)
            defaults.set(global.favorites, forKey: "favorites")
            let favoriteimage = UIImage(named: "trash-can")
            favoritebutton.setImage(favoriteimage, for: .normal)
        }
        global.favorites = defaults.array(forKey: "favorites") as! [String]
        print(global.favorites)
    }
    
    
    @objc func showDetails(_ sender:UITapGestureRecognizer){

       // this is the function that lets us perform the segue
        global.currentMainJSON = self.cityjson
        global.currentMainCity = self.cityname
        //print(self.parent?.parent?.parent)
        if(self.parent?.parent?.parent is UINavigationController) {
            self.parent?.parent?.parent?.performSegue(withIdentifier: "DetailSegue", sender: self)
        }else{
            self.parent?.parent?.parent?.parent?.performSegue(withIdentifier: "DetailSegue", sender: self)
        }
        //self.parent?.parent?.performSegue(withIdentifier: "DetailSegue", sender: self)
//       let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "DetailTodayViewController") as UIViewController
//        vc.modalPresentationStyle = .fullScreen
//        vc.modalTransitionStyle = .coverVertical
//        self.present(vc, animated: true, completion: nil)
    }
    
    func hideFavoritebutton(){
        self.favoritebutton.isHidden = true
        self.favoritebutton.isEnabled = false
    }
    
    func setCityViewDataAndViews(citysearchstring:String, cityname:String, jsondata: JSON) {
        self.cityjson = jsondata
        self.cityname = cityname
        self.citysearchstring = citysearchstring
        self.setViews()
    }
    
    func setCityViewData(citysearchstring:String, cityname:String, jsondata: JSON) {
        self.cityjson = jsondata
        self.cityname = cityname
        self.citysearchstring = citysearchstring
    }
    
    func setViews() {
        if (global.favorites.contains(self.citysearchstring)){
            //favoritebutton.isSelected = true
            let favoriteimage = UIImage(named: "trash-can")
            favoritebutton.setImage(favoriteimage, for: .normal)
        }
        else {
            let favoriteimage = UIImage(named: "plus-circle")
            favoritebutton.setImage(favoriteimage, for: .normal)
        }
        switch self.cityjson["currently"]["icon"].stringValue {
        case "cloudy":
            WeatherImage.image = UIImage(named: "weather-cloudy")
        case "clear-night":
            WeatherImage.image = UIImage(named: "weather-night")
        case "rain":
            WeatherImage.image = UIImage(named: "weather-rainy")
        case "sleet":
            WeatherImage.image = UIImage(named: "weather-snowy-rainy")
        case "snow":
            WeatherImage.image = UIImage(named: "weather-snowy")
        case "wind":
            WeatherImage.image = UIImage(named: "weather-windy-variant")
        case "fog":
            WeatherImage.image = UIImage(named: "weather-fog")
        case "partly-cloudy-night":
            WeatherImage.image = UIImage(named: "weather-night-partly-cloudy")
        case "partly-cloudy-day":
            WeatherImage.image = UIImage(named: "weather-partly-cloudy")
        default:
             WeatherImage.image = UIImage(named: "weather-sunny")
        }
        CurrentCity.text = cityname
        CurrentTemperature.text = String(format: "%.0f",self.cityjson["currently"]["temperature"].floatValue) + "° F"
        CurrentSummary.text = self.cityjson["currently"]["summary"].stringValue
        CurrentHumidity.text =  String(format: "%.1f", self.cityjson["currently"]["humidity"].floatValue * 100) + " %"
        CurrentWindSpeed.text = String(format: "%.2f", self.cityjson["currently"]["windSpeed"].floatValue) + " mph"
        CurrentVisibility.text =  String(format: "%.2f", (self.cityjson["currently"]["visibility"].floatValue)) + " km"
        CurrentPressure.text = self.cityjson["currently"]["pressure"].stringValue + " mb"
        for (_, object) in self.cityjson["daily"]["data"] {
            let time = object["time"].stringValue
            let sunsettime = object["sunriseTime"].stringValue
            let sunrisetime = object["sunsetTime"].stringValue
            var icontext = "weather-sunny"
            switch object["icon"].stringValue {
            case "cloudy":
                icontext = "weather-cloudy"
            case "clear-night":
                icontext = "weather-night"
            case "rain":
                icontext = "weather-rainy"
            case "sleet":
                icontext = "weather-snowy-rainy"
            case "snow":
                icontext = "weather-snowy"
            case "wind":
                icontext = "weather-windy-variant"
            case "fog":
                icontext = "weather-fog"
            case "partly-cloudy-night":
                icontext = "weather-night-partly-cloudy"
            case "partly-cloudy-day":
                icontext = "weather-partly-cloudy"
            default:
                 icontext =  "weather-sunny"
            }
            day_data += [Day(DayTime: time, IconText: icontext, DaySunriseTime: sunsettime,DaySunsetTime: sunrisetime)]
        }
        
        DayTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return day_data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DayTableViewCell", for: indexPath) as? DayTableViewCell  else {
              fatalError("The dequeued cell is not an instance of ayTableViewCell.")
          }
        
        let day = day_data[indexPath.row]
        
//        cell.nameLabel.text = day.name
//        cell.photoImageView.image = day.photo
//        cell.ratingControl.rating = day.rating
        cell.DayDate.text = day.DayDate
        cell.DayIcon.image = UIImage(named: day.icontext)
        cell.DaySunriseTime.text = day.DaySunriseTime
        cell.DaySunsetTime.text = day.DaySunsetTime
        return cell
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
