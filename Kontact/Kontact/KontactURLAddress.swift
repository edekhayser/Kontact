//
//  KontactURLAddress.swift
//  Kontact
//
//  Created by Evan Dekhayser on 8/26/15.
//  Copyright © 2015 Xappox, LLC. All rights reserved.
//

import Contacts
import AddressBook

@objc public class KontactURLAddress: NSObject{
	public let label: String
	public let urlAddress: String
	
	public init(label: String, urlAddress: String){
		self.label = label
		self.urlAddress = urlAddress
		super.init()
	}
}