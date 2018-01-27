//
//  CustomAnnotationView.swift
//  GaoDeTest
//
//  Created by 岁变 on 2018/1/26.
//  Copyright © 2018年 岁变. All rights reserved.
//

import UIKit

//这里是自定义的气泡标识
class CustomAnnotationView: MAAnnotationView {
    //设置一些尺寸
    let labelBackColor = UIColor(red:0.09, green:0.45, blue:1.00, alpha:1.00)
    let annoViewWidth: CGFloat = 60
    let annoViewHeight: CGFloat = 70
    let imageWith: CGFloat = 55
    let imageHeight: CGFloat = 55
    let labelWidth: CGFloat = 20
    let labelHeight: CGFloat = 20
    
    var picture = UIImageView()
    var countLabel = UILabel()

    override init!(annotation: MAAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.setNeedsDisplay()
        self.bounds = CGRect(x: 0, y: 0, width: annoViewWidth, height: annoViewHeight)
        self.backgroundColor = UIColor.clear
    }
    
    //MARK: 重绘View视图，画出一个尖角
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawInContext(context: UIGraphicsGetCurrentContext()!)
        configView()        
    }
    
    //添加子视图
    func configView() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        picture = UIImageView(frame: CGRect(x: 2.5, y: 2.5, width: imageWith, height: imageHeight))
        picture.clipsToBounds = true
        picture.contentMode = UIViewContentMode.scaleAspectFill
        picture.isUserInteractionEnabled = true
        
        countLabel.frame = CGRect(x: self.frame.width - 10, y: -10, width: labelWidth, height: labelHeight)
        countLabel.layer.cornerRadius = 10
        countLabel.clipsToBounds = true
        countLabel.backgroundColor = labelBackColor
        countLabel.textColor = UIColor.white
        countLabel.textAlignment = NSTextAlignment.center
        countLabel.font = UIFont.systemFont(ofSize: 10)
        
        self.addSubview(picture)
        self.addSubview(countLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //重绘方法
    func drawInContext(context: CGContext) {
        //配置
        context.setLineWidth(2.0)
        context.setFillColor(UIColor.white.cgColor)
        //绘制路线
        getDrawPath(context: context)
        context.fillPath()
    }
    
    //绘制路线方法
    func getDrawPath(context: CGContext) {
        let rrect = self.bounds
        let radius: CGFloat = 6.0
        let minx = rrect.minX
        let midx = rrect.midX
        let maxx = rrect.maxX
        let miny = rrect.minY
        let maxy = rrect.maxY - 10
        
        context.move(to: .init(x: midx + 10, y: maxy))
        context.addLine(to: .init(x: midx, y: maxy + 10))
        context.addLine(to: .init(x: midx - 10, y: maxy))
        context.addArc(tangent1End: .init(x: minx, y: maxy), tangent2End: .init(x: minx, y: miny), radius: radius)
        context.addArc(tangent1End: .init(x: minx, y: miny), tangent2End: .init(x: maxx, y: miny), radius: radius)
        context.addArc(tangent1End: .init(x: maxx, y: miny), tangent2End: .init(x: maxx, y: maxy), radius: radius)
        context.addArc(tangent1End: .init(x: maxx, y: maxy), tangent2End: .init(x: minx, y: maxy), radius: radius)
        context.closePath()
    }
    
    
}
