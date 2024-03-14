//
//  ServicePermissonViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/01/22.
//

import UIKit

class ServicePermissonViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cameraDescriptionLabel: UILabel!
    @IBOutlet weak var alrmDescriptionLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [descriptionLabel, cameraDescriptionLabel, alrmDescriptionLabel].forEach{$0?.textColor = .gray4}
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
