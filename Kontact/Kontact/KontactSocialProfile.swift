//
//  KontactSocialProfile.swift
//  Kontact
//
//  Created by Evan Dekhayser on 8/26/15.
//  Copyright © 2015 Xappox, LLC. All rights reserved.
//

import Contacts
import AddressBook

@objc public class KontactSocialProfile: NSObject{
	public let label: String
	public let service: String
	public let urlString: String
	public let userIdentifier: String
	public let username: String
	
	public init(label: String, service: String, urlString: String, userIdentifier: String, username: String){
		self.label = label
		self.service = service
		self.urlString = urlString
		self.userIdentifier = userIdentifier
		self.username = username
		super.init()
	}
	
}