//
//  SearchResultsViewController.swift
//  DarkSkyApp
//
//  Created by Samuel Chiang on 12/2/19.
//  Copyright © 2019 Samuel Chiang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class SearchResultsViewController: UIViewController {

    @IBOutlet weak var childcityview: UIView!
    @IBOutlet weak var navigationitem: UINavigationItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationitem.title = global.currentMainCity
        let button = UIButton(type: .custom)
        //set image for button
        let twitterimage = UIImage(named: "twitter")
        button.setImage(twitterimage?.withTintColor(UIColor.systemBlue), for: .normal)
        //add function for button
        button.addTarget(self, action:#selector(self.launchtwitter(sender: )), for: UIControl.Event.touchUpInside)
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 53, height: 51)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationitem.rightBarButtonItem = barButton
        self.navigationitem.leftBarButtonItem?.title = "Weather"
//        let favoriteimage = UIImage(named: "trash-can")
//        let trashimage = UIImage(named: "trash-can")
//        favoritebutton.setImage(favoriteimage, for: .normal)
//        favoritebutton.setImage(trashimage, for: .selected)
        
    }
    
    @objc func launchtwitter(sender :UIButton) {
        var output = "https://twitter.com/intent/tweet?text=The current temperature at "
        output += global.currentMainCity + " is "
        output += String(format: "%.0f",global.currentMainJSON["currently"]["temperature"].floatValue) + "° F. The weather conditions are " + global.currentMainJSON["currently"]["summary"].stringValue + ". "
        var urlString = output.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        urlString += "%23CSCI571WeatherSearch"
        if let url = URL(string: urlString) {
            print(url)
            UIApplication.shared.open(url)
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
