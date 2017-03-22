//
//  UserService.swift
//  Graygram
//
//  Created by aney on 2017. 3. 20..
//  Copyright © 2017년 Taedong Kim. All rights reserved.
//

import Alamofire
import ObjectMapper

struct UserService {
  
  //클로저 이스케이핑 : 이 클로저는 기본적으로 함수 스코프 안에서만 사용하도록 허용되어있다.
  //클로저를 함수 밖에서도 쓸 수 있도록 @escaping 사용
  //이 안에서만 사용할 수 있는 제약이 풀리고, responseJSON에서도 호출할수 있는 것이 된다.
  static func me(completion: @escaping (DataResponse<User>) -> Void) {
    let urlString = "https://api.graygram.com/me"
    Alamofire.request(urlString, method: .get)
      .validate(statusCode: 200..<400)
      .responseJSON { response in
        let newResponse: DataResponse<User> = response
          .flatMap { value in
            if let user = Mapper<User>().map(JSONObject: value) {
              return .success(user)
            } else {
              return .failure(MappingError(from: value, to: User.self))
            }
          }
        completion(newResponse)
      }
  }
  
}
