//
//  KontactAuthorizationStatus.swift
//  Kontact
//
//  Created by Evan Dekhayser on 8/26/15.
//  Copyright © 2015 Xappox, LLC. All rights reserved.
//

import Contacts
import AddressBook

@objc public enum KontactAuthorizationStatus: Int{
	case NotDetermined = 0
	case Restricted = 1
	case Denied = 2
	case Authorized = 3
}