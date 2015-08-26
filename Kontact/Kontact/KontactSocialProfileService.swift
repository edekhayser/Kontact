//
//  KontactSocialProfileService.swift
//  Kontact
//
//  Created by Evan Dekhayser on 8/26/15.
//  Copyright © 2015 Xappox, LLC. All rights reserved.
//

import Contacts
import AddressBook

@objc public enum KontactSocialProfileService: Int{
	case Facebook
	case Flickr
	case LinkedIn
	case MySpace
	case SinaWeibo
	case Twitter
	case GameCenter
	@available (iOS, introduced=7.0, deprecated=9.0)
	@available (OSX, introduced=10.9, deprecated=10.11)
	@available (watchOS, unavailable)
	case Yelp
	@available (iOS, introduced=7.0, deprecated=9.0)
	@available (OSX, introduced=10.9, deprecated=10.11)
	@available (watchOS, unavailable)
	case TencentWeibo
	
	@available (iOS 9, *)
	@available (OSX 10.11, *)
	@available (watchOS 2.0, *)
	public var cnValue: String{
		switch self{
		case .Facebook:
			return CNSocialProfileServiceFacebook
		case .Flickr:
			return CNSocialProfileServiceFlickr
		case .LinkedIn:
			return CNSocialProfileServiceLinkedIn
		case .MySpace:
			return CNSocialProfileServiceMySpace
		case .SinaWeibo:
			return CNSocialProfileServiceSinaWeibo
		case .TencentWeibo:
			return CNSocialProfileServiceTencentWeibo
		case .Twitter:
			return CNSocialProfileServiceTwitter
		case .Yelp:
			return CNSocialProfileServiceYelp
		case .GameCenter:
			return CNSocialProfileServiceGameCenter
		}
	}
	
	@available (iOS, introduced=7.0, deprecated=9.0)
	@available (OSX, introduced=10.9, deprecated=10.11)
	@available (watchOS, unavailable)
	public var abValue: String{
		switch self{
		case .Facebook:
			return String(kABPersonSocialProfileServiceFacebook)
		case .Flickr:
			return String(kABPersonSocialProfileServiceFlickr)
		case .LinkedIn:
			return String(kABPersonSocialProfileServiceLinkedIn)
		case .MySpace:
			return String(kABPersonSocialProfileServiceMyspace)
		case .SinaWeibo:
			return String(kABPersonSocialProfileServiceSinaWeibo)
		case .Twitter:
			return String(kABPersonSocialProfileServiceTwitter)
		case .GameCenter:
			return String(kABPersonSocialProfileServiceGameCenter)
		default:
			assert(false, "\(self) is invalid before iOS 9, OS X 10.11, and watchOS 2.")
			return ""
		}
	}
}