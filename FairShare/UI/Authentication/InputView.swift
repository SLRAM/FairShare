//
//  InputView.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 5/11/24.
//

import SwiftUI

struct InputView: View {
	@Binding var text: String
	var title: InputType
	var isSecureField = false

	var body: some View {
		VStack(alignment: .leading, spacing: 12) {
			Text(title.description.capitalized)
				.foregroundStyle(Color.black)
				.fontWeight(.bold)
				.font(.footnote)

			if isSecureField {
				SecureField(title.placeholder, text: $text)
					.font(.system(size: 14))
			} else {
				TextField(title.placeholder, text: $text)
					.font(.system(size: 14))

			}

			Divider()
		}
	}
}

enum InputType: CustomStringConvertible {
	case firstName
	case lastName
	case email
	case password
	case confirmPassword


	var placeholder: String {
		switch self {
		case .email:
			return Strings.LoginView.emailPlaceholder
		case .password:
			return Strings.LoginView.passwordPlaceholder
		case .firstName, .lastName:
			return Strings.LoginView.namePlaceholder + self.description.lowercased()
		case .confirmPassword:
			return self.description
		}
	}

	var description: String {
		switch self {
		case .firstName:
			return Strings.LoginView.firstName
		case .lastName:
			return Strings.LoginView.LastName
		case .email:
			return Strings.LoginView.email
		case .password:
			return Strings.LoginView.password
		case .confirmPassword:
			return Strings.LoginView.confirmPassword
		}
	}

}

#Preview {
	InputView(text: .constant(""), title: InputType.firstName)
}
