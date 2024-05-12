//
//  UserModel.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 5/11/24.
//

import Foundation

struct UserModel: Identifiable {
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
}

extension UserModel {
	static var sampleUser = UserModel(id: NSUUID().uuidString, firstName: "Stephanie", lastName: "Ramirez", email: "stephanieramirez@pursuit.org")
}
