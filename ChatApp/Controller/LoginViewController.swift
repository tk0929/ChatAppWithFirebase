//
//  LoginViewController.swift
//  ChatApp
//
//  Created by t.koike on 2021/02/02.
//

import UIKit
import Firebase
import PKHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextFIeld: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var dontHaveAccountButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        print("LoginViewController")
        configureUI()
        navigationController?.isNavigationBarHidden = true


    }

    func configureUI() {

        loginButton.layer.cornerRadius = 8

    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


    @IBAction func tappedDontHaveAccountButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }


    @IBAction func tappedLoginButton(_ sender: UIButton) {

        guard let email = emailTextField.text else { return }
        guard let password = passwordTextFIeld.text else { return }

        HUD.show(.progress)

        Auth.auth().signIn(withEmail: email, password:password) { ( result , error ) in

            if let error = error {
                print("ログインに失敗しました。\(error)")
                HUD.hide()
                return
            }
            //            ログイン時にトークルームの情報をFirestoreからもってくる
            HUD.hide()
//            let nc = self.presentingViewController as! UINavigationController
//            let talkListViewController = nc.viewControllers[nc.viewControllers.count - 1] as? TalkListController
//            talkListViewController?.fetchTalkRoomInfo()

            self.performSegue(withIdentifier: "toMainTab", sender: nil)

//            self.dismiss(animated: true, completion: nil)
        }

    }


}
