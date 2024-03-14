//
//  bulletinBoardMainViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/01/01.
//
import Tabman
import Pageboy
import UIKit

class BulletinBoardMainViewController: TabmanViewController, DormitoryButtonHandling {
    private var viewControllers: [UIViewController] {
        let allVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "brownVC") as! BrownVC
        allVC.path = Network.pathAllPostUrl
        
        let helpVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "brownVC") as! BrownVC
        helpVC.path = Network.helpPostUrl
        
        let togetherVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "brownVC") as! BrownVC
        togetherVC.path = Network.togetherUrl
        
        let shareVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "brownVC") as! BrownVC
        shareVC.path = Network.shareUrl
        
        let lostVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "brownVC") as! BrownVC
        lostVC.path = Network.lostUrl
        
        return [allVC, helpVC, togetherVC, shareVC, lostVC]
    }
    @IBOutlet weak var naviCustomView: UIView!
    
    @IBOutlet weak var tabmanView: UIView!
    @IBOutlet weak var writeButton: TagButton!
    
    @IBOutlet weak var dormitoryButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setTapman()
        setTintAdjustmentModeForButtons(in: self.view)
        setObserver()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    private func setUI() {
        writeButton.configuration?.image = UIImage(named: "bulletinBoardPlus")
    }
    
    @objc func dormitoryChangeNotification(_ notification: Notification) {
        if notification.object is String {
            dormitoryButton.head1 = SelectedDormitory.shared.domitory
            dormitoryButton.setTitle(SelectedDormitory.shared.domitory, for: .normal)
            dormitoryButton.isUserInteractionEnabled = true
        }
    }
    
    private func setObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(dormitoryChangeNotification(_:)), name: .init("DormitoryChangeNotification"), object: nil)
    }
    
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
    
    
    
    private func setTapman() {
        self.dataSource = self
        // 바 세팅
        let bar = TMBar.ButtonBar()
        bar.backgroundView.style = .blur(style: .regular)
                bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0)
                bar.buttons.customize { (button) in
                    button.tintColor = .gray3 // 선택 안되어 있을 때
                    button.selectedTintColor = .primary // 선택 되어 있을 때
                    button.font = .body1!
                    button.selectedFont = .title5!
                }
        
        //인디케이터 세팅
        bar.indicator.weight = .light
        bar.indicator.tintColor = .primary
        bar.layout.alignment = .centerDistributed
               
        bar.layout.interButtonSpacing = 24 // 버튼 사이 간격
        bar.layout.transitionStyle = .progressive// Customize
        
        let item = TMBarItem(title: "dddddddd")
        item.title = "Item 1"
        item.badgeValue = "New"
        addBar(bar, dataSource: dataSource as! TMBarDataSource, at: .custom(view: tabmanView, layout: nil))
    }
    

    
    @IBAction func dormitoryButtonTapped(_ sender: UIButton) {
        presentSheet()
    }
    
    
}



extension BulletinBoardMainViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        //        let item = TMBarItem(title: "")
        //        item.title = "Page \(index)"
        //        item.image = UIImage(named: "image.png")
        //
        //        return item
        
        // MARK: - Tab 안 글씨들
        switch index {
        case 0:
            return TMBarItem(title: "전체")
        case 1:
            return TMBarItem(title: "도와주세요")
        case 2:
            return TMBarItem(title: "함께해요")
        case 3:
            return TMBarItem(title: "나눔해요")
        case 4:
            return TMBarItem(title: "분실신고")
        default:
            let title = "Page \(index)"
            return TMBarItem(title: title)
        }
        
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
}
