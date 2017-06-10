//
//  XJHBottomNavController.swift
//  BottomNavDemo
//
//  Created by xujunhao on 2017/6/10.
//  Copyright © 2017年 cocoadogs. All rights reserved.
//

import UIKit

class XJHBottomNavController: UINavigationController {
    private let tiptoesHeight = UIApplication.shared.statusBarFrame.size.height
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(navigationBarClass: XJHBottomNavBar.self, toolbarClass: nil)
        viewControllers = [rootViewController];
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.isHidden = true
        interactivePopGestureRecognizer?.addTarget(self, action: #selector(handleTiptoesDisplay(sender:)))
        configureNavigationBar()
    }
    
    fileprivate func configureNavigationBar() {
        guard let bar = navigationBar as? XJHBottomNavBar else { return }
        view.addSubview(bar.tiptoes)
        view.addSubview(bar.currentTitleLabel)
        view.addSubview(bar.priorTitleLabel)
        bar.tiptoes.frame = CGRect(x: 0, y: view.frame.height - tiptoesHeight, width: view.frame.width, height: tiptoesHeight)
        bar.currentTitleLabel.sizeToFit()
        bar.currentTitleLabel.center = CGPoint(x: view.center.x, y: bar.tiptoes.center.y)
        bar.priorTitleLabel.frame = bar.currentTitleLabel.frame
    }
    
    @objc private func handleTiptoesDisplay(sender: UIGestureRecognizer) {
        guard let bar = navigationBar as? XJHBottomNavBar else { return  }
        
        // You can customize the transition style here
        let portionValue = sender.location(in: view).x
        let currentAlpha = portionValue / view.frame.width
        
        // Magic number is to fix the bug that when pan gesture goed half and stop
        bar.currentTitleLabel.alpha = (1 - currentAlpha) < 0.5 ? (1 - currentAlpha) * 2 : 1 // 1 -> 0
        bar.priorTitleLabel.alpha = currentAlpha > 0.5 ? currentAlpha * 2 - 1 : 0 // 0 -> 1
    }
}

extension XJHBottomNavController: UINavigationBarDelegate {
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPush item: UINavigationItem) -> Bool {
        guard let bar = navigationBar as? XJHBottomNavBar else { return true }
        bar.priorTitleLabel.text = ""
        bar.priorTitleLabel.isHidden = false
        return true
    }
    
    public func navigationBar(_ navigationBar: UINavigationBar, didPush item: UINavigationItem) {
        if let pushTitle = item.title {
            guard let bar = navigationBar as? XJHBottomNavBar else { return }
            bar.currentTitleLabel.text = pushTitle
            bar.currentTitleLabel.sizeToFit()
            bar.currentTitleLabel.center = CGPoint(x: view.center.x, y: bar.tiptoes.center.y)
        }
    }
    
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        guard let bar = navigationBar as? XJHBottomNavBar else { return true }
        bar.priorTitleLabel.isHidden = false
        
        // Get the former viewcontroller
        let numberOfViewControllers = viewControllers.count
        if numberOfViewControllers > 0 {
            if let popTitle = viewControllers[numberOfViewControllers - 1].title {
                bar.priorTitleLabel.text = popTitle
            }
        }
        return true
    }
    
    public func navigationBar(_ navigationBar: UINavigationBar, didPop item: UINavigationItem) {
        guard let bar = navigationBar as? XJHBottomNavBar else { return }
        bar.currentTitleLabel.text = bar.priorTitleLabel.text
        bar.currentTitleLabel.sizeToFit()
        bar.currentTitleLabel.center = CGPoint(x: view.center.x, y: bar.tiptoes.center.y)
        bar.currentTitleLabel.alpha = 1.0
        bar.priorTitleLabel.isHidden = true
    }
}

fileprivate class XJHBottomNavBar: UINavigationBar {
    
    var currentTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 8)
        label.textColor = UIColor.white
        label.text = "Home"
        label.textAlignment = .center
        return label
    }()
    
    var priorTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 8)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    var tiptoes: UIView = {
        let toes = UIView()
        toes.backgroundColor = UIColor(red: 66.0/255.0, green: 69.0/255.0, blue: 78.0/255.0, alpha:1.0)
        return toes
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
