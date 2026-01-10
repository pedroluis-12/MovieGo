//
//  CoreDataStack.swift
//
// Created by Pedro Luis Martins Coelho on 05/01/26.
//

import Foundation
import CoreData

public class CoreDataStack {
    public static let shared = CoreDataStack()
    
    public let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "MovieGo")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
    }
    
    public var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}
