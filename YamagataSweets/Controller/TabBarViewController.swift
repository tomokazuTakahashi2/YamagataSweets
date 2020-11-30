//
//  TabBarViewController.swift
//  YamagataSweets
//
//  Created by Raphael on 2020/11/30.
//  Copyright © 2020 Raphael. All rights reserved.
//

import UIKit
import FirebaseAuth

class TabBarViewController: UITabBarController {
    
    var user: User?{
        didSet{
            print("user?.name:",user?.name)
        }
    }
 

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        confirmLoggedInUser()
    }
    //カレントユーザーuidがnilか、ユーザー情報がnilだったら、SignUpViewControllerに飛ばす
    private func confirmLoggedInUser(){
        if Auth.auth().currentUser == nil{
           presentToMainViewController()
        }
    }
    //SignUpViewControllerに飛ばす
    private func presentToMainViewController(){
        //画面遷移
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let signUpViewController = storyBoard.instantiateViewController(identifier: "SignUpViewController")as! SignUpViewController
        let navController = UINavigationController(rootViewController: signUpViewController)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
    }
    
    //DateFormatter
    private func dateFormatterForCreatedAt(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }

}
