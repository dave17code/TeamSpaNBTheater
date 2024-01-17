//
//  MovieSearchVC.swift
//  TeamSpaNBTheater
//
//  Created by woonKim on 2024/01/15.
//

import UIKit
import SwiftyJSON

class MovieSearchVC: UIViewController {
    
    // "backdrop_path"와 "title"을 저장할 배열
    var backdropPaths: [String] = []
    var titles: [String] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = createLayout()
        
        // 페이지 1부터 20까지의 데이터를 가져오기
        for page in 1...30 {
            fetchDataFromServer(page: page)
        }
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        
        // item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 1, bottom: 5, trailing: 1)
        
        // Group
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.42)), subitem: item, count: 3)
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        // return
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func fetchDataFromServer(page: Int) {
        let urlString = "https://api.themoviedb.org/3/movie/now_playing?language=en-US&page=\(page)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        
        // API 키를 헤더에 추가
        let apiKey = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiNzljOWRkNWQzZmU2OTMxNTA0ZjliY2RlZTkzYThiMSIsInN1YiI6IjY1YTVlNzlmOWJjZDBmMDEyM2JhNTNkYSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.eaOrevC0Rkl_lpQBPFhiF8IgLhhgaq1oa1bxc0Jongs"
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            // SwiftyJSON을 사용하여 데이터 파싱
            guard let json = try? JSON(data: data) else { return }
            self.parseJSON(json)
            
        }.resume()
    }
    
    func parseJSON(_ json: JSON) {

        // SwiftyJSON을 사용하여 데이터 추출
        if let results = json["results"].array {
            for result in results {
                if let backdropPath = result["backdrop_path"].string {
                    self.backdropPaths.append(backdropPath)
                }
                if let title = result["title"].string {
                    self.titles.append(title)
                }
            }
        }
        
        // 배열에 저장된 데이터 출력
        print("백드롭 경로 배열: \(self.backdropPaths)")
        print("제목 배열: \(self.titles)")
    }
}

extension MovieSearchVC: UICollectionViewDelegate {
    
}

extension MovieSearchVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieSearchCollectionViewCell
        
        // ImageCell에 데이터 전달하여 설정
        let imagePath = backdropPaths[indexPath.item]
        cell.configure(with: imagePath)
        cell.movieTitle.text = self.titles[indexPath.row]
        
        return cell
    }
}
