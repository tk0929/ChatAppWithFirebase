//
//  UserListCell.swift
//  ChatApp
//
//  Created by t.koike on 2021/01/24.
//

import UIKit
import Nuke

class UserListCell: UITableViewCell {
    
    
    @IBOutlet weak var userImageVIew: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var user: User? {
        
        didSet {
            
            userNameLabel.text = user?.username
            guard let url = URL(string: user?.profileImageUrl ?? "") else { return }
            Nuke.loadImage(with: url, into: userImageVIew)
            
        }
    
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImageVIew.layer.cornerRadius = 25
    
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    

}
