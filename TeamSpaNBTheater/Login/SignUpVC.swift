//
//  SignUpVC.swift
//  TeamSpaNBTheater
//
//  Created by woonKim on 2024/01/15.
//

import UIKit

class SignUpVC: UIViewController {
    
    @IBOutlet weak var userIdTxField: UITextField!
    @IBOutlet weak var passwordTxField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpVC(_ sender: Any) {
        // 입력된 userId와 password를 가져와서 UserInfo 객체 생성
        guard let userId = userIdTxField.text, let password = passwordTxField.text else {
            showAlert(message: "입력된 정보가 올바르지 않습니다.")
            return
        }
        
        let userInfo = UserInfo(userId: userId, password: password)
        
        // UserDefaults에서 저장된 회원 정보를 가져옴
        var existingUsers = loadUsers()
        
        // 회원가입 처리
        existingUsers[userInfo.userId] = userInfo
        saveUsers(users: existingUsers)
        
        // 회원가입 완료 얼럿 창 표시
        showCompletionAlert(message: "회원가입이 완료되었습니다. userId: \(userInfo.userId)")
    }
    
    // UserDefaults에서 사용자 정보를 불러오는 함수
    private func loadUsers() -> [String: UserInfo] {
        if let data = UserDefaults.standard.data(forKey: "users") {
            do {
                let users = try JSONDecoder().decode([String: UserInfo].self, from: data)
                return users
            } catch {
                print("Error decoding user data: \(error.localizedDescription)")
            }
        }
        return [:]
    }
    
    // 사용자 정보를 UserDefaults에 저장하는 함수
    private func saveUsers(users: [String: UserInfo]) {
        do {
            let encodedData = try JSONEncoder().encode(users)
            UserDefaults.standard.set(encodedData, forKey: "users")
        } catch {
            print("Error encoding user data: \(error.localizedDescription)")
        }
    }
    
    // 경고창을 띄우는 함수
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(okAction)
        // 경고창을 현재 화면의 최상위 뷰 컨트롤러에 띄움
        present(alertController, animated: true, completion: nil)
    }
    
    private func showCompletionAlert(message: String) {
        let alertController = UIAlertController(title: "회원가입 완료", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
