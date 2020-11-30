//
//  LoginViewController.swift
//  YamagataSweets
//
//  Created by Raphael on 2020/11/29.
//  Copyright © 2020 Raphael. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import PKHUD


class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var toSignInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.layer.cornerRadius = 10
        
        //未入力の場合は押せない、色も薄い
        loginButton.isEnabled = false
        loginButton.backgroundColor = UIColor.rgb(red: 255, green: 221, blue: 187)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        //キーボード出現の通知
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        //キーボードが隠れた通知
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    //キーボードが隠れないように上がる
    @objc func showKeyboard(notification: Notification) {
        let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey]as AnyObject).cgRectValue
        
        guard let keyboardMinY = keyboardFrame?.minY else {return}
        let registerButtonMaxY = loginButton.frame.maxY
        let distance = registerButtonMaxY - keyboardMinY + 20
        let transform = CGAffineTransform(translationX: 0, y: -distance)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity:1, options: [], animations: {
            self.view.transform = transform
        })
        //print("キーボードが出ました")
    }
    //キーボードを隠し、画面を元に戻す
    @objc func hideKeyboard() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity:1, options: [], animations: {
            self.view.transform = .identity
        })
        //print("キーボードが隠れました")
    }
    
    //タッチしたらキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBAction func loginActionButton(_ sender: Any) {
        HUD.show(.progress,onView: view)
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password){(res,err)in
            if let err = err {
                print("ログイン情報の取得に失敗しました：",err)
                HUD.hide {(_)in
                    HUD.flash(.error,delay: 1)
                }
                return
            }
            print("ログインに成功しました")
            //Firestoreにアクセス
            guard let uid = Auth.auth().currentUser?.uid else{return}
            let ref = Firestore.firestore().collection("users").document(uid)
            ref.getDocument{(snapshot,err)in
                if let err = err{
                    print("ユーザー情報の取得に失敗しました。\(err)")
                    HUD.hide {(_)in
                        HUD.flash(.error,delay: 1)
                    }
                    return
                }
                guard let data = snapshot?.data() else {return}
                let user = User.init(dic: data)
                
                print("ユーザー情報の取得ができました。\(user.name)")
                HUD.hide {(_)in
                    HUD.flash(.success,onView: self.view, delay: 1){(_)in
                        self.presentToTabBarViewController(user: user)
                    }
                }
            }
        }
    }
    private func presentToTabBarViewController(user:User){
           //画面遷移
           let storyBoard = UIStoryboard(name: "Main", bundle: nil)
           let tabBarViewController = storyBoard.instantiateViewController(identifier: "TabBarController")as! TabBarViewController
           //HomeViewControllerのuserにuserを飛ばす
           tabBarViewController.user = user
           tabBarViewController.modalPresentationStyle = .fullScreen
           self.present(tabBarViewController, animated: true, completion: nil)
       }
    
    @IBAction func toSignInActionButton(_ sender: Any) {
        //前の画面に戻る
        navigationController?.popViewController(animated: true)
    }

}
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let emailIsEmpty = emailTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
        
        //各テキストフィールドが空なら
        if emailIsEmpty || passwordIsEmpty{
            //登録ボタンは押せない
            loginButton.isEnabled = false
            //色が薄い
            loginButton.backgroundColor = UIColor.rgb(red: 255, green: 221, blue: 187)
        //すべて入力されていれば
        }else{
            //押せる
            loginButton.isEnabled = true
            //色が濃い
            loginButton.backgroundColor = UIColor.rgb(red: 255, green: 141, blue: 0)
        }
        
    }
}
