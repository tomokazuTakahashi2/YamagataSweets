//
//  SlideViewController.swift
//  YamagataSweets
//
//  Created by Raphael on 2020/11/26.
//  Copyright © 2020 Raphael. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class SlideViewController: ButtonBarPagerTabStripViewController {

        override func viewDidLoad() {
            //バーボタン間の隙間
            settings.style.buttonBarMinimumLineSpacing = 2
            super.viewDidLoad()
                        
        }

        override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
            //管理されるViewControllerを返す処理
            let firstVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstViewController")
            let first2VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "First2ViewController")
            let secondVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondViewController")
            let thirdVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThirdViewController")
            let fourthVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FourthViewController")
            let fifthVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FifthViewController")
            let sixthVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SixthViewController")
            let seventhVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SeventhViewController")
            let eighthVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EighthViewController")
            let ninthVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NinthViewController")
            let childViewControllers:[UIViewController] = [firstVC, first2VC, secondVC, thirdVC,fourthVC,fifthVC,sixthVC,seventhVC,eighthVC,ninthVC]
            return childViewControllers
    }
    }
