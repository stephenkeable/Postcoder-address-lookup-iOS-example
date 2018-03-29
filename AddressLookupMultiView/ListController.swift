//
//  ListController.swift
//  AddressLookupMultiView
//
//  Created by Stephen Keable on 27/02/2018.
//  Copyright © 2018 Stephen Keable. All rights reserved.
//

import UIKit

// Controller for 2nd step in address lookup UI, where the user selects an address from a list

class ListController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var addressList: UITableView!
    @IBOutlet weak var listHeaderLabel: UILabel!
    
    // Setup the postcoder client
    var client = PostcoderClient()
    
    // Setup an empty address object, where we will store the list of addresses returned by the API
    var addresses = [PostcoderAddress]()
    
    // Storing the items we use to search with
    var postcodeString: String = ""
    var nextPage: Int = 0
    var countryToSearch = PostcoderCountry(name: "United Kingdom", code: "GB")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lookupAddress(postcodeString, page: nextPage, country: countryToSearch)
        
        addressList.delegate = self
        addressList.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Action for the next page button in list footer, used when more than 100 results are found by the API
    @IBAction func listFooterButton(_ sender: Any) {
        lookupAddress(postcodeString, page: nextPage, country: countryToSearch)
    }
    
    // Main function to interact with the API and update the list of addresses
    func lookupAddress(_ postcode: String, page: Int, country: PostcoderCountry) {
    
        client.getAddresses(for: postcode, page: page, country: country.countryCode) { [unowned self] postcoderAddresses, error in
            if let postcoderAddresses = postcoderAddresses {
                self.addresses = postcoderAddresses.addresses
                
                if self.addresses.count == 1 {
                    // Use the singular for the table header text
                    self.listHeaderLabel.text = "1 address found"
                    
                    // Optional jump past the list to populate the final step, if we only have 1 address to choose
                    if let firstAddress = self.addresses.first {
                        self.performSegue(withIdentifier: "listSegue", sender: firstAddress)
                    }
                    
                } else {
                    // Include count of addresses for the table header
                    self.listHeaderLabel.text = "\(postcoderAddresses.totalResults) addresses found"
                }
                
                // Show or hide the "Next page" button and update the nextpage variable for additional requests
                if let nextPage = postcoderAddresses.nextPage {
                    self.nextPage = nextPage
                    self.addressList.tableFooterView?.isHidden = false
                } else {
                    self.nextPage = 0
                    self.addressList.tableFooterView?.isHidden = true
                }
                
                self.addressList.reloadData()
                
                // Scroll to top of table view, mainly for when someone performs more than one search
                self.addressList.scrollToRow(at: IndexPath(row: 0, section:0), at: UITableViewScrollPosition.top, animated: true)
                
            } else {
                if error == .noResultsFound {
                    
                    // Search worked, but found no matching addresses. Show message in header and hide "next page" button
                    self.listHeaderLabel.text = "No addresses found"
                    self.addressList.tableFooterView?.isHidden = true
                    
                } else {
                    
                    // Something failed so dump to log, see postcoderError.swift for more info on different errors.
                    dump(error)
                    
                    // Show generic error message in header for user and hide "next page" button
                    self.listHeaderLabel.text = "An error occurred"
                    self.addressList.tableFooterView?.isHidden = true
                }
            }
        }
    }
    
    
    // Set number of items in list to number of results in current page of addresses
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    // Connect the address object to the table view and which properties to use as labels
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressListItem", for: indexPath)
        
        let address = addresses[indexPath.row]
        
        // Create empty array of strings to add address fields as we unwrap them
        var labelArray = [String]()
        
        // Cascade through lines, if we don't have line1 then 2 and 3 won't be present.
        if let addressLine1 = address.addressLine1 {
            labelArray.append(addressLine1)
            
            if let addressLine2 = address.addressLine2 {
                labelArray.append(addressLine2)
                
                if let addressLine3 = address.addressLine3 {
                    labelArray.append(addressLine3)
                }
            }
        }
        
        if let postTown = address.postTown {
            labelArray.append(postTown)
        }
        
        if let postcode = address.postcode {
            labelArray.append(postcode)
        }
        
        // Grab first element in array for main cell title text
        cell.textLabel?.text = labelArray[0]
        
        // Remove it from array
        labelArray.removeFirst()
        
        // Join the rest of the array items, and assign to the subtitle of the cell
        cell.detailTextLabel?.text = labelArray.joined(separator: ", ")
        
        return cell
    }
    
    // Perform a segue to the final address form with the selected item from the list
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // segue to detail controller and pass the address object
        performSegue(withIdentifier: "listSegue", sender: addresses[indexPath.row])
    }
    
    // Save the selected item to a variable in the detailController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "listSegue" {
            
            // Make sure the address is a type the next view is expecting
            if let address = sender as? PostcoderAddress {
                if let addressDetailController = segue.destination as? DetailController {
                    addressDetailController.selectedAddress = address
                }
            }
                
        }
    }
    
}
