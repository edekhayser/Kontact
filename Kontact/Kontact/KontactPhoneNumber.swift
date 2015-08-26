//
//  KontactPhoneNumber.swift
//  Kontact
//
//  Created by Evan Dekhayser on 8/26/15.
//  Copyright © 2015 Xappox, LLC. All rights reserved.
//

import Contacts
import AddressBook

@objc public class KontactPhoneNumber: NSObject{
	public let label: String
	public let phoneNumber: String
	
	public init(label: String, phoneNumber: String){
		self.label = label
		self.phoneNumber = phoneNumber
		super.init()
	}
}