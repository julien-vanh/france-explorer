//
//  Completion.swift
//  TripList
//
//  Created by Julien Vanheule on 04/02/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import Foundation
import CoreData

public class Completion: NSManagedObject, Identifiable {
    @NSManaged public var placeId: String?
    @NSManaged public var createdAt: Date?
}

extension Completion {
    
    static func getAllCompletion() -> NSFetchRequest<Completion> {
        let request: NSFetchRequest<Completion> = Completion.fetchRequest() as! NSFetchRequest<Completion>
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        return request
    }
    
    func configure(placeId: String){
        self.placeId = placeId
        self.createdAt = Date()
    }
}
