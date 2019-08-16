//
//  Ride.swift
//  resevation
//
//  Created by mac on 8/15/19.
//  Copyright © 2019 alaa. All rights reserved.
//

import Foundation
import RealmSwift

class Ride: Object {
    @objc dynamic var source : Location? = nil
    @objc dynamic var destination : Location? = nil
    @objc dynamic var cost = 0
    @objc dynamic var id = ""
    @objc dynamic var dateTime = Date()
    var passenger = LinkingObjects(fromType: Passenger.self, property: "rides")
    
}

class Location: Object {
    @objc dynamic var name = ""
    @objc dynamic var address = ""
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    
}

class Passenger: Object {
    @objc dynamic var fullName = ""
    @objc dynamic var rating = 0
    @objc dynamic var phoneNumber = ""
    let rides = List<Ride>()
}
