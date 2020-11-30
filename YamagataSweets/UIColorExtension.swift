//
//  UIColorExtension.swift
//  YamagataSweets
//
//  Created by Raphael on 2020/11/29.
//  Copyright © 2020 Raphael. All rights reserved.
//

import UIKit

extension UIColor{
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
    
}
