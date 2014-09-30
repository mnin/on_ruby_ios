//
//  User.swift
//  onruby
//
//  Created by Martin Wilhelmi on 25.09.14.
//

import Foundation

class User {
    let id: Int
    let available, freelancer: Bool?
    let imageURL, name, nickname: String
    let github, twitter, url: String?
    var image: UIImage?

    init(id: Int, available: Bool?, freelancer: Bool?, github: String?, imageURL: String, name: String, nickname: String, twitter: String?, url: String?) {
        self.id         = id
        self.available  = available
        self.freelancer = freelancer
        self.github     = github
        self.imageURL   = imageURL
        self.name       = name
        self.nickname   = nickname
        self.twitter    = twitter
        self.url        = url
    }

    class func loadFromJsonArray(participants: NSArray) -> [User] {
        var userArray = [User]()
        var user_id: Int
        var user: User?

        for participant in participants {
            user_id = participant.objectForKey("user_id") as Int
            user = User.find(user_id)?
            if user != nil {
                userArray.append(user!)
            }
        }

        return userArray
    }

    class func find(id: Int) -> User? {
        return UserGroup.current().allUserDictionary()[id]
    }

    class func loadUsersFromJSONDictionary(usersJsonDictionary: NSArray) -> Dictionary<Int, User> {
        var userDictionary = Dictionary<Int, User>()
        var id: Int
        var available, freelancer: Bool?
        var github, twitter, url: String?
        var imageURL, name, nickname: String

        for userJsonDictionary in usersJsonDictionary {
            id         = userJsonDictionary["id"]       as Int
            imageURL   = userJsonDictionary["image"]    as String
            name       = userJsonDictionary["name"]     as String
            nickname   = userJsonDictionary["nickname"] as String
            available  = (userJsonDictionary["available"]  == nil || userJsonDictionary["available"]  is NSNull) ? nil : (userJsonDictionary["available"]!  as Bool)
            freelancer = (userJsonDictionary["freelancer"] == nil || userJsonDictionary["freelancer"] is NSNull) ? nil : (userJsonDictionary["freelancer"]! as Bool)
            github     = (userJsonDictionary["github"]     == nil || userJsonDictionary["github"]     is NSNull) ? nil : (userJsonDictionary["github"]!     as String)
            twitter    = (userJsonDictionary["twitter"]    == nil || userJsonDictionary["twitter"]    is NSNull) ? nil : (userJsonDictionary["twitter"]!    as String)
            url        = (userJsonDictionary["url"]        == nil || userJsonDictionary["url"]        is NSNull) ? nil : (userJsonDictionary["url"]!        as String)

            userDictionary[id] = User(id: id, available: available, freelancer: freelancer, github: github, imageURL: imageURL, name: name, nickname: nickname, twitter: twitter, url: url)
        }

        return userDictionary
    }
}
