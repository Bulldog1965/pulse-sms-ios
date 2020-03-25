//
//  ConversationTableViewCell.swift
//  Pulse
//
//  Created by Luke Klinker on 1/2/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import UIKit

class ConversationTableViewCell : UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var snippet: UILabel!
    @IBOutlet weak var conversationImage: UIImageView!
    @IBOutlet weak var imageLetter: UILabel!
    @IBOutlet weak var unreadIndicator: UIImageView!
    
    func bind(conversation: Conversation) {
        self.title.text = conversation.title
        self.title.textColor = UIColor(named: "ColorPrimaryText")
        
        self.snippet.text = conversation.snippet
        self.snippet.textColor = UIColor(named: "ColorSecondaryText")
        
        self.imageLetter.text = "\(conversation.title.first!)"
        
        self.conversationImage.image = UIImage(color: UIColor(rgb: conversation.color))
        self.conversationImage.maskCircle()
        
        if !conversation.read {
            self.unreadIndicator.image = UIImage(color: UIColor(rgb: conversation.colorDark))
            self.unreadIndicator.maskCircle()
            self.unreadIndicator.isHidden = false
        } else {
            self.unreadIndicator.isHidden = true
        }
    }
}
