//
//  UserList.swift
//  ChatApp
//
//  Created by t.koike on 2021/01/23.
//

import UIKit
import Firebase

class UserListViewController: UIViewController {
    
    private let cellId = "cellId"
    var users = [User]()
    private var selectedUser: User?
    
    
    @IBOutlet weak var userListTableView: UITableView!
    @IBOutlet weak var startTalkButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchUserInfoFromFirestore()
        userListTableView.delegate = self
        userListTableView.dataSource = self
        
    }
    
    
    private func configureUI() {
        
        userListTableView.tableFooterView = UIView()
        navigationController?.navigationBar.barTintColor = .orange
        startTalkButton.layer.cornerRadius = 15
        startTalkButton.tintColor = .black
        startTalkButton.setTitle("会話を開始", for: .normal)
        startTalkButton.isEnabled = false
        
    }
    
    
    
    
    @IBAction func tappedStartTalkButton(_ sender: UIButton) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let partnerUid = self.selectedUser?.uid else { return }
        let members = [uid,partnerUid]
        
        let docData = [
            
            "members":members,
            "latestMessageId": "",
            "createdAt": Timestamp()
            
        ] as [String : Any]
        
        
        Firestore.firestore().collection("talkRoom").addDocument(data: docData) { (error)  in
            
            if let error = error {
                print("ルーム情報の保存に失敗しました。\(error)")
                return
            }
            
            self.dismiss(animated: true, completion: nil)
            print("ルーム情報の保存に成功しました。")
            
        }
    }
    
    
    
    private func fetchUserInfoFromFirestore() {
        
        Firestore.firestore().collection("users").getDocuments { (snapShot, error) in
            
            if let error = error {
                print("ユーザ情報の取得に失敗しました: \(error)")
                return
            }
            
            snapShot?.documents.forEach({ (snapShot) in
                
                let dic = snapShot.data()
                let user = User.init(dic: dic)
                user.uid = snapShot.documentID
                
                guard let uid = Auth.auth().currentUser?.uid else { return }
                if uid == snapShot.documentID { return }
                
                self.users.append(user)
                self.userListTableView.reloadData()
                
            })
            
        }
        
    }
    
}


// MARK: - UITableViewDataSource
extension UserListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = userListTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserListCell
        cell.user = users[indexPath.row]
        
        return cell
    }
    
    
}

// MARK: - UITableViewDelegate
extension UserListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        startTalkButton.isEnabled = true
        let user = users[indexPath.row]
        self.selectedUser = user
        
    }
    
    
    
    
}


