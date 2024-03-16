//
//  registerPostViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/01/08.
//

import UIKit
import DropDown

class RegisterPostViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var categoryButton: UIButton!
    
    @IBOutlet weak var dormitoryButton: UIButton!
    
    
    @IBOutlet weak var dormitoryLabel: UILabel!
    
    @IBOutlet weak var bulletinBoardLabel: UILabel!
    
    @IBOutlet weak var countTextFieldTextLabel: UILabel!
    
    @IBOutlet weak var countTextViewTextLabel: UILabel!
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var finishButton: UIButton!
    
    
    let dropDown = DropDown()
    let textFieldMaxLength = 20
    let textViewMaxLength = 300
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setDropDown()
        setDelegate()
        [dormitoryLabel, bulletinBoardLabel, countTextFieldTextLabel, titleLabel, descriptionLabel].forEach{$0.asColor(targetString: ["*"], color: .primary!)}
    }
    
    private func setNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setDelegate() {
        textField.delegate = self
        textView.delegate = self
        self.navigationController?.navigationBar.delegate = self
    }
    
    private func setUI() {
        countTextViewTextLabel.textAlignment = .right
        countTextViewTextLabel.numberOfLines = 0 // 라인 수 제한을 해제
        countTextViewTextLabel.sizeToFit()

        
        //textViewPlaceHolder느낌
        textView.delegate = self
        if textView.text == "" {
            textView.textColor = .gray4
            textView.text = "내용을 입력해 주세요."
        }else {
            textView.textColor = .black
        }
    }
    
    private func setDropDown() {
        DropDown.startListeningToKeyboard()
        DropDown.appearance().setupCornerRadius(20)
        DropDown.appearance().backgroundColor = .white
        DropDown.appearance().cellHeight = 52
        DropDown.appearance().shadowOpacity = 0
        DropDown.appearance().selectionBackgroundColor = .gray0 ?? .white
        DropDown.appearance().textFont = UIFont(name: CustomFonts.defult.rawValue, size: 16)!
        dropDown.cancelAction = { [self] in
            [dormitoryButton, categoryButton].forEach{$0?.borderColor = .gray1}
        }
        
    }
    
    private func setTextField() {
        countTextFieldTextLabel.text = String(textField.text!.count) + "/20"
    }
    
    @IBAction func dropDownButtonTapped(_ sender: UIButton) {
        switch sender {
        case dormitoryButton:
            dropDown.dataSource = ["본관", "양성재","양진재", "양현재"]
        case categoryButton:
            dropDown.dataSource = ["도와주세요", "함께해요", "나눔해요", "분실신고"]
        default:
            dropDown.dataSource = []
        }
        
        //공통된 작업
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0, y:((dropDown.anchorView?.plainView.bounds.height)!-5))
        sender.borderColor = .primaryMid
        dropDown.show()
        dropDown.selectionAction = { (index: Int, item: String) in
            sender.setTitle(item, for: .normal)
            sender.borderColor = .gray1
        }
    }
    
    private func changeFinishButtonBackgroundColor() {
        if countTextViewTextLabel.text?.first == "0" || countTextFieldTextLabel.text?.first == "0" {
            finishButton.backgroundColor = .gray3
        }else{
            finishButton.backgroundColor = .primary
        }

    }
    
    @IBAction func finishButtonTapped(_ sender: UIButton) {
        //이미지 없다고 가정함 일단은.
        //TODO: 이미지와 태그는 UI세팅 후에 다시 처리해야함
        let post = Post(dormitoryType: dormitoryButton.title(for: .normal) ?? "", boardType: categoryButton.title(for: .normal) ?? "", title: textField.text ?? "" , content: textView.text ?? "", tags: "태그는 추후 구현!", imagesUrls: [])
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(post) {
            let url = URL(string: "http://43.202.254.127:8080/api/articles")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                } else if let data = data {
                    print("Response: \(response)")
                    let decoder = JSONDecoder()
                           if let response = try? decoder.decode(PostResponse.self, from: data) {
                               print("Article ID: \(response.data.articleId)")
                           }
                }
            }
            
            task.resume()
        }
    }
    
}

extension RegisterPostViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text ?? ""
        let addedText = string
        let newText = oldText + addedText
        let newTextLength = newText.count
        
        
        if newTextLength <= textFieldMaxLength {
            return true
        }

        let lastWordOfOldText = String(oldText[oldText.index(before: oldText.endIndex)])
        let separatedCharacters = lastWordOfOldText.decomposedStringWithCanonicalMapping.unicodeScalars.map{ String($0) }
        let separatedCharactersCount = separatedCharacters.count

        if separatedCharactersCount == 1 && !addedText.isConsonant {
            return true
        }

        if separatedCharactersCount == 2 && addedText.isConsonant {
            return true
        }

        if separatedCharactersCount == 3 && addedText.isConsonant {
            return true
        }

        return false
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        countTextFieldTextLabel.text = String(textField.text!.count) + "/" + String(textFieldMaxLength)
        let text = textField.text ?? ""
        if text.count > textFieldMaxLength {
            let startIndex = text.startIndex
            let endIndex = text.index(startIndex, offsetBy: textFieldMaxLength - 1)
            let fixedText = String(text[startIndex...endIndex])
            textField.text = fixedText
        }
        changeFinishButtonBackgroundColor()
    }
    
}

extension RegisterPostViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let oldText = textView.text ?? ""
        let addedText = text
        let newText = oldText + addedText
        let newTextLength = newText.count
        

        if newTextLength <= textViewMaxLength {
            return true
        }

        let lastWordOfOldText = String(oldText[oldText.index(before: oldText.endIndex)])
        let separatedCharacters = lastWordOfOldText.decomposedStringWithCanonicalMapping.unicodeScalars.map{ String($0) }
        let separatedCharactersCount = separatedCharacters.count

        if separatedCharactersCount == 1 && !addedText.isConsonant {
            return true
        }

        if separatedCharactersCount == 2 && addedText.isConsonant {
            return true
        }

        if separatedCharactersCount == 3 && addedText.isConsonant {
            return true
        }

        return false
    }

    func textViewDidChange(_ textView: UITextView) {
        countTextViewTextLabel.text = String(textView.text!.count) + "/" + String(textViewMaxLength)
        let text = textView.text ?? ""
        if text.count > textViewMaxLength {
            let startIndex = text.startIndex
            let endIndex = text.index(startIndex, offsetBy: textViewMaxLength - 1)
            let fixedText = String(text[startIndex...endIndex])
            textView.text = fixedText
        }
        changeFinishButtonBackgroundColor()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .gray4 {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.textColor = .gray4
            textView.text = "내용을 입력해 주세요."
        }
    }
}

extension RegisterPostViewController: UINavigationBarDelegate {
    func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
            let alert = UIAlertController(title: "확인", message: "진짜 뒤로 가시겠습니까?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "아니오", style: .cancel, handler: { _ in
            }))
            alert.addAction(UIAlertAction(title: "예", style: .default, handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }))
            present(alert, animated: true, completion: nil)
            return false
        }
}


extension String {
    var isConsonant: Bool {
        guard let scalar = UnicodeScalar(self)?.value else {
            return false
        }
        
        let consonantScalarRange: ClosedRange<UInt32> = 12593...12622
        
        return consonantScalarRange ~= scalar
    }
}
