//
//  UserModel.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 5/11/24.
//

import Foundation

struct UserModel: Identifiable, Codable {
	var id: String
	var firstName: String
	var lastName: String
	var email: String

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
}
