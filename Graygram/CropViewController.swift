//
//  CropViewController.swift
//  Graygram
//
//  Created by aney on 2017. 3. 13..
//  Copyright © 2017년 Taedong Kim. All rights reserved.
//

import UIKit

final class CropViewController: UIViewController {
  
  // MARK: Properties
  
  var didFinishCropping:  ((UIImage) -> Void)?
  
  fileprivate let scrollView = UIScrollView()
  fileprivate let imageView = UIImageView()
  
  /// 이미지가 크롭될 정사각형 영역을 가이드해주는 뷰
  fileprivate let cropAreaView = UIView()
  fileprivate let cropAreaTopCoverView = UIView()
  fileprivate let cropAreaBottomCoverView = UIView()
  
  
  init(image: UIImage) {
    super.init(nibName: nil, bundle: nil)
    self.imageView.image = image
    self.automaticallyAdjustsScrollViewInsets = false
    //scrollView 가 첫 자식 뷰일 때 inset을 잡아준다. 그거를 해제하기 위한 처리
    
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .cancel,
      target: self,
      action: #selector(cancelButtonDidTap)
    )
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .done,
      target: self,
      action: #selector(doneButtonDidTap)
    )
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.scrollView.delegate = self
    self.scrollView.showsVerticalScrollIndicator = false
    self.scrollView.showsHorizontalScrollIndicator = false
    self.scrollView.maximumZoomScale = 3  // 최대 3배까지 줌 가능하게 설정
    
    // Core Animation
    self.cropAreaView.layer.borderColor = UIColor.lightGray.cgColor
    self.cropAreaView.layer.borderWidth = 1 / UIScreen.main.scale
    // 항상 물리 픽셀이 1픽셀이 그려지도록 처리
    // 0.5 -> @2x = 1
    // 0.3333.. -> @3x = 1
    self.cropAreaView.isUserInteractionEnabled = false
    // 스크롤 뷰보다 나중에 addSubview해줬기 때문에 이벤트를 크롭영역 뷰가 먹는다.
    // 그래서 해당 뷰의 이벤트를 막는 삽입 삽입
    
    self.cropAreaTopCoverView.backgroundColor = .white
    self.cropAreaTopCoverView.alpha = 0.9
    self.cropAreaTopCoverView.isUserInteractionEnabled = false
    self.cropAreaBottomCoverView.backgroundColor = .white
    self.cropAreaBottomCoverView.alpha = 0.9
    self.cropAreaBottomCoverView.isUserInteractionEnabled = false
    
    self.scrollView.alwaysBounceVertical = true
    self.scrollView.alwaysBounceHorizontal = true
    
    self.view.addSubview(self.scrollView)
    self.scrollView.addSubview(self.imageView)
    self.view.addSubview(self.cropAreaView)
    self.view.addSubview(self.cropAreaTopCoverView)
    self.view.addSubview(self.cropAreaBottomCoverView)
    
    self.scrollView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    self.cropAreaView.snp.makeConstraints { make in
      make.width.equalToSuperview()
      make.height.equalTo(self.cropAreaView.snp.width)
      make.centerY.equalToSuperview()
    }
    
    self.cropAreaTopCoverView.snp.makeConstraints { make in
      make.width.equalToSuperview()
      make.top.equalToSuperview()
      make.bottom.equalTo(self.cropAreaView.snp.top)
    }
    
    self.cropAreaBottomCoverView.snp.makeConstraints { make in
      make.top.equalTo(self.cropAreaView.snp.bottom)
      make.width.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.initializeImageViewFrameIfNeeded()
    self.scrollView.contentInset.top = self.scrollView.height / 2 - self.cropAreaView.height / 2
    self.scrollView.contentInset.bottom = self.scrollView.contentInset.top
    self.scrollView.contentSize = self.imageView.size
    self.scrollView.contentOffset.x = self.scrollView.contentSize.width / 2 - self.scrollView.width / 2
    self.scrollView.contentOffset.y = self.scrollView.contentSize.height / 2 - self.scrollView.height / 2
  }

  // IfNeeded 는 바로 실행되는게 아니라, 특정 조건 만족시 실행되는 메서드라는 네이밍 컨벤션
  // ex)
  // self.view.layoutSubviews()
  // self.view.layoutIfNeeded()
  func initializeImageViewFrameIfNeeded() {
    guard self.imageView.size == .zero else { return }
    guard let image = self.imageView.image else { return }
    
    if image.size.width > image.size.height { // landscape
      self.imageView.height = self.cropAreaView.height
      self.imageView.width = self.imageView.height * image.size.width / image.size.height
      
    } else if image.size.width < image.size.height { // portrait
      self.imageView.width = self.cropAreaView.width
      self.imageView.height = self.imageView.width * image.size.height / image.size.width
      
    } else { // sqaure
      self.imageView.size = self.cropAreaView.size
    }
  }
  
  
  func cancelButtonDidTap() {
    _ = self.navigationController?.popViewController(animated: true)
    // 컴파일 시, 경고가 뜨는데.. 무시하려고 처리
    // 함수 작성 시, @discardableResult를 함수 위에 써주면, 경고가 사라짐..
  }
  
  func doneButtonDidTap() {
    // 1. 이미지를 영역에 맞게 crop -> 실제 이미지 크기만큼 가이드 뷰의 크기도 늘려야 함.
    // 2. 이미지가 crop됐다고 알려줌.
    
    guard let image = self.imageView.image else { return }
    var rect = self.scrollView.convert(self.cropAreaView.frame, from: self.cropAreaView.superview)
    
    rect.origin.x *= image.size.width / self.imageView.width
    rect.origin.y *= image.size.height / self.imageView.height
    rect.size.width *= image.size.width / self.imageView.width
    rect.size.height *= image.size.height / self.imageView.height
    
    if let croppedCGImage = image.cgImage?.cropping(to: rect) {
      let croppedImage = UIImage(cgImage: croppedCGImage)
      self.didFinishCropping?(croppedImage)
    }
    
    // UIView.convert(CGRect, from:)
    // UIView.convert(CGRect, to:)
  
    //  self.view
    //  |-scrollView  (10, 20)
    //  |  |-imageView  (0, 0)  (10, 20)
    //  |
    //  |-cropAreaView (0, 0) (0, 0)
  }
  
}


// MARK: - UIScrollViewDelegate

extension CropViewController: UIScrollViewDelegate {
  
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return self.imageView
  }//줌할 뷰를 지정
  
}
