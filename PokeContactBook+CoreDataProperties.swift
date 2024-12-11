//
//  PokeContactBook+CoreDataProperties.swift
//  PoketContact
//
//  Created by t2023-m0072 on 12/11/24.
//
//

import Foundation
import CoreData


extension PokeContactBook {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PokeContactBook> {
        return NSFetchRequest<PokeContactBook>(entityName: "PokeContactBook")
    }

    @NSManaged public var image: String?
    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String?

}

extension PokeContactBook : Identifiable {

}
