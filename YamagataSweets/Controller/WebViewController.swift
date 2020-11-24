//
//  WebViewController.swift
//  YamagataSweets
//
//  Created by Raphael on 2020/11/25.
//  Copyright © 2020 Raphael. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {

    var webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 50)
        self.view.addSubview(webView)
        
        //ボタン
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(buttonAction(_ :)), for: .touchUpInside)
        button.setTitle("戻る", for: .normal)
        button.frame = CGRect(x: 0, y: self.view.frame.size.height - 50, width: self.view.frame.size.width, height: 50)
        self.view.addSubview(button)
        
        let urlString = UserDefaults.standard.object(forKey: "url")
        let url = URL(string: urlString! as! String)
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
    @objc func buttonAction(_ sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
}
