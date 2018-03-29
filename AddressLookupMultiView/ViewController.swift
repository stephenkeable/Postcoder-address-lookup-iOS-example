//
//  ViewController.swift
//  AddressLookupMultiView
//
//  Created by Stephen Keable on 27/02/2018.
//  Copyright © 2018 Stephen Keable. All rights reserved.
//

// Be sure to change the postcoderApiKey variable in the postcoderClient.swift file
//
// The test API key, which only works with UK and always return addresses for postcode "NR14 7PZ"
// To get a trial API key sign up at - https://www.alliescomputing.com/postcoder/sign-up

import UIKit

// Controller for 1st step of address lookup UI, where user enters a postcode or part of address

class ViewController: UIViewController {

    @IBOutlet weak var postcodeField: UITextField!
    @IBOutlet weak var countryLabel: UILabel!
    
    // TODO:- Select country based on user location or IP
    
    // Default value for country
    var selectedCountry = PostcoderCountry(name: "United Kingdom", code: "GB")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryLabel.text = selectedCountry.description
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // If the Return button on keyboard (Labelled "Search") run the searchSegue, triggered by the UIButton
    @IBAction func postcodeFieldReturn(_ sender: Any) {
        performSegue(withIdentifier: "searchSegue", sender: self)
    }
    
    // Prepare data (country and postcode/address) for next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchSegue" {
            
            if let postcode = postcodeField.text {
                
                let trimPostcode = postcode.trimmingCharacters(in: .whitespaces)
                
                if let addressListController = segue.destination as? ListController {
                    addressListController.postcodeString = trimPostcode
                    addressListController.countryToSearch = selectedCountry
                }
            }
        }
    }
    
    // Prevent the searchSegue if the postcode field is blank or missing
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "searchSegue" {
            if let postcode = postcodeField.text {
                
                let trimPostcode = postcode.trimmingCharacters(in: .whitespaces)
                
                if trimPostcode == "" {
                    return false
                }
                
                return true
            }
            
            return false
        }
        
        return true
    }
    
    // Function for returning from the country list view
    @IBAction func unwindToViewController(sender: UIStoryboardSegue) {
        
        if (sender.identifier != nil) {
            if sender.identifier == "unwindFromCountry" {
                if let sourceViewController = sender.source as? CountryController {
                    selectedCountry = sourceViewController.selectedCountry
                    countryLabel.text = selectedCountry.description
                }
            }
        }
        
    }
}

