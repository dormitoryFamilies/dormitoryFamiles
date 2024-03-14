//
//  ChoiceDormitoryButton.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/01/22.
//

import UIKit

class DormitoryButton: UIButton {
    var actionSheet: UIAlertController?
    var site: [String: String]?
  
    func setupActionSheet(dormitories: [String], site: [String: String]) {
        self.site = site
        let alert = UIAlertController(title: "", message: "기숙사 선택", preferredStyle: .actionSheet)
        for dormitory in dormitories {
            let action = UIAlertAction(title: dormitory, style: .default) { [self] _ in
                //액션시트의 버튼이 눌렸을때
                self.head2 = dormitory
                self.setTitle(dormitory, for: .normal)
                print(self.currentTitle)
            }
            alert.addAction(action)
        }
        self.actionSheet = alert
    }
    
    
}
