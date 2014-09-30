//
//  Location.swift
//  onruby
//
//  Created by Martin Wilhelmi on 25.09.14.
//

import Foundation

class Location {
    let id: Int
    let name, street, house_number, zip, city, url: String

    init(id: Int, name: String, street: String, house_number: String, zip: String, city: String, url: String) {
        self.id           = id
        self.name         = name
        self.street       = street
        self.house_number = house_number
        self.zip          = zip
        self.city         = city
        self.url          = url
    }

    class func loadFromJsonDictionary(locationDictionary: NSDictionary) -> Location {
        let id           = locationDictionary["id"]           as Int
        let name         = locationDictionary["name"]         as String
        let street       = locationDictionary["street"]       as String
        let house_number = locationDictionary["house_number"] as String
        let zip          = locationDictionary["zip"]          as String
        let city         = locationDictionary["city"]         as String
        let url          = locationDictionary["url"]          as String

        return Location(id: id, name: name, street: street, house_number: house_number, zip: zip, city: city, url: url)
    }
}
