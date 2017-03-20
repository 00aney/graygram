//
//  SplashViewController.swift
//  Graygram
//
//  Created by aney on 2017. 3. 6..
//  Copyright © 2017년 Taedong Kim. All rights reserved.
//

import UIKit
import Alamofire

final class SplashViewController: UIViewController {

	// MARK: Properties
	fileprivate let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.activityIndicatorView.startAnimating()
		self.view.addSubview(self.activityIndicatorView)
		self.activityIndicatorView.snp.makeConstraints { make in
			make.center.equalToSuperview()
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		
		/*
		1. `/me` API 호출
		2. 200인 경우 성공 (로그인이 되어있는 상태)
		3. 401인 경우 실패 (로그인이 되어있지 않은 상태)
		4. API 요청에 성공한(로그인 된) 경우 피드 화면
		5. API 요청에 실패한(로그인 되지 않은) 경우 로그인 화면
		*/
		let urlString = "https://api.graygram.com/me"
		Alamofire.request(urlString, method: .get)
			.validate(statusCode: 200..<400)
			.responseJSON { response in
				switch response.result {
				case .success:
					AppDelegate.instance?.presentMainScreen()
				case .failure:
					AppDelegate.instance?.presentLoginScreen()
				}
			}
			
	}
	
}
