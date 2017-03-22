//
//  SplashViewController.swift
//  Graygram
//
//  Created by aney on 2017. 3. 6..
//  Copyright © 2017년 Taedong Kim. All rights reserved.
//

import UIKit

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
    
    UserService.me() { response in
      switch response.result {
      case .success:
        AppDelegate.instance?.presentMainScreen()
        
      case .failure:
        AppDelegate.instance?.presentLoginScreen()
      }
    }		
  }
	
}
