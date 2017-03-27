//
//  MainTabBarController.swift
//  Graygram
//
//  Created by aney on 2017. 3. 8..
//  Copyright © 2017년 Taedong Kim. All rights reserved.
//

import UIKit

final class MainTabBarController: UITabBarController {
  
  let feedViewController = FeedViewController()
  let settingsViewController = SettingsViewController()
  
  /// 탭바에 업로드 버튼 영역을 만들기 위한 가짜 뷰 컨트롤러
  let fakeViewController = UIViewController()
  
  init() {
    super.init(nibName: nil, bundle: nil)
    self.delegate = self
    self.fakeViewController.tabBarItem.image = UIImage(named: "tab-upload")
    self.fakeViewController.tabBarItem.imageInsets.top = 5
    self.fakeViewController.tabBarItem.imageInsets.bottom = -5
    
    self.viewControllers = [
      UINavigationController(rootViewController: self.feedViewController),
      UINavigationController(rootViewController: self.settingsViewController),
      self.fakeViewController,
    ]
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func presentImagePickerController() {
    let imagePickerController = UIImagePickerController()
    imagePickerController.delegate = self
    self.present(imagePickerController, animated: true, completion: nil)
  }
  
}


// MARK: - UITabBarControllerDelegate

extension MainTabBarController: UITabBarControllerDelegate {
  
  func tabBarController(
    _ tabBarController: UITabBarController,
    shouldSelect viewController: UIViewController
  ) -> Bool {
    // AnyObject 는 레퍼런스 타입으로 === 사용가능, Any는 반대
    if viewController === self.fakeViewController {
      self.presentImagePickerController()
      return false
    }
    return true
  }
  
}


// MARK: - UIImagePickerControllerDelegate
// UIImagePickerController 는 딜리게이스 두개 따라야 함. 아래 두개
extension MainTabBarController: UIImagePickerControllerDelegate {
  
  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [String : Any]
  ) {
    guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
    guard let grayscaledImage = selectedImage.grayscaled() else { return }
    
    let cropViewController = CropViewController(image: grayscaledImage)
    cropViewController.didFinishCropping = { [weak cropViewController] croppedImage in
      let postEditorViewController = PostEditorViewController(image: croppedImage)
      
      cropViewController?.navigationController?.pushViewController(postEditorViewController, animated: true)
    }
    
    picker.pushViewController(cropViewController, animated: true)
  }
  
}

extension MainTabBarController: UINavigationControllerDelegate {
  
}
