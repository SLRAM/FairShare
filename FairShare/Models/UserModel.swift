//
//  UserModel.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 5/11/24.
//

import Foundation

protocol PayerProtocol: Identifiable, Codable, Hashable {
	var id: String { get }
	var firstName: String { get }
	var lastName: String { get }
}

extension PayerProtocol {
	var fullName: String {
		"\(firstName) \(lastName)"
	}

	var abbreviatedName: String {
		return "\(firstName) \(lastName.prefix(1))."
	}

	var initials: String {
		let formatter = PersonNameComponentsFormatter()
		if let components = formatter.personNameComponents(from: "\(firstName) \(lastName)") {
			formatter.style = .abbreviated
			return formatter.string(from: components)
		}

		return ""
	}
}

extension PayerProtocol where Self: Hashable {
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(firstName)
		hasher.combine(lastName)
	}

	static func ==(lhs: Self, rhs: Self) -> Bool {
		return lhs.id == rhs.id && lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName
	}
}


struct UserModel: PayerProtocol {
	var id: String
	var firstName: String
	var lastName: String
	var email: String
	//TODO: add phone number.
}

extension UserModel {
	static let dummyData: UserModel = dummyArrayData[0]
	static let dummyArrayData: [UserModel] = [
		UserModel(
			id: UUID().uuidString,
			firstName: "Jane",
			lastName: "Smith",
			email: "janesmith@gmail.com"
		),
		UserModel(
			id: UUID().uuidString,
			firstName: "John",
			lastName: "Williams",
			email: "jwill@gmail.com"
		)
	]
}
