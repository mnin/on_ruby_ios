//
//  SettingViewController.swift
//  onruby
//
//  Created by Martin Wilhelmi on 24.09.14.
//

import UIKit

class SettingsViewController: UITableViewController {
    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return allUserGroups.count
        case 1:
            return 2
        case 2:
            return 1
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "User Groups"
        case 1:
            return "User Group contact"
        case 2:
            return "app developer contact"
        default:
            return ""
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier: String
        var cell: UITableViewCell!

        if indexPath.section == 0 {
            cellIdentifier = "userGroupCellIdentifier"
        } else {
            cellIdentifier = "defaultCellIdentifier"
        }

        cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell!
        if cell == nil
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }

        let currentCity = UserGroup.current()

        switch indexPath.section {
        case 0:
            var userGroup = allUserGroups[indexPath.row]
            let imageView = cell.viewWithTag(100) as UIImageView
            let label = cell.viewWithTag(101) as UILabel

            label.text = userGroup.name
            imageView.image = UIImage(named: userGroup.key)

            if userGroup.key == currentCity.key {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        case 1:
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.imageView?.image = nil
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Twitter"
            case 1:
                cell.textLabel?.text = "Homepage"
            default:
                break
            }
        case 2:
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.imageView?.image = nil

            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Twitter"
            default:
                break
            }
        default:
            break
        }

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)

        switch indexPath.section {
        case 0:
            var userGroup : UserGroup = allUserGroups[indexPath.row] as UserGroup
            self.changeCurrentUserGroup(userGroup)
        case 1:
            let currentUserGroup = UserGroup.current()

            switch indexPath.row {
            case 0:
                UIApplication.sharedApplication().openURL(currentUserGroup.twitterUrl())
            case 1:
                UIApplication.sharedApplication().openURL(currentUserGroup.homepageUrl())
            default:
                break
            }
        case 2:
            UIApplication.sharedApplication().openURL(NSURL(string: "https://twitter.com/mnin"))
        default:
            break
        }
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 51
        } else {
            return 44
        }
    }

    func changeCurrentUserGroup(userGroup: UserGroup) {
        var currentUserGroup = UserGroup.current()
        if userGroup.key != currentUserGroup.key {
            userGroup.setAsCurrent()
            postUserGroupChangedNotification()
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }
    }

    func postUserGroupChangedNotification() {
        let notificationCenter = NSNotificationCenter.defaultCenter()

        notificationCenter.postNotificationName("reloadUserGroup", object: nil)
    }
}
