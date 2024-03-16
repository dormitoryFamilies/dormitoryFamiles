//
//  homeViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/01/14.
//

import UIKit
import SwiftSoup

class HomeViewController: UIViewController, DormitoryButtonHandling {
    
    @IBOutlet weak var menuLabel: UILabel!
    
    @IBOutlet weak var lineView: UIView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var todayMenuLabel: UILabel!
    
    @IBOutlet weak var dormitoryButton: UIButton!
    
    @IBOutlet weak var morningButton: RoundButton!
    
    @IBOutlet weak var lunchButton: RoundButton!
    
    @IBOutlet weak var eveningButton: RoundButton!
    
    var todayString: String {
        get {
            let dateFormmatter = DateFormatter()
            dateFormmatter.dateFormat = "yyyy-MM-dd"
            return dateFormmatter.string(from: Date())
        }
    }
    
    let site = ["본관": "https://dorm.chungbuk.ac.kr/home/sub.php?menukey=20041&type=1", "양성재":"https://dorm.chungbuk.ac.kr/home/sub.php?menukey=20041&type=2", "양진재":"https://dorm.chungbuk.ac.kr/home/sub.php?menukey=20041&type=3"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setObserver()
        self.menuLabel.sizeToFit()
        self.menuLabel.lineSpacing(12)
        self.menuLabel.textAlignment = .center
        setLabelAndButton()
        
        setDormitoryButton()
        
        let stackViewBottomConstraint = timeLabel.bottomAnchor.constraint(equalTo: lineView.bottomAnchor, constant: -16)
        stackViewBottomConstraint.isActive = true
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        fetchWebsite(time: .morning)
        setTintAdjustmentModeForButtons(in: self.view)
    }
    
    
    //기숙사 시트의 버튼이 눌려지면(기숙사가 선택되면) 그 title을 버튼의 title과 일치시키는 함수
    @objc func dormitoryChangeNotification(_ notification: Notification) {
        if notification.object is String {
            dormitoryButton.head1 = SelectedDormitory.shared.domitory
            dormitoryButton.setTitle(SelectedDormitory.shared.domitory, for: .normal)
        }
        
        //홈이라 메뉴 세팅도 다시 해줘야 함.
        //아침메뉴받아오는거
        fetchWebsite(time: .morning)
        //UI 아침으로 세팅
        [lunchButton, eveningButton].forEach{
            $0?.backgroundColor = .secondary
            $0?.tintColor = .black
        }
        morningButton.backgroundColor = .white
        morningButton.tintColor = .primary
    }
    
    //시트를 동작하였을때 버튼의 컬러가 변하지 않게 하는 함수
    func setTintAdjustmentModeForButtons(in view: UIView) {
        //받아온 뷰를 돌며 타입이 버튼이거나 버튼을 상속받은 엘리먼트들만
        for subview in view.subviews {
            if let button = subview as? UIButton {
                button.tintAdjustmentMode = .normal
            }
            //버튼이 아니라면 그 내부를 또 탐색
            setTintAdjustmentModeForButtons(in: subview)
        }
    }
    
    
    private func setObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(dormitoryChangeNotification(_:)), name: .init("DormitoryChangeNotification"), object: nil)
    }
    
    
    func setLabelAndButton() {
        morningButton.setTitle("아침", for: .normal)
        lunchButton.setTitle("점심", for: .normal)
        eveningButton.setTitle("저녁", for: .normal)
        dormitoryButton.setTitle("양진재", for: .normal)
    }
    
    
    func setDormitoryButton() {
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = .init(4)
        dormitoryButton.configuration = configuration
        dormitoryButton?.tintAdjustmentMode = .normal
    }
    
    
    
    @IBAction func menuButtonTapped(_ sender: RoundButton) {
        
        [morningButton, lunchButton, eveningButton].forEach{
            $0?.backgroundColor = .secondary
            $0?.tintColor = .black
        }
        sender.backgroundColor = .white
        sender.tintColor = .primary
        
        let mealTimeMapping = ["아침": "morning", "점심": "lunch", "저녁": "evening"]
        if let title = sender.currentTitle, let mappedTitle = mealTimeMapping[title], let time = MealTime(rawValue: mappedTitle) {
            self.fetchWebsite(time: time)
        }
    }
    
    
    
    @IBAction func dormitoryButtonTapped(_ sender: DormitoryButton) {
        presentSheet()
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    func fetchWebsite(time: MealTime) {
        guard dormitoryButton.currentTitle! != "양현재" else {
            return
        }
        guard let url = URL(string: site[dormitoryButton.currentTitle!]!) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                let html = String(data: data, encoding: .utf8)!
                self.parseHTML(html: html, for: self.todayString, time: time)
            }
        }
        task.resume()
    }
    
    func parseHTML(html: String, for date: String, time: MealTime) {
        let mealTimeString = time.rawValue
        do {
            let document = try SwiftSoup.parse(html)
            if let element = try document.select("tr#\(date)").first() {
                let menu = try element.select("td.\(mealTimeString)").first()?.html().replacingOccurrences(of: "<br>", with: "\n")
                
                DispatchQueue.main.async {
                    self.menuLabel.text = menu
                }
            }
        } catch Exception.Error(_, let message) {
            print(message)
        } catch {
            print("error")
        }
    }
    
}

enum MealTime:String, CaseIterable {
    case morning = "morning"
    case lunch = "lunch"
    case evening = "evening"
}

