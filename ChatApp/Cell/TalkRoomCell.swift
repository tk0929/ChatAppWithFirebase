//
//  ChatRoomCell.swift
//  ChatApp
//
//  Created by t.koike on 2021/01/15.
//

import UIKit
import Firebase
import Nuke

class TalkRoomCell: UITableViewCell {
    
    
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var partnerMessageTextView: UITextView!
    @IBOutlet weak var partnerDateLabel: UILabel!
    @IBOutlet weak var myMessageTextView: UITextView!
    @IBOutlet weak var myDateLabel: UILabel!
    
    
    @IBOutlet weak var messageTextViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var myMessageTextViewConstrainst: NSLayoutConstraint!
    
    var message: Message? {
        
        didSet {
            
            //            if let message = message {
            //
            //                let width = estimatedFrameForTextView(text: message.message).width + 15
            //                messageTextViewWidthConstraint.constant = width
            //
            //                partnerMessageTextView.text = message.message
            //                partnerDateLabel.text = dateFormatterForDataLabel(date: message.createdAt.dateValue())
            ////                userImageView.image
            //            }
            
            
            
        }
        
        
    }
    
    
    override func awakeFromNib() {
        
        backgroundColor = .clear
        userImageView.layer.cornerRadius = 30
        myMessageTextView.layer.cornerRadius = 15
        myMessageTextView.backgroundColor = .green
        partnerMessageTextView.layer.cornerRadius = 15
        partnerMessageTextView.font = UIFont.systemFont(ofSize: 14)
        
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        checkWhichUserMessage()
        
        
    }
    
    //    textVIewの幅を計算する
    private func estimatedFrameForTextView(text: String) -> CGRect {
        
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
        
    }
    
    private func dateFormatterForDataLabel(date: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_jP")
        return formatter.string(from: date)
        
    }
    
    
    private func checkWhichUserMessage() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        if uid == message?.uid {
            
            partnerMessageTextView.isHidden = true
            partnerDateLabel.isHidden = true
            userImageView.isHidden = true
            
            myDateLabel.isHidden = false
            myMessageTextView.isHidden = false
            
            
            if let message = message {
                
                let width = estimatedFrameForTextView(text: message.message).width + 20
                myMessageTextViewConstrainst.constant = width
                
                myMessageTextView.text = message.message
                myDateLabel.text = dateFormatterForDataLabel(date: message.createdAt.dateValue())
            }
            
            
        }else {
            
            partnerMessageTextView.isHidden = false
            partnerDateLabel.isHidden = false
            userImageView.isHidden = false
            
            myDateLabel.isHidden = true
            myMessageTextView.isHidden = true
            
//            if let urlString = message?.partnerUser?.profileImageUrl, let profileImageUrl = URL(string: urlString) {
//                
//                Nuke.loadImage(with: profileImageUrl , into: userImageView)
//
//            }
            
            
            if let message = message {
                
                let width = estimatedFrameForTextView(text: message.message).width + 20
                messageTextViewWidthConstraint.constant = width
                
                partnerMessageTextView.text = message.message
                partnerDateLabel.text = dateFormatterForDataLabel(date: message.createdAt.dateValue())
                
            }
            
        }
        
        
    }
    
    
    
    
    
}
