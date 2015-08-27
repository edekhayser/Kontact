//
//  KontactStore.swift
//  Kontact
//
//  Created by Evan Dekhayser on 8/26/15.
//  Copyright © 2015 Xappox, LLC. All rights reserved.
//

import Contacts
import AddressBook

@objc public class KontactStore: NSObject{
	
	static let sharedInstance = KontactStore()
	
	private var ab: AnyObject!
	@available (iOS, introduced=7.0, deprecated=9.0)
	@available (watchOS, unavailable)
	private var addressBook: ABAddressBookRef{
		get{
			if ab == nil{
				ab = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
			}
			return ab as ABAddressBookRef
		}
		set{
			ab = newValue
		}
	}
	
	public class func getAuthorizationStatus() -> KontactAuthorizationStatus{
		if #available(iOS 9, watchOS 2.0, *){
			return KontactAuthorizationStatus(rawValue: CNContactStore.authorizationStatusForEntityType(.Contacts).rawValue)!
		} else {
			return KontactAuthorizationStatus(rawValue: ABAddressBookGetAuthorizationStatus().rawValue as Int)!
		}
	}
	
	public func requestAccess(completionHandler: (Bool, NSError?) -> Void){
		if #available(iOS 9, watchOS 2.0, *){
			CNContactStore().requestAccessForEntityType(.Contacts, completionHandler: completionHandler)
		} else {
			addressBook.requestAccess(completionHandler)
		}
	}
	
	public func addEntities(entities: KontactEntity..., toContainerWithIdentifier identifier: String? = nil) throws {
		if #available(iOS 9, watchOS 2.0, *){
			let saveRequest = CNSaveRequest()
			for entity in entities{
				saveRequest.addContact(entity.contact.mutableCopy() as! CNMutableContact, toContainerWithIdentifier: identifier)
			}
			try CNContactStore().executeSaveRequest(saveRequest)
		} else {
			for entity in entities{
				ABAddressBookAddRecord(addressBook, entity.record, nil)
			}
			ABAddressBookSave(addressBook, nil)
		}
	}
	
	public func deleteEntities(entities: KontactEntity...) throws{
		if #available(iOS 9, watchOS 2.0, *){
			let saveRequest = CNSaveRequest()
			for entity in entities{
				saveRequest.deleteContact(entity.contact.mutableCopy() as! CNMutableContact)
			}
			try CNContactStore().executeSaveRequest(saveRequest)
		} else {
			for entity in entities{
				ABAddressBookRemoveRecord(addressBook, entity.record, nil)
			}
			ABAddressBookSave(addressBook, nil)
		}
	}
	
	@available (iOS, introduced=7.0, deprecated=9.0)
	@available (watchOS, unavailable)
	public func updateEntities() {
		ABAddressBookSave(addressBook, nil)
	}
	
	@available (iOS 9, *)
	@available (watchOS 2.0, *)
	public func updateEntities(entities: KontactEntity...) throws{
		let saveRequest = CNSaveRequest()
		for entity in entities{
			saveRequest.updateContact(entity.contact.mutableCopy() as! CNMutableContact)
		}
		try CNContactStore().executeSaveRequest(saveRequest)
	}
	
	public func entityWithIdentifier(identifier: String) throws -> KontactEntity{
		if #available(iOS 9, watchOS 2.0, *){
			return try KontactEntity(contact: CNContactStore().unifiedContactWithIdentifier(identifier, keysToFetch: []))
		} else {
			return KontactEntity(record: ABAddressBookGetPersonWithRecordID(addressBook, Int32(identifier)!).takeRetainedValue())
		}
	}
	
	public func getAllEntities() throws -> [KontactEntity]{
		if #available(iOS 9, watchOS 2.0, *){
			var entities = [KontactEntity]()
			try CNContactStore().enumerateContactsWithFetchRequest(CNContactFetchRequest(keysToFetch: [CNContactIdentifierKey]), usingBlock: { (contact, _) in
				entities.append(KontactEntity(contact: contact))
			})
			return entities
		} else {
			return (ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue() as [AnyObject]).map{
				return KontactEntity(record: $0)
			}
		}
	}
	
}
