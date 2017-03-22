//
//  FeedService.swift
//  Graygram
//
//  Created by aney on 2017. 3. 20..
//  Copyright © 2017년 Taedong Kim. All rights reserved.
//

import Alamofire
import ObjectMapper

struct FeedService {
  
  static func feed(paging: Paging, completion: @escaping (DataResponse<Feed>) -> Void) {
    let urlString: String
    switch paging {
    case .refresh:
      urlString = "https://api.graygram.com/feed?limit=5"
    case .next(let nextURLString):
      urlString = nextURLString
    }
    
    Alamofire.request(urlString).responseJSON { response in
      let newResponse: DataResponse<Feed> = response.flatMap{ value in
        if let feed = Mapper<Feed>().map(JSONObject: value) {
          return .success(feed)
        } else {
          return .failure(MappingError(from: value, to: Feed.self))
        }
      }
      completion(newResponse)
    }
  }
  
}
