//
//  postcoderError.swift
//  AddressLookup
//
//  Created by Stephen Keable on 20/02/2018.
//  Copyright © 2018 Stephen Keable, under MIT licence.
//

// More detail on error handling from the API can be found here:-
// https://developers.alliescomputing.com/postcoder-web-api/error-handling

enum PostcoderError: Error {
    
    // Request failed, probably lack of connectivity
    case requestFailed
    
    // Request succedded, but response failed, possibly connectivity
    case responseUnsuccessful
    
    // URL up to and including the API key was badly formes
    case invalidBaseUrl
    
    // URL after the API was badly formed
    case invalidUrl
    
    // Data not present on response
    case invalidData
    
    // Converting data to JSON failed for some reason
    case jsonConversionFailure
    
    // Parsing JSON into Postcoder Addresses type failed
    case jsonParsingFailure
    
    // Request URL was malformed, normally an incorrect method/endpoint name
    case requestURLIncorrect
    
    // Usually the incorrect API Key was used, or account has no credits left
    case accountLevelError
    
    // 500 error, probably worth contacting the support team at Allies -
    // https://www.alliescomputing.com/support
    case serverSideError
    
    // Simple error, request successful but no addresses found (Handled in ListController)
    case noResultsFound
}
