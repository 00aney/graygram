//
//  PostService.swift
//  Graygram
//
//  Created by aney on 2017. 3. 22..
//  Copyright © 2017년 Taedong Kim. All rights reserved.
//

import Alamofire
import ObjectMapper

struct PostService {
  
  static func create(
    image: UIImage,
    message: String?,
    progress: @escaping (Progress) -> Void,
    completion: @escaping (DataResponse<Post>) -> Void
  ) {
    let urlString = "https://api.graygram.com/posts"
    let headers: HTTPHeaders = [
      "Accept": "application/json",
    ]
    
    Alamofire.upload(
      multipartFormData: { formData in
        if let imageData = UIImageJPEGRepresentation(image, 1) {
          formData.append(imageData, withName: "photo", fileName: "photo.jpg", mimeType: "image/jpeg")
        }
        if let messageData = message?.data(using: .utf8) {
          formData.append(messageData, withName: "message")
        }
      },
      to: urlString,
      headers: headers,
      encodingCompletion: { encodingResult in
        switch encodingResult {
        case .success(let request, _, _):
          request // API 요청
            .uploadProgress(closure: progress)
            .validate(statusCode: 200..<400)
            .responseJSON { response in
              let newResponse: DataResponse<Post> = response
                .flatMap { value in
                  if let post = Mapper<Post>().map(JSONObject: value) {
                    return .success(post)
                  } else {
                    return .failure(MappingError(from: value, to: Post.self))
                  }
              }
              completion(newResponse)
          }
          
        case .failure(let error):
          print("인코딩 실패: \(error)")
          let response = DataResponse<Post>(
            request: nil,
            response: nil,
            data: nil,
            result: .failure(error)
          )
          completion(response)
        }
      }
    )
  }
  
  
  /// 미션
  /// 1. like()와 unlike() 구현하기
  /// 2. PostCardCell에서 PostService.like() PostService.unlike() 사용하도록 리팩토링
  /// 3. 주의 : self를 약한 참조로 넘기기!
  /// 4. PostCardCell에서 import Alamofire 제거
  static func like(postID: Int, completion: @escaping (DataResponse<Void>) -> Void) {
    let urlString = "https://api.graygram.com/posts/\(postID)/likes"
    Alamofire.request(urlString, method: .post).responseJSON { response in
      let newResponse: DataResponse<Void> = response
        .flatMap { value in
          return .success(Void())
        }
      completion(newResponse)
    }
  }
  
  static func unlike(postID: Int, completion: @escaping (DataResponse<Void>) -> Void) {
    let urlString = "https://api.graygram.com/posts/\(postID)/likes"
    Alamofire.request(urlString, method: .delete).responseJSON { response in
      let newResponse: DataResponse<Void> = response
        .flatMap { value in
          return .success(Void())
      }
      completion(newResponse)
    }
  }
  
}
