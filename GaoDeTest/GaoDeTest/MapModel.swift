
//
//  MapModle.swift
//  GaoDeTest
//
//  Created by 岁变 on 2018/1/26.
//  Copyright © 2018年 岁变. All rights reserved.
//

import UIKit

//用于地图相册设计的model，包含图片网址和地理位置，开发中这些数据应该是由网络获取回来，然后用model来承接和处理这些数据。
class MapModel: NSObject {
    var imageUrl: String = ""    //图片网址
    var longitude: String = ""   //经度
    var latitude: String = ""    //纬度
}
