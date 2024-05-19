//
//  MainTabView.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 5/18/24.
//

import SwiftUI

struct MainTabView: View {
	@EnvironmentObject var viewModel: AuthViewModel

	var body: some View {
		TabView {
			ReceiptView()
				.tabItem {
					Label("Receipts", systemImage: "list.dash")
				}
			ProfileView()
				.tabItem {
					Label("Profile", systemImage: "person.crop.circle")
				}
		}
	}
}

#Preview {
	MainTabView().environmentObject(AuthViewModel())
}
