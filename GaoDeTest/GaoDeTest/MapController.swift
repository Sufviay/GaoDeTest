//
//  MapController.swift
//  GaoDeTest
//
//  Created by 岁变 on 2018/1/25.
//  Copyright © 2018年 岁变. All rights reserved.
//

import UIKit

class MapController: UIViewController, MAMapViewDelegate {
    var mapView: MAMapView!
    var mapModelArr: Array<MapModel> = []  //地图数据数组
    var coordinateArr: Array<CLLocationCoordinate2D> = []  //存储坐标地理位置的数组
    var pointAnnotationArr: Array<MAPointAnnotation> = []  //地图标注点的数组
    var elementCountArr: Array<Int> = []  //每个标注点的数据数量数组，用于显示数据的数量
    var elementFirstDataArr: Array<MapModel> = [] //每个标注点中的首个元素数据，用于标注点的附图
    var lastZoomAnnoArr: Array<MAPointAnnotation> = [] //记录上一次缩放生成的标注点数组
    var mapZoomCount: CGFloat = 10.0  //记录mapView的缩放比例
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        configMapView()
        getMapConfigData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //mapView 添加标注点
        mapView.addAnnotations(pointAnnotationArr)
        mapView.showAnnotations(pointAnnotationArr, edgePadding: UIEdgeInsetsMake(100, 100, 100, 100), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK: 配置地图
    func configMapView() {
        mapView = MAMapView.init(frame: self.view.bounds)
        mapView.delegate = self
        mapView.setZoomLevel(MAPZOOMLEVEL, animated: false)
        self.view.addSubview(mapView)
    }
    
    //MARK: 处理地图显示的数据
    func getMapConfigData() {
        //对地理位置坐标数组（coordinateArr）和地图数据数组（MapModelArr）赋值
        MapViewTool.initCoordinateArr(mapController: self)
        getShowMapDate()
    }
    
    //MARK: 处理用于展示的地图数据
    func getShowMapDate() {
        MapViewTool.changeMapViewDataForMapScale(mapController: self)
    }

    //MARK: mapViewDelegate
    
    //返回标注点的代理方法 这里的MAAnnotationView是自定义的。
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: CustomAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as? CustomAnnotationView
            if annotationView == nil {
                annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            
            let idx = Int(annotation.title!)
            let countText: String = String(self.elementCountArr[idx!])
            annotationView?.countLabel.text = countText
            
            let model = self.elementFirstDataArr[idx!]
            let imageUrl = URL.init(string: model.imageUrl)
            //主线程刷新UI
            DispatchQueue.main.async {
                annotationView?.picture.sd_setImage(with: imageUrl, placeholderImage: UIImage())
            }
            return annotationView
        }
        return nil
    }
    
    //将要缩放的代理方法
    func mapView(_ mapView: MAMapView!, mapWillZoomByUser wasUserAction: Bool) {
        //记录上一次缩放的标注点数组
        lastZoomAnnoArr = self.pointAnnotationArr
    }
    //进行缩放的代理方法
    func mapView(_ mapView: MAMapView!, mapDidZoomByUser wasUserAction: Bool) {
        //当缩放比例不变就不执行
        if self.mapZoomCount != mapView.zoomLevel {
            DispatchQueue.main.async {
                //先将已有的标注点数组删除
                mapView.removeAnnotations(self.lastZoomAnnoArr)
                //获取新的数据
                self.getShowMapDate()
                //记录缩放后的缩放比例
                self.mapZoomCount = mapView.zoomLevel
                //添加新数据
                mapView.addAnnotations(self.pointAnnotationArr)
            }
        }
    }

}
