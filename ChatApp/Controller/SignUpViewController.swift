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
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var alredyHaveAccountButton: UIButton!
    
    var authModel = AuthModel()
    
    
    //    MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("SignUpViewController")
        configureUI()
        emailTextField.delegate = self
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        authModel.delegate = self
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        
    }
    
    // MARK: - Helper
    private func configureUI() {
        
        profileImageButton.layer.cornerRadius = 75
        profileImageButton.layer.borderWidth = 1
        profileImageButton.layer.borderColor = UIColor.lightGray.cgColor
        
        signUpButton.layer.cornerRadius = 15
        signUpButton.backgroundColor = .lightGray
        signUpButton.isEnabled = false
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func tappedAlreadyHaveAccountButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toLogin", sender: nil)
    }
    
    @IBAction func tappedSignUpButton(_ sender: UIButton) {
        
        guard let userName = userNameTextField.text else { return }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        authModel.signUp(email: email, password: password, name: userName)
        
    }
    
    
    private func registerProfileImage(){
        
        let image = profileImageButton.imageView?.image ?? UIImage(named: "NoImage")
        guard let uplodeImage = image?.jpegData(compressionQuality: 0.5) else { return }
        
        //        HUD.show(.progress)
        
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
                //                self.createUser(profileImageUrl: urlString)
                
            }
            
        }
        
    }
    
    
    @IBAction func tappedProfileImageButton(_ sender: UIButton) {
        
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
            
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = .lightGray
            
        }else{
            
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = .systemGreen
            
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


//MARK: - AuthModelDelegate
extension SignUpViewController: AuthModelDelegate {
    func didLoginCompletion() {
    }
    
    
    func didSignUpCompletion(newUser: User) {
        authModel.sendEmailVerification(user: newUser)
        performSegue(withIdentifier: "toSendEmailVerification", sender: nil)
    }
    
    func emailVerificationDidSend() {

    }
    
    func errorDidOccur(error: Error) {
        print(error.localizedDescription)
    }
    
    
    
}

