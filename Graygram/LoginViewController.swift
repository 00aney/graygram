//
//  LoginViewController.swift
//  Graygram
//
//  Created by aney on 2017. 3. 6..
//  Copyright © 2017년 Taedong Kim. All rights reserved.
//

import UIKit

import Alamofire

final class LoginViewController: UIViewController {
	
	// MARK: UI
	
	fileprivate let usernameTextField = UITextField()
	fileprivate let passwordTextField = UITextField()
	fileprivate let loginButton = UIButton()
	
	
	// MARK: View Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .white	//default .clear
		self.title = "Login"
		
		self.usernameTextField.borderStyle = .roundedRect
		self.usernameTextField.placeholder = "Username"
		self.usernameTextField.font = UIFont.systemFont(ofSize: 14)
		self.usernameTextField.autocorrectionType = .no
		self.usernameTextField.autocapitalizationType = .none
		self.usernameTextField.addTarget(
			self,
			action: #selector(textFieldDidEditingChanged),
			for: .editingChanged
		)
		
		self.passwordTextField.borderStyle = .roundedRect
		self.passwordTextField.placeholder = "Password"
		self.passwordTextField.font = UIFont.systemFont(ofSize: 14)
		self.passwordTextField.isSecureTextEntry = true
		self.passwordTextField.addTarget(
			self,
			action: #selector(textFieldDidEditingChanged),
			for: .editingChanged
		)
		
		self.loginButton.backgroundColor = self.loginButton.tintColor
		self.loginButton.layer.cornerRadius = 5
		self.loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
		self.loginButton.setTitle("Login", for: .normal)
		self.loginButton.addTarget(
			self,
			action: #selector(loginButtonDidTap),
			for: .touchUpInside
		)
		
		self.view.addSubview(self.usernameTextField)
		self.view.addSubview(self.passwordTextField)
		self.view.addSubview(self.loginButton)
		
		self.usernameTextField.snp.makeConstraints { make in
			make.left.equalTo(15)
			make.right.equalTo(-15)
			make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(15)	//statusbar + navigationbar
			make.height.equalTo(30)
		}
		
		self.passwordTextField.snp.makeConstraints { make in
//			make.left.equalTo(self.usernameTextField.snp.left)
			
//			make.left.equalTo(self.usernameTextField)
//			make.right.equalTo(self.usernameTextField)
//			make.height.equalTo(self.usernameTextField)
			
			make.left.right.height.equalTo(self.usernameTextField)
			make.top.equalTo(self.usernameTextField.snp.bottom).offset(15)
		}
		
		self.loginButton.snp.makeConstraints { make in
			make.left.right.equalTo(self.usernameTextField)
			make.height.equalTo(40)
			make.top.equalTo(self.passwordTextField.snp.bottom).offset(15)
		}
		
/*
		NSLayoutConstraint.activate([
			NSLayoutConstraint(
				item: self.usernameTextField,
				attribute: .left,
				relatedBy: .equal,
				toItem: self.view,
				attribute: .left,
				multiplier: 1,
				constant: 15
			)
		])
*/
		// SnapKit 오토레이아웃을 간편하게 할 수 있게 해준다.
		// extension 에 구현된 서드파티 라이브러리는 .. 임포트 안해줘도 접근 가능
		// 글로벌 정의되어있는 것들은 import해줘야한다.
		
		// extension 서드파티 라이브러리는 AppDelegate 에 import
	}

	// MARK: Actions
	
	func textFieldDidEditingChanged(_ textField: UITextField) {
		textField.textColor = .black
	}
	
	func loginButtonDidTap() {
		guard let username = self.usernameTextField.text, !username.isEmpty else {
			self.usernameTextField.becomeFirstResponder()
			return
		}
		guard let password = self.passwordTextField.text, !password.isEmpty else {
			self.passwordTextField.becomeFirstResponder()
			return
		}
		
		self.usernameTextField.isEnabled = false
		self.passwordTextField.isEnabled = false
		self.loginButton.isEnabled = false
		self.loginButton.alpha = 0.4
		
		let urlString = "https://api.graygram.com/login/username"
		let parameters: Parameters = [
			"username": username,
			"password": password,
		]
		let headers: HTTPHeaders = [
			"Accept": "application/json",		// default: text/html
		]
		Alamofire.request(urlString, method: .post, parameters: parameters, headers: headers)
			.validate(statusCode: 200..<400)
			.responseJSON { response in
				switch response.result {
				case .success(let value):
					print("로그인 성공! \(value)")
					AppDelegate.instance?.presentMainScreen()
					
				case .failure(let error):
					self.usernameTextField.isEnabled = true
					self.passwordTextField.isEnabled = true
					self.loginButton.isEnabled = true
					self.loginButton.alpha = 1
					
					if let data = response.data,
						let json = try? JSONSerialization.jsonObject(with: data), //	실패하면 nil 반환
						let dict = json as? [String: Any],
						let errorInfo = dict["error"] as? [String: Any] {
						
						let field = errorInfo["field"] as? String
						if field == "username" {
							self.usernameTextField.becomeFirstResponder()
							self.usernameTextField.textColor = .red
						} else if field == "password" {
							self.passwordTextField.becomeFirstResponder()
							self.passwordTextField.textColor = .red
						}
					}
					print("로그인 실패 ㅠㅠ \(error)")
					/*
						Optional({
							error =     {
								field = username;
								message = "User not registered";
							};
						})
					*/
				}
			}
	}

	//알라모파이어는 기본적으로 응답만 받으면 성공으로 인식하기 때문에 validate를 써줘야 한다.
}
