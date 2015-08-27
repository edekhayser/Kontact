//
//  KontactGroup.swift
//  Kontact
//
//  Created by Evan Dekhayser on 8/26/15.
//  Copyright © 2015 Xappox, LLC. All rights reserved.
//

import Contacts
import AddressBook

@objc public class KontactGroup: NSObject{
	
	private var r: AnyObject!
	@available (iOS, introduced=7.0, deprecated=9.0)
	@available (OSX, introduced=10.9, deprecated=10.11)
	@available (watchOS, unavailable)
	public var abGroup: ABRecordRef!{
		get{
			return r as ABRecordRef
		}
		set{
			r = newValue
		}
	}
	
	private var g: AnyObject!
	@available (iOS 9, *)
	@available (OSX 10.11, *)
	@available (watchOS 2.0, *)
	public var cnGroup: CNGroup!{
		get{
			return g as! CNGroup
		}
		set{
			g = newValue
		}
	}
	
	@available (iOS 9, *)
	@available (OSX 10.11, *)
	@available (watchOS 2.0, *)
	public func getIdentifier() -> String{
		return cnGroup.identifier
	}
	
	public func getName() -> String{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			return cnGroup.name
		} else {
			return ABRecordCopyValue(abGroup, kABGroupNameProperty).takeRetainedValue() as! String
		}
	}
	public func setName(newValue: String){
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			let copy = cnGroup.mutableCopy() as! CNMutableGroup
			copy.name = newValue
			cnGroup = copy
		} else {
			
		}
	}
	
}
