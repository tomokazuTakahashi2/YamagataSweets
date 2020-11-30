//
//  SignUpViewController.swift
//  YamagataSweets
//
//  Created by Raphael on 2020/11/29.
//  Copyright © 2020 Raphael. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import PKHUD

struct User {
    let name: String
    let createdAt: Timestamp
    let email: String
    
    init(dic: [String: Any]) {
        self.name = dic["name"] as! String
        self.createdAt = dic["createdAt"] as! Timestamp
        self.email = dic["email"] as! String
    }
}


class SignUpViewController: UIViewController{

    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerButton.layer.cornerRadius = 10
        //未入力の場合は押せない、色も薄い
        registerButton.isEnabled = false
        registerButton.backgroundColor = UIColor.rgb(red: 255, green: 221, blue: 187)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        usernameTextField.delegate = self
        
        //キーボード出現の通知
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        //キーボードが隠れた通知
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    //キーボードが隠れないように上がる
    @objc func showKeyboard(notification: Notification) {
        let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey]as AnyObject).cgRectValue
        
        guard let keyboardMinY = keyboardFrame?.minY else {return}
        let registerButtonMaxY = registerButton.frame.maxY
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
    //登録ボタン
    @IBAction func tappedRegisterButton(_ sender: Any) {
        handleAuthToFirebase()
        
    }
    private func handleAuthToFirebase(){
        HUD.show(.progress,onView: view)
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        Auth.auth().createUser(withEmail: email, password: password){(res, err)in
            if let err = err{
                print("認証情報の保存に失敗しました。\(err)")
                HUD.hide {(_)in
                    HUD.flash(.error,delay: 1)
                }
                return
            }
            print("認証情報の取得に成功しました。")
            
            self.addUserInfoToFirestore(email: email)
        }
        
    }
    
    private func addUserInfoToFirestore(email: String){
        //Firestoreへの保存
        guard let uid = Auth.auth().currentUser?.uid else{return}
        guard let name = self.usernameTextField.text else{return}
        let docData = ["email":email, "name":name, "createdAt":Timestamp()]as [String: Any]
        let ref = Firestore.firestore().collection("users").document(uid)
        ref.setData(docData){(err)in
            if let err = err{
                print("Firestoreへの保存に失敗しました。\(err)")
                HUD.hide {(_)in
                    HUD.flash(.error,delay: 1)
                }
                return
            }
            print("Firestoreへの保存に成功しました。")
            
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
        //slideViewControllerのuserにuserを飛ばす
        tabBarViewController.user = user
        tabBarViewController.modalPresentationStyle = .fullScreen
        self.present(tabBarViewController, animated: true, completion: nil)
    }

    @IBAction func tapToLogin(_ sender: Any) {
        //画面遷移
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyBoard.instantiateViewController(identifier: "LoginViewController")as! LoginViewController
  
        navigationController?.pushViewController(loginViewController,animated: true)
    }
}
extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let emailIsEmpty = emailTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
        let usernameIsEmpty = usernameTextField.text?.isEmpty ?? true
        
        //各テキストフィールドが空なら
        if emailIsEmpty || passwordIsEmpty || usernameIsEmpty {
            //登録ボタンは押せない
            registerButton.isEnabled = false
            //色が薄い
            registerButton.backgroundColor = UIColor.rgb(red: 255, green: 221, blue: 187)
        //すべて入力されていれば
        }else{
            //押せる
            registerButton.isEnabled = true
            //色が濃い
            registerButton.backgroundColor = UIColor.rgb(red: 255, green: 141, blue: 0)
        }
        
    }
}
