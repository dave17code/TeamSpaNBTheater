//
//  ViewController.swift
//  TeamSpaNBTheater
//
import UIKit

class MovieListVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // 테이블뷰 선언
    var tableView: UITableView!

    // 섹션 타이틀 배열
    let sectionTitles = ["Popular", "Now playing", "Upcoming"]

    // 각 섹션의 데이터 배열
    var popularMovies: [String] = ["Movie1", "Movie2", "Movie3", "Movie4", "Movie5"]
    var nowPlayingMovies: [String] = ["MovieA", "MovieB", "MovieC", "MovieD", "MovieE"]
    var upcomingMovies: [String] = ["MovieX", "MovieY", "MovieZ", "MovieW", "MovieV"]

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
    }

    // MARK: UITableViewDataSource and UITableViewDelegate

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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
        collectionView.tag = indexPath.section // 셀의 섹션을 태그로 설정
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionCellIdentifier\(collectionView.tag)")
        collectionView.backgroundColor = UIColor.yellow

        // 각 셀에 콜렉션뷰 추가
        cell.contentView.addSubview(collectionView)

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.systemTeal

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
        case 0: // Popular 섹션의 콜렉션뷰
            return popularMovies.count
        case 1: // Now playing 섹션의 콜렉션뷰
            return nowPlayingMovies.count
        case 2: // Upcoming 섹션의 콜렉션뷰
            return upcomingMovies.count
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
        let label = UILabel(frame: cell.contentView.bounds)
        label.text = ""

        switch collectionView.tag {
        case 0: // Popular 섹션의 콜렉션뷰
            label.text = popularMovies[indexPath.item]
        case 1: // Now playing 섹션의 콜렉션뷰
            label.text = nowPlayingMovies[indexPath.item]
        case 2: // Upcoming 섹션의 콜렉션뷰
            label.text = upcomingMovies[indexPath.item]
        default:
            break
        }

        label.textAlignment = .center
        cell.contentView.addSubview(label)

        // 셀의 배경색을 노란색으로 변경
        cell.backgroundColor = UIColor.yellow

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
        let cellWidth = collectionView.bounds.width
        let cellHeight = collectionView.bounds.height
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
