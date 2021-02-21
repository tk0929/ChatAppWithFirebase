//
//  talkListTableViewCell.swift
//  ChatApp
//
//  Created by t.koike on 2021/01/13.
//

import UIKit
import Nuke


class TalkListCell: UITableViewCell {

    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var latestMessageLabel: UILabel!
    @IBOutlet weak var partnerNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
        
    
    
    
    var talkRoom: TalkRoom? {
            
        didSet {
            
            if let talkRoom = talkRoom {
                
//                partnerNameLabel.text = talkRoom.partnerUser?.username
//            
//                guard let url = URL(string: talkRoom.partnerUser?.profileImageUrl ?? "") else { return }
//                Nuke.loadImage(with: url, into: userProfileImage)
//                
                dateLabel.text = dateFormatterForDataLabel(date: talkRoom.createdAt.dateValue())
                
            }
            
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userProfileImage.layer.cornerRadius = userProfileImage.frame.size.width * 0.5
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

     
    }
    
//    日付を表示させるdateFormatter
    private func dateFormatterForDataLabel(date: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ja_3P")
        return formatter.string(from: date)

    }
    
    
    

}
            
