//
//  KontactRelationLabel.swift
//  Kontact
//
//  Created by Evan Dekhayser on 8/25/15.
//  Copyright © 2015 Xappox, LLC. All rights reserved.
//

import Contacts
import AddressBook

@objc public enum KontactRelationLabel: Int{
	case Father
	case Mother
	case Parent
	case Brother
	case Sister
	case Child
	case Friend
	case Spouse
	case Partner
	case Assistant
	case Manager
	
	@available (iOS 9, *)
	@available (OSX 10.11, *)
	@available (watchOS 2.0, *)
	public init(contactLabel: String){
		switch contactLabel{
		case CNLabelContactRelationAssistant:
			self = .Assistant
		case CNLabelContactRelationBrother:
			self = .Brother
		case CNLabelContactRelationChild:
			self = .Child
		case CNLabelContactRelationFather:
			self = .Father
		case CNLabelContactRelationFriend:
			self = .Friend
		case CNLabelContactRelationManager:
			self = .Manager
		case CNLabelContactRelationMother:
			self = .Mother
		case CNLabelContactRelationParent:
			self = .Parent
		case CNLabelContactRelationPartner:
			self = .Partner
		case CNLabelContactRelationSister:
			self = .Sister
		default:
			self = .Spouse
		}
	}
	
	@available (iOS 9, *)
	@available (OSX 10.11, *)
	@available (watchOS 2.0, *)
	public var cnValue: String{
		switch self{
		case .Assistant:
			return CNLabelContactRelationAssistant
		case .Brother:
			return CNLabelContactRelationBrother
		case .Child:
			return CNLabelContactRelationChild
		case .Father:
			return CNLabelContactRelationFather
		case .Friend:
			return CNLabelContactRelationFriend
		case .Manager:
			return CNLabelContactRelationManager
		case .Mother:
			return CNLabelContactRelationMother
		case .Parent:
			return CNLabelContactRelationParent
		case .Partner:
			return CNLabelContactRelationPartner
		case .Sister:
			return CNLabelContactRelationSister
		default:
			return CNLabelContactRelationSpouse
		}
	}
	
	@available (iOS, introduced=7.0, deprecated=9.0)
	@available (OSX, introduced=10.9, deprecated=10.11)
	@available (watchOS, unavailable)
	public init(personLabel: CFString){
		switch String(personLabel){
		case String(kABPersonAssistantLabel):
			self = .Assistant
		case String(kABPersonBrotherLabel):
			self = .Brother
		case String(kABPersonChildLabel):
			self = .Child
		case String(kABPersonFatherLabel):
			self = .Father
		case String(kABPersonFriendLabel):
			self = .Friend
		case String(kABPersonManagerLabel):
			self = .Manager
		case String(kABPersonMotherLabel):
			self = .Mother
		case String(kABPersonParentLabel):
			self = .Parent
		case String(kABPersonPartnerLabel):
			self = .Partner
		case String(kABPersonSisterLabel):
			self = .Sister
		default:
			self = .Spouse
		}
	}
	
	@available (iOS, introduced=7.0, deprecated=9.0)
	@available (OSX, introduced=10.9, deprecated=10.11)
	@available (watchOS, unavailable)
	public var abValue: CFString{
		switch self{
		case .Assistant:
			return kABPersonAssistantLabel
		case .Brother:
			return kABPersonBrotherLabel
		case .Child:
			return kABPersonChildLabel
		case .Father:
			return kABPersonFatherLabel
		case .Friend:
			return kABPersonFriendLabel
		case .Manager:
			return kABPersonManagerLabel
		case .Mother:
			return kABPersonMotherLabel
		case .Parent:
			return kABPersonParentLabel
		case .Partner:
			return kABPersonPartnerLabel
		case .Sister:
			return kABPersonSisterLabel
		default:
			return kABPersonSpouseLabel
		}
	}
	
	
}