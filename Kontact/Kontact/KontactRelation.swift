//
//  KontactRelation.swift
//  Kontact
//
//  Created by Evan Dekhayser on 8/25/15.
//  Copyright © 2015 Xappox, LLC. All rights reserved.
//

import Contacts
import AddressBook

@objc public class KontactRelation: NSObject{
	public let name: String
	public let label: KontactRelationLabel
	
	public init(name: String, label: KontactRelationLabel){
		self.name = name
		self.label = label
		super.init()
	}
}
