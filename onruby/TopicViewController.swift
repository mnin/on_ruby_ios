//
//  TopicViewController.swift
//  onruby
//
//  Created by Martin Wilhelmi on 26.09.14.
//

class TopicViewController: UIViewController, UIActionSheetDelegate {
    var topic: Topic!
    @IBOutlet var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setAttributedStringForTopic(topic)
    }

    func setAttributedStringForTopic(topic: Topic) {
        textView.attributedText = attributedStringForTopic(topic.name, description: topic.description)
    }

    func attributedStringForTopic(name: String, description: String) -> NSAttributedString {
        let topicName = NSAttributedString(string: "\(name):", attributes: NSDictionary(object: UIFont.boldSystemFontOfSize(UIFont.systemFontSize() + 2), forKey: NSFontAttributeName))
        let lineBreak = NSAttributedString(string: "\n")
        let html = MMMarkdown.HTMLStringWithMarkdown(description, error: nil)
        let topicDescription = NSAttributedString(data: html.dataUsingEncoding(NSISOLatin1StringEncoding, allowLossyConversion: true)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil, error: nil)

        var attributedString = NSMutableAttributedString()
        attributedString.appendAttributedString(topicName)
        attributedString.appendAttributedString(lineBreak)
        attributedString.appendAttributedString(lineBreak)
        attributedString.appendAttributedString(topicDescription!)

        return attributedString
    }
}
