//
//  Card+CoreDataProperties.swift
//  FlashCardCopy
//
//  Created by Irina Perepelkina on 19.06.2021.
//  Copyright © 2021 Irina Perepelkina. All rights reserved.
//
//

import Foundation
import CoreData


extension Card {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Card> {
        return NSFetchRequest<Card>(entityName: "Card")
    }

    @NSManaged public var question: String?
    @NSManaged public var answer: String?

}
