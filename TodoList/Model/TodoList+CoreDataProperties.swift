//
//  TodoList+CoreDataProperties.swift
//  TodoList
//
//  Created by Alley Pereira on 25/10/20.
//
//

import Foundation
import CoreData


extension TodoList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoList> {
        return NSFetchRequest<TodoList>(entityName: "TodoList")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var reminders: String?

}

extension TodoList : Identifiable {

}
