//
//  CollectionViewCell.swift
//  TeamSpaNBTheater
//
//  Created by woonKim on 2024/01/17.
//

import UIKit
import Kingfisher

class MovieSearchCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    
    func configure(with imagePath: String) {
        // Kingfisher를 사용하여 이미지 로드 및 표시
        let urlString = "https://image.tmdb.org/t/p/w500" + imagePath
        
        // 이미지 콘텐츠 모드를 ScaleAspectFill로 설정
        moviePoster.contentMode = .scaleAspectFill
        moviePoster.clipsToBounds = true
        
        if let url = URL(string: urlString) {
            moviePoster.kf.setImage(with: url)
        }
    }
}
