//
//  DetailsPhotoViewController.swift
//  DarkSkyApp
//
//  Created by Samuel Chiang on 11/29/19.
//  Copyright © 2019 Samuel Chiang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

var photoloadcount = 0

extension UIImageView {
    func loadfordetails(url: URL, index: Int, last:Int) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        photoloadcount += 1
                        if photoloadcount == last {
                            SwiftSpinner.hide()
                        }
                    }
                }
            }
        }
    }
}


class DetailsPhotoViewController: UIViewController {
    @IBOutlet weak var mainscrollview: UIScrollView!
    @IBOutlet weak var mainstackview: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftSpinner.show("Fetching Google Images...")
        self.mainstackview.translatesAutoresizingMaskIntoConstraints = false
        getCustomSearch(cityname: global.currentMainCity)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func getCustomSearch(cityname: String) {
        let photonum = 8
        var input_link = "https://weather-node2019.appspot.com/customsearch?state_input=" + cityname //+ "%20City"
        input_link = input_link.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            Alamofire.request(input_link).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                for i in 0..<photonum {
                    photoloadcount = 0
                    let imageView = UIImageView()
                    imageView.frame = CGRect(x: 0, y: 0, width: self.mainscrollview.frame.width, height: 500)
                    imageView.heightAnchor.constraint(equalToConstant: 500).isActive = true

//                    imageView.center = self.mainscrollview.center
                    imageView.contentMode = .scaleAspectFill
                    imageView.loadfordetails(url: URL(string: swiftyJsonVar["items"][i]["link"].stringValue)!, index: i, last: photonum)
//                    yPosition += 400 + 20
//                    scrollViewContentSize += 400 + 20
                    //self.mainscrollview.contentSize.height = 200 * CGFloat(i + 1)
//                    self.mainscrollview.addSubview(imageView)
                    self.mainstackview.addArrangedSubview(imageView)
                }
            }
        }
    
    }

}
