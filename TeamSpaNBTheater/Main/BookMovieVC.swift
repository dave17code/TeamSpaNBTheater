//
//  BookMovieVC.swift
//  TeamSpaNBTheater
//
//  Created by woonKim on 2024/01/15.
//

import UIKit
import SwiftUI
import SnapKit
import Then

class BookMovieVC: UIViewController {
    
    var book = UILabel()            //"예매하기"
    var movieName = UILabel()       //"영화명"
    var date = UILabel()
    var person = UILabel()
    var totalPrice = UILabel()
    
    var movieTitleLabel = UILabel() //예매할 영화 제목 레이블
    var personLabel = UILabel()     //인원 수 변수 레이블(스테퍼 값)
    var totalPriceLabel = UILabel() //총 가격 변수 레이블
    
    var personStepper = UIStepper() //인원 수 조정 스테퍼
    var payButton = UIButton()      //결제 하기 버튼
    
    let datePicker = UIDatePicker() //날짜선택 Picker
    let releaseDate = Date()        //영화 개봉일을 담을 변수. 현재: Date() -> 오늘 날짜.
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupMainLayoutWithSnapKit()
        
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
        
        // MovieDetailVC 에서 제목 값 입력 받을 것
        movieTitleLabel.text = "블랙 위도우"
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
        
        let availableBookDays = Calendar.current.date(byAdding: .month, value: 1, to: releaseDate)
        datePicker.minimumDate = releaseDate
        datePicker.maximumDate = availableBookDays
        datePicker.preferredDatePickerStyle = .compact
        datePicker.minuteInterval = 30
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
        payButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10) //아래 여백
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(50)
        }
    }
    
    @objc private func stepperValueChanged(_ sender: UIStepper) {
        // personStepper value -> personLabel 에 update
        personLabel.text = String(Int(sender.value))
        
        // totalPrice = stepperValue * 영화가격
        totalPriceLabel.text = String(Int(5000*Int(sender.value)))+" 원"
    }
}

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255.0,
            green: CGFloat((hex >> 8) & 0xFF) / 255.0,
            blue: CGFloat(hex & 0xFF) / 255.0,
            alpha: alpha
        )
    }
}

struct PreView: PreviewProvider {
  static var previews: some View {
    BookMovieVC().toPreview()
  }
}
extension UIViewController {
  private struct Preview: UIViewControllerRepresentable {
      let viewController: UIViewController
      func makeUIViewController(context: Context) -> UIViewController {
        return viewController
      }
      func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
      }
    }
    func toPreview() -> some View {
      Preview(viewController: self)
    }
}
