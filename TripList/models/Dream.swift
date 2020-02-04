//
//  Dream.swift
//  LifeList
//
//  Created by Julien Vanheule on 18/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import Foundation
import CoreData

public class Dream: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID?
    @NSManaged public var createdAt: Date?
    @NSManaged public var completed: Bool
    @NSManaged public var title: String?
    @NSManaged public var placeId: String?
    @NSManaged public var note: String?
    @NSManaged public var order: Int
}

extension Dream {
    
    static func getAllDreams() -> NSFetchRequest<Dream> {
        let request: NSFetchRequest<Dream> = Dream.fetchRequest() as! NSFetchRequest<Dream>
        request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
          
        return request
    }
    
    func configure(place: Place){
        id = UUID()
        createdAt = Date()
        completed = false
        title = place.title
        placeId = place.id
        note = ""
    }
}
