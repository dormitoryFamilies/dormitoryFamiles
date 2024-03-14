//
//  ChoiceDormitoryViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/01/25.
//

import UIKit


class ChoiceDormitoryViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        label?.textAlignment = .center
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle else {return}
        SelectedDormitory.shared.changeKind(title)
        NotificationCenter.default.post(name: .init("DormitoryChangeNotification"), object: title)
        dismiss(animated: true)
        
    }
}
