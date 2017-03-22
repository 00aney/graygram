//
//  PostCardCell.swift
//  Graygram
//
//  Created by aney on 2017. 2. 22..
//  Copyright © 2017년 Taedong Kim. All rights reserved.
//

import UIKit

import SnapKit
import ManualLayout

final class PostCardCell: UICollectionViewCell {
	
	// MARK: Constants
	
	struct Metric {
		static let userPhotoViewTop = CGFloat(0)
		static let userPhotoViewLeft = CGFloat(10)
		static let userPhotoViewWidth = CGFloat(30)
		static let userPhotoViewHeight = CGFloat(30)
		
		static let usernameLabelLeft = CGFloat(10)
		static let usernameLabelRight = CGFloat(10)
		
		static let photoViewTop = CGFloat(10)
		
		static let likeButtonTop = CGFloat(10)
		static let likeButtonLeft = CGFloat(10)
		static let likeButtonWidth = CGFloat(20)
		static let likeButtonHeight = CGFloat(20)
    
    static let likeCountLabelTop = CGFloat(10)
    static let likeCountLabelLeft = CGFloat(10)
    static let likeCountLabelRight = CGFloat(10)
		
		static let messageLabelTop = CGFloat(10)
		static let messageLabelLeft = CGFloat(10)
		static let messageLabelRight = CGFloat(10)
	}
	
	struct Font {
    static let likeCountLabel = UIFont.boldSystemFont(ofSize: 12)
		static let messageLabel = UIFont.systemFont(ofSize: 13)
		static let usernameLabel = UIFont.boldSystemFont(ofSize: 13)
    
	}
  
  fileprivate var post: Post?
	
	// MARK: UI
	
	fileprivate let userPhotoView = UIImageView()
	fileprivate let usernameLabel = UILabel()
	fileprivate let photoView = UIImageView()
	fileprivate let likeButton = UIButton()
	fileprivate let likeCountLabel = UILabel()
	fileprivate let messageLabel = UILabel()
	//private vs fileprivate 파일 안에서 사용가능(extension에서도 접근 가능)
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.userPhotoView.layer.cornerRadius = Metric.userPhotoViewWidth / 2
		self.userPhotoView.clipsToBounds = true
		//기본 적으로 레이어는 자기가 가진 컨텐츠를 전부 그리는 속성이 활성화 되어있다.
		
		self.usernameLabel.font = Font.usernameLabel
		self.photoView.backgroundColor = .lightGray
		
