//
//  loginViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/01/18.
//

import UIKit

class loginViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLabel()
    }
    

    private func setLabel() {
        titleLabel.text = "기숙사에 대한 정보를 담았어요!"
        titleLabel.asColor(targetString: ["기숙사", "정보"], color: .primary!)
        
        descriptionLabel.font = UIFont.body2
    }
    
    @IBAction func kakaoLoginbuttonTapped(_ sender: RoundButton) {
        print("로그인 버튼이 눌렸다")
    }
    
}
