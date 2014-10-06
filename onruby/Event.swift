//
//  Event.swift
//  onruby
//
//  Created by Martin Wilhelmi on 24.09.14.
//

import Foundation

class Event {
    let id: Int
    let name, description: String
    let date: NSDate
    let location: Location
    let user: User?
    let topicArray: [Topic]
    let participantsArray: [User]
    let materialsArray: [Material]

    init(id: Int, name: String, description: String, date: NSDate, topicArray: [Topic], materialsArray: [Material], participantsArray: [User], user: User?, location: Location) {
        self.id                = id
        self.name              = name
        self.description       = description
        self.date              = date
        self.topicArray        = topicArray
        self.materialsArray    = materialsArray
        self.participantsArray = participantsArray
        self.user              = user
        self.location          = location
    }

    func dateString() -> String {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
        return dateFormatter.stringFromDate(self.date)
    }

    class func all() -> [Event] {
        var eventsFromJson = UserGroup.getArrayFromJSON("events")
        var eventArray     = [Event]()
        var id: Int
        var location: Location
        var user: User?
        var name, description, dateString: String
        var date: NSDate!
        var topicArray: [Topic]
        var participantsArray: [User]
        var materialsArray: [Material]

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"

        for eventDictionary in eventsFromJson {
            id                = eventDictionary["id"]          as Int
            name              = eventDictionary["name"]        as String
            description       = eventDictionary["description"] as String
            dateString        = eventDictionary["date"]        as String
            participantsArray = User.loadFromJsonArray(eventDictionary["participants"] as NSArray)
            user              = User.find(eventDictionary["user_id"] as Int)
            topicArray        = Topic.findAllForEvent(id)
            materialsArray    = Material.loadFromJsonArray(eventDictionary["materials"] as NSArray)
            location          = Location.loadFromJsonDictionary(eventDictionary["location"] as NSDictionary)

            date = dateFormatter.dateFromString(dateString)

            eventArray.append(Event(id: id, name: name, description: description, date: date, topicArray: topicArray, materialsArray: materialsArray, participantsArray: participantsArray, user: user, location: location))
        }

        return eventArray.sorted({$0.date.timeIntervalSince1970 > $1.date.timeIntervalSince1970})
    }
}
