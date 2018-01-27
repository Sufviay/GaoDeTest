//
//  ViewController.swift
//  GaoDeTest
//
//  Created by 岁变 on 2018/1/24.
//  Copyright © 2018年 岁变. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        //设置原点（0，0）实际上是（0，64）
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    @IBAction func clickButton(_ sender: Any) {
        let nextMapVC = MapController()
        self.navigationController?.pushViewController(nextMapVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

