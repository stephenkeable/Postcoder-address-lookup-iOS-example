//
//  DetailController.swift
//  AddressLookupMultiView
//
//  Created by Stephen Keable on 27/02/2018.
//  Copyright © 2018 Stephen Keable. All rights reserved.
//

import UIKit

// Controller for 3rd (final) step where the selected address is displayed in form fields (so that people can edit any mistakes)

class DetailController: UIViewController {
    
    @IBOutlet weak var addressLine1: UITextField!
    @IBOutlet weak var addressLine2: UITextField!
    @IBOutlet weak var addressLine3: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var postcode: UITextField!
    
    var selectedAddress: PostcoderAddress = PostcoderAddress()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Blank all fields, to get rid of old results
        addressLine1.text = ""
        addressLine2.text = ""
        addressLine3.text = ""
        city.text = ""
        postcode.text = ""
        
        // Unwrap each value and populate field
        if let addressLine1String = selectedAddress.addressLine1 {
            addressLine1.text = addressLine1String
        }
        
        if let addressLine2String = selectedAddress.addressLine2 {
            addressLine2.text = addressLine2String
        }
        
        if let addressLine3String = selectedAddress.addressLine3 {
            addressLine3.text = addressLine3String
        }
        
        if let postTownString = selectedAddress.postTown {
            city.text = postTownString
        }
        
        if let postcodeString = selectedAddress.postcode {
            postcode.text = postcodeString
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
