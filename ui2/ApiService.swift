//
//  Service.swift
//  ui2
//
//  Created by lamour on 5/13/20.
//  Copyright © 2020 Lamour Butcher. All rights reserved.
//

import Foundation

public enum LoginError: Error {
    case invalidPassword
    case accountNotFound
}

struct ErrorStrings {
    static let AccountNotFound = "Account not found"
    static let InvalidPassword = "Invalid Password"
}

extension Error {
    func localized() -> String {
        if let err = self as? LoginError {
            return err == .accountNotFound ? ErrorStrings.AccountNotFound : ErrorStrings.InvalidPassword
        } else {
            return self.localizedDescription
        }
    }
}

protocol ApiServiceProtocol: class {
    static var correctPasswordInput: String { get }
    static var correctUsernameInput: String { get }
    var queue: DispatchQueue { get }
}


extension ApiServiceProtocol {
    func signIn(
        username: String,
        password: String,
        completion: @escaping(Result<Void>) -> Void
    ) {
        //let valueFor30seconds = DispatchTimeInterval.seconds(30)
        //let timeFromNow =   DispatchTime.now() + valueFor30seconds
        queue.asyncAfter(deadline: .now() + 0.2) {
            // simulate api request
            if username == Self.correctUsernameInput &&
            password == Self.correctPasswordInput
            {
                completion(.success(()))
            }
            else if username != Self.correctUsernameInput {
                completion(.failure(LoginError.accountNotFound))
            }
            else {
                completion(.failure(LoginError.invalidPassword))
            }
        }
    }
}

class ApiService: ApiServiceProtocol {
    static var correctUsernameInput: String = "James23"
    static var correctPasswordInput: String = "bond@123"
    let queue =  DispatchQueue(label: "com.lamour.lamour.ui2.service.background.queue")
}

class MockedApiService: ApiServiceProtocol {
    static var correctUsernameInput: String = "Mello23"
    static var correctPasswordInput: String = "Pass@1823$$"
    let queue =  DispatchQueue(label: "com.lamour.ui2.test.background.queue")
}
