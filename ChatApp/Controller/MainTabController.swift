//
//  MainTabControllerViewController.swift
//  ChatApp
//
//  Created by t.koike on 2021/01/11.
//

import UIKit

class MainTabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MainTabController")
        UITabBar.appearance().tintColor = ColorSet.primary
        UITabBar.appearance().barTintColor = ColorSet.secondary
        
        viewControllers?.enumerated().forEach({ (index,viewController) in
            
            switch index {
            case 0:
                setTabBarIcon(viewController, title: "トーク", imageName: "TalkIcon")
      
            case 1:
                setTabBarIcon(viewController, title: "メモ", imageName: "MemoIcon")
            default: break
            }
         
        })

        
    }
    
    
    private func setTabBarIcon(_ viewController: UIViewController,title: String,imageName: String) {
        
        viewController.tabBarItem.image = UIImage(named: imageName)?.resize(size: .init(width: 25, height: 25))
        viewController.tabBarItem.title = title
        
    }
    
    
    
}
