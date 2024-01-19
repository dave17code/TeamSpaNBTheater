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

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 예매 내역 동적으로 가져와서 출력
        loadUserData()
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
