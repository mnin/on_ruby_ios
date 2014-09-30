//
//  ParticipantsViewController.swift
//  onruby
//
//  Created by Martin Wilhelmi on 25.09.14.
//

import UIKit

class ParticipantsViewController: UITableViewController {
    var participants: [User]!

    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return participants!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "userCellIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell!
        if cell == nil
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }

        let userImage = cell.viewWithTag(100) as UIImageView
        let userNickname = cell.viewWithTag(101) as UILabel

        let user: User = self.participants[indexPath.row]
        userNickname.text = user.nickname

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

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)

        let user = self.participants[indexPath.row]
        var userViewController = storyboard?.instantiateViewControllerWithIdentifier("user") as UserViewController
        userViewController.user = user
        navigationController?.pushViewController(userViewController, animated: true)
    }
}
