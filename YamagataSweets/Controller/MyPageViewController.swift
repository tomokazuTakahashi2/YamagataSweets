//
//  MyPageViewController.swift
//  YamagataSweets
//
//  Created by Raphael on 2020/11/13.
//  Copyright © 2020 Raphael. All rights reserved.
//

import UIKit
import FirebaseAuth

class MyPageViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        logoutButton.layer.cornerRadius = 10
    }
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        handleLogout()
    }
    
    private func handleLogout(){
        do{
           try Auth.auth().signOut()
            presentToMainSignUpViewController()
            print("ログアウトしました")
        } catch(let err){
            print("ログアウトに失敗しました：\(err)")
        }
    }
    private func presentToMainSignUpViewController(){
        //画面遷移
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let signUpViewController = storyBoard.instantiateViewController(identifier: "SignUpViewController")as! SignUpViewController
        let navController = UINavigationController(rootViewController: signUpViewController)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
    }
}
