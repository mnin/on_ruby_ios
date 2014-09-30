//
//  Topic.swift
//  onruby
//
//  Created by Martin Wilhelmi on 25.09.14.
//

import Foundation

class Topic {
    let id, user_id: Int
    let event_id: Int?
    let name, description: String

    init(event_id: Int?, id: Int, user_id: Int, name: String, description: String) {
        self.event_id    = event_id
        self.id          = id
        self.user_id     = user_id
        self.name        = name
        self.description = description
    }

    class func findAllForEvent(event_id: Int) -> [Topic] {
        let allTopics  = UserGroup.current().allTopics()
        var topicArray = [Topic]()

        for topic in allTopics {
            if topic.event_id == event_id {
                topicArray.append(topic)
            }
        }

        return topicArray
    }

    class func all() -> [Topic] {
        var topicsFromJson = UserGroup.getArrayFromJSON("topics")
        var topicArray     = [Topic]()
        var id, user_id: Int
        var event_id: Int?
        var name, description: String

        for topicDictionary in topicsFromJson {
            id          = topicDictionary["id"]          as Int
            user_id     = topicDictionary["user_id"]     as Int
            name        = topicDictionary["name"]        as String
            description = topicDictionary["description"] as String
            event_id    = (topicDictionary["event_id"] == nil || topicDictionary["event_id"] is NSNull) ? nil : (topicDictionary["event_id"]! as Int)

            topicArray.append(Topic(event_id: event_id, id: id, user_id: user_id, name: name, description: description))
        }

        return topicArray
    }
}
