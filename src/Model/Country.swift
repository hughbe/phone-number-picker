//
//  Country.swift
//  PhoneNumberPicker
//
//  Created by Hugh Bellamy on 06/09/2015.
//  Copyright (c) 2015 Hugh Bellamy. All rights reserved.
//

import Foundation

public func ==(lhs: Country, rhs: Country) -> Bool {
    return lhs.countryCode == rhs.countryCode
}

public class Country: NSObject {
    public static var emptyCountry: Country { return Country(countryCode: "", phoneExtension: "", isMain: true) }
    
    public static var currentCountry: Country {
        if let countryCode = (NSLocale.current as NSLocale).object(forKey: NSLocale.Key.countryCode) as? String {
            return Countries.countryFromCountryCode(countryCode: countryCode)
        }
        return Country.emptyCountry
    }
    
    public var countryCode: String
    public var phoneExtension: String
    public var isMain: Bool
    
    public init(countryCode: String, phoneExtension: String, isMain: Bool) {
        self.countryCode = countryCode
        self.phoneExtension = phoneExtension
        self.isMain = isMain
    }
    
    @objc public var name: String {
        return (NSLocale.current as NSLocale).displayName(forKey: NSLocale.Key.countryCode, value: countryCode) ?? "Invalid country code"
    }
}
