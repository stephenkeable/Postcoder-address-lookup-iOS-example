//
//  CountryController.swift
//  AddressLookupMultiView
//
//  Created by Stephen Keable on 27/02/2018.
//  Copyright © 2018 Stephen Keable, under MIT licence.
//

import UIKit

// Controller for step 1A, a list of countries shown when they click the "change" button next to current selected country

class CountryController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var countryList: UITableView!
    
    // Assign countries from a default set saved in postcoderCountries.swift
    // This could be changed to load a list from an API endpoint.
    // Note: Need to ensure that the ISO 2 character code is passed to the Postcoder API
    var countries = defaultCountries.countries
    
    var selectedCountry = PostcoderCountry(name: "United Kingdom", code: "GB")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        countryList.delegate = self
        countryList.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Set number of items in list to number of results in list of countries
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    // Build the cells used in table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryListItem", for: indexPath)
        
        // Use the description field from the countries object
        let country = countries[indexPath.row]
        cell.textLabel?.text = country.description
        
        return cell
    }
    
    // When a country is choose, trigger an unwind segue back to the ViewController (1st step of UI)
    // The unwindToViewController action in the ViewController does most of the legwork
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        selectedCountry = countries[indexPath.row]
        
        performSegue(withIdentifier: "unwindFromCountry", sender: self)
        
    }
    
}
