//
//  ItemModel.swift
//  YamagataSweets
//
//  Created by Raphael on 2020/11/13.
//  Copyright © 2020 Raphael. All rights reserved.
//

import Foundation
import Firebase


struct ItemModel: Codable {
    let rest: [Results]
}

struct Results: Codable{
    let name: String
    let latitude: String
    let longitude: String
    let url: String
    let photos: Photos
    let address: String
    let tel: String
    let opentime: String
    let holiday: String
    
    var isLiked: Bool = false
    var uid: String?
    var id: String?
    var likes: [String] = []
     
    enum CodingKeys : String, CodingKey {
        case name
        case latitude
        case longitude
        case url
        case photos = "image_url"
        case address
        case tel
        case opentime
        case holiday
    }
    
}

struct Photos: Codable {
    let shopImage: String
    
    enum CodingKeys : String, CodingKey {
        case shopImage = "shop_image2"
    }
}
//import Firebase
//
//class FireStoreModel: NSObject {
//
//    let results = Results.self
//    
//    init(snapshot: DocumentSnapshot, myId: String) {
//        results.id = snapshot.documentID
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
