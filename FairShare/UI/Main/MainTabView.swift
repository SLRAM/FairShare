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
						title: { Strings.MainTabView.receiptsTab.text },
						icon: { Images.System.listDash.image }
					)
				}
			ProfileView()
				.tabItem {
					Label(
						title: { Strings.MainTabView.profileTab.text },
						icon: { Images.System.personCropCircle.image }
					)
				}
		}
	}
}

#Preview {
	MainTabView().environmentObject(AuthViewModel())
}
