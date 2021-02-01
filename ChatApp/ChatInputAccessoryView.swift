//
//  ChatInputAccessoryView.swift
//  ChatApp
//
//  Created by t.koike on 2021/01/16.
//

import UIKit

protocol ChatInputAccessoryViewDelegate: class {
    
    func tappedSendButton(messageText: String)
    
}


class ChatInputAccessoryView: UIView {
    
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var chatTextView: UITextView!
    
    weak var delegate: ChatInputAccessoryViewDelegate?
    
    
    
    @IBAction func teppedSendButton(_ sender: UIButton) {
        
        guard let messageText = chatTextView.text else { return }
        delegate?.tappedSendButton(messageText: messageText)
        
    }
    
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        autoresizingMask = .flexibleHeight
        loadNib()
        configureNib()
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureNib(){
        
        chatTextView.layer.cornerRadius = 15
        chatTextView.layer.borderColor = UIColor.lightGray.cgColor
        chatTextView.layer.borderWidth = 1
        chatTextView.backgroundColor = .systemGray
        chatTextView.font = UIFont.boldSystemFont(ofSize: 14)
        chatTextView.text = ""
        chatTextView.delegate = self
        
        sendButton.layer.cornerRadius = 15
        sendButton.imageView?.contentMode = .scaleAspectFill
        sendButton.contentHorizontalAlignment = .fill
        sendButton.contentVerticalAlignment = .fill
        sendButton.isEnabled = false
        
    }
    
    
    private  func loadNib(){
        
        let nib = UINib(nibName: "ChatInputAccessoryView", bundle: nil)
        guard let view =  nib.instantiate(withOwner: self, options: nil).first as? UIView else{ return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        view.backgroundColor = ColorSet.primary
        self.addSubview(view)
        
        
    }
    
    func removeText(){
        
        chatTextView.text = ""
        sendButton.isEnabled = false
        
    }
    
    
}




//MARK: - UITextViewDelegate

extension ChatInputAccessoryView: UITextViewDelegate{
    
    //    空文字のとき送信ボタンを押せなくする
    func textViewDidChange(_ textView: UITextView) {
        
        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if text.isEmpty {
            
            sendButton.isEnabled = false
            
        }else{
            
            sendButton.isEnabled = true
            
        }
        
    }
    
    
}

