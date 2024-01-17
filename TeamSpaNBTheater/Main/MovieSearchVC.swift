//
//  MovieSearchVC.swift
//  TeamSpaNBTheater
//
//  Created by woonKim on 2024/01/15.
//

import UIKit
import SwiftyJSON

class MovieSearchVC: UIViewController {
    
    // 전역 변수로 MovieData 초기화
    var movieSearchData: [String: String] = [:]
    var originalMovieData: [String: String] = [:]
    var filteredMovieData: [String: String] = [:]
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var movieSearchTxField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = createLayout()
        fetchDataNowPlaying()
        collectionView.reloadData()
    }
    
    @IBAction func movieSearchTxField(_ sender: Any) {
        // 현재 텍스트 필드의 텍스트에 새로 입력된 문자열 추가
        let currentText = movieSearchTxField.text ?? ""
        
        if currentText.isEmpty {
            // 입력 텍스트가 0일 때, 원본 데이터로 복원
            movieSearchData = originalMovieData
        } else {
            // 사용자가 입력한 문자열을 기준으로 필터링
            let filteredMovies = originalMovieData.filter {
                $0.value.lowercased().contains(currentText.lowercased())
            }
            // 필터링된 결과로 데이터 갱신
            movieSearchData = filteredMovies
        }
        
        // 메인 스레드에서 컬렉션 뷰 리로드
        DispatchQueue.main.async {
            self.collectionView.reloadData()
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
    
    func fetchDataNowPlaying() {
        // 페이지가 1부터 49까지의 데이터를 가져옴
        for page in 1...49 {
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

            // 비동기적으로 데이터 가져오기
            URLSession.shared.dataTask(with: request) { data, response, error in
                // 에러 처리
                if let data = data {
                    let json = try! JSON(data: data)
                    let results = json["results"].arrayValue
                    
                    for result in results {
                        let backdropPath = result["backdrop_path"].stringValue
                        let title = result["title"].stringValue
                        
                        // 딕셔너리에 값을 추가하기 전에 비어있는지 확인
                        if !backdropPath.isEmpty && !title.isEmpty {
                            self.movieSearchData[backdropPath] = title
                            self.originalMovieData[backdropPath] = title
                        }
                    }
                    
                    // 추가된 데이터 확인
                    print("Updated Movie Data: \(self.movieSearchData)")
                }
            }.resume()
        }
    }
}

extension MovieSearchVC: UICollectionViewDelegate {
    
}

extension MovieSearchVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movieSearchData.keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieSearchCollectionViewCell
        
        // ImageCell에 데이터 전달하여 설정
        let keyAtIndex = Array(movieSearchData.keys)[indexPath.item]
        let title = movieSearchData[keyAtIndex] ?? ""
        cell.configure(with: keyAtIndex) // assuming backdropPath is the key
        cell.movieTitle.text = title
        
        return cell
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Array {
    func safeIndex(_ index: Int) -> Element? {
        return self[safe: index]
    }
}