    self.likeButton.addTarget(self, action: #selector(likeButtonDidTap), for: .touchUpInside)
		self.likeButton.setBackgroundImage(UIImage(named: "icon-like"), for: .normal)
		self.likeButton.setBackgroundImage(UIImage(named: "icon-like-selected"), for: .selected)
		//setImage vs setBackgroundImage 백그라운드 이미지는 버튼 크기에 따라 변한다.
//		self.likeButton.isSelected = true

    self.likeCountLabel.font = Font.likeCountLabel
		
		self.messageLabel.font = Font.messageLabel
		self.messageLabel.numberOfLines = 3
		
		self.contentView.addSubview(self.userPhotoView)
		self.contentView.addSubview(self.usernameLabel)
		self.contentView.addSubview(self.photoView)
		self.contentView.addSubview(self.likeButton)
    self.contentView.addSubview(self.likeCountLabel)
		self.contentView.addSubview(self.messageLabel)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

  class func size(width: CGFloat, post: Post, isMessageTrimmed: Bool) -> CGSize {
		var height: CGFloat = 0
		
		// userPhotoView
		height += Metric.userPhotoViewTop
		height += Metric.userPhotoViewHeight
	
		// photoView
		height += Metric.photoViewTop
		height += width // photo view height
		
		// likeButton
		height += Metric.likeButtonTop
		height += Metric.likeButtonHeight
		
		// messageLabel
		if let message = post.message, !message.isEmpty {
			height += Metric.messageLabelTop
      
      height += message.height(
        width: width - Metric.messageLabelLeft - Metric.messageLabelRight,
        font: Font.messageLabel,
        numberOfLines: isMessageTrimmed ? 3 : 0
      )
		} else {
			
		}
	
		return CGSize(width: width, height: height)
	}
	
  /// 셀을 설정합니다.
  ///
  /// - parameter post: Post 인스턴스
  /// - parameter isMessageTrimmed: 메시지 라벨 높이를 제한할 것인지를 나타냅니다.
  func configure(post: Post, isMessageTrimmed: Bool) {
		self.backgroundColor = .white
    self.post = post
		self.userPhotoView.setImage(with: post.userPhotoID)
		self.usernameLabel.text = post.username
		self.photoView.setImage(with: post.photoID)
    self.likeButton.isSelected = post.isLiked
    self.likeCountLabel.text = self.likeCountLabelText(with: post.likeCount!)
    self.messageLabel.text = post.message
    self.messageLabel.numberOfLines = isMessageTrimmed ? 3 : 0
		self.setNeedsLayout()	// layoutSubviews 호출
//		self.layoutIfNeeded()// layoutSubviews 호출
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		// MARK: ManualLayout
		self.userPhotoView.top = Metric.userPhotoViewTop
		self.userPhotoView.left = Metric.userPhotoViewLeft
		self.userPhotoView.width = Metric.userPhotoViewWidth
		self.userPhotoView.height = Metric.userPhotoViewHeight
		
		self.usernameLabel.left = self.userPhotoView.right + Metric.usernameLabelLeft
		self.usernameLabel.sizeToFit()
		//오른쪽 아래로 크기가 늘어난다. 그래서 centerY가 설정되기 전에 sizeToFit 해준다.
		self.usernameLabel.width = min(
			self.usernameLabel.width,
			self.contentView.width - self.usernameLabel.left - Metric.usernameLabelRight
		)
		
		//늘렸던 것을 줄인다. 이름이 엄청 긴 경우..
		self.usernameLabel.lineBreakMode = .byClipping
		//
		self.usernameLabel.centerY = self.userPhotoView.centerY
		
		self.usernameLabel.width = self.contentView.width
			- Metric.usernameLabelLeft
			- Metric.userPhotoViewLeft
			- Metric.userPhotoViewWidth
		
		self.photoView.top = self.userPhotoView.bottom + Metric.photoViewTop
		self.photoView.width = self.contentView.width
		self.photoView.height = self.photoView.width
		
		self.likeButton.top = self.photoView.bottom + Metric.likeButtonTop
		self.likeButton.left = Metric.likeButtonLeft
		self.likeButton.width = Metric.likeButtonWidth
		self.likeButton.height = Metric.likeButtonHeight
    
    self.likeCountLabel.sizeToFit()
    self.likeCountLabel.left = self.likeButton.right + Metric.likeCountLabelLeft
    self.likeCountLabel.centerY = self.likeButton.centerY
    self.likeCountLabel.width = min(
      self.likeCountLabel.width,
      self.contentView.width - self.likeCountLabel.left - Metric.likeCountLabelRight
    )
    
		self.messageLabel.left = Metric.messageLabelLeft
		self.messageLabel.top = self.likeButton.bottom + Metric.messageLabelTop
		self.messageLabel.width = self.contentView.width
			- Metric.messageLabelLeft
			- Metric.messageLabelRight
		self.messageLabel.sizeToFit()
		
//		self.photoView.frame.size.width = self.contentView.frame.width
//		self.photoView.frame.size.height = self.photoView.frame.size.width
//		
//		self.messageLabel.frame.origin.x = 10
//		self.messageLabel.frame.origin.y = self.photoView.frame.height + 10
//		self.messageLabel.frame.size.width = self.contentView.frame.width - 20
//		self.messageLabel.sizeToFit()//텍스트에 맞게 자기 크기 조정
	}
  
  // MARK: - Actions
  func likeButtonDidTap() {
    if !self.likeButton.isSelected {
      self.like()
    } else {
      self.unlike()
    }
  }
  //데이터 동기화 방법
  //1. 실제 동작하는거와 똑같이 매번 post 값을 변경
  //2. 좋아요를 눌렀을 때, FeedVC에 알려준다. +1 하라고.
  // 1) Delegate
  // 2) callback
  // 3) Notification(App 내에서 글로벌하게 쏠 수 있다.모든 곳에서 하나의 데이터에 관한 알림을 받는다.)
  
  func like() {
    guard let post = self.post else { return }
    NotificationCenter.default.post(name: .postDidLike, object: self, userInfo: ["postID": post.id])
    PostService.like(postID: post.id) { response in
      switch response.result {
      case .success:
        print("좋아요 성공")
      case .failure:
        NotificationCenter.default.post(name: .postDidUnlike, object: self, userInfo: ["postID": post.id])
      }
    }
  }
  
  func unlike() {
    guard let post = self.post else { return }
    NotificationCenter.default.post(name: .postDidUnlike, object: self, userInfo: ["postID": post.id])
    PostService.unlike(postID: post.id) { response in
      switch response.result {
      case .success:
        print("좋아요 취소 성공")
      case .failure:
        NotificationCenter.default.post(name: .postDidLike, object: self, userInfo: ["postID": post.id])
      }
    }
  }
  
  func likeCountLabelText(with likeCount: Int) -> String {
    if likeCount == 0 {
      return "가장 먼저 좋아요를 눌러보세요."
    } else {
      return "\(likeCount)명이 좋아합니다."
    }
    
    //옵셔널이 붙는 이유.. -> 느낌표를 붙여서 선언한 옵셔널이기 때문이다.
    //!로 붙은 프로퍼티도 모두 옵셔널로 처리된다.(swift 3.0 부터)
    
  }
}

//Apple의 MVC는... Massive ViewController
//MVP : 모델 뷰 프레젠트
//MVVM : Model View ViewModel

//RxSwift <- RxCocoa <-> UIKit
//
