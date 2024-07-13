//
//  ContactPickerView.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 6/30/24.
//

import Contacts
import ContactsUI
import SwiftUI

struct ContactPickerView: UIViewControllerRepresentable {
	//TODO: add searchbar and guard for adding self.
	@Binding var selectedContacts: [ContactModel]

	func makeUIViewController(context: Context) -> CNContactPickerViewController {
		let picker = CNContactPickerViewController()
		picker.delegate = context.coordinator
		return picker
	}

	func updateUIViewController(_ uiViewController: CNContactPickerViewController, context: Context) {}

	func makeCoordinator() -> Coordinator {
		Coordinator(selectedContacts: $selectedContacts)
	}

	class Coordinator: NSObject, CNContactPickerDelegate {
		@Binding var selectedContacts: [ContactModel]

		init(selectedContacts: Binding<[ContactModel]>) {
			_selectedContacts = selectedContacts
		}

		func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
			var newContacts: [ContactModel] = []

			for contact in contacts {
				let phoneNumber: String = {
					var phone = String()

					for phoneNumber in contact.phoneNumbers {
						let strippedNumber = phoneNumber.value.stringValue.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
						phone = strippedNumber
						break
					}

					return phone
				}()

				let model = ContactModel(
					firstName: contact.givenName,
					lastName: contact.familyName,
					phoneNumber: phoneNumber
				)

				newContacts.append(model)
			}

			selectedContacts = newContacts
		}

		func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
		}
	}
}
