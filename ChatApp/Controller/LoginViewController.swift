//
//  LoginViewController.swift
//  ChatApp
//
//  Created by t.koike on 2021/02/02.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextFIeld: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var dontHaveAccountButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    func configureUI() {
        
        loginButton.layer.cornerRadius = 8
        
    }
    
    
    @IBAction func tappedDontHaveAccountButton(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func tappedLoginButton(_ sender: UIButton) {
        
    
        
    }
    
}
