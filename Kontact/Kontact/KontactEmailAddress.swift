//
//  KontactEmailAddress.swift
//  Kontact
//
//  Created by Evan Dekhayser on 8/26/15.
//  Copyright © 2015 Xappox, LLC. All rights reserved.
//

import Contacts
import AddressBook

@objc public class KontactEmailAddress: NSObject{
	public let label: String
	public let emailAddress: String
	
	public init(label: String, emailAddress: String){
		self.label = label
		self.emailAddress = emailAddress
		super.init()
	}
}