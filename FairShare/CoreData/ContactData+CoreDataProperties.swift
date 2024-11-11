//
//  ContactData+CoreDataProperties.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 11/9/24.
//
//

import Foundation
import CoreData

extension ContactData {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<ContactData> {
		return NSFetchRequest<ContactData>(entityName: "ContactData")
	}

	@NSManaged public var id: String
	@NSManaged public var firstName: String
	@NSManaged public var lastName: String
	@NSManaged public var phoneNumber: String?

}

extension ContactData : Identifiable {
	func convertToContactModel() -> ContactModel {
		return ContactModel(self)
	}
}

extension Array where Element == ContactData {
	func convertToContactModels() -> [ContactModel] {
		return self.map { $0.convertToContactModel() }
	}
}
