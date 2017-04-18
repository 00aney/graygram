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
import URLNavigator
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
  var destination: URL?

	class var instance: AppDelegate? {
		return UIApplication.shared.delegate as? AppDelegate
	}

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    Fabric.with([Crashlytics.self])
//    Crashlytics.sharedInstance().crash()
		
    URLNavigationMap.initialize()
    
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
    
    if let url = launchOptions?[.url] as? URL {
//      Navigator.present(url, wrap: true)
      self.destination = url
    }
    
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
//    tabBarController.viewControllers = [navigationController]
		self.window?.rootViewController = tabBarController
    
    if let destination = self.destination {
      Navigator.present(destination, wrap: true)
    }
	}
  
  /* 커스텀 스킴 처리해야할 곳 : 1. 앱딜리게이트 didFinishLaunchingWithOptions , 2. */
  // launchOptions 에서는 딕셔러니가 들어오는데, [UIApplicationLaunchOptionsKey: Any]가 들어있다.
  // UIApplicationLaunchOptionsKey 의 키는 url, sourceApplication, remoteNotification 등이 있다.
  // didFinishLaunchingWithOptions이건 앱이 꺼진후 켜질때 실행되는 메소드
  // 백그라운드에 있을때는 UIApplicationOpenURLOptionsKey 메소드 호출
  // 즉, didFinishLaunchingWithOptions과 UIApplicationOpenURLOptionsKey 에 처리해줘야 한다.
  func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplicationOpenURLOptionsKey : Any] = [:]
    ) -> Bool {
    // 앱이 백그라운드에 있다가 URL을 통해 foreground로 전환된 경우
    if Navigator.present(url, wrap: true) != nil { // wrap:true -> 네비게이션 바 나옴.
      return true
    }
    return false
  }
}
