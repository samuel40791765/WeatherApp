//
//  ViewController.swift
//  Darksky
//
//  Created by Samuel Chiang on 11/19/19.
//  Copyright © 2019 Samuel Chiang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Global {
    var currentMainCity:String = ""
    var searchCity: String = ""
    var currentMainJSON = JSON()
    var favorites: [String] = []
}

var global = Global()
let defaults = UserDefaults.standard



class MainViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    var searchBar: UISearchBar!

    @IBOutlet weak var navbar: UINavigationItem!
    @IBOutlet weak var autocompletetable: UITableView!
    var autocompletedata: [String] = []
     
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.hideKeyboardWhenTappedAround()
        self.autocompletetable.dataSource = self
        self.autocompletetable.delegate = self
        self.autocompletetable.rowHeight = 40.0
        self.autocompletetable.register(UINib(nibName: "AutoCompleteTableViewCell", bundle: nil), forCellReuseIdentifier: "AutoCompleteTableViewCell")
        self.autocompletetable.allowsSelection = false
        self.view.sendSubviewToBack(self.autocompletetable)
        makeSearchBar()
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
        self.searchBar.endEditing(true)
        self.autocompletetable.allowsSelection = false
        self.view.sendSubviewToBack(self.autocompletetable)
    }
    
    
    private func getAutocomplete(text: String) {
        var input_link = "https://weather-node2019.appspot.com/autocompletedata?text_string=" + text
        input_link = input_link.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            Alamofire.request(input_link).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                print(swiftyJsonVar)
                self.autocompletedata.removeAll()
                for i in 0..<swiftyJsonVar.count {
                    self.autocompletedata.append(swiftyJsonVar[i]["description"].stringValue)
                }
//                    if let resData = swiftyJsonVar.arrayObject {
//                        self.curLocationRes = resData as! [[String:AnyObject]]
//
//                    }
//                    if self.curLocationRes.count > 0 {
//                        self.DayTableView.reloadData()
//                    }
                self.view.bringSubviewToFront(self.autocompletetable)
                self.autocompletetable.allowsSelection = true
                self.autocompletetable.reloadData()
            }
            else {
                 self.autocompletetable.allowsSelection = false
                 self.view.sendSubviewToBack(self.autocompletetable)
            }
        }
    
    }

    func makeSearchBar() {
        self.searchBar = UISearchBar()
        self.searchBar.delegate = self
        self.searchBar.placeholder = "Enter City Name..."
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.view.sendSubviewToBack(self.autocompletetable)
            self.autocompletetable.allowsSelection = false
        }
        else{
            getAutocomplete(text: searchText)
        }
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
        self.searchBar.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        //print(self.autocompletedata[row])
        global.searchCity = self.autocompletedata[row]
        global.currentMainCity = self.autocompletedata[row].components(separatedBy: ",")[0]
        self.parent?.performSegue(withIdentifier: "ResultsSegue", sender: self)
        self.dismissKeyboard()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autocompletedata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AutoCompleteTableViewCell", for: indexPath) as! AutoCompleteTableViewCell
        cell.citytext.text = self.autocompletedata[indexPath.row]
        return cell
    }
}
