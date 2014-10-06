//
//  SettingViewController.swift
//  onruby
//
//  Created by Martin Wilhelmi on 24.09.14.
//

import UIKit

class EventsViewController: UITableViewController {
    let notificationCenter = NSNotificationCenter.defaultCenter()
    var eventArray         = [Event]()
    var observer: AnyObject!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setRefreshControl()
        self.loadUserGroup()

        startObserver()
    }

    deinit {
        notificationCenter.removeObserver(self.observer)
    }

    func setRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.refreshControlTitle()
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
    }

    func refresh(sender: AnyObject) {
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Refreshing...")
        UserGroup.current().reloadJSONFile()
    }

    func refreshControlTitle() {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
        let lastModificationDate = UserGroup.current().getModificationDate()

        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh (last updated at \(dateFormatter.stringFromDate(lastModificationDate)))")
    }

    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return self.eventArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "eventCellIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell!
        if cell == nil
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }

        let event = self.eventArray[indexPath.row]
        let eventName = cell.viewWithTag(100) as UILabel
        let eventDate = cell.viewWithTag(101) as UILabel

        eventName.text = event.name
        eventDate.text = event.dateString()

        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var eventViewController = storyboard?.instantiateViewControllerWithIdentifier("event") as EventViewController
        eventViewController.event = self.eventArray[indexPath.row]
        navigationController?.pushViewController(eventViewController, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }

    func startObserver() {
        self.observer = notificationCenter.addObserverForName("reloadUserGroup", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {(notification: NSNotification!) -> Void in
            let updatedUserGroupKey = notification.object as String?
            if updatedUserGroupKey != nil && updatedUserGroupKey == UserGroup.current().key {
                self.loadUserGroup()
                self.navigationController?.popToRootViewControllerAnimated(false)
                self.tableView.reloadData()
                self.refreshControlTitle()
            }

            self.refreshControl?.endRefreshing()
        })
    }

    func loadUserGroup() {
        self.navigationItem.title = UserGroup.current().name
        self.eventArray = UserGroup.current().allEvents()
    }
}
