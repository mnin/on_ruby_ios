//
//  TopicViewController.swift
//  onruby
//
//  Created by Martin Wilhelmi on 26.09.14.
//

import UIKit

class TopicViewController: UIViewController, UIActionSheetDelegate {
    var topic: Topic!
    @IBOutlet var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setAttributedTextForTopic(topic)
    }

    func setAttributedTextForTopic(topic: Topic) {
        let topicName = NSAttributedString(string: "\(topic.name):", attributes: NSDictionary(object: UIFont.boldSystemFontOfSize(UIFont.systemFontSize() + 2), forKey: NSFontAttributeName))
        let lineBreak = NSAttributedString(string: "\n")
        let html = MMMarkdown.HTMLStringWithMarkdown(topic.description, error: nil)
        let topicDescription = NSAttributedString(data: html.dataUsingEncoding(NSISOLatin1StringEncoding, allowLossyConversion: true), options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil, error: nil)

        var attributedText = NSMutableAttributedString()
        attributedText.appendAttributedString(topicName)
        attributedText.appendAttributedString(lineBreak)
        attributedText.appendAttributedString(lineBreak)
        attributedText.appendAttributedString(topicDescription)

        textView.attributedText = attributedText
    }
}
