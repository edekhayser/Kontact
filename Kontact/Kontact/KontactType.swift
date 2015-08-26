//
//  KontactType.swift
//  Kontact
//
//  Created by Evan Dekhayser on 8/24/15.
//  Copyright © 2015 Xappox, LLC. All rights reserved.
//

import Contacts
import AddressBook

@objc public enum KontactType: Int{
	@available(*, message="Available on all versions.")
	case Contact
	@available(*, message="Available on iOS 9, OS X 10.11, watchOS 2, and above.")
	case Organization
	@available(*, message="Unavabilable on iOS 9, OS X 10.11, watchOS 2, and above.")
	case Group
	@available(*, message="Unavabilable on iOS 9, OS X 10.11, watchOS 2, and above.")
	case Source
	
	@available (*, deprecated=9.0)
	public init(type: ABRecordType){
		if type == ABRecordType(kABGroupType){
			self = .Group
		} else if type == ABRecordType(kABSourceType){
			self = .Source
		} else {
			self = .Contact
		}
	}
	
	@available (iOS 9, *)
	public init(type: CNContactType){
		if type == .Organization{
			self = .Organization
		} else {
			self = .Contact
		}
	}
	
	@available (*, deprecated=9.0)
	public var abType: ABRecordType{
		switch self{
		case .Group:
			return ABRecordType(kABGroupType)
		case .Source:
			return ABRecordType(kABSourceType)
		default:
			return ABRecordType(kABPersonType)
		}
	}
	
	@available (iOS 9, *)
	public var cnType: CNContactType{
		switch self{
		case .Contact:
			return CNContactType.Person
		default:
			return CNContactType.Organization
		}
	}
}
