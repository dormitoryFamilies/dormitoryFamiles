

//
//  ViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2023/09/04.
//

import UIKit
import WebKit

class MealMenuViewController: UIViewController {
    
    private let schoolMealButton: UIButton = {
        let button = UIButton()
        button.setTitle("학식 보기", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.titleColor
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 18)
        button.addTarget(nil, action: #selector(schoolMealButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var dateText: UILabel = {
        let lb = UILabel()
           let currentDate = Date()
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "MM-dd"
           let formattedDate = dateFormatter.string(from: currentDate)
           lb.text = "오늘의 긱식 (\(formattedDate))"
           return lb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConstraint()
    }
    
    private func setConstraint() {
        let component = [schoolMealButton, dateText]
        component.forEach{self.view.addSubview($0)}
        component.forEach{$0.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                self.dateText.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
                self.dateText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                self.dateText.widthAnchor.constraint(equalToConstant: 500),
                self.dateText.heightAnchor.constraint(equalToConstant: 50),
                
                self.schoolMealButton.topAnchor.constraint(equalTo: self.dateText.bottomAnchor, constant: 15),
                self.schoolMealButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                self.schoolMealButton.widthAnchor.constraint(equalToConstant: 200),
                self.schoolMealButton.heightAnchor.constraint(equalToConstant: 50),
                
            ])
        }
    }
    
        @objc func schoolMealButtonTapped() {
        //self.navigationController?.pushViewController(SchoolWebViewController(), animated: true)
        present(SchoolWebViewController(), animated: true)
    }
}
