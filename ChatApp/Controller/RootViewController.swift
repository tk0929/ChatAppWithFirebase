//
//  RootViewController.swift
//  ChatApp
//
//  Created by t.koike on 2021/02/08.
//

import UIKit
import Firebase

final class RootViewController: UIViewController {
    
    private var current: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildViewController()
    }
    
    
    func transitionToMainTab() {
        
        let storyboard = UIStoryboard(name: "MainTab", bundle: nil)
        let mainTabController = storyboard.instantiateViewController(withIdentifier: "MainTabController") as! MainTabController
        //        let nc = UINavigationController(rootViewController: mainTabController)
        
        transition(to: mainTabController)
        
    }
    
    func transitionToLogin() {
        
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        transition(to: loginViewController)
        
    }
    
    func transitionToSignUp() {
        
        let storyboard = UIStoryboard(name: "signUp", bundle: nil)
        let signUpViewController = storyboard.instantiateViewController(withIdentifier: "MainTabController") as! SignUpViewController
        
        transition(to: signUpViewController)
    }
    
    
    private func addChildViewController() {
        
        guard let current = current else { return }
        addChild(current)
        current.view.frame = view.bounds
        view.addSubview(current.view)
        current.didMove(toParent: self)
        
    }
    
    private func transition (to vc: UIViewController) {
        
        addChild(vc)
        vc.view.frame = view.bounds
        view.addSubview(vc.view)
        vc.didMove(toParent: self)
        current?.willMove(toParent: nil)
        current?.view.removeFromSuperview()
        current?.removeFromParent()
        current = vc
        
        
    }
    
}
