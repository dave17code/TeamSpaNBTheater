//
//  MyPageVC.swift
//  TeamSpaNBTheater
//
//  Created by woonKim on 2024/01/15.
//

import UIKit

class MyPageVC: UIViewController {
    
    // 현재 로그인한 사용자 정보
    var user: UserInfo?
    
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userIdLabel.text = loadUserData().userInfo?.userId
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 예매 내역은 마이페이지에 진입할 때마다 테이블뷰에 업데이트
        user = loadUserData().userInfo
        tableView.reloadData()
    }
    
    func loadUserData() -> (userInfo: UserInfo?, reservations: [MovieReservation]?) {
        guard let userId = UserDefaults.standard.string(forKey: "loggedInUserId"),
              let data = UserDefaults.standard.data(forKey: "users") else {
            print("Error loading user information.")
            return (nil, nil)
        }
        
        do {
            var users = try JSONDecoder().decode([String: UserInfo].self, from: data)
            guard var userInfo = users[userId] else {
                print("Error loading user information.")
                return (nil, nil)
            }
            
            if !userInfo.movieReservations.isEmpty {
                for reservation in userInfo.movieReservations {
                    print("예매한 영화 : ", reservation.movieTitle)
                    print("예매 날짜 : ", reservation.reservationDate)
                    print("예매 시간 : ", reservation.reservationTime)
                    print("총 인원 : ", reservation.totalPeople)
                    print("총 가격 : ", reservation.price)
                }
            } else {
                print("예매 내역이 없습니다.")
            }
            
            return (userInfo, userInfo.movieReservations)
        } catch {
            print("Error decoding user data: \(error.localizedDescription)")
            return (nil, nil)
        }
    }
}

extension MyPageVC: UITableViewDelegate {
    
}

extension MyPageVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.user?.movieReservations.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageTableViewCell.identifier, for: indexPath) as? MyPageTableViewCell else {
            return UITableViewCell()
        }
        
        cell.bookMovieDate.text = self.user?.movieReservations[indexPath.row].reservationDate
        cell.bookMovieTitle.text = self.user?.movieReservations[indexPath.row].movieTitle
        cell.bookPepleCount.text = String("(\(self.user?.movieReservations[indexPath.row].totalPeople ?? 0))인")
        cell.bookMovieStartTime.text = self.user?.movieReservations[indexPath.row].reservationTime
        
        return cell
    }
}
