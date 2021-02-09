//
//  SignUpViewController.swift
//  ChatApp
//
//  Created by t.koike on 2021/01/19.
//

import UIKit
import Firebase
import FirebaseAuth
import PKHUD

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var alredyHaveAccountButton: UIButton!
    
    
    
    //    MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("SignUpViewController")
        configureUI()
        emailTextField.delegate = self
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        
    }
    
    
    
    private func configureUI() {
        
        profileImageButton.layer.cornerRadius = 75
        profileImageButton.layer.borderWidth = 1
        profileImageButton.layer.borderColor = UIColor.lightGray.cgColor
        
        registerButton.layer.cornerRadius = 15
        registerButton.backgroundColor = .lightGray
        registerButton.isEnabled = false
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func tappedAlreadyHaveAccountButton(_ sender: UIButton) {
        
//        let storyBoard = UIStoryboard(name:"Login", bundle: nil)
//        let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController" )
//        navigationController?.pushViewController(loginViewController, animated: true)
        
        performSegue(withIdentifier: "toLogin", sender: nil)
        
    }
    //    登録ボタン押下したときにprofileimageの情報ををfirestore,storageに保存している
    @IBAction func tappedRegisterButton(_ sender: UIButton) {
        
        let image = profileImageButton.imageView?.image ?? UIImage(named: "NoImage")
        guard let uplodeImage = image?.jpegData(compressionQuality: 0.5) else { return }
        
        HUD.show(.progress)
        
        let fileName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("profile_image").child(fileName)
        
        storageRef.putData(uplodeImage, metadata: nil) { (metaData, error) in
            if let error = error {
                
                print("Firestorageへの画像の保存に失敗しました: \(error)")
                HUD.hide()
                return
            }
            
            print("Firestorageへの画像の保存に成功しました")
            
            storageRef.downloadURL { (url, error) in
                
                if let error = error {
                    print("Firestorageからのダウンロードに失敗しました。: \(error)")
                    HUD.hide()
                    return
                }
                
                guard let urlString = url?.absoluteString else { return }
                self.createUser(profileImageUrl: urlString)
                
            }
            
        }
        
    }
    
    
    private func createUser(profileImageUrl: String) {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("認証情報の保存に失敗しました。\(error)")
                HUD.hide()
                return
            }
            
            print("認証情報の保存に成功しました。")
            
            guard let uid = authResult?.user.uid else { return }
            guard let username = self.userNameTextField.text else { return }
            
            // TODO: docDataをmodelへ切り出す
            let docData = [
                "email": email,
                "username": username,
                "createdAt": Timestamp(),
                "profileImageUrl": profileImageUrl
            ] as [String : Any]
            
            Firestore.firestore().collection("users").document(uid).setData(docData) { (error) in
                if let error = error {
                    print("Firestoreへの保存に失敗しました。\(error)")
                    HUD.hide()
                    return
                }
                
                print("Firestoreへの情報の保存が成功しました。")
                
                HUD.hide()
                
                self.dismiss(animated: true, completion: nil)
                
            }
            
        }
        
    }
    
    
    @IBAction func tappedProfileImageButotn(_ sender: UIButton) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true, completion: nil)
        
    }
    
}


//MARK: - UITextFieldDelegate

extension SignUpViewController: UITextFieldDelegate {
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        let emailText = emailTextField.text?.isEmpty ?? false
        let userNameText = userNameTextField.text?.isEmpty ?? false
        let passwordText = passwordTextField.text?.isEmpty ?? false
        
        if emailText || userNameText || passwordText {
            
            registerButton.isEnabled = false
            registerButton.backgroundColor = .lightGray
            
        }else{
            
            registerButton.isEnabled = true
            registerButton.backgroundColor = .systemGreen
            
            
        }
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        emailTextField.resignFirstResponder()
        userNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        return true
        
    }
    
    
}

//MARK: - UIImagePickerControllerDelegate,UINavigationControllerDelegate

extension SignUpViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editImage = info[.editedImage] as? UIImage {
            profileImageButton.setImage(editImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }else if let originalImage = info[.originalImage] as? UIImage {
            profileImageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        profileImageButton.setTitle("", for: .normal)
        profileImageButton.imageView?.contentMode = .scaleAspectFill
        profileImageButton.contentVerticalAlignment = .fill
        profileImageButton.contentHorizontalAlignment = .fill
        profileImageButton.clipsToBounds = true
        
        dismiss(animated: true, completion: nil)
        
        
    }
    
    
    
}



