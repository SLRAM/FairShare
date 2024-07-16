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

	@Published var showMessageComposeView = false
	@Published var selectedGuest: ContactModel?

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

	private var currentUserServiceTotal: Double {
		receipt.userServiceTotal(userID: userID)
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
		case .service:
			return isEnabled ? currentUserServiceTotal.currencyFormat() : item.cost.currencyFormat()

		}
	}

	func guestReceiptImages() -> [UIImage]? {
		if let guestReceiptDescription = guestReceiptDescription(), let receiptDescription = receiptDescription() {
			return [guestReceiptDescription, receiptDescription]
		} else {
			return nil
		}
	}

	func guestReceiptDescription() -> UIImage? {
		var description = ""

		if let guest = selectedGuest {
			description += "Personal Receipt Breakdown for \(guest.fullName)\n\n"
			let guestItems = receipt.currentUserReceipt(userID: guest.id).filter { $0.type == .item }
			description += "Items:\n"
			for item in guestItems {
				let title = item.title
				let guestCost = item.costPerPayer(guestCount: guestCount).currencyFormat()
				description += "\(title), Cost: \(guestCost)\n"
			}

			description += "-------------------------------\n"

			let guestSubtotal = receipt.userSubtotal(userID: guest.id).currencyFormat()
			let guestServiceFee = receipt.userServiceTotal(userID: guest.id).currencyFormat()

			let guestTaxTotal = receipt.userTaxTotal(userID: guest.id).currencyFormat()
			let guestTotal = receipt.userTotal(userID: guest.id).currencyFormat()

			description += "Subtotal: \(guestSubtotal)\n"
			description += "Service Fee: \(guestServiceFee)\n"

			description += "Tax Total: \(guestTaxTotal)\n"
			description += "-------------------------------\n"
			description += "Total: \(guestTotal)"
		}

		return description.image(size: CGSize(width: 300, height: 300))
	}

	func receiptDescription() -> UIImage? {
		var description = "Original Receipt\n\n"
		var itemDescription = ""
		var subtotalDescription = ""
		var taxDescription = ""
		var tipDescription = ""
		var totalDescription = ""
		let divider = "-------------------------------\n"

		for itemInType in groupedItems {
			guard let firstItem = itemInType.first else { continue }

			switch firstItem.type {
			case .item:
				itemDescription += "Items:\n"
				for item in itemInType {
					let title = item.title
					let cost = item.cost.currencyFormat()
					itemDescription += "\(title), Cost: \(cost)\n"
				}
				
				itemDescription += divider

			case .subTotal:
				for item in itemInType {
					let cost = item.cost.currencyFormat()
					subtotalDescription += "Subtotal: \(cost)\n"
				}
			case .service:
				for item in itemInType {
					let cost = item.cost.currencyFormat()
					subtotalDescription += "Service Fee: \(cost)\n"
				}

			case .tax:
				for item in itemInType {
					let cost = item.cost.currencyFormat()
					taxDescription += "Tax: \(cost)\n"
				}

			case .tip:
				for item in itemInType {
					let cost = item.cost.currencyFormat()
					tipDescription += "Tip: \(cost)\n"
				}

			case .total:
				for item in itemInType {
					let cost = item.cost.currencyFormat()
					totalDescription += "Total: \(cost)\n"
				}
			}
		}

		description += itemDescription + subtotalDescription + taxDescription + tipDescription + divider + totalDescription

		return description.image(size: CGSize(width: 300, height: 300))
	}
}
