//
//  FairShareApp.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 5/6/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		FirebaseApp.configure()

		return true
	}
}

@main
struct FairShareApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
	@StateObject var viewModel = AuthViewModel()

	let persistenceController = PersistenceController.shared

	var body: some Scene {
		WindowGroup {
			EntryView()
				.environment(\.managedObjectContext, persistenceController.container.viewContext)
				.environmentObject(viewModel)
		}
	}
}
