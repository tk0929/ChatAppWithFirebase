//
//  AuthModel.swift
//  ChatApp
//
//  Created by t.koike on 2021/02/13.
//

import Foundation
import Firebase

protocol AuthModelDelegate: class {
    
    func didSignUp(newUser: User)
    func didSignUpCompletion()
    func didLogin()
    func errorDidOccur(error: Error)
    
}


class AuthModel: AuthModelDelegate {
    
    weak var delegate: AuthModelDelegate?
    
     func signUp(email: String, password: String, name: String, profileImageUrl: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result,error) in
            
            guard let self = self else { return }
            
            if let user = result?.user {
                self.updateDisplayName(name: name, of: user)
            }else{
                //               ここにエラーメッセージ
            }
        }
        
    }
    
    func updateDisplayName(name: String, of user: User) {
        let request = user.createProfileChangeRequest()
        request.displayName = name
        request.commitChanges { [weak self] error in
            
            guard let self = self else { return }
            if error != nil {
                self.sendEmailVerification(to: user)
            }
            //               ここにエラーメッセージ
        }
    }
    
    func sendEmailVerification(to User: User) {
        User.sendEmailVerification { [weak self] error in
            
            guard let self = self else { return }
            if error != nil {
                self.didSignUpCompletion()
            }
//     ここにエラーメッセージ
        }
        
    }
    
    
    
    
}

extension AuthModelDelegate {
    func didSignUp(newUser: User) {}
    func didLogin(){}
    func didSignUpCompletion(){}
    func errorDidOccur(error: Error){}
}



