//
//  BrownVC.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/01/31.
//

import UIKit

class BrownVC: UIViewController {
    var articles: [Article] = []
    var path = ""
    @IBOutlet weak var collectionView: UICollectionView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        self.collectionView.register(UINib(nibName: "BulluetinBoardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        network(url: Network.url + path)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeDormiotry), name: .changeDormiotry, object: nil)
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
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    @objc private func changeDormiotry() {
            network(url: Network.url + path)
        self.collectionView.reloadData()
        }
    
}


extension BrownVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let articleElement = articles[indexPath.row]
        
        let id = articleElement.articleId
        
        let url = "http://43.202.254.127:8080/api/articles/\(id)"
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let articleDetailViewController = storyboard.instantiateViewController(withIdentifier: "detail") as? BulletinBoardDetailViewViewController { 
                articleDetailViewController.setUrl(url: url)
                articleDetailViewController.id = id
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
