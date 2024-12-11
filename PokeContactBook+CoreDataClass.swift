//
//  PokeContactBook+CoreDataClass.swift
//  PoketContact
//
//  Created by t2023-m0072 on 12/11/24.
//
//

import Foundation
import CoreData

@objc(PokeContactBook)
public class PokeContactBook: NSManagedObject {

    public static let className = "PokeContactBook"
    public enum Key {
        static let name = "name"
        static let phoneNumber = "phoneNumber"
        static let profileImage = "image"
    }
    
}
