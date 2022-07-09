//
//  LoginViewModel.swift
//  AsyncAlgorithms
//
//  Created by Vincent on 09/07/2022.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {

    @Published var userName: String = ""
    @Published var password: String = ""
    @Published var passwordConfirmation: String = ""

    @Published var canLogin: Bool = false

    init() {
        Publishers.CombineLatest3($userName, $password, $passwordConfirmation)
            .map { userName, password, passwordConfirmation in
                (userName.isEmpty == false) && (password == passwordConfirmation)
            }
            .assign(to: &$canLogin)
    }
}
