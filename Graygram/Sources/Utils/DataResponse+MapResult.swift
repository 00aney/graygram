//
//  DataResponse+MapResult.swift
//  Graygram
//
//  Created by aney on 2017. 3. 20..
//  Copyright © 2017년 Taedong Kim. All rights reserved.
//

import Alamofire

extension DataResponse {
  
  // (Value) -> Result<T>
  func flatMap<T>(_ transform: (Value) -> Result<T>) -> DataResponse<T> {
    let result: Result<T>
    switch self.result {
    case .success(let value):
      result = transform(value)
    case .failure(let error):
      result = .failure(error)
    }
    // TODO: result
    return DataResponse<T>(
      request: self.request,
      response: self.response,
      data: self.data,
      result: result,
      timeline: self.timeline
    ) 
  }
  
}