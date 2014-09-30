//
//  Material.swift
//  onruby
//
//  Created by Martin Wilhelmi on 25.09.14.
//

import Foundation

class Material {
    let id: Int
    let user_id: Int?
    let name, url: String

    init(id: Int, user_id: Int?, name: String, url: String) {
        self.id      = id
        self.user_id = user_id
        self.name    = name
        self.url     = url
    }

    class func loadFromJsonArray(materialsFromJson: NSArray) -> [Material] {
        var materialArray = [Material]()
        var id: Int
        var user_id: Int?
        var name, url: String

        for dict in materialsFromJson {
            id      = dict["id"]   as Int
            name    = dict["name"] as String
            url     = dict["url"]  as String
            user_id = (dict["user_id"] == nil || dict["user_id"] is NSNull) ? nil : (dict["user_id"]! as Int)

            materialArray.append(Material(id: id, user_id: user_id, name: name, url: url))
        }

        return materialArray
    }
}
