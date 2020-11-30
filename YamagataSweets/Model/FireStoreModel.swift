//
//  FireStoreModel.swift
//  YamagataSweets
//
//  Created by Raphael on 2020/11/27.
//  Copyright © 2020 Raphael. All rights reserved.
//
//import Firebase
//
//class FireStoreModel: NSObject {
//    var isLiked: Bool = false
//    var uid: String?
//    var id: String?
//    var likes: [String] = []
//    
//    init(snapshot: DocumentSnapshot, myId: String) {
//        self.id = snapshot.documentID
//        let valueDictionary = snapshot.value(forKey: "") as! [String: Any]
//        self.uid = valueDictionary["uid"]as? String
//        //ハートカウント
//        if let likes = valueDictionary["likes"] as? [String] {
//            self.likes = likes
//        }
//        //ハートカウント済み
//        for likeId in self.likes {
//            if likeId == myId {
//                self.isLiked = true
//                break
//            }
//        }
//    }
//}


