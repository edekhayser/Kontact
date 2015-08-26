//
//  KontactDate.swift
//  Kontact
//
//  Created by Evan Dekhayser on 8/26/15.
//  Copyright © 2015 Xappox, LLC. All rights reserved.
//

import Contacts
import AddressBook

@objc public class KontactDate: NSObject{
	public let label: String
	public let date: NSDate
	
	public init(label: String, date: NSDate){
		self.label = label
		self.date = date
		super.init()
	}
}