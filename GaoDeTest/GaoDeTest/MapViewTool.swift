//
//  MapViewTool.swift
//  GaoDeTest
//
//  Created by 岁变 on 2018/1/25.
//  Copyright © 2018年 岁变. All rights reserved.
//

import UIKit
let MAPZOOMLEVEL: CGFloat = 10.0
class MapViewTool: NSObject {
    
    //初始化model数据数组这里的model数据提前设置好
    class func initModelArr() -> Array<MapModel> {
        let model1 = MapModel()
        model1.imageUrl = "https://flashcdn.hyuge.cn/flash/1666231/78565/12516700_mid"
        model1.latitude = "39.992520"
        model1.longitude = "116.336170"
        let model2 = MapModel()
        model2.imageUrl = "https://flashcdn.hyuge.cn/flash/1666231/78565/12516699_mid"
        model2.latitude = "39.978234"
        model2.longitude = "116.352343"
        let model3 = MapModel()
        model3.imageUrl = "https://flashcdn.hyuge.cn/flash/1666231/78565/12516698_mid"
        model3.latitude = "39.998293"
        model3.longitude = "116.348904"
        let model4 = MapModel()
        model4.imageUrl = "https://flashcdn.hyuge.cn/flash/1666231/78565/12516697_mid"
        model4.latitude = "40.004087"
        model4.longitude = "116.353915"
        let model5 = MapModel()
        model5.imageUrl = "https://flashcdn.hyuge.cn/flash/1666231/78565/12516695_mid"
        model5.latitude = "40.001442"
        model5.longitude = "116.353915"
        let model6 = MapModel()
        model6.imageUrl = "https://flashcdn.hyuge.cn/flash/1666231/78565/12516532_mid"
        model6.latitude = "39.989105"
        model6.longitude = "116.360200"
        let model7 = MapModel()
        model7.imageUrl = "https://flashcdn.hyuge.cn/flash/1666231/78565/12516497_mid"
        model7.latitude = "39.989098"
        model7.longitude = "116.360201"
        let model8 = MapModel()
        model8.imageUrl = "https://flashcdn.hyuge.cn/flash/1666231/78565/12516496_mid"
        model8.latitude = "39.998439"
        model8.longitude = "116.324219"
        let model9 = MapModel()
        model9.imageUrl = "https://flashcdn.hyuge.cn/flash/1666231/78565/12516495_mid"
        model9.latitude = "39.979590"
        model9.longitude = "116.352792"
        let modelArr = [model1, model2, model3, model4, model5, model6, model7, model8, model9]
        return modelArr
    }

    
    //初始化地理坐标数组
    class func initCoordinateArr(mapController: MapController) {
        let modelArr = initModelArr()
        mapController.mapModelArr = modelArr
        for model in modelArr {
            let coor = CLLocationCoordinate2D.init(latitude: Float64(model.latitude)!, longitude: Float64(model.longitude)!)
            mapController.coordinateArr.append(coor)
        }
    }
    
    //MARK: 功能实现的主要方法。
    //思路：放大或缩小地图，改变的是地图的比例尺参数（mapView.zoomLevel），比例尺表示的是一屏幕像素等于的实际距离，单位是（米），在地图上的两个标注点的实际距离是不变的，缩放地图，两标注点的屏幕像素距离要发生改变，所以，我们就可以定一个常量，比如20屏幕像素距离，缩放地图时，标注点之间超过了20像素的距离就展开，小于就合并为一个。
    //这样我们就需要写一个方法，这个方法要在地图每次执行缩放的时候对坐标组中各个坐标之间的像素距离重新计算、重新分类。将小于规定像素距离的坐标点（CLLocationCoordinate2D），归为一个地图标注点（MAPointAnnotation）
    class func changeMapViewDataForMapScale(mapController: MapController) {
        //mapController.coordinateArr  这是已经有值的坐标数组 mapController.mapModelArr   这是已经有值的model数组
        let mapView: MAMapView! = mapController.mapView
        let coorArr = mapController.coordinateArr
        let modelArr = mapController.mapModelArr
        
        if modelArr.count == 0 {
            return
        }
        
        //创建接收更新分类好的数组
        var refreshPointArr: Array<Array<MAPointAnnotation>> = []
        var refreshModelArr: Array<Array<MapModel>> = []
        
