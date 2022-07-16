//
//  LoginView.swift
//  AsyncAlgorithms
//
//  Created by Vincent on 09/07/2022.
//

import SwiftUI

struct LoginView: View {

    @StateObject var viewModel = LoginViewModel()

    var body: some View {
        VStack {
            Form {
                Section {
                    TextField("Username", text: $viewModel.userName)
                    TextField("Password", text: $viewModel.password)
                        .autocorrectionDisabled()
                    TextField("Password Confirmation", text: $viewModel.passwordConfirmation)
                        .autocorrectionDisabled()
                    if let error = viewModel.error {
                        Text(error.rawValue)
                            .foregroundColor(.red)
                    }
                }

                Section {
                    Button {
                        // Login
                    } label: {
                        Text("Create your account")
                    }
                    .disabled(viewModel.canLogin == false)
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
