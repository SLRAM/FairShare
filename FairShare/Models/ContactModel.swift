//
//  ContactModel.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 6/30/24.
//

import Foundation

struct ContactModel: PayerProtocol {
	var id: String
	var firstName: String
	var lastName: String
	var phoneNumber: String

	init(id: String = UUID().uuidString, firstName: String, lastName: String, phoneNumber: String) {
		self.id = id
		self.firstName = firstName
		self.lastName = lastName
		self.phoneNumber = phoneNumber
	}

	//TODO: active user can create "guest" contact by phone number. If this contact makes an account later, they can be linked to their guest account and updated via matching phone number.

	static let dummyData: ContactModel = dummyArrayData[0]
	static let dummyArrayData: [ContactModel] = [
		ContactModel(
			id: UUID().uuidString,
			firstName: "John",
			lastName: "Appleseed",
			phoneNumber: "8885555512"
		),
		ContactModel(
			id: UUID().uuidString,
			firstName: "Kate",
			lastName: "Bell",
			phoneNumber: "5555648583"
		)
	]
}
