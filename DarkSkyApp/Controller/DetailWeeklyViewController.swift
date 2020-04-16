//
//  DetailWeeklyViewController.swift
//  DarkSkyApp
//
//  Created by Samuel Chiang on 11/27/19.
//  Copyright © 2019 Samuel Chiang. All rights reserved.
//

import UIKit
import SwiftyJSON
import Charts

class DetailWeeklyViewController: UIViewController {

    @IBOutlet weak var mainimage: UIImageView!
    @IBOutlet weak var summary: UILabel!
    @IBOutlet weak var weekchart: LineChartView!
    var imagestring : String = ""
    var labelstring : String = ""
    var minTemps: [Double] = []
    var maxTemps: [Double] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setChart()
        self.mainimage.image = UIImage(named: imagestring)
        self.summary.text = labelstring
        // Do any additional setup after loading the view.
    }
    func setContent(jsondata: JSON) {
        self.maxTemps.removeAll()
        self.minTemps.removeAll()
        switch jsondata["daily"]["icon"].stringValue {
        case "cloudy":
            self.imagestring = "weather-cloudy"
        case "clear-night":
            self.imagestring = "weather-night"
        case "rain":
            self.imagestring  = "weather-rainy"
        case "sleet":
            self.imagestring  = "weather-snowy-rainy"
        case "snow":
            self.imagestring  = "weather-snowy"
        case "wind":
            self.imagestring = "weather-windy-variant"
        case "fog":
            self.imagestring  = "weather-fog"
        case "partly-cloudy-night":
            self.imagestring  = "weather-night-partly-cloudy"
        case "partly-cloudy-day":
            self.imagestring = "weather-partly-cloudy"
        default:
             self.imagestring = "weather-sunny"
        }
        self.labelstring = jsondata["daily"]["summary"].stringValue
        for i in 0..<8 {
            minTemps.append(jsondata["daily"]["data"][i]["temperatureLow"].doubleValue)
            maxTemps.append(jsondata["daily"]["data"][i]["temperatureHigh"].doubleValue)
        }
    }
    
    func setChart() {
        self.weekchart.doubleTapToZoomEnabled = false
        self.weekchart.highlightPerTapEnabled = false
        var minlineChartEntry = [ChartDataEntry]()
        var maxlineChartEntry = [ChartDataEntry]()
        for i in 0..<8 {
            let minvalue = ChartDataEntry(x: Double(i), y: minTemps[i])
            let maxvalue = ChartDataEntry(x: Double(i), y: maxTemps[i])
            minlineChartEntry.append(minvalue)
            maxlineChartEntry.append(maxvalue)
        }
        
        let line1 = LineChartDataSet(entries: minlineChartEntry, label: "Minimum Temperature (°F)")
        line1.colors = [NSUIColor.white]
        //line1.
        line1.circleRadius = 5
        line1.circleHoleColor = NSUIColor.white
        line1.circleColors = [NSUIColor.white]
//        line1.setDrawHighlightIndicators(false)
//        line1.highlightEnabled = false
        let line2 = LineChartDataSet(entries: maxlineChartEntry, label: "Maximum Temperature (°F)")
        line2.colors = [NSUIColor.orange]
        line2.circleRadius = 5
        line2.circleHoleColor = NSUIColor.orange
        line2.circleColors = [NSUIColor.orange]
        
        let data = LineChartData()
        data.addDataSet(line1)
        data.addDataSet(line2)
        
        self.weekchart.data = data
        //self.weekchart.drawGridBackgroundEnabled = true
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
