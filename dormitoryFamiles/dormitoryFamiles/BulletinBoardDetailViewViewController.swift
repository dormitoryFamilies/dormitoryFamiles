//
//  BulletinBoardDetailViewViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/02/13.
//

import UIKit

class BulletinBoardDetailViewViewController: UIViewController {
    
    @IBOutlet weak var roundLine: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textViewSuperView: TagButton!
    @IBOutlet weak var commentTextView: UITextView!
    
    @IBOutlet weak var statusTag: RoundButton!
    @IBOutlet weak var categoryTag: RoundButton!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nickname: UILabel!
    
    @IBOutlet weak var dormitory: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var likeCountLabel: UILabel!
    
    @IBOutlet weak var replyCountLabel: UILabel!
    
    @IBOutlet weak var chatCountLabel: UILabel!
    
    var dataClass : DataClass?
    var id: Int = 0
    var collectionViewHeightConstraint = NSLayoutConstraint()
    var url = ""
    var activityIndicator = UIActivityIndicatorView(style: .large)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setIndicator()
        setDelegate()
        setCollectionViewAutoSizing()
        setTextView()
        collectionView.isScrollEnabled = false
        network(url: url)
        replyNetwork(id: id)
    }
    
    private func setIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
    }
    
    func setUrl(url: String) {
        self.url = url
    }
    
    @IBAction func replyPostButtonTapped(_ sender: UIButton) {
        let commentData = ["content": commentTextView.text]
        
        if let jsonData = try? JSONEncoder().encode(commentData) {
            let url = URL(string: Network.replyUrl(id: id))!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                } else if let data = data {
                    print("Response: \(response)")
                }
            }
            
            task.resume()
        }
    }
    
    private func network(url: String) {
        Network.getMethod(url: url) { (result: Result<DetailResponse, Error>) in
            switch result {
            case .success(let response):
                let response = response.data
                DispatchQueue.main.async { [self] in
                    self.titleLabel.title2 = response.title
                    self.nickname.title5 = response.nickName
                    self.profileImage.image = UIImage(named: response.profileUrl)
                    self.dormitory.title5 = response.memberDormitory
                    self.categoryTag.subTitle2 = response.boardType
                    //TODO: 태그 세팅도 해야함.
                    self.contentLabel.body1 = response.content
                    self.likeCountLabel.text = String(response.wishCount)
                    //TODO: isWIshed구현해야함
                    self.statusTag.subTitle2 = response.status
                    
                    let datetime = response.createdAt
                    self.timeLabel.body2 = changeToTime(createdAt: datetime)
                    self.dateLabel.body2 = changeToDate(createdAt: datetime)
                    
                    //TODO: 이미지url구현해야함
                    
                    self.collectionView.reloadData()
                    
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    private func replyNetwork(id: Int) {
        let commentUrl = Network.replyUrl(id: id)
        Network.getMethod(url: commentUrl) { [self] (result: Result<ReplyResponse, Error>) in
            switch result {
            case .success(let response):
                self.dataClass = response.data
                DispatchQueue.main.async { [self] in
                    self.replyCountLabel.text = String(dataClass!.totalCount)
                }
            case .failure(let error):
                
                print(error.localizedDescription)
            }
        }
    }
    
    
    private func changeToTime(createdAt datetime: String) -> String {
        let timeStartIndex = datetime.index(datetime.startIndex, offsetBy: 11)
        let timeEndIndex = datetime.index(datetime.startIndex, offsetBy: 16)
        let timeRange = timeStartIndex..<timeEndIndex
        let time = String(datetime[timeRange]).replacingOccurrences(of: "-", with: ":")
        return time
    }
    
    private func changeToDate(createdAt datetime: String) -> String {
        let dateStartIndex = datetime.index(datetime.startIndex, offsetBy: 5)
        let dateEndIndex = datetime.index(datetime.startIndex, offsetBy: 10)
        let dateRange = dateStartIndex..<dateEndIndex
        let date = String(datetime[dateRange]).replacingOccurrences(of: "-", with: "/")
        return date
    }
    
    private func setDelegate() {
        commentTextView?.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "ReplyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "rereplyCell")
        collectionView.register(UINib(nibName: "ReplyHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "replyCell")
    }
    
    private func setCollectionViewAutoSizing() {
        collectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: collectionView.contentSize.height)
        collectionViewHeightConstraint.isActive = true
    }
    
    deinit {
        collectionView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            collectionViewHeightConstraint.constant = collectionView.contentSize.height
        }
    }
    
    
    private func setTextView() {
        if commentTextView.text == "" {
            commentTextView.textColor = .gray4
            commentTextView.text = "댓글을 남겨주세요."
        }else {
            commentTextView.textColor = .black
        }
    }
    
    private func setCommentTextView() {
        commentTextView.font = .body2
        
        //텍스트뷰 사이즈에 맞게 늘리기
        commentTextView.isScrollEnabled = false
        commentTextView.sizeToFit()
    }
    
}


extension BulletinBoardDetailViewViewController: UITextViewDelegate {
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

extension BulletinBoardDetailViewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
           return dataClass?.comments.count ?? 0
       }

       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           guard let count = dataClass?.comments[section].replyComments?.count, count > 0 else {
               return 0
           }
           return count
       }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rereplyCell", for: indexPath) as! ReplyCollectionViewCell
        print(indexPath.section)
        let replyComment = dataClass?.comments[indexPath.section].replyComments?[indexPath.row]
        cell.nickname.text = replyComment?.nickname ?? ""
        cell.content.text = replyComment?.content ?? ""
        cell.replyCommentId = replyComment?.replyCommentId ?? 0
        cell.memberId = replyComment?.memberId ?? 0
        cell.profileUrl = replyComment?.profileUrl ?? ""
        cell.createdAt = replyComment?.createdAt ?? ""
        cell.isWriter = ((replyComment?.isWriter) != nil)
        return cell
    }
    
    //헤더뷰관련
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "replyCell", for: indexPath) as! ReplyHeaderCollectionReusableView
            
            let replyComment = dataClass?.comments[indexPath.section]
            
            headerView.commentId = replyComment?.commentId ?? 0
            headerView.memberId = replyComment?.memberId ?? 0
            headerView.profileUrl = replyComment?.profileUrl ?? ""
            headerView.nickname.text = replyComment?.nickname ?? ""
            let datetime = replyComment?.createdAt ?? ""
            headerView.timeLabel.body2 = changeToTime(createdAt: datetime)
            headerView.dateLabel.body2 = changeToDate(createdAt: datetime)
            headerView.content.text = replyComment?.content ?? ""
            headerView.isWriter = ((replyComment?.isWriter) != nil)
            headerView.isDeleted = ((replyComment?.isDeleted) != nil)
    
            
            return headerView
        default:
            assert(false, "Invalid element type")
        }
    }
    
}

extension BulletinBoardDetailViewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.bounds.width
        let height: CGFloat = 100
        
        return CGSize(width: width, height: height)
    }
    
    //셀과 셀 사이의 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
    
    //헤더 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 148)
    }
    
}
