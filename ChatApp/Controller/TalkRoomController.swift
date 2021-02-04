//
//  ChatRoomController.swift
//  ChatApp
//
//  Created by t.koike on 2021/01/14.
//

import UIKit
import Firebase

class TalkRoomController: UIViewController {
    
    var talkRoom: TalkRoom?
    var user: User?
    
    private let cellId = "cellId"
    private var message = [Message]()
    
    
    private lazy var chatInputAccessoryView: ChatInputAccessoryView = {
        
        let view = ChatInputAccessoryView()
        view.frame = .init(x: 0, y: 0, width: view.frame.width, height: 100)
        view.delegate = self
        return view
        
    }()
    
    
    @IBOutlet weak var talkRoomTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUpTableView()
        fetchMessage()
        
    }
    
    private func setUpNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(){

    }
    
    @objc func keyboardWillHide() {
        
    }
    
    
    
    
    private func setUpTableView() {
        talkRoomTableView.delegate = self
        talkRoomTableView.dataSource = self
        
        talkRoomTableView.register(UINib(nibName: "TalkRoomCell", bundle: nil), forCellReuseIdentifier: cellId)
        talkRoomTableView.backgroundColor = ColorSet.secondary
        talkRoomTableView.contentInset = .init(top: 0, left: 0, bottom: 60, right: 0)
        //        talkRoomTableView.scrollIndicatorInsets = .init(top: 0, left: 0, bottom: 60, right: 0)
        talkRoomTableView.keyboardDismissMode = .interactive
    }
    
    override var inputAccessoryView: UIView? {
        
        get{
            return chatInputAccessoryView
        }
        
    }
    
    
    override var canBecomeFirstResponder: Bool {
        
        get{
            return true
        }
        
    }
    
    private func fetchMessage() {
        
        guard let talkRoomDocId = talkRoom?.docmentId else { return }
        
        Firestore.firestore().collection("talkRoom").document(talkRoomDocId).collection("message").addSnapshotListener { (snapShot,error) in
            
            if let error = error {
                print("メッセージ情報の取得に失敗しました。\(error)")
                return
            }
            
            snapShot?.documentChanges.forEach({ (docmentChamge) in
                switch docmentChamge.type {
                case .added:
                    let dic = docmentChamge.document.data()
                    let message = Message(dic: dic)
                    message.partnerUser = self.talkRoom?.partnerUser
                    self.message.append(message)
                    
                    //                    メッセージの並び替え
                    self.message.sort { (m1,m2) -> Bool in
                        
                        let m1Date = m1.createdAt.dateValue()
                        let m2Date = m2.createdAt.dateValue()
                        return m1Date < m2Date
                        
                    }
                    
                    self.talkRoomTableView.reloadData()
                    //メッセージ最下部へスクロール
                    self.talkRoomTableView.scrollToRow(at: IndexPath(row: self.message.count - 1,  section: 0), at: .bottom, animated: false)
                    
                    
                case .modified:
                    break
                case .removed:
                    break
                }
                
            })
            
        }
        
    }
    
    
    
    
}


// MARK: - ChatInputAccessoryViewDelegate
extension TalkRoomController: ChatInputAccessoryViewDelegate {
    
    
    func tappedSendButton(messageText: String) {
        
        addMessageToFireStore(messageText: messageText)
        
    }
    
    
    
    private func addMessageToFireStore(messageText: String) {
        
        guard let talkRoomDocId = talkRoom?.docmentId else { return }
        guard let name = user?.username else { return }
        guard  let uid = Auth.auth().currentUser?.uid else { return }
        chatInputAccessoryView.removeText()
        let messagId = randomString(length: 20)
        
        let docData = [
            
            "name": name,
            "createdAt": Timestamp(),
            "uid": uid,
            "message": messageText
            
        ] as [String : Any]
        
        Firestore.firestore().collection("talkRoom").document(talkRoomDocId).collection("message").document().setData(docData) { (error) in
            
            if let error = error {
                print("メッセージ情報の保存に失敗しました。\(error)")
                return
            }
            
            
            let latestMessageData = [
                "latestMessageId": messagId
            ]
            
            Firestore.firestore().collection("talkRoom").document(talkRoomDocId).updateData(latestMessageData) { (error) in
                
                if let error = error {
                    print("最新メッセージの保存に失敗しました。\(error)")
                    return
                }
                print("最新メッセージの保存に成功しました。")
            }
            
        }
    }
    
    
    func randomString(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
}


// MARK: - UITableViewDataSource
extension TalkRoomController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = talkRoomTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TalkRoomCell
        cell.message = message[indexPath.row]
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        talkRoomTableView.estimatedRowHeight = 20
        return UITableView.automaticDimension
    }
    
    
    
}


// MARK: - UITableViewDelegate
extension TalkRoomController: UITableViewDelegate {
    
    
    
    
    
    
    
}




