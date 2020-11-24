//
//  ItemModel.swift
//  YamagataSweets
//
//  Created by Raphael on 2020/11/13.
//  Copyright © 2020 Raphael. All rights reserved.
//

import Foundation

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
