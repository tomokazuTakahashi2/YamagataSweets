//
//  InformationViewController.swift
//  YamagataSweets
//
//  Created by Raphael on 2020/11/24.
//  Copyright © 2020 Raphael. All rights reserved.
//

import UIKit
import MapKit

class InformationViewController: UIViewController {
    
    var selectedItem: Results?

    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var heartCount: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    @IBOutlet weak var openTimeLabel: UILabel!
    @IBOutlet weak var holidayLabel: UILabel!
    @IBOutlet weak var urlButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        showLocation()
    }
    

    private func setupViews() {
        storeNameLabel.text = selectedItem?.name
        addressLabel.text = selectedItem?.address
        
        guard let imageString = selectedItem?.photos.shopImage else { return }
        if let url = URL(string: imageString){
            let data = try! Data(contentsOf: url)
            self.imageView.image = UIImage(data: data)
        }else{
            self.imageView.image = UIImage(named: "\(selectedItem?.name ?? "NO-IMAGE")")
        }
        
        telLabel.text = selectedItem?.tel ?? "不明"
        openTimeLabel.text = selectedItem?.opentime ?? "不明"
        holidayLabel.text = selectedItem?.holiday ?? "不明"
        urlButton.setTitle("\(selectedItem?.url ?? "不明")", for: .normal)
    }
    //MARK:-店舗の場所を示す
    func showLocation(){

        let latitude = selectedItem!.latitude as String
        let longitude = selectedItem!.longitude as String

        // 緯度・軽度を設定
        let location = CLLocationCoordinate2DMake(Double(latitude)!, Double(longitude)!)
        // マップビューに緯度・軽度を設定
        mapView.setCenter(location, animated:true)

        // 縮尺を設定
        var region = mapView.region
        region.center = location
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        // マップビューに縮尺を設定
        mapView.setRegion(region, animated:true)
        //makeAPin()へ

        self.makeAPin(targetCoordinate: location)
    }
    //MARK:-マップ上にピンを置く
    func makeAPin(targetCoordinate:CLLocationCoordinate2D){
        
        //MKPointAnnotationインスタンスを取得し、ピンを生成
         let pin = MKPointAnnotation()

        //ピンの置く場所に緯度経度を設定
         pin.coordinate = targetCoordinate

        //ピンのタイトルを設定
        pin.title = selectedItem?.name

        //ピンを地図に置く
         self.mapView.addAnnotation(pin)

        //検索地点の緯度経度を中心に半径500mの範囲を表示
         self.mapView.region = MKCoordinateRegion(center: targetCoordinate, latitudinalMeters: 500.0, longitudinalMeters: 500.0)
    }
    @IBAction func urlButtonAction(_ sender: Any) {
        //遷移先でwebViewに取得したURLを表示
        let webViewController:UIViewController = WebViewController()
        
        webViewController.modalTransitionStyle = .crossDissolve
        
        UserDefaults.standard.set(selectedItem?.url, forKey: "url")
        
        self.present(webViewController,animated: true, completion: nil)
    }
}
