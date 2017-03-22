//
//  AppDelegate.swift
//  Graygram
//
//  Created by aney on 2017. 2. 22..
//  Copyright © 2017년 Taedong Kim. All rights reserved.
//

import UIKit

import Kingfisher
import SnapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	class var instance: AppDelegate? {
		return UIApplication.shared.delegate as? AppDelegate
	}

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
    //apperance()는 어떤 뷰 클래스에서 모든 애플리케이션 내에서 사용되는 공통의 특성을 설정
    UINavigationBar.appearance().tintColor = .black
    UIBarButtonItem.appearance().tintColor = .black
    UITabBar.appearance().tintColor = .black
    
    //UIWindow는 실행될 때 무조건 뷰 하나를 가지고 있어야한다.
		let window = UIWindow(frame: UIScreen.main.bounds)
		window.backgroundColor = .white
		window.makeKeyAndVisible()
		
//		let viewController = LoginViewController()
//		let navigationController = UINavigationController(rootViewController: viewController)
//		window.rootViewController = navigationController
		
		let splashViewController = SplashViewController()
		window.rootViewController = splashViewController
		
		self.window = window
		return true
	}

	func presentLoginScreen() {
		let loginViewController = LoginViewController()
		let navigationController = UINavigationController(rootViewController: loginViewController)
		self.window?.rootViewController = navigationController
	}
	
	func presentMainScreen() {
//		let feedViewController = FeedViewController()
//		let navigationController = UINavigationController(rootViewController: feedViewController)
    
    let tabBarController = MainTabBarController()
////    tabBarController
//    tabBarController.viewControllers = [navigationController]
		self.window?.rootViewController = tabBarController
	}
	
}
