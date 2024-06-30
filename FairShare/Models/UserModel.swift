//
//  UserModel.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 5/11/24.
//

import Foundation

struct UserModel: Identifiable, Codable, Hashable {
	var id: String
	var firstName: String
	var lastName: String
	var email: String
	//TODO: add phone number.
}

extension UserModel {
	var initials: String {
		let formatter = PersonNameComponentsFormatter()
		if let components = formatter.personNameComponents(from: "\(firstName) \(lastName)") {
			formatter.style = .abbreviated
			return formatter.string(from: components)
		}

		return ""
	}

	var fullName: String {
		return "\(firstName) \(lastName)"
	}

	var abbreviatedName: String {
		return "\(firstName) \(lastName.prefix(1))."
	}

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
