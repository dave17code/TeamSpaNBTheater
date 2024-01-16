//
//  MovieDetailVC.swift
//  TeamSpaNBTheater
//

import UIKit

class MovieDetailVC: UIViewController {

    var selectedMovie: Movie?

    override func viewDidLoad() {
        super.viewDidLoad()

        // 예시로 선택된 영화의 제목을 출력하는 코드
        if let selectedMovie = selectedMovie {
            let titleLabel = UILabel()
            titleLabel.text = selectedMovie.title
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false

            view.addSubview(titleLabel)

            NSLayoutConstraint.activate([
                titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
    }
}
