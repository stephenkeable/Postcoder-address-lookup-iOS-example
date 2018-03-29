//
//  postcoderCountries.swift
//  AddressLookupMultiView
//
//  Created by Stephen Keable on 28/02/2018.
//  Copyright © 2018 Stephen Keable. All rights reserved.
//

import Foundation

// Struct to build basic country object with description (shown as label) and countryCode (passed to Postocder API)
struct PostcoderCountry {
    let description: String
    let countryCode: String
}

extension PostcoderCountry {
    init(name: String, code: String) {
        self.countryCode = code
        self.description = name
    }
}

// Simple struct of an array of PostcoderCountry under .countries
struct PostcoderCountries {
    let countries: [PostcoderCountry]
}

extension PostcoderCountries {

    // Helper method to grab a country based on the ISO countryCode, for use with something like IP to Geo
    func getCountryByCode(_ countryCode: String) -> PostcoderCountry? {
        
        let country: PostcoderCountry? = self.countries.first{ $0.countryCode == countryCode }
        
        return country
    }
    
}

// Create a list of countries, used in the CountryController
let defaultCountries = PostcoderCountries(countries: [
    PostcoderCountry(name: "United Kingdom", code: "GB"),
    PostcoderCountry(name: "Republic of Ireland", code: "IE"),
    PostcoderCountry(name: "United States of America", code: "US"),
    PostcoderCountry(name: "France", code: "FR"),
    PostcoderCountry(name: "Germany", code: "DE"),
    PostcoderCountry(name: "Netherlands", code: "NL")
])
