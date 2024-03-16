//
//  TabbarViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/02/05.
//

import UIKit

class TabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        changeSelectedButtonTitleColor()
    }
    
    private func changeSelectedButtonTitleColor() {
        let selectedColor   = UIColor.black
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
    }
}
