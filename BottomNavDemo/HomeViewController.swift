//
//  HomeViewController.swift
//  BottomNavDemo
//
//  Created by xujunhao on 2017/6/10.
//  Copyright © 2017年 cocoadogs. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "HOME"
        view.backgroundColor = UIColor(red: 59.0/255.0, green: 62.0/255.0, blue: 67.0/255.0, alpha: 1.0)
        
        let button = UIButton()
        button.setTitle("Push", for: .normal)
        button.sizeToFit()
        button.center = view.center
        button.setTitleColor(UIColor.white, for: .normal)
        
        button.addTarget(self, action: #selector(nav), for: .touchUpInside)
        
        view.addSubview(button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nav() {
        let vc = NextViewController()
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
