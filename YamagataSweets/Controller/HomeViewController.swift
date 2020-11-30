//
//  HomeViewController.swift
//  YamagataSweets
//
//  Created by Raphael on 2020/11/13.
//  Copyright © 2020 Raphael. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Firebase
import FirebaseAuth

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, IndicatorInfoProvider {

    //ここがボタンのタイトルに利用されます
    var itemInfo: IndicatorInfo = "山形市１"
    
    var array = [Results]()
//    var heartArray = [FireStoreModel]()
    
    var selectedItems:Results?

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        getAPI()
        
    }
    //MARK:-viewWillAppear
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        let db = Firestore.firestore()
//        db.collection("users").document("likes").addSnapshotListener { documentSnapshot, error in
//          guard let document = documentSnapshot else {
//            print("Error fetching document: \(error!)")
//            return
//          }
//          guard let data = document.data() else {
//            print("Document data was empty.")
//            return
//          }
//          print("Current data: \(data)")
//        }
//
//    }
    
//MARK:-グルナビAPI
    func getAPI(){

        //URLを生成
        guard let url = URL(string: "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=ffd3c1155ff596e65e9d4cf8db64eb85&freeword=%E3%82%AB%E3%83%95%E3%82%A7&pref=PREF06&areacode_m=AREAM6352&hit_per_page=100") else {return}

        
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
                    //print("json: ", json)
                    
                    //コレクションビューに反映する
                    self.array = json.rest
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    //値がnilだったら
                } catch(let err) {
                    print("情報の取得に失敗しました。:" , err)
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
        
        cell.setData(array[indexPath.item])

        
        // セル内のボタンのアクションをソースコードで設定する
        cell.heartButton.addTarget(self, action:#selector(handleHeartButton(_:forEvent:)), for: .touchUpInside)
        
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
        performSegue(withIdentifier: "Segue", sender: nil)
    }
    
    // 画面遷移先のViewControllerを取得し、データを渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Segue" {
            let informationVC = segue.destination as! InformationViewController
            informationVC.selectedItem = selectedItems

        }
    }
    //MARK:-XLPagerTabStrip
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    // MARK:-セル内のボタンがタップされた時に呼ばれるメソッド
    @objc func handleHeartButton(_ sender: UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: ハートボタンがタップされました。")

        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.collectionView)
        let indexPath = collectionView.indexPathForItem(at: point)

        // 配列からタップされたインデックスのデータを取り出す
        var postData = array[indexPath!.item]

        // Firebaseに保存するデータの準備
        //カレントユーザーのIDをuidとする
        if let uid = Auth.auth().currentUser?.uid {
            //もしイイね済みだったら、
            if postData.isLiked {
                // indexの初期値を-1とする
                var index = -1
                //postData.likes配列から一つずつ取り出したものをlikeIdとする
                for likeId in postData.likes {
                    //uidとlikeIDが同じであれば、
                    if likeId == uid {
                        // postData.likes配列のファーストインデックスをindexとする
                        index = postData.likes.firstIndex(of: likeId)!
                        //ループを抜ける
                        break
                    }
                }
                //postData.likes配列のindexを削除する
                postData.likes.remove(at: index)
            //イイねされていなかったら、
            } else {
                //postData.likes配列にuidを追加する
                postData.likes.append(uid)
                print(postData.likes)
            }

            // FireStoreに保存する
            let db = Firestore.firestore()
            var ref: DocumentReference? = nil
            ref = db.collection("users").addDocument(data: [
                "likes": postData.likes
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        }
    }
}
