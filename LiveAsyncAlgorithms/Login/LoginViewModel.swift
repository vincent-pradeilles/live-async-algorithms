//
//  LoginViewModel.swift
//  AsyncAlgorithms
//
//  Created by Vincent on 09/07/2022.
//

import Foundation
import Combine
import AsyncAlgorithms

enum LoginError: String, Error {
    case emptyUserName
    case passwordMismatch
}

class LoginViewModel: ObservableObject {

    @Published var userName: String = ""
    @Published var password: String = ""
    @Published var passwordConfirmation: String = ""

    @Published var error: LoginError?

    @Published private(set) var canLogin: Bool = false

    private var tasks = Set<TaskCancellable>()

    init() {
        Task {
            let combinedSequences = combineLatest($userName.values, $password.values, $passwordConfirmation.values)

            for await (userName, password, passwordConfirmation) in combinedSequences {
                canLogin = userName.isEmpty == false
                && password.isEmpty == false
                && password == passwordConfirmation

                if userName.isEmpty {
                    error = .emptyUserName
                } else if password != passwordConfirmation {
                    error = .passwordMismatch
                } else {
                    error = nil
                }
            }
        }.store(in: &tasks)
    }
}
