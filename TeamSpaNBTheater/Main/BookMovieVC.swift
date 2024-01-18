//
//  BookMovieVC.swift
//  TeamSpaNBTheater
//
//  Created by woonKim on 2024/01/15.
//

import UIKit
import SnapKit
import Then
import SwiftUI

class BookMovieVC: UIViewController {
    // MARK: 화면 고정 레이블(변하지 않는 문구)
    let book = UILabel()               //“예매하기”
    let movieName = UILabel()          //“영화명”
    let date = UILabel()               //"날짜"
    let person = UILabel()             //"인원"
    let totalPrice = UILabel()         //"총 가격"
    
    // MARK: 화면 구성 레이블 및 요소
    var movieTitleLabel = UILabel()    //예매할 영화 제목 레이블
    var personLabel = UILabel()        //인원 수 변수 레이블(스테퍼 값)
    var totalPriceLabel = UILabel()    //총 가격 변수 레이블
    var personStepper = UIStepper()    //인원 수 조정 스테퍼
    var payButton = UIButton()         //결제 하기 버튼
    let datePicker = UIDatePicker()    //날짜선택 Picker
    
    // MARK: MovieDetailVC 에서 받아올 변수
    var movieTitle: String = ""        //예매할 영화 제목 변수
    var movieReleaseDate: String = ""  //예매할 영화 개봉일
    
    let sendDateFormatter = DateFormatter() //예매일 Dateformatter
    let sendTimeFormatter = DateFormatter() //예매시간 Dateformatter
    var sendDateString: String = ""         //예매일
    var sendTimeString: String = ""         //예매시간
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setupMainLayoutWithSnapKit()
        setupBookMovieDate()
    }
    
    private func setupBookMovieDate() {
        sendDateFormatter.dateFormat = "yyyy년 MM월 dd일"
        sendTimeFormatter.dateFormat = "HH시 mm분"
        
        sendDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        sendTimeFormatter.timeZone = TimeZone(abbreviation: "UTC")
        sendDateString = sendDateFormatter.string(from: datePicker.date)
        sendTimeString = sendTimeFormatter.string(from: datePicker.date)
    }
    
    private func setupMainLayoutWithSnapKit() {
        view.addSubview(movieTitleLabel)
        view.addSubview(book)
        view.addSubview(movieName)
        view.addSubview(date)
        view.addSubview(datePicker)
        view.addSubview(person)
        view.addSubview(personLabel)
        view.addSubview(personStepper)
        view.addSubview(totalPrice)
        view.addSubview(totalPriceLabel)
        view.addSubview(payButton)
        
        book.text = "예매하기"
        book.textColor = UIColor(hex: 0x6AA3FF)
        book.textAlignment = .left
        book.font = UIFont.boldSystemFont(ofSize: 30)
        book.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50) //위 여백
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-100)
            make.height.equalTo(40)
        }
        
        movieName.text = "영화명"
        movieName.textAlignment = .left
        movieName.font = UIFont.boldSystemFont(ofSize: 25)
        movieName.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(150) //위 여백
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-250)
            make.height.equalTo(40)
        }
        
        movieTitleLabel.text = movieTitle
        movieTitleLabel.textAlignment = .right
        movieTitleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        movieTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(150) //위 여백
            make.leading.equalToSuperview().offset(200)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(40)
        }
        
        date.text = "날짜"
        date.textAlignment = .left
        date.font = UIFont.boldSystemFont(ofSize: 25)
        date.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(250) //위 여백
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-250)
            make.height.equalTo(40)
        }
        
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let releaseDate = dateFormatter.date(from: movieReleaseDate) {
            // 개봉일로부터 1달 뒤까지의 날짜만 캘린더 활성화
            let availableBookDays = Calendar.current.date(byAdding: .month, value: 1, to: releaseDate)
            datePicker.date = releaseDate
            datePicker.timeZone = TimeZone(abbreviation: "UTC")
            datePicker.minimumDate = releaseDate
            datePicker.maximumDate = availableBookDays
            datePicker.preferredDatePickerStyle = .compact
            datePicker.minuteInterval = 30
            datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        }
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(250) //위 여백
            make.leading.equalToSuperview().offset(100)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(40)
        }
        
        person.text = "인원"
        person.textAlignment = .left
        person.font = UIFont.boldSystemFont(ofSize: 25)
        person.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(350) //위 여백
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-250)
            make.height.equalTo(40)
        }
        
        personLabel.text = "1"
        personLabel.textAlignment = .right
        personLabel.font = UIFont.boldSystemFont(ofSize: 25)
        personLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(350) //위 여백
            make.leading.equalToSuperview().offset(150)
            make.trailing.equalToSuperview().offset(-150)
            make.height.equalTo(40)
        }
        
        personStepper.value = 1
        personStepper.minimumValue = 1
        personStepper.maximumValue = 100
        personStepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
        personStepper.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(355) //위 여백
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(40)
        }
        
        totalPrice.text = "총 가격"
        totalPrice.textAlignment = .left
        totalPrice.font = UIFont.boldSystemFont(ofSize: 25)
        totalPrice.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(450) //위 여백
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-250)
            make.height.equalTo(40)
        }
        
        totalPriceLabel.text = "5000"+" 원"
        totalPriceLabel.textAlignment = .right
        totalPriceLabel.font = UIFont.boldSystemFont(ofSize: 25)
        totalPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(450) //위 여백
            make.leading.equalToSuperview().offset(150)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(40)
        }
        
        payButton.setTitle("결제 하기", for: .normal)
        payButton.setTitleColor(.white, for: .normal)
        payButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        payButton.backgroundColor = UIColor(hex: 0x6AA3FF)
        payButton.addTarget(self, action: #selector(payButtonTapped(_:)), for: .touchDown)
        payButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10) //아래 여백
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(50)
        }
    }
    //인원 수 조정 스테퍼 실행 함수
    @objc private func stepperValueChanged(_ sender: UIStepper) {
        // personStepper value -> personLabel 에 update
        personLabel.text = String(Int(sender.value))
        // totalPrice = stepperValue * 영화가격
        totalPriceLabel.text = String(Int(5000*Int(sender.value))) + " 원"
    }
    
    //결제하기 버튼 실행 함수
    @objc private func payButtonTapped(_ sender: UIButton) {
        print("예매한 영화 : ", movieTitle)
        print("예매 날짜 : ", sendDateString)
        print("예매 시간 : ", sendTimeString)
        print("총 인원 : ", Int(personStepper.value))
        print("총 가격 : ", Int(5000*Int(personStepper.value)))
        
        // ****************************여기서 Pypage로 값 전달하면 됨
        // ****************************여기서 Pypage로 값 전달하면 됨
        // ****************************여기서 Pypage로 값 전달하면 됨
        // ****************************여기서 Pypage로 값 전달하면 됨
        // ****************************여기서 Pypage로 값 전달하면 됨
    }
    
    // 캘린더를 통해 datePicker의 값이 변경될 때 호출되는 함수
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        setupBookMovieDate()
    }
}
