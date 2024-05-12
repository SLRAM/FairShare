//
//  LoginView.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 5/11/24.
//

import SwiftUI
import Firebase

struct LoginView: View {
	enum ViewType {
		case login
		case register

		var titleString: String {
			switch self {
			case .login:
				"Welcome Back"
			case .register:
				"Register"
			}
		}

		var buttonTitleString: String {
			switch self {
			case .login:
				return "Sign In"
			case .register:
				return "Sign Up"
			}
		}

		var buttonSwitchString: String {
			switch self {
			case .login:
				return "Don't have an account?"
			case .register:
				return "Already have an account?"
			}
		}

		var buttonSwitchSubString: String {
			switch self {
			case .login:
				return "Sign up"
			case .register:
				return "Sign in"
			}
		}
	}

	let backgroundGradient = LinearGradient(
		colors: [.blue, .green],
		startPoint: .topLeading, endPoint: .bottomTrailing)

	@State private var email = ""
	@State private var password = ""
	@State private var firstName = ""
	@State private var lastName = ""
	@State private var confirmPassword = ""
	@State private var isRegistered = true
	@State private var viewType = ViewType.login


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
								text: $confirmPassword,
								title: .confirmPassword,
								isSecureField: true
							)

							InputView(
								text: $firstName,
								title: .firstName
							)

							InputView(
								text: $lastName,
								title: .LastName
							)
						}

					}
					.padding(.horizontal)
					.padding(.top, 15)

					Button {
						print("log user in")
						if isRegistered {
							login()
						} else {
							register()
						}
					} label: {
						HStack {
							Text(viewType.buttonTitleString.uppercased())
								.fontWeight(.semibold)
							Image(systemName: "arrow.right")

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
	}

	func register() {
		Auth.auth().createUser(withEmail: email, password: password) { (auth, error) in
			if let maybeError = error { //if there was an error, handle it
				let err = maybeError as NSError
				switch err.code {
				case AuthErrorCode.wrongPassword.rawValue:
					print("wrong password")
				case AuthErrorCode.invalidEmail.rawValue:
					print("invalid email")
				case AuthErrorCode.accountExistsWithDifferentCredential.rawValue:
					print("accountExistsWithDifferentCredential")
				case AuthErrorCode.weakPassword.rawValue:
					print("weak password")
				default:
					print("unknown error: \(err.localizedDescription)")
				}
			} else { //there was no error so the user could be auth'd or maybe not!
				if let _ = auth?.user {
					print("user is authd")
				} else {
					print("no authd user")
				}
			}
		}
	}

	func login() {
		Auth.auth().signIn(withEmail: email, password: password) { (auth, error) in
			if let maybeError = error { //if there was an error, handle it
				let err = maybeError as NSError
				switch err.code {
				case AuthErrorCode.wrongPassword.rawValue:
					print("wrong password")
				case AuthErrorCode.invalidEmail.rawValue:
					print("invalid email")
				case AuthErrorCode.accountExistsWithDifferentCredential.rawValue:
					print("accountExistsWithDifferentCredential")
				default:
					print("unknown error: \(err.localizedDescription)")
				}
			} else { //there was no error so the user could be auth'd or maybe not!
				if let _ = auth?.user {
					print("user is authd")
				} else {
					print("no authd user")
				}
			}
		}
	}
}

#Preview {
    LoginView()
}
