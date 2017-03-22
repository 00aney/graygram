//
//  MappingError.swift
//  Graygram
//
//  Created by aney on 2017. 3. 20..
//  Copyright © 2017년 Taedong Kim. All rights reserved.
//

import ObjectMapper

struct MappingError: Error, CustomStringConvertible {
  
  // `String(describing: mappingError)`를 할 때 이 값이 사용됩니다.
  // `CustomStringConvertible`에 정의되어 있는 속성
  let description: String
  
  init(from: Any?, to: Any.Type) {
    self.description = "Failed to map from \(from) to \(to)"
  }
  
}
