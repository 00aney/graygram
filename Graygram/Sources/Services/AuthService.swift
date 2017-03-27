//
//  AuthService.swift
//  Graygram
//
//  Created by aney on 2017. 3. 20..
//  Copyright © 2017년 Taedong Kim. All rights reserved.
//

import Alamofire

struct AuthService {
  
  static func login(
    username: String,
    password: String,
    completion: @escaping (DataResponse<Void>) -> Void
  ) {
    let urlString = "https://api.graygram.com/login/username"
    let parameters: Parameters = [
      "username": username,
      "password": password,
      ]
    let headers: HTTPHeaders = [
      "Accept": "application/json",		// default: text/html
    ]
    Alamofire.request(urlString, method: .post, parameters: parameters, headers: headers)
      .validate(statusCode: 200..<400)
      .responseJSON { response in
        // 미션:
        // response의 Generic 타입을 Void로 만들어서 completion 클로저를 호출해보세요.
        let newResponse: DataResponse<Void> = response.flatMap { value in
          return Result.success(Void())
        }
        completion(newResponse)
      }
  }
  
  static func logout() {
    let storage = HTTPCookieStorage.shared
    if let cookies = storage.cookies {
      for cookie in cookies {
        storage.deleteCookie(cookie)
        print("쿠키 삭제: \(cookie.name)")
      }
    }
  }
  
}
