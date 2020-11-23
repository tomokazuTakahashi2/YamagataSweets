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
    let address: String
    let name: String
    let photos: Photos
    
    enum CodingKeys : String, CodingKey {
        case address
        case name
        case photos = "image_url"
    }
    
}

struct Photos: Codable {
    let shopImage: String
    
    enum CodingKeys : String, CodingKey {
        case shopImage = "shop_image2"
    }
}
