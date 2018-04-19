//
//  YKOutputView.swift
//  YKOutputView
//
//  Created by 焉知味 on 2018/4/19.
//  Copyright © 2018年 焉知味. All rights reserved.
//

import UIKit

enum YKOutputDirection: Int {
    case Left = 1
    case Right
    case Center
}

struct YKCellModel {
    var title: String
    var imageName: String
    var titleFont: UIFont
    var titleColor: UIColor
}

protocol YKOutputViewDelegate: NSObjectProtocol {
    func YKOutputVieDidSelectedAt(_ index: IndexPath)
}

class YKOutputView: UIView {
    /// 背景按钮
    private lazy var bgBtn: UIButton = {
        let btn = UIButton()
        btn.frame = self.frame
        btn.addTarget(self, action: #selector(dismisssView), for: .touchUpInside)
        return btn
    }()
    /// 内容TableView
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.separatorColor = UIColor(red: 230.0 / 255.0, green: 230.0 / 255.0, blue: 230.0 / 255.0, alpha: 1)
        view.backgroundColor = .white
        view.bounces = false
        view.layer.cornerRadius = 10
        view.delegate = self
        view.dataSource = self
        view.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        return view
    }()
    /// 点击区域原点
    private var touchOrigin: CGPoint = .zero
    /// 单个cell大小
    private var singleSize: CGSize = .zero
    /// 数据
    private var cellArray: [YKCellModel] = []
    /// 类型
    private var direction: YKOutputDirection = .Left
    /// 隐藏视图回调
    var dismissOperation: (() -> Void)? = nil
    weak var delegate: YKOutputViewDelegate?
    
    class func show(_ dataArray: [YKCellModel], origin: CGPoint, size: CGSize, direction: YKOutputDirection, delegate: YKOutputViewDelegate?) -> YKOutputView {
        let view = YKOutputView()
        view.setupView(dataArray, origin: origin, size: size, direction: direction, delegate: delegate)
        return view
    }

    // MARK: 初始化
    private func setupView(_ dataArray: [YKCellModel], origin: CGPoint, size: CGSize, direction: YKOutputDirection, delegate: YKOutputViewDelegate?) {
        touchOrigin = origin
        singleSize = size
        cellArray = dataArray
        self.direction = direction
        self.delegate = delegate
        
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowRadius = 10
        frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        backgroundColor = .clear
        // 添加背景按钮
        insertSubview(bgBtn, at: 0)
        
        switch direction {
        case .Left:
            tableView.frame = CGRect(x: origin.x, y: origin.y, width: size.width, height: size.height * CGFloat(dataArray.count))
        case .Right:
            tableView.frame = CGRect(x: origin.x, y: origin.y, width: -size.width, height: size.height * CGFloat(dataArray.count))
        case .Center:
            tableView.frame = CGRect(x: origin.x - size.width / 2, y: origin.y, width: size.width, height: size.height * CGFloat(dataArray.count))
        }
        self.addSubview(tableView)
        tableView.reloadData()
    }
    
    /// 弹出视图
    func popView() {
        let keyWindow = YKKeyWindow()
        keyWindow.addSubview(self)
        //动画效果弹出
        alpha = 0
        let frame = tableView.frame
        tableView.frame = CGRect(x: touchOrigin.x, y: touchOrigin.y, width: 0, height: 0)
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
            self.tableView.frame = frame
        }
    }
    
    // MARK: 隐藏视图
    @objc func dismisssView() {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
            self.tableView.frame = CGRect(x: self.touchOrigin.x, y: self.touchOrigin.y, width: 0, height: 0)
        }) { (_) in
            self.removeFromSuperview()
            if let dismissOperation = self.dismissOperation {
                dismissOperation()
            }
        }
    }
    
    // MARK: 画三角形
    override func draw(_ rect: CGRect) {
        // 拿到当前视图准备好的画板
        guard let context = UIGraphicsGetCurrentContext() else { return }
        // 利用path进行绘制三角形
        context.beginPath()
        
        var startX = touchOrigin.x
        let startY = touchOrigin.y
        switch direction {
        case .Left:
            startX = touchOrigin.x + 20
        case .Right:
            startX = touchOrigin.x - 20
        default:
            break
        }
        
        // 设置起点
        context.move(to: CGPoint(x: startX, y: startY))
        context.addLine(to: CGPoint(x: startX + 5, y: startY - 5))
        context.addLine(to: CGPoint(x: startX + 10, y: startY))
        context.closePath()
        
        // 设置填充色
        tableView.backgroundColor?.setFill()
        tableView.backgroundColor?.setStroke()
        
        // 绘制路径path
        context.drawPath(using: .fillStroke)
    }
}

extension YKOutputView: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return singleSize.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        if indexPath.row < cellArray.count {
            let model = cellArray[indexPath.row]
            cell.textLabel?.text = model.title
            cell.textLabel?.textColor = model.titleColor
            cell.textLabel?.font = model.titleFont
            if model.imageName != "" {
                cell.imageView?.image = UIImage(named: model.imageName)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.YKOutputVieDidSelectedAt(indexPath)
        dismisssView()
    }
    
    // MARK: 让分割线和文字对齐
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        cell.layoutMargins = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        cell.preservesSuperviewLayoutMargins = false
    }
}

// MARK: 获取UIWindow
func YKKeyWindow() -> UIWindow {
    if UIApplication.shared.keyWindow == nil {
        return ((UIApplication.shared.delegate?.window)!)!
    } else {
        return UIApplication.shared.keyWindow!
    }
}
