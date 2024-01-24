//
//  LogInVC.swift
//  TeamSpaNBTheater
//
//  Created by woonKim on 2024/01/15.
//

import UIKit

class LogInVC: UIViewController {
    
    @IBOutlet weak var userIdTxField: UITextField!
    @IBOutlet weak var passwordTxField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTxField.isSecureTextEntry = true
    }
    
    @IBAction func userIdTxField(_ sender: Any) {
    }
    
    @IBAction func passwordTxField(_ sender: Any) {
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        
        // UserDefaults에서 저장된 회원 정보를 가져옴
        let existingUsers = loadUsers()
        
        // 입력된 userId와 password를 가져와서 직접 사용
        let userId = userIdTxField.text
        let password = passwordTxField.text
        
        // userId와 password가 일치하는지 확인
        if let storedUserInfo = existingUsers[userId ?? ""] {
            // 입력된 비밀번호와 저장된 비밀번호가 일치하는 경우
            if storedUserInfo.password == password {
                
                // 로그인 성공 후 사용자의 아이디를 UserDefaults에 저장
                loginSuccess(userId: userId ?? "")
                
                // Main 스토리보드를 로드
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)

                // 탭바 컨트롤러 인스턴스 생성
                guard let tabBarController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarController") as? UITabBarController else {
                    // 인스턴스 생성에 실패하면 중단
                    return
                }
                
                // MovieListVC에 사용자 정보 전달
                if let movieListVC = tabBarController.viewControllers?.first as? MovieListVC {
                    movieListVC.loggedInUserInfo = storedUserInfo
                }

                // 현재의 뷰 컨트롤러를 탭바 컨트롤러로 모달 풀스크린 전환
                tabBarController.modalPresentationStyle = .fullScreen
                self.present(tabBarController, animated: true, completion: nil)
            } else {
                // 비밀번호 불일치
                showAlert(message: "로그인 실패. 올바른 비밀번호를 입력해주세요.")
            }
        } else {
            // 사용자 정보가 없는 경우
            showAlert(message: "로그인 실패. 올바른 userId를 입력해주세요.")
        }
    }
    
    // 경고창을 띄우는 함수
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(okAction)
        // 경고창을 현재 화면의 최상위 뷰 컨트롤러에 띄움
        present(alertController, animated: true, completion: nil)
    }
    
    // UserDefaults에서 사용자 정보를 불러오는 함수
    func loadUsers() -> [String: UserInfo] {
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
    
    // 로그인 성공 시에 호출되는 함수
    func loginSuccess(userId: String) {
        // UserDefaults에 loggedInUserId 키로 사용자의 아이디 저장
        UserDefaults.standard.set(userId, forKey: "loggedInUserId")
    }
}
