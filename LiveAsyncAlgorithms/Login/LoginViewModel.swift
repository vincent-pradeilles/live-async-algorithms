//
//  LoginViewModel.swift
//  AsyncAlgorithms
//
//  Created by Vincent on 09/07/2022.
//

import Foundation
import Combine
import AsyncAlgorithms

class LoginViewModel: ObservableObject {

    @Published var userName: String = ""
    @Published var password: String = ""
    @Published var passwordConfirmation: String = ""

    @Published private(set) var canLogin: Bool = false

    func listenToFormUpdates() async {
        let asyncSequence = combineLatest($userName.values, $password.values, $passwordConfirmation.values)
        for await (userName, password, passwordConfirmation) in asyncSequence {
            canLogin = (userName.isEmpty == false)
                && (password.isEmpty == false)
                && (password == passwordConfirmation)
        }
    }
}
