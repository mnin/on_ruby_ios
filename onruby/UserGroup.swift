//
//  Group.swift
//  onruby
//
//  Created by Martin Wilhelmi on 24.09.14.
//

import Foundation

let allUserGroups = [
    UserGroup(key: "hamburg",      name: "Hamburg",                  twitter: "hamburgsync"),
    UserGroup(key: "bremen",       name: "HackHB",                   twitter: "hackhb"),
    UserGroup(key: "cologne",      name: "Kölsch.rb",                twitter: "colognerb"),
    UserGroup(key: "saar",         name: "RUGSaar",                  twitter: "RUGSaar"),
    UserGroup(key: "karlsruhe",    name: "Ruby Usergroup Karlsruhe", twitter: "rug_ka"),
    UserGroup(key: "berlin",       name: "Ruby Usergroup Berlin",    twitter: "rug_b"),
    UserGroup(key: "leipzig",      name: "LoR",                      twitter: "LeipzigOnRails"),
    UserGroup(key: "dresden",      name: "Ruby Usergroup Dresden",   twitter: "ruby_dresden"),
    UserGroup(key: "railsgirlshh", name: "Railsgirls Hamburg",       twitter: "railsgirlshh"),
    UserGroup(key: "bonn",         name: "bonn.rb",                  twitter: "bonnrb"),
    UserGroup(key: "innsbruck",    name: "Innsbruck.rb",             twitter: "innsbruckrb")
]

class UserGroup {
    var jsonDictionary: NSDictionary?
    var events          = [Event]()
    var topics          = [Topic]()
    var userDictionary  = Dictionary<Int, User>()
    let name, key, twitter: String

    init(key: String, name: String, twitter: String) {
        self.key     = key
        self.name    = name
        self.twitter = twitter
    }

    func twitterUrl() -> NSURL {
        return NSURL(string: "https://twitter.com/\(self.twitter)")
    }

    func homepageUrl() -> NSURL {
        return NSURL(string: "http://\(self.key).onruby.de")
    }

    func dataUrlString() -> String {
        return "http://\(self.key).onruby.de/api.json"
    }

    func getFilePathForKey() -> String {
        let fileManager     = NSFileManager.defaultManager()
        var downloaded_path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        var documents_path  = NSBundle.mainBundle().resourcePath!

        downloaded_path += "/\(self.key).json"
        documents_path  += "/\(self.key).json"

        if fileManager.fileExistsAtPath(downloaded_path) {
            return downloaded_path
        } else {
            return documents_path
        }
    }

    func getModificationDate() -> NSDate {
        let fileManager = NSFileManager.defaultManager()
        let fileAttributeDictionary = fileManager.attributesOfItemAtPath(self.getFilePathForKey(), error: nil) as Dictionary!
        let modificationDate = fileAttributeDictionary[NSFileModificationDate] as NSDate!

        return modificationDate
    }

    func getJSON() -> NSDictionary {
        if self.jsonDictionary? == nil {
            var error: NSError?
            let filepath = getFilePathForKey()
            let jsonData = NSData.dataWithContentsOfFile(filepath, options: NSDataReadingOptions.DataReadingMapped, error: &error)

            self.jsonDictionary = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &error) as? NSDictionary
        }

        return self.jsonDictionary!
    }

    func setAsCurrent() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let key      = self.key
        defaults.setValue(key, forKey: "currentCityKey")
        defaults.synchronize()
        self.resetCache()
    }

    func allUserDictionary() -> Dictionary<Int, User> {
        if self.userDictionary.count == 0 {
            self.userDictionary = User.loadUsersFromJSONDictionary(UserGroup.getArrayFromJSON("users"))
        }

        return self.userDictionary
    }

    func allEvents() -> [Event] {
        if self.events.isEmpty {
            self.events = Event.all()
        }

        return self.events
    }

    func allTopics() -> [Topic] {
        if self.topics.isEmpty {
            self.topics = Topic.all()
        }

        return self.topics
    }

    func reloadJSONFile() {
        let manager = AFHTTPRequestOperationManager()
        var filepath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        filepath += "/\(self.key).json"

        manager.requestSerializer.setValue(API_KEY, forHTTPHeaderField: "x-api-key")
        manager.GET(self.dataUrlString(), parameters: nil, success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
            var data = operation.responseData
            data.writeToFile(filepath, atomically: false)
            if UserGroup.current().key == self.key {
                let notificationCenter = NSNotificationCenter.defaultCenter()
                self.resetCache()

                notificationCenter.postNotificationName("reloadUserGroup", object: nil)
            }
        }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
            let alertView = UIAlertView(title: "Error", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
        })
    }

    func resetCache() {
        self.jsonDictionary = nil
        self.userDictionary.removeAll(keepCapacity: true)
        self.events = []
        self.topics = []
    }

    class func current() -> UserGroup {
        let defaults = NSUserDefaults.standardUserDefaults()
        let currentKey = defaults.objectForKey("currentCityKey") as? String
        var currentCity = allUserGroups.first!

        if currentKey != nil {
            for UserGroup in allUserGroups {
                if UserGroup.key == currentKey {
                    currentCity = UserGroup
                }
            }
        }

        return currentCity
    }

    class func getArrayFromJSON(dictKey: NSString) -> NSArray {
        let currentUserGroup = UserGroup.current()
        let jsonDictionary = currentUserGroup.getJSON()

        return jsonDictionary.objectForKey(dictKey) as NSArray
    }
}
