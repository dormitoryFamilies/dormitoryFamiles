import UIKit

class RoundButton: UIButton {
    
    var spacing: CGFloat = 4 {
        didSet {
            updateSpacing()
        }
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
        self.layer.cornerRadius = self.bounds.height / 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        self.layer.masksToBounds = true
        self.setTitleColor(.red, for: .normal)
        updateSpacing()
    }
    
    private func updateSpacing() {
        let insetAmount = spacing / 2
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView == self.titleLabel {
            return self
        }
        return hitView
    }
}

class TagButton: RoundButton {

    override func setNeedsLayout() {
        super.setNeedsLayout()
        self.layer.cornerRadius = min(self.bounds.height, 48) / 2
    }
    
    convenience init(title: String) {
        self.init()
        setUI(title: title)
    }
    
    private func setUI(title: String) {
        self.setTitle(title, for: .normal)
        self.layer.borderColor = UIColor.gray4?.cgColor
        self.layer.borderWidth = 1
        self.layer.masksToBounds = true
        self.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        self.setTitleColor(.gray4, for: .normal)
    }
    
    func changePinkColor() {
        self.backgroundColor = .primaryMid
    }

    func changeWhiteColor() {
        self.backgroundColor = .white
    }
    
    func changeTitleGray() {
        self.setTitleColor(.gray4, for: .normal)
    }
}
