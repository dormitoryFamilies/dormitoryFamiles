//
//  ViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2023/09/04.
//

import UIKit
import WebKit

class MealMenuViewController: UIViewController {
    
    private lazy var schoolMealButton: UIButton = {
        let button = UIButton()
        button.setTitle("학식 보기", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.titleColor
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 18)
        return button
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(schoolMealButton)
        schoolMealButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.schoolMealButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            self.schoolMealButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            self.schoolMealButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            self.schoolMealButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
}
