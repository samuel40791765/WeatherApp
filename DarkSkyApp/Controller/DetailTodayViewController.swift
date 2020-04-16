//
//  DetailTodayViewController.swift
//  DarkSkyApp
//
//  Created by Samuel Chiang on 11/27/19.
//  Copyright © 2019 Samuel Chiang. All rights reserved.
//

import UIKit
import SwiftyJSON


class DetailTodayViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    private let spacing:CGFloat = 8.0
    var windspeedvalue : String = ""
    var pressurevalue : String = ""
    var precipitationvalue : String = ""
    var temperaturevalue : String = ""
    var humidityvalue : String = ""
    var visibilityvalue : String = ""
    var cloudcovervalue : String = ""
    var ozonevalue : String = ""
    var centerimagepath : String = ""
    var centerlabel : String = ""
    
    
    @IBOutlet weak var collectionview: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionview.delegate = self
        self.collectionview.dataSource = self
//        self.collectionview.register(TodayCollectionViewCell.self, forCellWithReuseIdentifier: "TodayCollectionViewCell")
    }
    
    func setContent(jsondata: JSON) {
        switch jsondata["currently"]["icon"].stringValue {
        case "cloudy":
            self.centerimagepath = "weather-cloudy"
        case "clear-night":
            self.centerimagepath = "weather-night"
        case "rain":
            self.centerimagepath  = "weather-rainy"
        case "sleet":
            self.centerimagepath  = "weather-snowy-rainy"
        case "snow":
            self.centerimagepath  = "weather-snowy"
        case "wind":
            self.centerimagepath = "weather-windy-variant"
        case "fog":
            self.centerimagepath  = "weather-fog"
        case "partly-cloudy-night":
            self.centerimagepath  = "weather-night-partly-cloudy"
        case "partly-cloudy-day":
            self.centerimagepath = "weather-partly-cloudy"
        default:
             self.centerimagepath = "weather-sunny"
        }
        self.centerlabel = jsondata["currently"]["summary"].stringValue
        self.windspeedvalue = String(format: "%.2f", jsondata["currently"]["windSpeed"].floatValue) + " mph"
        self.pressurevalue = jsondata["currently"]["pressure"].stringValue + " mb"
        self.precipitationvalue =  String(format: "%.1f", (jsondata["currently"]["precipIntensity"].floatValue)) + " mmph"
        self.humidityvalue = String(format: "%.1f", jsondata["currently"]["humidity"].floatValue * 100) + " %"
        self.temperaturevalue = String(format: "%.0f",jsondata["currently"]["temperature"].floatValue) + "° F"
        self.visibilityvalue =  String(format: "%.2f", (jsondata["currently"]["visibility"].floatValue)) + " km"
        self.cloudcovervalue = String(format: "%.2f", jsondata["currently"]["cloudCover"].floatValue * 100) + " %"
        self.ozonevalue = jsondata["currently"]["ozone"].stringValue + " DU"
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(indexPath.item)
        if indexPath[0] == 1 && indexPath[1] == 1 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectioncenterinfobox", for: indexPath) as? TodayCenterCollectionViewCell {
                cell.image.image = UIImage(named: self.centerimagepath)
                cell.labelsummary.text = self.centerlabel
                return cell
            }
        }
        else{
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectioninfobox", for: indexPath) as? TodayCollectionViewCell {
    //            cell.backgroundColor = UIColor.green
                //cell.image.image = UIImage(named:"weather-windy")
                if indexPath[0] == 0 && indexPath[1] == 0 {
                    cell.image.image = UIImage(named:"weather-windy")
                    cell.label.text = "Wind Speed"
                    cell.labelvalue.text = self.windspeedvalue
                }
                else if indexPath[0] == 0 && indexPath[1] == 1 {
                    cell.image.image = UIImage(named:"gauge")
                    cell.label.text = "Pressure"
                    cell.labelvalue.text = self.pressurevalue
                }
                else if indexPath[0] == 0 && indexPath[1] == 2 {
                    cell.image.image = UIImage(named:"weather-pouring")
                    cell.label.text = "Precipitation"
                    cell.labelvalue.text = self.precipitationvalue
                }
                else if indexPath[0] == 1 && indexPath[1] == 0 {
                    cell.image.image = UIImage(named:"thermometer")
                    cell.label.text = "Temperature"
                    cell.labelvalue.text = self.temperaturevalue
                }
                else if indexPath[0] == 1 && indexPath[1] == 2 {
                    cell.image.image = UIImage(named:"water-percent")
                    cell.label.text = "Humidity"
                    cell.labelvalue.text = self.humidityvalue
                }
                else if indexPath[0] == 2 && indexPath[1] == 0 {
                    cell.image.image = UIImage(named:"eye-outline")
                    cell.label.text = "Visibility"
                    cell.labelvalue.text = self.visibilityvalue
                }
                else if indexPath[0] == 2 && indexPath[1] == 1 {
                    cell.image.image = UIImage(named:"weather-fog")
                    cell.label.text = "Cloud Cover"
                    cell.labelvalue.text = self.cloudcovervalue
                }
                else if indexPath[0] == 2 && indexPath[1] == 2 {
                    cell.image.image = UIImage(named:"earth")
                    cell.label.text = "Ozone"
                    cell.labelvalue.text = self.ozonevalue
                }
                return cell
            } else {
                return UICollectionViewCell()
            }
        }
        return UICollectionViewCell()
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

extension DetailTodayViewController : UICollectionViewDelegateFlowLayout {
  //1
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let numberOfItemsPerRow:CGFloat = 3
      let spacingBetweenCells:CGFloat = 8
      
      let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
      
      if let collection = self.collectionview{
          let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
          // let height = (collection.bounds.height - totalSpacing)/numberOfItemsPerRow
          return CGSize(width: width, height: 190)
      }else{
          return CGSize(width: 0, height: 0)
      }
  }
  
  //3
//  func collectionView(_ collectionView: UICollectionView,
//                      layout collectionViewLayout: UICollectionViewLayout,
//                      insetForSectionAt section: Int) -> UIEdgeInsets {
//    return sectionInsets
//  }
//
//  // 4
//  func collectionView(_ collectionView: UICollectionView,
//                      layout collectionViewLayout: UICollectionViewLayout,
//                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//    return sectionInsets.left
//  }
}
