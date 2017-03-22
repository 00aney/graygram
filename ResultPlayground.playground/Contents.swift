//: Playground - noun: a place where people can play

enum Result<Value> {
  case success(Value)
  case failure(Error)
}


extension Result {
  func map<T>(_ transform: (Value) -> T) -> Result<T> {  // value 만드는데 사용
    switch self {
    case .success(let value):
      let newValue = transform(value)
      return .success(newValue)
      
    case .failure(let error):
      return .failure(error)
    }
  }
  
  func flatMap<T>(_ transform: (Value) -> Result<T>) -> Result<T> {  // value 를 받아서 새로운 result를 만드는데 사용
    switch self {
    case .success(let value):
      return transform(value)
      
    case .failure(let error):
      return .failure(error)
    }
  }
}

struct MyError: Error {}

let result = Result.success(123)
  .map { value in
    return "\(value)" // .success("123")
  }
  .map { value in
    return value.characters.reversed().map{ String($0) }  // .success("321")
  }
  .flatMap { value -> Result<String> in
    return .failure(MyError())
  }

print(result)


struct User {
  
}

Result<Any>.success(["id": 123] as [String: Any])
  .flatMap { value -> Result<[String: Any]> in
    if let json = value as? [String: Any] {
      return .success(json)
    } else {
      return .failure(MyError())
    }
  }
//  .flatMap { json -> Result<User> in
//    if let user = User(json: json) {
//      return .success(user)
//    } else {
//      return .failure(MyError())
//    }
//  }


let intOptional: Int? = 123
intOptional
  .map { value in
    value * 2
  }
  .flatMap { value -> Optional<Int> in
    return nil
  }

// Monad
// 모나드 검색