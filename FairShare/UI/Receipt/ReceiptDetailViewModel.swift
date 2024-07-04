//
//  ReceiptDetailViewModel.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 7/7/24.
//

import Foundation
import SwiftUI

class ReceiptDetailViewModel: ObservableObject {
	var receipt: ReceiptModel
	var userID: String

	@Published var isEnabled = false
	@Published var displayedGroupedItems: [[ReceiptItem]] = []
	@Published private var groupedItems: [[ReceiptItem]] = []
	@Published private var filteredGroupedItems: [[ReceiptItem]] = []

	init(receipt: ReceiptModel, userID: String) {
		self.receipt = receipt
		self.userID = userID
		setupInitialItems()
	}

	private var currentUserSubtotal: Double {
		receipt.userSubtotal(userID: userID)
	}

	private var currentUserTax: Double {
		receipt.userTaxTotal(userID: userID)
	}

	private var currentUserTotal: Double {
		receipt.userTotal(userID: userID)
	}

	private var guestCount: Int {
		receipt.guestIDs.count
	}

	private func setupInitialItems() {
		groupedItems = groupItemsByType(items: receipt.items)
		filteredGroupedItems = groupItemsByType(items: receipt.currentUserReceipt(userID: userID))
		displayedGroupedItems = groupedItems
	}

	private func groupItemsByType(items: [ReceiptItem]) -> [[ReceiptItem]] {
		guard !items.isEmpty else {
			return []
		}

		let dictionaryByType = Dictionary(grouping: items, by: { $0.type })
		let itemTypes = ReceiptItemType.allCases
		return itemTypes.compactMap({ dictionaryByType[$0] })
	}

	func toggleEnabled() {
		if isEnabled {
			displayedGroupedItems = filteredGroupedItems
		} else {
			displayedGroupedItems = groupedItems
		}
	}

	func formattedCost(for item: ReceiptItem) -> String {
		switch item.type {
		case .item:
			return isEnabled ? item.costPerPayer(guestCount: guestCount).currencyFormat() : item.cost.currencyFormat()
		case .subTotal:
			return isEnabled ? currentUserSubtotal.currencyFormat() : item.cost.currencyFormat()
		case .tax:
			return isEnabled ? currentUserTax.currencyFormat() : item.cost.currencyFormat()
		case .tip:
			return item.cost.currencyFormat()
		case .total:
			return isEnabled ? currentUserTotal.currencyFormat() : item.cost.currencyFormat()

		}
	}
}
