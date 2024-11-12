//
//  ReceiptListViewModel.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 11/11/24.
//

import SwiftUI

class ReceiptListViewModel: ObservableObject {
	@Published var availablePayers: [any PayerProtocol]
//	@Published var didAddGuests = false
	@Published var contactsListIsPresented = false
	@Published var newReceiptIsPresented = false

	init(availablePayers: [any PayerProtocol]) {
		self.availablePayers = availablePayers
	}
}

extension ReceiptListViewModel {
	func addGuests(_ guests: [ContactModel]) {
		var payerList: [any PayerProtocol] = []
		payerList = guests
//		payerList.append(currentUser)

		availablePayers = payerList.sorted { $0.firstName < $1.firstName }
		contactsListIsPresented.toggle()
		newReceiptIsPresented.toggle()
	}
}
