//
//  postcoderClient.swift
//  AddressLookup
//
//  Created by Stephen Keable on 20/02/2018.
//  Copyright © 2018 Stephen Keable. All rights reserved.
//

import Foundation

class PostcoderClient {
    
    // This is a test API key, which only works with UK and always return addresses for postcode "NR14 7PZ"
    // To get a trial API key sign up at - https://www.alliescomputing.com/postcoder/sign-up
    
    fileprivate let postcoderApiKey = "PCW45-12345-12345-1234X"
    
    // Store base URL with API Key for use with any method/endpoint
    lazy var baseUrl: String = {
        var baseUrlComponents = URLComponents()
        
        baseUrlComponents.scheme = "https"
        baseUrlComponents.host = "ws.postcoder.com"
        baseUrlComponents.path = "/pcw/\(postcoderApiKey)"
    
        if let baseUrl = baseUrlComponents.string {
            return baseUrl
        } else {
            return ""
        }
    }()
    
    let downloader = JSONDownloader()
    
    // MARK: - Postcoder Address lookup for the /address/ method
    
    typealias PostcoderAddressCompletionHandler = (PostcoderAddresses?, PostcoderError?) -> Void
    
    func getAddresses(for postcode: String, page: Int, country: String, completionHandler completion: @escaping PostcoderAddressCompletionHandler) {
        
        // Check the baseUrl is ok to work with
        guard var urlComponents = URLComponents(string: self.baseUrl) else {
            completion(nil, .invalidBaseUrl)
            return
        }
        
        // Add some basic query string parameters to our URL
        
        let linesParam = URLQueryItem(name: "lines", value: "3")
        let pageParam = URLQueryItem(name: "page", value: "\(page)")
        let identifierParam = URLQueryItem(name: "identifier", value: "iOS_Swift_Example_Code")
        
        urlComponents.queryItems = [linesParam, pageParam, identifierParam]
        
        guard var url = urlComponents.url else {
            completion(nil, .invalidUrl)
            return
        }
        
        // Additional query string parameters for /address/ can found at:-
        // https://developers.alliescomputing.com/postcoder-web-api/address-lookup/premise
        
        // Add the endpoint (address), country and postcode input to the URL
        url.appendPathComponent("address/\(country)/\(postcode)")
        
        let request = URLRequest(url: url)
        
        // Create the full task with the request
        let task = downloader.jsonTask(with: request) { json, error in
            
            DispatchQueue.main.async {
                
                guard let json = json else {
                    completion(nil, error)
                    return
                }
                
                // Create a PostcoderAddresses instance using the JSON returned from the API
                guard let postcoderAddressJSON = json as? [[String: AnyObject]], let postcoderAddresses = PostcoderAddresses(json: postcoderAddressJSON) else {
                    completion(nil, .jsonParsingFailure)
                    return
                }
                
                completion(postcoderAddresses, nil)
                
            }
        }
        // Fire the request off to the API
        task.resume()
    }
    
}

// MARK - JSON Downloader - So can be reused by multiple clients or additional methods in the the PostcoderClient

class JSONDownloader {
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    // Couple of typealias to tidy things up
    typealias JSONArray = [AnyObject]
    typealias JSONTaskCompletionHandler = (JSONArray?, PostcoderError?) -> Void
    
    func jsonTask(with request: URLRequest, completionHandler completion: @escaping JSONTaskCompletionHandler) -> URLSessionDataTask {
        
        // Add the JSON header, to ensure we get JSON back, not XML.
        var jsonRequest = request
        jsonRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTask(with: jsonRequest) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            
            if httpResponse.statusCode == 200 {
                if let data = data {
                    do {
                        // We have a 200 code and some data back, now try to convert to JSON
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? JSONArray
                        
                        if let json = json {
                            
                            // Check how many items in JSON Array, returns empty array when no addresses are found
                            if json.count == 0 {
                                completion(nil, .noResultsFound)
                            } else {
                                completion(json, nil)
                            }
                        }
                    } catch {
                        completion(nil, .jsonConversionFailure)
                    }
                } else {
                    completion(nil, .invalidData)
                }
            } else if httpResponse.statusCode == 403 {
                completion(nil, .accountLevelError)
            } else if httpResponse.statusCode == 404 {
                completion(nil, .requestURLIncorrect)
            } else if httpResponse.statusCode == 500 {
                completion(nil, .serverSideError)
            } else {
                completion(nil, .responseUnsuccessful)
            }
        }
        return task
    }
}
