//
//  CollectionViewCell.swift
//  YamagataSweets
//
//  Created by Raphael on 2020/11/13.
//  Copyright © 2020 Raphael. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var municipalitiesLabel: UILabel!
    @IBOutlet weak var heartCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(_ results: Results) {
        //イメージ画像
        let imageString = results.photos.shopImage
        if let url = URL(string: imageString){
            let data = try! Data(contentsOf: url)
            self.imageView.image = UIImage(data: data)

        }else{
            self.imageView.image = UIImage(named: "\(results.name)")
            //print("画像がnil")
        }
        //店名
        self.storeNameLabel.text = results.name
        //住所
        self.municipalitiesLabel.text = results.address
        
        self.heartCountLabel.text = "00"
        
    }
}
