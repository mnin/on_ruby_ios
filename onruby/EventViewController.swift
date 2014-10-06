//
//  EventViewController.swift
//  onruby
//
//  Created by Martin Wilhelmi on 25.09.14.
//

import UIKit

class EventViewController: UITableViewController {
    var event: Event!

    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return self.event.topicArray.count
        case 2:
            return self.event.materialsArray.count
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 && !self.event.topicArray.isEmpty {
            return "Topics"
        } else if section == 2 && !self.event.materialsArray.isEmpty {
            return "Materials"
        }

        return nil
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let eventCellIdentifier = "eventCellIdentifier"
        let genericCellIdentifier = "genericCellIdentifier"
        let userCellIdentifier = "userCellIdentifier"
        var cellIdentifier: String

        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cellIdentifier = eventCellIdentifier
            case 1:
                cellIdentifier = userCellIdentifier
            case 2:
                cellIdentifier = eventCellIdentifier
            default:
                cellIdentifier = genericCellIdentifier
            }
        default:
            cellIdentifier = genericCellIdentifier
        }

        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell!
        if cell == nil
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }

        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let textView = cell!.viewWithTag(100) as UITextView
                var attributedText = NSMutableAttributedString()
                let lineBreak = NSAttributedString(string: "\n")
                let systemFontSize = UIFont.systemFontSize()
                let html = MMMarkdown.HTMLStringWithMarkdown(event.description, error: nil)
                let eventDescription = NSAttributedString(data: html.dataUsingEncoding(NSISOLatin1StringEncoding, allowLossyConversion: true), options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil, error: nil)

                attributedText.appendAttributedString(NSAttributedString(string: self.event.name, attributes: NSDictionary(object: UIFont.boldSystemFontOfSize(systemFontSize + 2), forKey: NSFontAttributeName)))
                attributedText.appendAttributedString(lineBreak)
                attributedText.appendAttributedString(NSAttributedString(string: self.event.dateString()))
                attributedText.appendAttributedString(lineBreak)
                attributedText.appendAttributedString(lineBreak)
                attributedText.appendAttributedString(eventDescription)

                textView.attributedText = attributedText
            case 1:
                cell?.selectionStyle = UITableViewCellSelectionStyle.Default
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

                let userImage = cell.viewWithTag(100) as UIImageView
                let userNickname = cell.viewWithTag(101) as UILabel

                let user = self.event.user
                userNickname.text = user!.nickname
                userImage.image = nil

                let urlObject = NSURL(string: user!.imageURL)
                let iconURLRequest = NSURLRequest(URL: urlObject)
                cell.imageView?.associatedObject = urlObject
                cell.imageView?.image = nil

                if user!.image == nil {
                    cell.imageView?.setImageWithURLRequest(iconURLRequest, placeholderImage: nil, success:
                        { [weak cell] (request:NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
                            if request != nil && cell?.imageView?.associatedObject as NSURL? == request.URL {
                                UIGraphicsBeginImageContext(CGSize(width: 40, height: 40))
                                image.drawInRect(CGRect(x: 0, y: 0, width: 40, height: 40))
                                cell?.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
                                UIGraphicsEndImageContext()
                                user!.image = cell?.imageView?.image
                                cell?.setNeedsLayout()
                            }
                        }, failure: { [weak cell] (request:NSURLRequest!, response: NSHTTPURLResponse!, error: NSError!) -> Void in
                            if request != nil && cell?.imageView?.associatedObject as NSURL? == request.URL {
                                cell?.imageView?.image = nil
                                cell?.setNeedsLayout()
                            }
                        }
                    )
                } else {
                    cell.imageView?.image = user!.image
                }
            case 2:
                let location = self.event.location
                let textView = cell!.viewWithTag(100) as UITextView
                var attributedText = NSMutableAttributedString()
                let lineBreak = NSAttributedString(string: "\n")
                let systemFontSize = UIFont.systemFontSize()

                attributedText.appendAttributedString(NSAttributedString(string: "\(location.name) - \(location.url)", attributes: NSDictionary(object: UIFont.boldSystemFontOfSize(systemFontSize + 1), forKey: NSFontAttributeName)))
                attributedText.appendAttributedString(lineBreak)
                attributedText.appendAttributedString(NSAttributedString(string: "\(location.street) \(location.house_number)"))
                attributedText.appendAttributedString(lineBreak)
                attributedText.appendAttributedString(NSAttributedString(string: "\(location.zip) \(location.city)"))

                textView.attributedText = attributedText
            case 3:
                let participantsCount = self.event.participantsArray.count
                cell?.textLabel?.text = "Participants (\(participantsCount))"
                if participantsCount > 0 {
                    cell?.selectionStyle = UITableViewCellSelectionStyle.Default
                    cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                }
            default:
                break
            }
        case 1:
            let topic = self.event.topicArray[indexPath.row]
            cell?.textLabel?.text = topic.name
            cell?.selectionStyle = UITableViewCellSelectionStyle.Default
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        case 2:
            let material = self.event.materialsArray[indexPath.row]
            cell?.textLabel?.text = material.name
            cell?.selectionStyle = UITableViewCellSelectionStyle.Default
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        default:
            break
        }

        return cell!
    }

    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 1 {
            return 51
        } else {
            return UITableViewAutomaticDimension
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)

        switch indexPath.section {
        case 0:
            if indexPath.row == 1 {
                let user: User? = self.event.user
                var userViewController = storyboard?.instantiateViewControllerWithIdentifier("user") as UserViewController
                userViewController.user = user
                navigationController?.pushViewController(userViewController, animated: true)
            } else if indexPath.row == 3 {
                let participants = self.event.participantsArray
                if !participants.isEmpty {
                    var participantsViewController = storyboard?.instantiateViewControllerWithIdentifier("participants") as ParticipantsViewController
                    participantsViewController.participants = participants
                    navigationController?.pushViewController(participantsViewController, animated: true)
                }
            }
        case 1:
            let topic = self.event.topicArray[indexPath.row]

            var topicViewController = storyboard?.instantiateViewControllerWithIdentifier("topic") as TopicViewController
            topicViewController.topic = topic
            navigationController?.pushViewController(topicViewController, animated: true)
        case 2:
            let material = self.event.materialsArray[indexPath.row]
            UIApplication.sharedApplication().openURL(NSURL(string: material.url))
        default:
            break
        }
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 1 || indexPath.section == 2 {
            return true
        } else {
            return false
        }
    }

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        let showUserClosure = { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            var user: User?
            if indexPath.section == 1 {
                let topic = self.event.topicArray[indexPath.row]
                user = topic.user()
            } else if indexPath.section == 2 {
                let material = self.event.materialsArray[indexPath.row]
                user = material.user()
            }

            if user != nil {
                var userViewController = self.storyboard?.instantiateViewControllerWithIdentifier("user") as UserViewController
                userViewController.user = user
                self.navigationController?.pushViewController(userViewController, animated: true)
            }

            tableView.setEditing(false, animated: true)
        }

        let showUserAction = UITableViewRowAction(style: .Default, title: "User", handler: showUserClosure)
        showUserAction.backgroundColor = UIColor.greenColor()

        return [showUserAction]
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
}
