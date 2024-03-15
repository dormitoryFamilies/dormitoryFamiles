//
//  BrownVC.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/01/31.
//

import UIKit

class SearchViewController: UIViewController {
    var articles: [Article] = []
    var path = ""
    
    @IBOutlet weak var noPostImageSettingView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        //검색 화면에 들어올때 검색 결과가 없다는 창은 아예 안보여야함.
        noPostImageSettingView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        self.collectionView.register(UINib(nibName: "BulluetinBoardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        network(url: Network.url + path)
        setSearchBar()
        
    }
    
    private func setSearchBar() {
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: width - 28, height: 40))
        searchBar.placeholder = "검색어를 입력해 주세요."
        if let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField {
            textFieldInsideSearchBar.leftView = nil
            textFieldInsideSearchBar.attributedPlaceholder = NSAttributedString(string: searchBar.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray3 as Any])
            textFieldInsideSearchBar.font = UIFont(name: "Pretendard Variable", size: 16)
        }
        searchBar.searchTextField.backgroundColor = .gray0
        searchBar.searchTextField.layer.cornerRadius = searchBar.bounds.height / 2
        searchBar.searchTextField.clipsToBounds = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
        searchBar.delegate = self
    }
    
    private func setDelegate() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    private func network(url: String) {
        Network.getMethod(url: url) { (result: Result<ArticleResponse, Error>) in
            switch result {
            case .success(let response):
                self.articles = response.data.articles
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    if self.articles.isEmpty {
                        print("검색 결과 없음")
                        self.noPostImageSettingView.isHidden = false
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BulluetinBoardCollectionViewCell
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor(red: 0.894, green: 0.898, blue: 0.906, alpha: 1).cgColor
        
        cell.layer.cornerRadius = 20
        
        
        let article = articles[indexPath.row]
        cell.title.text = article.title
        cell.nickName.text = article.nickName
        cell.viewCount.text = "조회" + String(article.viewCount)
        cell.commentCount.text = String(article.commentCount)
        cell.wishCount.text = String(article.wishCount)
        cell.content.text = article.content
        cell.categoryTag.body2 = article.boardType
        cell.statusTag.body2 = article.status
        if article.isWished {
        //TODO: 0311 예림씨 답장 오면 색이 있는 하트로 이미지 교체하기
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let articleElement = articles[indexPath.row]
        
        let id = articleElement.articleId
        
        let url = "http://43.202.254.127:8080/api/articles/\(id)"
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let articleDetailViewController = storyboard.instantiateViewController(withIdentifier: "detail") as? BulletinBoardDetailViewViewController {
                articleDetailViewController.setUrl(url: url)
                self.navigationController?.pushViewController(articleDetailViewController, animated: true)
            }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 335, height: 167)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    //검색이 완료되면 실행되는 메서드
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        noPostImageSettingView.isHidden = true
        if let searchText = searchBar.text {
            print("검색어: \(searchText)")
            network(url: Network.url+Network.searchUrl(searchText: searchText))
        }
    }
}
