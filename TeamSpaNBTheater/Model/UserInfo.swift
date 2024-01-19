//
//  UserInfo.swift
//  TeamSpaNBTheater
//
//  Created by 윤규호 on 1/19/24.
//

class UserInfo: Codable {
    var userId: String
    var password: String
    var movieReservations: [MovieReservation] // 여러 개의 예약 내역을 나타내는 배열
    init(userId: String, password: String, movieReservations: [MovieReservation] = []) {
        self.userId = userId
        self.password = password
        self.movieReservations = movieReservations
    }
}
class MovieReservation: Codable {
    var movieTitle: String
    var releaseDate: String
    var reservationDate: String
    var reservationTime: String
    var totalPeople: Int
    var price: Double
    init(movieTitle: String, releaseDate: String, reservationDate: String, reservationTime: String, totalPeople: Int, price: Double) {
        self.movieTitle = movieTitle
        self.releaseDate = releaseDate
        self.reservationDate = reservationDate
        self.reservationTime = reservationTime
        self.totalPeople = totalPeople
        self.price = price
    }
}
