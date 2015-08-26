//
//  KontactEntity.swift
//  Kontact
//
//  Created by Evan Dekhayser on 8/24/15.
//  Copyright © 2015 Xappox, LLC. All rights reserved.
//

import Contacts
import AddressBook

@objc public class KontactEntity: NSObject {
	
	// TODO: ABAddressBook Errors
	
	private var r: AnyObject!
	@available (iOS, introduced=7.0, deprecated=9.0)
	@available (OSX, introduced=10.9, deprecated=10.11)
	@available (watchOS, unavailable)
	public var record: ABRecordRef!{
		get{
			return r as ABRecordRef
		}
		set{
			r = newValue
		}
	}
	
	private var c: NSObject!
	@available (iOS 9, *)
	@available (OSX 10.11, *)
	@available (watchOS 2.0, *)
	public var contact: CNContact!{
		get{
			return c as? CNContact
		}
		set{
			c = newValue
		}
	}
	
	public override init(){
		super.init()
		if #available(iOS 9.0, OSX 10.11, watchOS 2.0, *){
			self.contact = CNContact()
		} else {
			self.record = ABPersonCreate().takeRetainedValue()
		}
	}
	
	@available (iOS, introduced=7.0, deprecated=9.0)
	@available (OSX, introduced=10.9, deprecated=10.11)
	@available (watchOS, unavailable)
	public init(record: ABRecordRef){
		super.init()
		self.record = record
	}
	
	@available (iOS 9, *)
	@available (OSX 10.11, *)
	@available (watchOS 2.0, *)
	public init(contact: CNContact){
		super.init()
		self.contact = contact
	}
	
	public func getIdentifier() -> String{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			return contact.identifier
		} else {
			return "\(ABRecordGetRecordID(record))"
		}
	}
	
	public func getContactType() throws -> KontactType{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactTypeKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactNamePrefixKey])
			}
			return KontactType(type: contact.contactType)
		} else {
			return KontactType(type: ABRecordGetRecordType(record))
		}
	}
	@available (iOS 9, *)
	@available (OSX 10.11, *)
	@available (watchOS 2.0, *)
	public func setContactType(newValue: KontactType) throws{
		if !contact.isKeyAvailable(CNContactTypeKey){
			try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactTypeKey])
		}
		let copy = contact.mutableCopy() as! CNMutableContact
		copy.contactType = newValue.cnType
		contact = copy.copy() as! CNContact
	}
	
	public func getBirthday() throws -> NSDateComponents?{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactBirthdayKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactBirthdayKey])
			}
			return contact.birthday
		} else {
			guard let date = ABRecordCopyValue(record, kABPersonBirthdayProperty).takeRetainedValue() as? NSDate else { return nil }
			let calendar: NSCalendar!
			if #available(iOS 8, *){
				calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
			} else {
				calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
			}
			return calendar.components([NSCalendarUnit.Day, NSCalendarUnit.Month, NSCalendarUnit.Year], fromDate: date)
		}
	}
	
	@available (iOS 9, *)
	@available (OSX 10.11, *)
	@available (watchOS 2.0, *)
	public func getNonGregorianBirthday() throws -> NSDateComponents?{
		if !contact.isKeyAvailable(CNContactNonGregorianBirthdayKey){
			try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactNonGregorianBirthdayKey])
		}
		return contact.nonGregorianBirthday
	}
	@available (iOS 9, *)
	@available (OSX 10.11, *)
	@available (watchOS 2.0, *)
	public func setNonGregorianBirthday(newValue: NSDateComponents?) throws{
		if !contact.isKeyAvailable(CNContactNonGregorianBirthdayKey){
			try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactNonGregorianBirthdayKey])
		}
		let copy = contact.mutableCopy() as! CNMutableContact
		copy.nonGregorianBirthday = newValue
		contact = copy.copy() as! CNContact
	}
	
	public func getDates() throws -> [KontactDate] {
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactDatesKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactDatesKey])
			}
			return contact.dates.map{ (labeledValue) -> KontactDate in
				return KontactDate(label: labeledValue.label, date: labeledValue.value as! NSDate)
			}
		} else {
			let multiValue = ABRecordCopyValue(record, kABPersonDateProperty).takeRetainedValue()
			var dates = [KontactDate]()
			for index in 0..<ABMultiValueGetCount(multiValue){
				dates.append(KontactDate(label: ABMultiValueCopyLabelAtIndex(multiValue, index).takeRetainedValue() as String, date: ABMultiValueCopyValueAtIndex(multiValue, index).takeRetainedValue() as! NSDate))
			}
			return dates
		}
	}
	public func setDates(newValue: [KontactDate]) throws{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactDatesKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactDatesKey])
			}
			let copy = contact.mutableCopy() as! CNMutableContact
			copy.dates = newValue.map{ (kontactDate) -> CNLabeledValue in
				return CNLabeledValue(label: kontactDate.label, value: kontactDate.date)
			}
			contact = copy.copy() as! CNContact
		} else {
			let multiValue = ABMultiValueCreateMutable(UInt32(kABMultiDateTimePropertyType)).takeRetainedValue()
			for kontactDate in newValue{
				ABMultiValueAddValueAndLabel(multiValue, kontactDate.date, kontactDate.label, nil)
			}
			ABRecordSetValue(record, kABPersonDateProperty, multiValue, nil)
		}
		
	}
	
	public func getPrefix() throws -> String{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactNamePrefixKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactNamePrefixKey])
			}
			return contact.namePrefix
		} else {
			return ABRecordCopyValue(record, kABPersonPrefixProperty).takeRetainedValue() as! String
		}
	}
	public func setPrefix(newValue: String?) throws{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactNamePrefixKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactNamePrefixKey])
			}
			let copy = contact!.mutableCopy() as! CNMutableContact
			copy.namePrefix = newValue ?? ""
			contact = copy.copy() as! CNContact
		} else {
			ABRecordSetValue(record, kABPersonPrefixProperty, newValue ?? "", nil)
		}
	}
	
	public func getFirstName() throws -> String{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactGivenNameKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactGivenNameKey])
			}
			return contact.givenName
		} else {
			return ABRecordCopyValue(record, kABPersonFirstNameProperty).takeRetainedValue() as! String
		}
	}
	public func setFirstName(newValue: String?) throws{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactGivenNameKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactGivenNameKey])
			}
			let copy = contact.mutableCopy() as! CNMutableContact
			copy.givenName = newValue ?? ""
			contact = copy.copy() as! CNContact
		} else {
			ABRecordSetValue(record, kABPersonFirstNameProperty, newValue ?? "", nil)
		}
	}
	
	public func getMiddleName() throws -> String{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactMiddleNameKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactMiddleNameKey])
			}
			return contact.middleName
		} else {
			return ABRecordCopyValue(record, kABPersonMiddleNameProperty).takeRetainedValue() as! String
		}
	}
	public func setMiddleName(newValue: String?) throws {
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactMiddleNameKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactMiddleNameKey])
			}
			let copy = contact.mutableCopy() as! CNMutableContact
			copy.middleName = newValue ?? ""
			contact = copy.copy() as! CNContact
		} else {
			ABRecordSetValue(record, kABPersonMiddleNameProperty, newValue ?? "", nil)
		}
	}
	
	public func getFamilyName() throws -> String{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactFamilyNameKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactFamilyNameKey])
			}
			return contact.familyName
		} else {
			return ABRecordCopyValue(record, kABPersonMiddleNameProperty).takeRetainedValue() as! String
		}
	}
	public func setFamilyName(newValue: String?) throws {
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactFamilyNameKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactFamilyNameKey])
			}
			let copy = contact.mutableCopy() as! CNMutableContact
			copy.familyName = newValue ?? ""
			contact = copy.copy() as! CNContact
		} else {
			ABRecordSetValue(record, kABPersonMiddleNameProperty, newValue ?? "", nil)
		}
	}
	
	@available (iOS 9, *)
	@available (OSX 10.11, *)
	@available (watchOS 2.0, *)
	public func getPreviousFamilyName() throws -> String{
		if !contact.isKeyAvailable(CNContactPreviousFamilyNameKey){
			try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactFamilyNameKey])
		}
		return contact.previousFamilyName
	}
	@available (iOS 9, *)
	@available (OSX 10.11, *)
	@available (watchOS 2.0, *)
	public func setPreviousFamilyName(newValue: String?) throws{
		if !contact.isKeyAvailable(CNContactPreviousFamilyNameKey){
			try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactFamilyNameKey])
		}
		let copy = contact.mutableCopy() as! CNMutableContact
		copy.previousFamilyName = newValue ?? ""
		contact = copy.copy() as! CNContact
	}
	
	public func getSuffix() throws -> String{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactNameSuffixKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactNameSuffixKey])
			}
			return contact.nameSuffix
		} else {
			return ABRecordCopyValue(record, kABPersonSuffixProperty).takeRetainedValue() as! String
		}
	}
	public func setSuffix(newValue: String?) throws{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactNameSuffixKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactNameSuffixKey])
			}
			let copy = contact.mutableCopy() as! CNMutableContact
			copy.nameSuffix = newValue ?? ""
			contact = copy.copy() as! CNContact
		} else {
			ABRecordSetValue(record, kABPersonSuffixProperty, newValue ?? "", nil)
		}
	}
	
	public func getPhoneticFirstName() throws -> String{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactPhoneticGivenNameKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactPhoneticGivenNameKey])
			}
			return contact.phoneticGivenName
		} else {
			return ABRecordCopyValue(record, kABPersonFirstNamePhoneticProperty).takeRetainedValue() as! String
		}
	}
	public func setPhoneticFirstName(newValue: String?) throws{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactPhoneticGivenNameKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactPhoneticGivenNameKey])
			}
			let copy = contact.mutableCopy() as! CNMutableContact
			copy.phoneticGivenName = newValue ?? ""
			contact = copy.copy() as! CNContact
		} else {
			ABRecordSetValue(record, kABPersonFirstNamePhoneticProperty, newValue ?? "", nil)
		}
	}
	
	public func getPhoneticMiddleName() throws -> String{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactPhoneticMiddleNameKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactPhoneticMiddleNameKey])
			}
			return contact.phoneticMiddleName
		} else {
			return ABRecordCopyValue(record, kABPersonMiddleNamePhoneticProperty).takeRetainedValue() as! String
		}
	}
	public func setPhoneticMiddleName(newValue: String?) throws{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactPhoneticMiddleNameKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactPhoneticMiddleNameKey])
			}
			let copy = contact.mutableCopy() as! CNMutableContact
			copy.phoneticMiddleName = newValue ?? ""
			contact = copy.copy() as! CNContact
		} else {
			ABRecordSetValue(record, kABPersonMiddleNamePhoneticProperty, newValue ?? "", nil)
		}
	}
	
	public func getPhoneticLastName() throws -> String{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactPhoneticFamilyNameKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactPhoneticFamilyNameKey])
			}
			return contact.phoneticFamilyName
		} else {
			return ABRecordCopyValue(record, kABPersonLastNamePhoneticProperty).takeRetainedValue() as! String
		}
	}
	public func setPhoneticLastName(newValue: String?) throws{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactPhoneticFamilyNameKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactPhoneticFamilyNameKey])
			}
			let copy = contact.mutableCopy() as! CNMutableContact
			copy.phoneticFamilyName = newValue ?? ""
			contact = copy.copy() as! CNContact
		} else {
			ABRecordSetValue(record, kABPersonLastNamePhoneticProperty, newValue ?? "", nil)
		}
	}
	
	public func getOrganizationName() throws -> String{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactOrganizationNameKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactOrganizationNameKey])
			}
			return contact.organizationName
		} else {
			return ABRecordCopyValue(record, kABPersonOrganizationProperty).takeRetainedValue() as! String
		}
	}
	public func setOrganizationName(newValue: String?) throws{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactOrganizationNameKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactOrganizationNameKey])
			}
			let copy = contact.mutableCopy() as! CNMutableContact
			copy.organizationName = newValue ?? ""
			contact = copy.copy() as! CNContact
		} else {
			ABRecordSetValue(record, kABPersonOrganizationProperty, newValue ?? "", nil)
		}
	}
	
	public func getDepartmentName() throws -> String{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactDepartmentNameKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactDepartmentNameKey])
			}
			return contact.departmentName
		} else {
			return ABRecordCopyValue(record, kABPersonDepartmentProperty).takeRetainedValue() as! String
		}
	}
	public func setDepartmentName(newValue: String?) throws{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactDepartmentNameKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactDepartmentNameKey])
			}
			let copy = contact.mutableCopy() as! CNMutableContact
			copy.departmentName = newValue ?? ""
			contact = copy.copy() as! CNContact
		} else {
			ABRecordSetValue(record, kABPersonDepartmentProperty, newValue ?? "", nil)
		}
	}
	
	public func getJobTitle() throws -> String{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactJobTitleKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactJobTitleKey])
			}
			return contact.jobTitle
		} else {
			return ABRecordCopyValue(record, kABPersonJobTitleProperty).takeRetainedValue() as! String
		}
	}
	public func setJobTitle(newValue: String?) throws{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactJobTitleKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactJobTitleKey])
			}
			let copy = contact!.mutableCopy() as! CNMutableContact
			copy.jobTitle = newValue ?? ""
			contact = copy.copy() as! CNContact
		} else {
			ABRecordSetValue(record, kABPersonJobTitleProperty, newValue ?? "", nil)
		}
	}
	
	public func getSocialProfiles() throws -> [KontactSocialProfile]{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactSocialProfilesKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactSocialProfilesKey])
			}
			return contact.socialProfiles.map{ (labeledValue: CNLabeledValue) -> KontactSocialProfile in
				let value = labeledValue.value as! CNSocialProfile
				return KontactSocialProfile(label: labeledValue.label, service: value.service, urlString: value.urlString, userIdentifier: value.userIdentifier, username: value.username)
			}
		} else {
			let multiValue = ABRecordCopyValue(record, kABPersonSocialProfileProperty).takeRetainedValue() as ABMultiValueRef
			var socialProfiles = [KontactSocialProfile]()
			for index in 0..<ABMultiValueGetCount(multiValue){
				let label = ABMultiValueCopyLabelAtIndex(multiValue, index).takeRetainedValue() as String
				let value = ABMultiValueCopyValueAtIndex(multiValue, index).takeRetainedValue() as! NSDictionary
				socialProfiles.append(KontactSocialProfile(label: label, service: value[String(kABPersonSocialProfileServiceKey)] as! String, urlString: value[String(kABPersonSocialProfileURLKey)] as! String, userIdentifier: value[String(kABPersonSocialProfileUserIdentifierKey)] as! String, username: value[String(kABPersonSocialProfileUsernameKey)] as! String))
			}
			return socialProfiles
		}
	}
	public func setSocialProfiles(newValue: [KontactSocialProfile]) throws {
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactSocialProfilesKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactSocialProfilesKey])
			}
			let profiles = newValue.map{ (profile) -> CNLabeledValue in
				let value = CNSocialProfile(urlString: profile.urlString, username: profile.username, userIdentifier: profile.userIdentifier, service: profile.service)
				return CNLabeledValue(label: profile.label, value: value)
			}
			let copy = contact!.mutableCopy() as! CNMutableContact
			copy.socialProfiles = profiles
			contact = copy.copy() as! CNContact
		} else {
			let multiValue = ABMultiValueCreateMutable(UInt32(kABDictionaryPropertyType)).takeRetainedValue()
			for profile in newValue{
				let dictionary = NSDictionary(dictionary: [kABPersonSocialProfileServiceKey : profile.service, kABPersonSocialProfileURLKey : profile.urlString, kABPersonSocialProfileUserIdentifierKey : profile.userIdentifier, kABPersonSocialProfileUsernameKey : profile.username], copyItems: true)
				ABMultiValueAddValueAndLabel(multiValue, dictionary, profile.label, nil)
			}
			ABRecordSetValue(record, kABPersonSocialProfileProperty, multiValue, nil)
		}
	}
	
	public func getPhoneNumbers() throws -> [KontactPhoneNumber]{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactPhoneNumbersKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactPhoneNumbersKey])
			}
			return contact.phoneNumbers.map{ (labeledValue) -> KontactPhoneNumber in
				return KontactPhoneNumber(label: labeledValue.label, phoneNumber: (labeledValue.value as! CNPhoneNumber).stringValue)
			}
		} else {
			let multiValue = ABRecordCopyValue(record, kABPersonPhoneProperty).takeRetainedValue()
			var phoneNumbers = [KontactPhoneNumber]()
			for index in 0..<ABMultiValueGetCount(multiValue){
				phoneNumbers.append(KontactPhoneNumber(label: ABMultiValueCopyLabelAtIndex(multiValue, index).takeRetainedValue() as String, phoneNumber: ABMultiValueCopyValueAtIndex(multiValue, index).takeRetainedValue() as! String))
			}
			return phoneNumbers
		}
	}
	public func setPhoneNumbers(newValue: [KontactPhoneNumber]) throws{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactPhoneNumbersKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactPhoneNumbersKey])
			}
			let phoneNumbers = newValue.map{ (number) -> CNLabeledValue in
				let value = CNPhoneNumber(stringValue: number.phoneNumber)
				return CNLabeledValue(label: number.label, value: value)
			}
			let copy = contact!.mutableCopy() as! CNMutableContact
			copy.phoneNumbers = phoneNumbers
			contact = copy.copy() as! CNContact
		} else {
			let multiValue = ABMultiValueCreateMutable(UInt32(kABMultiStringPropertyType)).takeRetainedValue()
			for number in newValue{
				ABMultiValueAddValueAndLabel(multiValue, number.phoneNumber, number.label, nil)
			}
			ABRecordSetValue(record, kABPersonPhoneProperty, multiValue, nil)
		}
	}
	
	public func getURLAddresses() throws -> [KontactURLAddress]{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactUrlAddressesKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactUrlAddressesKey])
			}
			return contact.urlAddresses.map{ (labeledValue) -> KontactURLAddress in
				return KontactURLAddress(label: labeledValue.label, urlAddress: labeledValue.value as! String)
			}
		} else {
			let multiValue = ABRecordCopyValue(record, kABPersonURLProperty).takeRetainedValue()
			var urlAddresses = [KontactURLAddress]()
			for index in 0..<ABMultiValueGetCount(multiValue){
				urlAddresses.append(KontactURLAddress(label: ABMultiValueCopyLabelAtIndex(multiValue, index).takeRetainedValue() as String, urlAddress: ABMultiValueCopyValueAtIndex(multiValue, index).takeRetainedValue() as! String))
			}
			return urlAddresses
		}
	}
	public func setURLAddresses(newValue: [KontactURLAddress]) throws{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactUrlAddressesKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactUrlAddressesKey])
			}
			let labeledValues = newValue.map{ (number) -> CNLabeledValue in
				return CNLabeledValue(label: number.label, value: number.urlAddress)
			}
			let copy = contact!.mutableCopy() as! CNMutableContact
			copy.urlAddresses = labeledValues
			contact = copy.copy() as! CNContact
		} else {
			let multiValue = ABMultiValueCreateMutable(UInt32(kABMultiStringPropertyType)).takeRetainedValue()
			for address in newValue{
				ABMultiValueAddValueAndLabel(multiValue, address.urlAddress, address.label, nil)
			}
			ABRecordSetValue(record, kABPersonURLProperty, multiValue, nil)
		}
	}
	
	public func getPostalAddresses() throws -> [KontactPostalAddress]{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactPostalAddressesKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactPostalAddressesKey])
			}
			return contact.postalAddresses.map{ (labeledValue: CNLabeledValue) -> KontactPostalAddress in
				let postal = labeledValue.value as! CNPostalAddress
				return KontactPostalAddress(label: labeledValue.label, street: postal.street, city: postal.city, state: postal.state, zipCode: postal.postalCode, country: postal.country, countryCode: postal.ISOCountryCode)
			}
		} else {
			let multiValue = ABRecordCopyValue(record, kABPersonAddressProperty).takeRetainedValue()
			var postalAddresses = [KontactPostalAddress]()
			for index in 0..<ABMultiValueGetCount(multiValue){
				let dictionary = ABMultiValueCopyValueAtIndex(multiValue, index).takeRetainedValue()
				postalAddresses.append(KontactPostalAddress(label: ABMultiValueCopyLabelAtIndex(multiValue, index).takeRetainedValue() as String, street: dictionary[String(kABPersonAddressStreetKey)] as! String, city: dictionary[String(kABPersonAddressCityKey)] as! String, state: dictionary[String(kABPersonAddressStateKey)] as! String, zipCode: dictionary[String(kABPersonAddressZIPKey)] as! String, country: dictionary[String(kABPersonAddressCountryKey)] as! String, countryCode: dictionary[String(kABPersonAddressCountryCodeKey)] as! String))
			}
			return postalAddresses
		}
	}
	public func setPostalAddresses(newValue: [KontactPostalAddress]) throws{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactPostalAddressesKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactPostalAddressesKey])
			}
			let copy = contact.mutableCopy() as! CNMutableContact
			copy.postalAddresses = newValue.map{ (postal) -> CNLabeledValue in
				let value = CNMutablePostalAddress()
				value.street = postal.street
				value.city = postal.city
				value.state = postal.state
				value.postalCode = postal.zipCode
				value.country = postal.country
				value.ISOCountryCode = postal.countryCode
				return CNLabeledValue(label: postal.label, value: value)
			}
			contact = copy.copy() as! CNContact
		} else {
			let multiValue = ABMultiValueCreateMutable(UInt32(kABMultiDictionaryPropertyType)).takeRetainedValue()
			for address in newValue{
				let dictionary = [String(kABPersonAddressStreetKey) : address.street, String(kABPersonAddressCityKey) : address.city, String(kABPersonAddressStateKey) : address.state, String(kABPersonAddressZIPKey) : address.zipCode, String(kABPersonAddressCountryKey) : address.country, String(kABPersonAddressCountryCodeKey) : address.countryCode]
				ABMultiValueAddValueAndLabel(multiValue, dictionary, address.label, nil)
			}
			ABRecordSetValue(record, kABPersonAddressProperty, multiValue, nil)
		}
	}
	
	public func getEmailAddresses() throws -> [KontactEmailAddress]{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactEmailAddressesKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactEmailAddressesKey])
			}
			return contact.emailAddresses.map{ (labeledValue) -> KontactEmailAddress in
				return KontactEmailAddress(label: labeledValue.label, emailAddress: labeledValue.value as! String)
			}
		} else {
			let multiValue = ABRecordCopyValue(record, kABPersonEmailProperty).takeRetainedValue()
			var emailAddresses = [KontactEmailAddress]()
			for index in 0..<ABMultiValueGetCount(multiValue){
				emailAddresses.append(KontactEmailAddress(label: ABMultiValueCopyLabelAtIndex(multiValue, index).takeRetainedValue() as String, emailAddress: ABMultiValueCopyValueAtIndex(multiValue, index).takeRetainedValue() as! String))
			}
			return emailAddresses
		}
	}
	public func setEmailAddresses(newValue: [KontactEmailAddress]) throws{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactEmailAddressesKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactEmailAddressesKey])
			}
			let emailAddresses = newValue.map{ (number) -> CNLabeledValue in
				return CNLabeledValue(label: number.label, value: number.emailAddress)
			}
			let copy = contact!.mutableCopy() as! CNMutableContact
			copy.emailAddresses = emailAddresses
			contact = copy.copy() as! CNContact
		} else {
			let multiValue = ABMultiValueCreateMutable(UInt32(kABMultiStringPropertyType)).takeRetainedValue()
			for address in newValue{
				ABMultiValueAddValueAndLabel(multiValue, address.emailAddress, address.label, nil)
			}
			ABRecordSetValue(record, kABPersonEmailProperty, multiValue, nil)
		}
	}
	
	public func getNote() throws -> String{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactNoteKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactNoteKey])
			}
			return contact.note
		} else {
			return ABRecordCopyValue(record, kABPersonNoteProperty).takeRetainedValue() as! String
		}
	}
	public func setNote(newValue: String?) throws{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactNoteKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactNoteKey])
			}
			let copy = contact.mutableCopy() as! CNMutableContact
			copy.note = newValue ?? ""
			contact = copy.copy() as! CNContact
		} else {
			ABRecordSetValue(record, kABPersonNoteProperty, newValue ?? "", nil)
		}
	}
	
	public func getContactRelations() throws -> [KontactRelation]{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactRelationsKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactRelationsKey])
			}
			return contact.contactRelations.map({ (labeledValue) -> KontactRelation in
				let name = (labeledValue.value as! CNContactRelation).name
				let label = labeledValue.label
				return KontactRelation(name: name, label: KontactRelationLabel(contactLabel: label))
			})
		} else {
			let multiValue = ABRecordCopyValue(record, kABPersonRelatedNamesProperty).takeRetainedValue() as ABMultiValueRef
			var relations = [KontactRelation]()
			for index in 0..<ABMultiValueGetCount(multiValue){
				relations.append(KontactRelation(name: ABMultiValueCopyValueAtIndex(multiValue, index).takeRetainedValue() as! String, label: KontactRelationLabel(personLabel: ABMultiValueCopyLabelAtIndex(multiValue, index).takeRetainedValue())))
			}
			return relations
		}
	}
	public func setContactRelations(newValue: [KontactRelation]) throws{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactRelationsKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactRelationsKey])
			}
			let relations = newValue.map{ (relation: KontactRelation) -> CNLabeledValue in
				let contactRelation = CNContactRelation(name: relation.name)
				return CNLabeledValue(label: relation.label.cnValue, value: contactRelation)
			}
			let copy = contact.mutableCopy() as! CNMutableContact
			copy.contactRelations = relations
			contact = copy.copy() as! CNContact
		} else {
			let multiValue = ABMultiValueCreateMutable(UInt32(kABStringPropertyType)).takeRetainedValue()
			for relation in newValue{
				ABMultiValueAddValueAndLabel(multiValue, relation.name, relation.label.abValue, nil)
			}
		}
	}
	
	@available (iOS 9, *)
	@available (OSX 10.11, *)
	@available (watchOS 2.0, *)
	public func getInstantMessagingAddresses() throws -> [CNLabeledValue]{
		if !contact.isKeyAvailable(CNContactInstantMessageAddressesKey){
			try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactInstantMessageAddressesKey])
		}
		return contact.instantMessageAddresses
	}
	@available (iOS 9, *)
	@available (OSX 10.11, *)
	@available (watchOS 2.0, *)
	public func setInstantMessagingAddresses(newValue: [CNLabeledValue]) throws{
		if !contact.isKeyAvailable(CNContactRelationsKey){
			try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactRelationsKey])
		}
		let copy = contact.mutableCopy() as! CNMutableContact
		copy.instantMessageAddresses = newValue
		contact = copy.copy() as! CNContact
	}
	
	public func getImageData() throws -> NSData?{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactImageDataKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactNoteKey])
			}
			return contact.imageData
		} else {
			return ABPersonCopyImageData(record).takeRetainedValue() as NSData?
		}
	}
	public func setImageData(newValue: NSData?) throws{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactImageDataKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactImageDataKey])
			}
			let copy = contact.mutableCopy() as! CNMutableContact
			copy.imageData = newValue
			contact = copy.copy() as! CNContact
		} else {
			ABPersonSetImageData(record, newValue, nil)
		}
	}
	
	public func isImageDataAvailable() throws -> Bool{
		if #available(iOS 9, OSX 10.11, watchOS 2.0, *){
			if !contact.isKeyAvailable(CNContactImageDataAvailableKey){
				try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactImageDataAvailableKey])
			}
			return contact.imageDataAvailable
		} else {
			return ABPersonHasImageData(record)
		}
	}
	
	@available (iOS 9, *)
	@available (OSX 10.11, *)
	@available (watchOS 2.0, *)
	public func getThumbnailImageData() throws -> NSData?{
		if !contact.isKeyAvailable(CNContactThumbnailImageDataKey){
			try contact = CNContactStore().unifiedContactWithIdentifier(contact.identifier, keysToFetch: [CNContactThumbnailImageDataKey])
		}
		return contact.thumbnailImageData
	}
	
}
