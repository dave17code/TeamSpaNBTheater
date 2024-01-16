//
//  MovieListVC.swift
//  TeamSpaNBTheater
//

import UIKit

class MovieListVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    var tableView: UITableView!
    let sectionTitles = ["Popular Movies", "Now Playing","Top Rated Movies", "Upcoming Movies"]
    var upcomingMoviesData: [Movie] = []
    var topRatedMoviesData: [Movie] = []
    var popularMoviesData: [Movie] = []
    var nowPlayingMoviesData: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellIdentifier")
        view.addSubview(tableView)

        fetchMovieData(endpoint: "popular", section: 0)
        fetchMovieData(endpoint: "now_playing", section: 1)
        fetchMovieData(endpoint: "top_rated", section: 2)
        fetchMovieData(endpoint: "upcoming", section: 3)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)

        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }

        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: cell.contentView.bounds, collectionViewLayout: collectionViewLayout)
        collectionView.tag = indexPath.section
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionCellIdentifier\(collectionView.tag)")
        collectionView.backgroundColor = UIColor.white

        cell.contentView.addSubview(collectionView)

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(hex: 0x6aa3ff)

        let titleLabel = UILabel()
        titleLabel.text = sectionTitles[section]
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        titleLabel.textColor = UIColor.black

        headerView.addSubview(titleLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0: return popularMoviesData.count
        case 1: return nowPlayingMoviesData.count
        case 2: return topRatedMoviesData.count
        case 3: return upcomingMoviesData.count
        default: return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCellIdentifier\(collectionView.tag)", for: indexPath)

        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }

        let movie: Movie

        switch collectionView.tag {
        case 0: movie = popularMoviesData[indexPath.item]
        case 1: movie = nowPlayingMoviesData[indexPath.item]
        case 2: movie = topRatedMoviesData[indexPath.item]
        case 3: movie = upcomingMoviesData[indexPath.item]
        default: return cell
        }

        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: cell.contentView.bounds.width - 20, height: cell.contentView.bounds.height - 60))
        loadImage(for: movie, into: imageView)

        cell.contentView.addSubview(imageView)

        let titleLabel = UILabel(frame: CGRect(x: 0, y: cell.contentView.bounds.height - 40, width: cell.contentView.bounds.width, height: 30))
        titleLabel.text = movie.title
        titleLabel.textAlignment = .center
        cell.contentView.addSubview(titleLabel)
        cell.backgroundColor = UIColor.white

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.bounds.width - 10 * 2) / 2
        let cellHeight = collectionView.bounds.height
        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell selected at section \(collectionView.tag), item \(indexPath.item)")
        let selectedMovie: Movie

        switch collectionView.tag {
        case 0:
            selectedMovie = popularMoviesData[indexPath.item]
        case 1:
            selectedMovie = nowPlayingMoviesData[indexPath.item]
        case 2:
            selectedMovie = topRatedMoviesData[indexPath.item]
        case 3:
            selectedMovie = upcomingMoviesData[indexPath.item]
        default:
            return
        }

        // MovieDetailVC 인스턴스 생성
        if let movieDetailVC = storyboard?.instantiateViewController(withIdentifier: "MovieDetailVC") as? MovieDetailVC {
            // 선택된 영화 데이터 전달
            movieDetailVC.selectedMovie = selectedMovie

            // 내비게이션 스택이 있다면 푸시, 없다면 모달로 화면 전환
            if let navigationController = navigationController {
                // 내비게이션 스택이 있는 경우
                navigationController.pushViewController(movieDetailVC, animated: true)
            } else {
                // 내비게이션 스택이 없는 경우 (예: 모달로 표시)
                present(movieDetailVC, animated: true, completion: nil)
            }
        }
    }

    func loadImage(for movie: Movie, into imageView: UIImageView) {
        if let posterPath = movie.posterPath {
            let posterURL = "https://image.tmdb.org/t/p/w500\(posterPath)"
            if let url = URL(string: posterURL) {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil else {
                        print("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        imageView.image = image
                    }
                }.resume()
            }
        }
    }
}

class Movie {
    let title: String
    let posterPath: String?

    init(title: String, posterPath: String?) {
        self.title = title
        self.posterPath = posterPath
    }
}

extension MovieListVC {
    func fetchMovieData(endpoint: String, section: Int) {
        let apiKey = "a4da431c6791ead04a4fed52ad08e4fc"
        let urlString = "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)"

        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching movie data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print("JSON Data: \(json)")

                if let jsonArray = json as? [String: Any], let results = jsonArray["results"] as? [[String: Any]] {
                    let movies = self.parseMovieData(jsonArray: results)
                    DispatchQueue.main.async {
                        switch section {
                        case 0: self.popularMoviesData = movies
                        case 1: self.nowPlayingMoviesData = movies
                        case 2: self.topRatedMoviesData = movies
                        case 3: self.upcomingMoviesData = movies
                        default: break
                        }

                        self.tableView.reloadData()
                    }
                }
            } catch {
                print("Error parsing movie data: \(error.localizedDescription)")
            }
        }.resume()
    }

    func parseMovieData(jsonArray: [[String: Any]]) -> [Movie] {
        var movies: [Movie] = []

        for movieData in jsonArray {
            if let title = movieData["title"] as? String,
               let posterPath = movieData["poster_path"] as? String {
                let movie = Movie(title: title, posterPath: posterPath)
                movies.append(movie)
            }
        }

        return movies
    }
}

extension UIColor {
    convenience init?(hex: Int, alpha: CGFloat = 1.0) {
        guard hex >= 0 && hex <= 0xFFFFFF else {
            return nil
        }

        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
