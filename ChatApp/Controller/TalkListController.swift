//
//  TalkListViewController.swift
//  ChatApp
//
//  Created by t.koike on 2021/01/13.
//

import UIKit
import Firebase
import Nuke

class TalkListController: UIViewController {
    
    @IBOutlet weak var rightButton: UIBarButtonItem!
    @IBOutlet weak var talkListTableView: UITableView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    private let cellId = "CellId"
    private var talkRoom = [TalkRoom]()
    
    
    private var user: User? {
        
        didSet {
            navigationItem.title = user?.username
        }
        
        
        
    }
    
    //viewcontrollerごとでStatusBarの色を変えるときは使用する
    //    override var preferredStatusBarStyle: UIStatusBarStyle{
    //        return .lightContent
    //    }
    
    
    
    
    //  MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        confirmLoggedInUser()
        fetchLoginUserInfo()
        fetchTalkRoomInfo()
        
        talkListTableView.delegate = self
        talkListTableView.dataSource = self
        
    }
    
    
    
    //    MARK: - Helper
    private func configureUI(){
        
        talkListTableView.tableFooterView = UIView()
        navigationController?.navigationBar.barTintColor = ColorSet.primary
        navigationItem.title = "トークリスト"
        //NavigatinBarのフォントの設定
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont(name: "PingFangSC-Regular", size: 25) as Any]
        
        rightButton.title = "新規チャット"
        rightButton.style = .plain
        rightButton.tintColor = .white
        
        logoutButton.title = "ログアウト"
        logoutButton.style = .plain
        logoutButton.tintColor = .white
    }
    
    
    
    @IBAction func tappedLogoutButton(_ sender: UIButton) {
        
        do{
            try Auth.auth().signOut()
            let signUpViweController = UIStoryboard(name: "SignUp", bundle: nil).instantiateViewController(withIdentifier: "signUpViweController")
            self.present(signUpViweController, animated: true, completion: nil)
            
        }catch{
            print("ログアウトに失敗しました。 \(error)")
        }
        
        
    }
    
    @IBAction func tappedRightButton(_ sender: UIBarButtonItem) {
        
        let storyboard = UIStoryboard(name: "UserList", bundle: nil)
        let userListViewController = storyboard.instantiateViewController(withIdentifier: "UserListViewController")
        let navigationController = UINavigationController.init(rootViewController: userListViewController)
        //        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
        
    }
    
    
    private func fetchTalkRoomInfo() {
        
        Firestore.firestore().collection("talkRoom").addSnapshotListener { ( snapShot, error ) in
            
            if let error = error {
                print("TalkRoomの情報の取得に失敗しました。\(error)")
                return
            }
            
            snapShot?.documentChanges.forEach({ (documentChanges) in
                
                switch documentChanges.type {
                case .added:
                    self.handleAddedDocmentChanges(docmentChange: documentChanges)
                case .modified:
                    break
                case .removed:
                    break
                }
                
                
            })
            
        }
        
    }
    
    
    
    private func handleAddedDocmentChanges(docmentChange: DocumentChange){
        
        let dic = docmentChange.document.data()
        let talkRoom = TalkRoom(dic: dic)
        talkRoom.docmentId = docmentChange.document.documentID
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let isContain = talkRoom.members.contains(uid)
        
        if !isContain { return }
        
        talkRoom.members.forEach { (memberUid) in
            
            if memberUid != uid {
                
                Firestore.firestore().collection("users").document(memberUid).getDocument { ( userSnapShot, error ) in
                    
                    if let error = error {
                        print("TalkRoomの情報の取得に失敗しました。\(error)")
                        return
                    }
                    
                    guard let dic = userSnapShot?.data() else { return }
                    let user = User(dic: dic)
                    user.uid = docmentChange.document.documentID
                    talkRoom.partnerUser = user
                    
                    
                    guard let talkRoomId  = talkRoom.docmentId else { return }
                    let latestMessaageId = talkRoom.latestMessageId
                    
                    if latestMessaageId == "" {
                        
                        self.talkRoom.append(talkRoom)
                        self.talkListTableView.reloadData()
                        return
                    }
                    
                    Firestore.firestore().collection("talkRoom").document(talkRoomId).collection("message").document(latestMessaageId).getDocument { (messageSnapShot,error) in
                        
                        if let error = error {
                            print("TalkRoomの情報の取得に失敗しました。\(error)")
                            return
                        }
                        
                        guard let dic = messageSnapShot?.data() else { return }
                        let message = Message(dic: dic)
                        talkRoom.latestMessage = message
                        
                        self.talkRoom.append(talkRoom)
                        self.talkListTableView.reloadData()
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    private func confirmLoggedInUser() {
        
        if Auth.auth().currentUser?.uid == nil {
            
            let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
            let signUpViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
            signUpViewController.modalPresentationStyle = .fullScreen
            self.present(signUpViewController, animated: true, completion: nil)
            
        }
        
    }
    
    
    private func fetchLoginUserInfo() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print("ユーザー情報の取得に失敗しました。\(err)")
                return
            }
            
            guard let snapshot = snapshot, let dic = snapshot.data() else { return }
            
            let user = User(dic: dic)
            self.user = user
        }
    }
    
    
    
}


// MARK: - UITableViewDataSource
extension TalkListController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return talkRoom.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = talkListTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TalkListCell
        cell.talkRoom = talkRoom[indexPath.row]
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension TalkListController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard.init(name: "TalkRoom", bundle: nil)
        let talkRoomController = storyboard.instantiateViewController(identifier: "TalkRoomController") as! TalkRoomController
        talkRoomController.user = user
        talkRoomController.talkRoom = talkRoom[indexPath.row]
        navigationController?.pushViewController(talkRoomController, animated: true)
        
    }
    
    
}





