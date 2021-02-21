//
//  AuthModel.swift
//  ChatApp
//
//  Created by t.koike on 2021/02/13.
//

import Foundation
import Firebase

protocol AuthModelDelegate: class {
    
    func emailVerificationDidSend()
    func didSignUpCompletion(newUser: User)
    func didLoginCompletion()
    func errorDidOccur(error: Error)
    
}


class AuthModel {
    
    weak var delegate: AuthModelDelegate?
    
     func signUp(email: String, password: String, name: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result,error) in
            
            guard let self = self else { return }
            
            if let user = result?.user {
                self.updateDisplayName(name: name, user: user)
            }else{
                //               ここにエラーメッセージ
            }
        }
        
    }
    
    func updateDisplayName(name: String, user: User) {
        let request = user.createProfileChangeRequest()
        request.displayName = name
        request.commitChanges { [weak self] error in
            
            guard let self = self else { return }
            if error == nil {
                self.delegate?.didSignUpCompletion(newUser: user)
            }
         
            //               ここにエラーメッセージ
        }
    }
    
    func sendEmailVerification( user: User) {
        user.sendEmailVerification { [weak self] error in
            
            guard let self = self else { return }
            if error != nil {
                self.delegate?.emailVerificationDidSend()
            }
//     ここにエラーメッセージ
        }
        
    }
    
}



