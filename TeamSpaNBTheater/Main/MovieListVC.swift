//
//  ViewController.swift
//  TeamSpaNBTheater
//
import UIKit

class MovieListVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // 테이블뷰 선언
    var tableView: UITableView!

    // 섹션 타이틀 배열
    let sectionTitles = ["Upcoming Movies", "Top Rated Movies", "Popular Movies"]

    // 각 섹션의 데이터 배열
    var upcomingMoviesData: [Movie] = []
    var topRatedMoviesData: [Movie] = []
    var popularMoviesData: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // 테이블뷰 초기화
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self

        // 테이블뷰 셀 등록
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellIdentifier")

        // ViewController에 테이블뷰 추가
        view.addSubview(tableView)

        // API에서 영화 데이터 가져오기
        fetchMovieData(endpoint: "upcoming", section: 0)
        fetchMovieData(endpoint: "top_rated", section: 1)
        fetchMovieData(endpoint: "popular", section: 2)
    }

    // MARK: UITableViewDataSource and UITableViewDelegate

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

        // 기존 셀 내용 삭제
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }

        // 각 셀에 콜렉션뷰 추가
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

    // MARK: UICollectionViewDataSource and UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0: // Upcoming Movies
            return upcomingMoviesData.count
        case 1: // Top Rated Movies
            return topRatedMoviesData.count
        case 2: // Popular Movies
            return popularMoviesData.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCellIdentifier\(collectionView.tag)", for: indexPath)

        // 기존 서브뷰들을 모두 제거
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }

        // 각 셀에 표시할 내용 추가
        let movie: Movie

        switch collectionView.tag {
        case 0: // Upcoming Movies
            movie = upcomingMoviesData[indexPath.item]
        case 1: // Top Rated Movies
            movie = topRatedMoviesData[indexPath.item]
        case 2: // Popular Movies
            movie = popularMoviesData[indexPath.item]
        default:
            return cell
        }

        // 영화 포스터 이미지 표시
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: cell.contentView.bounds.width - 20, height: cell.contentView.bounds.height - 60))
        loadImage(for: movie, into: imageView)

        cell.contentView.addSubview(imageView)

        // 영화 제목 표시
        let titleLabel = UILabel(frame: CGRect(x: 0, y: cell.contentView.bounds.height - 40, width: cell.contentView.bounds.width, height: 30))
        titleLabel.text = movie.title
        titleLabel.textAlignment = .center
        cell.contentView.addSubview(titleLabel)
        cell.backgroundColor = UIColor.white

        return cell
    }

    // UICollectionViewDelegateFlowLayout의 메서드들을 올바른 위치로 이동
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // 셀과 셀 사이의 수직 간격
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // 셀과 셀 사이의 수평 간격
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.bounds.width - 10 * 2) / 2
        let cellHeight = collectionView.bounds.height
        return CGSize(width: cellWidth, height: cellHeight)
    }

    // 이미지 비동기 로딩
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

// 영화 정보를 담는 모델 클래스
class Movie {
    let title: String
    let posterPath: String?

    init(title: String, posterPath: String?) {
        self.title = title
        self.posterPath = posterPath
    }
}

// API로부터 영화 데이터를 가져오는 함수
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
                        // Update the appropriate section of the collection view with the fetched data
                        switch section {
                        case 0:
                            self.upcomingMoviesData = movies
                        case 1:
                            self.topRatedMoviesData = movies
                        case 2:
                            self.popularMoviesData = movies
                        default:
                            break
                        }

                        self.tableView.reloadData()
                    }
                }
            } catch {
                print("Error parsing movie data: \(error.localizedDescription)")
            }
        }.resume()
    }

    // JSON 데이터를 파싱하여 Movie 객체 배열로 변환하는 함수
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
