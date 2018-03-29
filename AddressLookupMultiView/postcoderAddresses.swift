//
//  postcoderAddresses.swift
//  AddressLookup
//
//  Created by Stephen Keable on 20/02/2018.
//  Copyright © 2018 Stephen Keable. All rights reserved.
//

import Foundation

// Core address elements needed for most cases, additional ones are returned and documented here:-
// https://developers.alliescomputing.com/postcoder-web-api/address-lookup/premise

// Note: We treat all fields as Optional as datasets vary around the world, some returning more data than others

struct PostcoderAddress {
    let summaryLine: String?
    let addressLine1: String?
    let addressLine2: String?
    let addressLine3: String?
    let postTown: String?
    let county: String?
    let postcode: String?
}

extension PostcoderAddress {
    
    // Storing keys here, so slightly easier to change later
    struct Key {
        static let summaryLine = "summaryline"
        static let addressLine1 = "addressline1"
        static let addressLine2 = "addressline2"
        static let addressLine3 = "addressline3"
        static let postTown = "posttown"
        static let county = "county"
        static let postcode = "postcode"
    }
    
    init?(addressJson: [String: AnyObject]) {
        
        // Unwrap each element and assign to variables, or nil if not present
        
        if let summaryLineString = addressJson[Key.summaryLine] as? String {
            self.summaryLine = summaryLineString
        } else {
            self.summaryLine = nil
        }
        
        if let addressLine1String = addressJson[Key.addressLine1] as? String {
            self.addressLine1 = addressLine1String
        } else {
            self.addressLine1 = nil
        }
        
        if let addressLine2String = addressJson[Key.addressLine2] as? String {
            self.addressLine2 = addressLine2String
        } else {
            self.addressLine2 = nil
        }
        
        if let addressLine3String = addressJson[Key.addressLine3] as? String {
            self.addressLine3 = addressLine3String
        } else {
            self.addressLine3 = nil
        }
        
        if let postTownString = addressJson[Key.postTown] as? String {
            self.postTown = postTownString
        } else {
            self.postTown = nil
        }
        
        if let countyString = addressJson[Key.county] as? String {
            self.county = countyString
        } else {
            self.county = nil
        }
        
        if let postcodeString = addressJson[Key.postcode] as? String {
            self.postcode = postcodeString
        } else {
            self.postcode = nil
        }
    }
    
    // If you want to create an empty PostcoderAddress instance
    
    init?() {
        self.summaryLine = ""
        self.addressLine1 = ""
        self.addressLine2 = nil
        self.addressLine3 = nil
        self.postTown = ""
        self.county = ""
        self.postcode = ""
    }
}

// Create a struct for an array of PostcoderAddress, along with two fields used for paging, which are found in the last item of the API response array

struct PostcoderAddresses {
    let addresses: [PostcoderAddress]
    
    // Data licensing restricts API to 100 results per response. Returns nil if only one page of results.
    let nextPage: Int?
    
    // When there are more than 100 results, we return the total number of results for search. Otherwise this is same as addresses.count
    let totalResults: Int
}

extension PostcoderAddresses {
    
    init?(json: [[String: AnyObject]]) {
        
        // Ensure we don't have an empty array
        if json.count > 0 {
            
            // Loop through response and create PostcoderAddress instances in array
            self.addresses = json.flatMap { PostcoderAddress(addressJson: $0) }
            
            // Pluck the nextpage field out from last address, if exists. With sensible alt if not present.
            
            if let nextPage = json.last?["nextpage"] as? String {
                self.nextPage = Int(nextPage)!
            } else {
                self.nextPage = nil
            }
            
            // Pluck the totalresults field out from last address, if exists. With sensible alt if not present.

            if let totalResults = json.last?["totalresults"] as? String {
                self.totalResults = Int(totalResults)!
            } else {
                self.totalResults = json.count
            }
            
        } else {
        
            return nil
            
        }
        
    }
}

