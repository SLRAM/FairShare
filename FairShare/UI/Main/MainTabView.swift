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
					Label(
						title: { ConstantStrings.MainTabView.receiptsTab.text },
						icon: { ConstantImages.System.listDash.image }
					)
				}
			ProfileView()
				.tabItem {
					Label(
						title: { ConstantStrings.MainTabView.profileTab.text },
						icon: { ConstantImages.System.personCropCircle.image }
					)
				}
		}
	}
}

#Preview {
	MainTabView().environmentObject(AuthViewModel())
}
