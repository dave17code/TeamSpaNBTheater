//
//  MovieDetailVC.swift
//  TeamSpaNBTheater
//
//  Created by woonKim on 2024/01/15.
//

import UIKit

class MovieDetailVC: UIViewController {
    
    private var movieData: Movie?
    
    let posterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor(hex: 0x6aa3ff)
        
        return label
    }()
    
    let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .darkGray
        
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        label.backgroundColor = .systemGray6
        
        return label
    }()
    
    let bookButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hex: 0x6aa3ff)
        button.setTitle("예매하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addSubviews()
        makeAutoLayout()
        setupInteraction()
    }
    
    private func setupInteraction() {
        bookButton.addTarget(self, action: #selector(bookMovieVC), for: .touchUpInside) //touchUpInside
    }
    
    @objc func bookMovieVC() {
        let goBookMovieVC = BookMovieVC()
        goBookMovieVC.movieTitle = self.movieData?.title ?? ""
        goBookMovieVC.movieReleaseDate = self.movieData?.releaseDate ?? ""
        goBookMovieVC.modalPresentationStyle = .automatic
        present(goBookMovieVC, animated: true, completion: nil)
    }
    
    private func addSubviews() {
        view.addSubview(posterImage)
        view.addSubview(titleLabel)
        view.addSubview(releaseDateLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(bookButton)
    }

    private func makeAutoLayout() {
        posterImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            posterImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            posterImage.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 70),
            posterImage.widthAnchor.constraint(equalToConstant: 300),
            posterImage.heightAnchor.constraint(equalToConstant: 320)
        ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50),
            titleLabel.topAnchor.constraint(equalTo: self.posterImage.bottomAnchor, constant: 8),
            titleLabel.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            releaseDateLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50),
            releaseDateLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 6)
        ])
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50),
            descriptionLabel.topAnchor.constraint(equalTo: self.releaseDateLabel.bottomAnchor, constant: 20),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 300),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 200),
        ])
        
        bookButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bookButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20),
            bookButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            bookButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
            bookButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func updateMovieData(_ movie: Movie) {
        self.movieData = movie
        
        self.titleLabel.text = self.movieData?.title ?? ""
        self.releaseDateLabel.text = self.movieData?.releaseDate ?? ""
        self.descriptionLabel.text = self.movieData?.overview ?? ""
    }
}
