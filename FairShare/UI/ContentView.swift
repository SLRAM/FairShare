//
//  ContentView.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 5/6/24.
//

import SwiftUI
import CoreData
import Firebase

struct ContentView: View {
	@EnvironmentObject var viewModel: AuthViewModel

	var body: some View {
		Group {
			if viewModel.userSession != nil {
				MainTabView()
			} else {
				LoginView()
			}
		}
	}
}

#Preview {
    ContentView()
}
