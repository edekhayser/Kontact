//
//  KontactPostalAddress.swift
//  Kontact
//
//  Created by Evan Dekhayser on 8/26/15.
//  Copyright © 2015 Xappox, LLC. All rights reserved.
//

import Contacts
import AddressBook

@objc public class KontactPostalAddress: NSObject{
	public let label: String
	
	public let street: String
	public let city: String
	public let state: String
	public let zipCode: String
	public let country: String
	public let countryCode: String
	
	public init(label: String, street: String, city: String, state: String, zipCode: String, country: String, countryCode: String){
		self.label = label
		self.street = street
		self.city = city
		self.state = state
		self.zipCode = zipCode
		self.country = country
		self.countryCode = countryCode
		super.init()
	}
}