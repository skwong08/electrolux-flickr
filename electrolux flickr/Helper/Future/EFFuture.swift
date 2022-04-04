//
//  EFFuture.swift
//  electrolux flickr
//
//  Created by Wong Sai Khong on 04/04/2022.
//

import Foundation

public struct Future<Value> {
    public typealias Completion = (Result<Value>) -> Void
    public typealias AsyncOperation = (@escaping Completion) -> Void
    public typealias FailureCompletion = (String) -> Void
    public typealias SuccessCompletion = (Value) -> Void

    private let operation: AsyncOperation

    public init(result: Result<Value>) {
        self.init(operation: { completion in
            completion(result)
        })
    }

    public init(value: Value) {
        self.init(result: .success(value))
    }

    public init(error: Error) {
        self.init(result: .failure(error.localizedDescription))
    }

    public init(operation: @escaping (_ completion:@escaping Completion) -> Void) {
        self.operation = operation
    }

    public func execute(completion: @escaping Completion) {
        self.operation() { result in
            completion(result)
        }
    }

    public func execute(onSuccess: @escaping SuccessCompletion, onFailure: FailureCompletion? = nil) {
        self.operation() { result in
            switch result {
            case .success(let value):
                onSuccess(value)
            case .failure(let error):
                onFailure?(error)
            }
        }
    }
}

extension Future {

    public func andThen<U>(_ f: @escaping (_ value: Value) -> Future<U>) -> Future<U> {
        return Future<U>(operation: { completion in
            self.execute(onSuccess: { value in
                f(value).execute(completion: completion)
            }, onFailure: { error in
                completion(.failure(error))
            })
        })
    }

    public func map<T>(_ f: @escaping (_ value: Value) -> T) -> Future<T> {
        return Future<T>(operation: { completion in
            self.execute(onSuccess: { value in
                completion(.success(f(value)))
            }, onFailure: { error in
                completion(.failure(error))
            })
        })
    }
}
