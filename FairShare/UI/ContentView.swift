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
	@State private var userIsLoggedIn = false
	@State private var isLoading = true

	var body: some View {
		if isLoading {
			ProgressView()
				.onAppear {
					Auth.auth().addStateDidChangeListener { auth, user in
						if user != nil {
							userIsLoggedIn.toggle()
						}
						isLoading.toggle()

					}
				}
		} else {
			if userIsLoggedIn {
				ReceiptView().environmentObject(DataManager())
			} else {
				LoginView()
			}
		}

	}
}

#Preview {
    ContentView()
}
