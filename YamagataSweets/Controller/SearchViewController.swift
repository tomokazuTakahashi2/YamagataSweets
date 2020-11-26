//
//  SearchViewController.swift
//  YamagataSweets
//
//  Created by Raphael on 2020/11/13.
//  Copyright © 2020 Raphael. All rights reserved.
//

import UIKit
import KRProgressHUD

class SearchViewController: UIViewController,UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    var array = [Results]()
        
    var selectedItems:Results?
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //サーチバー
        searchBar.delegate = self
        // コレクションビュー
        collectionView.delegate = self
        collectionView.dataSource = self
        //コレクションビューのレイアウト
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 0.1
        collectionView.collectionViewLayout = layout
        //カスタムセル
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
    }
    //MARK:-サーチバー
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // キーボードを閉じる
        view.endEditing(true)
        
        // 入力された値がnilでなければif文のブロック内の処理を実行
        if let word = searchBar.text {
            // getAPIへ渡す
            getAPI(word:word)
        }
    }
    //MARK:-グルナビAPI
    func getAPI(word:String){
        
        //キーワードをURlにエンコードする
        guard let keyword_encode = word.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        //URLを生成
        guard let url = URL(string: "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=ffd3c1155ff596e65e9d4cf8db64eb85&freeword=%E3%82%AB%E3%83%95%E3%82%A7,\(keyword_encode)&pref=PREF06&hit_per_page=100&freeword_condition=1") else {return}
        print(url)
        
        //Requestを生成
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        //非同期で通信を行う
        let task = URLSession.shared.dataTask(with: url){(data, response, err)in
            
            //errが入ってきたら（エラー）、
            if let err = err{
                print("情報の取得に失敗しました。:" , err)
                
                return
            }
            //dataが入ってきたら（成功）、
            if let data = data{
                //値がnilじゃなかったら
                do{
                    //dataをJsonに変換
                    let json = try JSONDecoder().decode(ItemModel.self, from: data)
                    print("json: ", json)
                    
                    //コレクションビューに反映する
                    self.array = json.rest
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    //値がnilだったら
                } catch(let err) {
                    print("情報の取得に失敗しました。:" , err)
                    // HUDで投稿完了を表示する
                    KRProgressHUD.showMessage("検索にヒットしませんでした。")
                }
            }
        }
        //タスクを開始する
        task.resume()
        
    }
    
    //MARK:-コレクションビュー
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! CollectionViewCell
        
        cell.setData(array[indexPath.row])
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return.init(width: collectionView.frame.width/2 - 20, height: collectionView.frame.width/2 + collectionView.frame.width/3)
    }
    
    //アイテムをタップしたら画面遷移
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //タップされたアイテムをinformationVCに渡す
        selectedItems = array[indexPath.item]
        
        // Identifierが"Segue"のSegueを使って画面遷移する関数
        performSegue(withIdentifier: "SearchSegue", sender: nil)
    }
    
    // 画面遷移先のViewControllerを取得し、データを渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchSegue" {
            let informationVC = segue.destination as! InformationViewController
            informationVC.selectedItem = selectedItems
            
        }
    }
    
}

