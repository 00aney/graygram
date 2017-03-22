//
//  Feed.swift
//  Graygram
//
//  Created by aney on 2017. 3. 20..
//  Copyright © 2017년 Taedong Kim. All rights reserved.
//

import ObjectMapper

struct Feed: Mappable {
  var posts: [Post]!
  var nextURLString: String?
  
  init?(map: Map) {
  }
  
  mutating func mapping(map: Map) {
    self.posts <- map["data"]
    self.nextURLString <- map["paging.next"]
  }
}
