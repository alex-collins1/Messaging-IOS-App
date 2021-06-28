//
//  Constants.swift
//  Flash Chat iOS13
//
//  Created by Alex Collins on 18/06/2021.
//  Copyright © 2021 Angela Yu. All rights reserved.
//



// the static key word will make the registerSegue and the loginSegue a property of the struct, so insetad of having to type out RegisterToChat all the time, we can say Constants.registerSegue instead, decreases chance of code bugging //

struct K {
    static let appName = "⚡️FlashChat"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
