//
//  HomeViewController4.swift
//  YamagataSweets
//
//  Created by Raphael on 2020/11/24.
//  Copyright © 2020 Raphael. All rights reserved.
//

import UIKit
import XLPagerTabStrip


class HomeViewController4: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, IndicatorInfoProvider {
    
    //バーボタンのタイトル
    var itemInfo: IndicatorInfo = "寒河江・大江・朝日町"
    
    var array = [Results]()
    
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
//        layout.itemSize = CGSize(width: collectionView.frame.width/2, height: collectionView.frame.width/2)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 0.1
        collectionView.collectionViewLayout = layout
        //カスタムセル
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        getAPI()
        
    }
//MARK:-グルナビAPI
    func getAPI(){

        //URLを生成
        guard let url = URL(string: "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=ffd3c1155ff596e65e9d4cf8db64eb85&freeword=%E3%82%AB%E3%83%95%E3%82%A7&pref=PREF06&areacode_m=AREAM6362&areacode_m=AREAM6374&hit_per_page=100") else {return}

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
        performSegue(withIdentifier: "Segue4", sender: nil)
    }
    
    // 画面遷移先のViewControllerを取得し、データを渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Segue4" {
            let informationVC = segue.destination as! InformationViewController
            informationVC.selectedItem = selectedItems

        }
    }
    //MARK:-XLPagerTabStrip
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
