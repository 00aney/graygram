//: Playground - noun: a place where people can play

import UIKit

enum Result {
  case success(Any)
  case failure(Error)
}

let result = Result.success("Hello")

switch result {
case .success(let value):
  print("성공: \(value)")
  
case .failure(let error):
  print("실패: \(error)")
}

struct User {}

enum UserResult {
  case success(User)
  case failure(Error)
}

let userResult = UserResult.success(User())

switch userResult {
case .success(let value):
  print("성공: \(value)")
  
case .failure(let error):
  print("실패: \(error)")
}


// Generic
enum GResult<Value> {
  case success(Value)
  case failure(Error)
}

let gResult = GResult.success(User())
switch gResult{
case .success(let value):
  print("성공: \(value)")

case .failure(let error):
  print("실패: \(error)")
}


struct DataResponse<T> {
  let result: GResult<T>
}

DataResponse(result: GResult.success("String"))
DataResponse(result: GResult.success(User()))