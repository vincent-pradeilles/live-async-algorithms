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
        .task {
            await viewModel.listenToFormUpdates()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
