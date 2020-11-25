//
//  PagesViewController.swift
//  YamagataSweets
//
//  Created by Raphael on 2020/11/24.
//  Copyright © 2020 Raphael. All rights reserved.
//

import UIKit

class PagesViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    var pageViewController:UIPageViewController!
    let pageControl = UIPageControl()

    override func viewDidLoad() {
            super.viewDidLoad()

        pageViewController = UIPageViewController(transitionStyle:.scroll,
        navigationOrientation: .horizontal,
        options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.setViewControllers([getFirst()], direction: .forward, animated: true, completion: nil)
        pageViewController.view.frame = view.frame
        view.addSubview(pageViewController.view!)

        //下の点々
        let position = UIScreen.main.bounds.size
        pageControl.frame = CGRect(x: position.width / 2 - 19.5, y: position.height - 110, width: 39, height: 37)
        pageControl.numberOfPages = 6
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
        pageControl.pageIndicatorTintColor = .black
        pageControl.currentPageIndicatorTintColor = .green
        view.addSubview(pageControl)
    }
    func getFirst() -> HomeViewController {
        return storyboard!.instantiateViewController(withIdentifier: "FirstViewController") as! HomeViewController
    }
    func getSecond() -> HomeViewController2 {
        return storyboard!.instantiateViewController(withIdentifier: "SecondViewController") as! HomeViewController2
    }

    func getThird() -> HomeViewController3 {
        return storyboard!.instantiateViewController(withIdentifier: "ThirdViewController") as! HomeViewController3
    }
    func getFourth() -> HomeViewController4 {
        return storyboard!.instantiateViewController(withIdentifier: "FourthViewController") as! HomeViewController4
    }
    func getFifth() -> HomeViewController5 {
        return storyboard!.instantiateViewController(withIdentifier: "FifthViewController") as! HomeViewController5
    }

    func getSixth() -> HomeViewController6 {
        return storyboard!.instantiateViewController(withIdentifier: "SixthViewController") as! HomeViewController6
    }
    //右スワイプ時に呼ばれる
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        //今のページが1だったら、2へ行く
        if viewController.isKind(of: HomeViewController.self) {
            return getSecond()
        //今のページが2だったら、3へ行く
        } else if viewController.isKind(of: HomeViewController2.self) {
            return getThird()
        //今のページが3だったら、4へ行く
        } else if viewController.isKind(of: HomeViewController3.self) {
            return getFourth()
        //今のページが4だったら、5へ行く
         } else if viewController.isKind(of: HomeViewController4.self) {
             return getFifth()
        //今のページが5だったら、6へ行く
         } else if viewController.isKind(of: HomeViewController5.self) {
             return getSixth()
        } else {
            return nil
        }

    }
    //左スワイプ時に呼ばれる
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        //今のページが2だったら、1へ戻る
        if viewController.isKind(of:HomeViewController2.self) {
            return getFirst()
        //今のページが3だったら、2へ戻る
        } else if viewController.isKind(of:HomeViewController3.self) {
            return getSecond()
        //今のページが4だったら、3へ戻る
        } else if viewController.isKind(of:HomeViewController4.self) {
            return getThird()
        //今のページが5だったら、4へ戻る
        } else if viewController.isKind(of:HomeViewController5.self) {
            return getFourth()
        //今のページが6だったら、5へ戻る
        } else if viewController.isKind(of:HomeViewController6.self) {
            return getFifth()
        } else {
            return nil
        }

    }
    /*スワイプに伴う処理(pagecontrolのcurrentPageの
    indexのインクリメント,デクリメントなど)はここに書く*/
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating: Bool, previousViewControllers: [UIViewController], transitionCompleted: Bool) {

        if transitionCompleted {
            if let currentVC = pageViewController.viewControllers?[0] {
                let vcName = String(describing: type(of:currentVC))
                if vcName == "HomeViewController" {
                    self.pageControl.currentPage = 0
                } else if vcName == "HomeViewController2" {
                    self.pageControl.currentPage = 1
                } else if vcName == "HomeViewController3" {
                    self.pageControl.currentPage = 2
                } else if vcName == "HomeViewController4" {
                    self.pageControl.currentPage = 3
                } else if vcName == "HomeViewController5" {
                    self.pageControl.currentPage = 4
                } else if vcName == "HomeViewController6" {
                    self.pageControl.currentPage = 5
                } else {
                    print("クラスの取得に失敗しました。")
                }
            }
        }
    }
}