        //这里规定值为 20 像素
        //获取当前比例尺下，20像素的实际距离，为最大实际距离，小于这个距离的合并
        let scaleDistace = mapView.metersPerPoint(forZoomLevel: mapView.zoomLevel)
        let maxDistance = scaleDistace * 20
        
        //下面是主要的处理算法
        for (idx, coor) in coorArr.enumerated() {
            let currentLocal = CLLocation.init(latitude: coor.latitude, longitude: coor.longitude)  //CLLocation 用于计算两坐标点的实际距离
            let pointAnno = MAPointAnnotation() //用于地图的标注点
            pointAnno.coordinate = coor
            let model = modelArr[idx]
            
            if idx == 0 {
                var newPointArr: Array<MAPointAnnotation> = []
                newPointArr.append(pointAnno)
                refreshPointArr.append(newPointArr)
                //处理坐标点分类的同时，将model数组也相应进行分类
                var newModelArr: Array<MapModel> = []
                newModelArr.append(model)
                refreshModelArr.append(newModelArr)
            } else {
                //这里意思是每个坐标点要跟已经分好组的数组的第一项做比较，小于最大值就加入该数组，如果都大于的话，就新建一个数组，添加到分类数组（refreshPointArr）中
                for (idxx, pointAnnoArr) in refreshPointArr.enumerated() {
                    let firstCoor: CLLocationCoordinate2D = pointAnnoArr.first!.coordinate
                    let arrFirstLocal = CLLocation.init(latitude: firstCoor.latitude, longitude: firstCoor.longitude)
                    let distance = currentLocal.distance(from: arrFirstLocal)
                    if distance < maxDistance {
                        //这里我直接添加到数组中去报错，所以我用替换的方法添加
                        var annoArr = pointAnnoArr
                        annoArr.append(pointAnno)
                        refreshPointArr.replaceSubrange(Range(idxx..<(idxx + 1)), with: [annoArr])
                        
                        var modelArr = refreshModelArr[idxx]
                        modelArr.append(model)
                        refreshModelArr.replaceSubrange(Range(idxx..<(idxx + 1)), with: [modelArr])
                        break
                    } else {
                        //当遍历到最后一个,距离distance>maxDistance 创建一个新的分组数组，加到refreshPointArr中
                        if idxx == (refreshModelArr.count - 1) {
                            var newPointArr: Array<MAPointAnnotation> = []
                            newPointArr.append(pointAnno)
                            refreshPointArr.append(newPointArr)
                            
                            var newModelArr: Array<MapModel> = []
                            newModelArr.append(model)
                            refreshModelArr.append(newModelArr)
                        }
                    }
                }
            }
        }
        getElementCountArr(mapController: mapController, refreshAnnoArr: refreshPointArr)
        getPointAnnoArrAndElementFirstArr(refreshModelArr: refreshModelArr, refreshAnnoArr: refreshPointArr, mapController: mapController)
    }
    
    
    //MARK: 对mapController.elementCountArr进行赋值 (每个分组的数据数量)
    class func getElementCountArr(mapController: MapController, refreshAnnoArr: Array<Array<MAPointAnnotation>>) {
        var tempArr: Array<Int> = []
        for arr in refreshAnnoArr {
            let count = arr.count
            tempArr.append(count)
        }
        mapController.elementCountArr = tempArr
    }
    
    //MARK: 对 mapController.pointAnnotationArr和 mapController.elementFirstDataArr
    class func getPointAnnoArrAndElementFirstArr(refreshModelArr: Array<Array<MapModel>>, refreshAnnoArr: Array<Array<MAPointAnnotation>>, mapController: MapController){
        
        var tempModelArr: Array<MapModel> = []
        var tempAnnoArr: Array<MAPointAnnotation> = []
        for (idx, arr) in refreshAnnoArr.enumerated() {
            let anno: MAPointAnnotation = arr.first!
            anno.title = String(idx)
            tempAnnoArr.append(anno)
    
            let modeArr = refreshModelArr[idx]
            let model = modeArr.first!
            tempModelArr.append(model)
        }
        mapController.pointAnnotationArr = tempAnnoArr
        mapController.elementFirstDataArr = tempModelArr
    }

}
