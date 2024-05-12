//
//  ReceiptView.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 5/11/24.
//

import SwiftUI
import Firebase

struct ReceiptView: View {
	@EnvironmentObject var dataManager: DataManager

	var body: some View {
		NavigationStack {
			List(dataManager.receipts, id: \.id) { receipt in
				Text(receipt.date)
			}
			.navigationTitle("Previous Receipts")
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Menu {
						Button(action: {}, label: {
							Text("Take a photo")
						})
						Button(action: {}, label: {
							Text("Add from library")
						})
						Button(action: {
							signOutAccount()
						}, label: {
							Text("Logout")
						})
					} label: {
						Label(title: { Text("Label") }, icon: { Image(systemName: "plus") })
					}
				}
			}
		}
	}

	func signOutAccount() {
		do {
			try Auth.auth().signOut()
//				authserviceSignOutDelegate?.didSignOut(self)
		} catch {
			print(error.localizedDescription)
//				authserviceSignOutDelegate?.didSignOutWithError(self, error: error)
		}
	}
}

#Preview {
	ReceiptView().environmentObject(DataManager())
}
