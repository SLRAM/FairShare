//
//  LoginView.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 5/11/24.
//

import SwiftUI
import Firebase

struct LoginView: View {
	///TODO: correct keyboard contraints
	@EnvironmentObject var viewModel: AuthViewModel

	@State private var email = ""
	@State private var password = ""
	@State private var firstName = ""
	@State private var lastName = ""
	@State private var confirmPassword = ""
	@State private var isRegistered = true
	@State private var viewType = ViewType.login

	let backgroundGradient = LinearGradient(
		colors: [.blue, .green],
		startPoint: .topLeading, endPoint: .bottomTrailing)

	var body: some View {
		NavigationStack {
			ZStack {
				VStack {
					Text(viewType.titleString)
						.foregroundStyle(.black)
						.font(.system(size: 40, weight: .bold, design: .rounded))
						.padding(.top, 25)

					Spacer()

					VStack(spacing: 25) {
						InputView(
							text: $email,
							title: .email
						)
						.textInputAutocapitalization(.none)

						InputView(
							text: $password,
							title: .password,
							isSecureField: true
						)

						if !isRegistered {
							InputView(
								text: $firstName,
								title: .firstName
							)

							InputView(
								text: $lastName,
								title: .lastName
							)
						}

					}
					.padding(.horizontal)
					.padding(.top, 15)

					Button {
						if isRegistered {
							Task {
								try await viewModel.signIn(with: email, password: password)
							}
						} else {
							Task {
								try await viewModel.createUser(with: email, password: password, firstName: firstName, lastName: lastName)
							}
						}
					} label: {
						HStack {
							Text(viewType.buttonTitleString.uppercased())
								.fontWeight(.semibold)
							Images.System.arrowRight.image

						}
						.foregroundStyle(.white)
						.frame(width: UIScreen.main.bounds.width - 32, height: 48)
					}
					.background(
						RoundedRectangle(
							cornerRadius: 10,
							style: .continuous
						)
						.fill(.blue)
					)
					.padding(.top, 25)

					Spacer()

					Button {
						isRegistered.toggle()
					} label: {
						HStack(spacing: 2) {
							Text(viewType.buttonSwitchString)
							Text(viewType.buttonSwitchSubString)
								.fontWeight(.bold)
						}
						.font(.system(size: 15))
						.foregroundStyle(.white)
					}
				}
			}
			.background(backgroundGradient)
		}
		.onChange(of: isRegistered) {
			if viewType == .login {
				viewType = .register
			} else {
				viewType = .login
			}
		}
		.alert(viewModel.errorMessage, isPresented: $viewModel.showAlert) {
			Button(Strings.LoginView.confirmString, role: .cancel) { viewModel.showAlert = false }
				}
	}
}

extension LoginView {
	enum ViewType {
		case login
		case register

		var titleString: String {
			switch self {
			case .login:
				Strings.LoginView.welcome
			case .register:
				Strings.LoginView.register
			}
		}

		var buttonTitleString: String {
			switch self {
			case .login:
				return Strings.LoginView.signIn
			case .register:
				return Strings.LoginView.signUp
			}
		}

		var buttonSwitchString: String {
			switch self {
			case .login:
				return Strings.LoginView.doesNotHaveAccount
			case .register:
				return Strings.LoginView.hasAccount
			}
		}

		var buttonSwitchSubString: String {
			switch self {
			case .login:
				return Strings.LoginView.signUp
			case .register:
				return Strings.LoginView.signIn
			}
		}
	}
}

#Preview {
    LoginView().environmentObject(AuthViewModel())
}
