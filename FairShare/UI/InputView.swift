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
	case LastName
	case email
	case password
	case confirmPassword


	var placeholder: String {
		switch self {
		case .email:
			return "name@example.com"
		case .password:
			return "Enter your password"
		case .firstName, .LastName:
			return "Enter your \(self.description.lowercased())"
		case .confirmPassword:
			return self.description
		}
	}

	var description: String {
		switch self {
		case .firstName:
			return "First Name"
		case .LastName:
			return "Last Name"
		case .email:
			return "Email Address"
		case .password:
			return "Password"
		case .confirmPassword:
			return "Confirm Password"
		}
	}

}

#Preview {
	InputView(text: .constant(""), title: InputType.firstName)
}
