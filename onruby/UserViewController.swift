//
//  UserViewController.swift
//  onruby
//
//  Created by Martin Wilhelmi on 25.09.14.
//

import UIKit

class UserViewController: UITableViewController {
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.user.nickname
    }

    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 3
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 51
        } else {
            return 44
        }
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Job Status"
        case 2:
            return "Social Networks"
        default:
            return ""
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier = "detailCellIdentifier"

        if indexPath.section == 0 {
            cellIdentifier = "userCellIdentifier"
        }

        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell!
        if cell == nil
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdentifier)
            cell.detailTextLabel?.textColor = UIColor.blackColor()
        }

        let user = self.user

        cell.selectionStyle = UITableViewCellSelectionStyle.None

        switch indexPath.section {
        case 0:
            let imageView = cell.viewWithTag(100) as UIImageView
            let label = cell.viewWithTag(101) as UILabel

            imageView.image = nil

            switch indexPath.row {
            case 0:
                label.text = user.name

                let urlObject = NSURL(string: user.imageURL)
                let iconURLRequest = NSURLRequest(URL: urlObject)
                cell.imageView?.associatedObject = urlObject
                cell.imageView?.image = nil

                if user.image == nil {
                    cell.imageView?.setImageWithURLRequest(iconURLRequest, placeholderImage: nil, success:
                        { [weak cell] (request:NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
                            if request != nil && cell?.imageView?.associatedObject as NSURL? == request.URL {
                                UIGraphicsBeginImageContext(CGSize(width: 40, height: 40))
                                image.drawInRect(CGRect(x: 0, y: 0, width: 40, height: 40))
                                cell?.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
                                UIGraphicsEndImageContext()
                                user.image = cell?.imageView?.image
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
                    cell.imageView?.image = user.image
                }

            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                cell?.textLabel?.text = "Available"
                if user.available != nil {
                    cell?.detailTextLabel?.text = user.available == false ? "No" : "Yes"
                } else {
                    cell?.detailTextLabel?.text = "Unknown"
                }
            case 1:
                cell?.textLabel?.text = "Freelancer"
                if user.freelancer != nil {
                    cell?.detailTextLabel?.text = user.freelancer == false ? "No" : "Yes"
                } else {
                    cell?.detailTextLabel?.text = "Unknown"
                }
            default:
                break
            }
        case 2:
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            switch indexPath.row {
            case 0:
                cell?.textLabel?.text = "GitHub"
                if user.github != nil && user.github != "" {
                    cell?.detailTextLabel?.text = user.github
                    cell.selectionStyle = UITableViewCellSelectionStyle.Gray
                } else {
                    cell?.detailTextLabel?.text = "Unknown"
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            case 1:
                cell?.textLabel?.text = "Twitter"
                if user.twitter != nil && user.twitter != "" {
                    cell?.detailTextLabel?.text = user.twitter
                    cell.selectionStyle = UITableViewCellSelectionStyle.Gray
                } else {
                    cell?.detailTextLabel?.text = "Unknown"
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            case 2:
                cell?.textLabel?.text = "Homepage"
                if user.url != nil && user.url != "" {
                    cell?.detailTextLabel?.text = user.url
                    cell.selectionStyle = UITableViewCellSelectionStyle.Gray
                } else {
                    cell?.detailTextLabel?.text = "Unknown"
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            default:
                break
            }
        default:
            break
        }

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let user = self.user

        tableView.deselectRowAtIndexPath(indexPath, animated: false)

        if indexPath.section == 2 {
            switch indexPath.row {
            case 0:
                if user.github != nil && user.github != "" {
                    let url: NSURL = NSURL(string: "https://github.com/\(user.github!)")
                    UIApplication.sharedApplication().openURL(url)
                }
            case 1:
                if user.twitter != nil && user.twitter != "" {
                    let url: NSURL = NSURL(string: "https://twitter.com/\(user.twitter!)")
                    UIApplication.sharedApplication().openURL(url)
                }
            case 2:
                if user.url != nil && user.url != "" {
                    let url: NSURL = NSURL(string: user.url!)
                    UIApplication.sharedApplication().openURL(url)
                }
            default:
                break
            }
        }
    }
}
