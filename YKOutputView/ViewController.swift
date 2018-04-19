//
//  ViewController.swift
//  YKOutputView
//
//  Created by 焉知味 on 2018/4/19.
//  Copyright © 2018年 焉知味. All rights reserved.
//

import UIKit

class ViewController: UIViewController,YKOotputViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func aaaaa(_ sender: UIButton) {
        let startRect = sender.convert(sender.frame, to: YKKeyWindow())
        let x: CGFloat = startRect.origin.x + startRect.size.width / 2
        let y: CGFloat = startRect.origin.y + startRect.size.height + 5
        var data: [YKCellModel] = []
        data.append(YKCellModel(title: "New", imageName: "", titleFont: UIFont.systemFont(ofSize: 17), titleColor: #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)))
        data.append(YKCellModel(title: "Hot", imageName: "", titleFont: UIFont.systemFont(ofSize: 17), titleColor: #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)))
        
        let outputView = YKOotputView.show(data, origin: CGPoint(x: 100, y: 100), size: CGSize(width: 140, height: 44), direction: .Center, delegate: self)
        outputView.dismissOperation = {
            print("AAAAAAAAA")
        }
        outputView.popView()
    }
    
    func YKOotputVieDidSelectedAt(_ index: IndexPath) {
        print("index \(index)")
    }
}

