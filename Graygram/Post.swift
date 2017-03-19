//
//  Post.swift
//  Graygram
//
//  Created by aney on 2017. 2. 22..
//  Copyright © 2017년 Taedong Kim. All rights reserved.
//

import ObjectMapper

struct Post: Mappable {
	
	var id: Int! //항상 값이 있는 경우 !
	var message: String?
	var photoID: String!
	
	var userPhotoID: String?
	var username: String!
  
  var isLiked: Bool!
  var likeCount: Int!
	
	
	//MARK: Mappable
	//failable initializer
	init?(map: Map) {
		
	}
	
	// mutating 자기 자신을 수정하는... function.. 구조체 선언할 땐 var 사용
	mutating func mapping(map: Map) {
		self.id <- map["id"]
		self.message <- map["message"]
		self.photoID <- map["photo.id"]
		self.userPhotoID <- map["user.photo.id"]
		self.username <- map["user.username"]
    self.isLiked <- map["is_liked"]
    self.likeCount <- map["like_count"]
	}
	
}


extension Notification.Name {
  /// Post에 좋아요를 표시할 때 발송되는 노티피케이션입니다. userInfo에 ["postID": Post.id] 값이 필요합니다.
  static var postDidLike: Notification.Name { return .init("postDidLike") }
  
  /// Post에 좋아요를 취소할 때 발송되는 노티피케이션입니다. userInfo에 ["postID": Post.id] 값이 필요합니다.
  static var postDidUnlike: Notification.Name { return .init("postDidUnlike") }
  
  /// 새로운 `Post`가 생성되었을 경우 발생하는 노티피케이션입니다. `userInfo`에 `post: Post`가 전달됩니다.
  static var postDidCreate: Notification.Name { return .init("postDidCreate") }
}

//Cf. 수열님이 컨트리뷰트한 프로토콜
struct Post2: ImmutableMappable {
  //불변하는 맵퍼블
  //-> 값이 변하지 않는 속성을 정희하고 싶을 때,
  //let 사용할 수 있다.
  
  let id: Int
  
  init(map: Map) throws {
    self.id = try map.value("id")
  }
}
