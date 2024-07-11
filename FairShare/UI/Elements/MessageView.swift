//
//  MessageView.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 7/13/24.
//

import SwiftUI
import MessageUI
import Messages

struct MessageComposeView: UIViewControllerRepresentable {
	var recipients: [String]
	var body: String
	var images: [UIImage]?

	@Environment(\.presentationMode) private var presentationMode

	class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
		var parent: MessageComposeView

		init(_ parent: MessageComposeView) {
			self.parent = parent
		}

		func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
			parent.presentationMode.wrappedValue.dismiss()
		}
	}

	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	func makeUIViewController(context: Context) -> MFMessageComposeViewController {
		let controller = MFMessageComposeViewController()
		controller.messageComposeDelegate = context.coordinator
		controller.recipients = recipients
		controller.body = body

		if let images = images {
			for (index, image) in images.enumerated() {
				if let imageData = image.jpegData(compressionQuality: 1.0) {
					controller.addAttachmentData(imageData, typeIdentifier: Strings.MessageView.typeIdentifier.string, filename: Strings.MessageView.fileName.string + "\(index + 1)" + Strings.MessageView.fileType.string)
				}
			}
		}

		return controller
	}

	func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {}

	public static func canSendText() -> Bool {
		MFMessageComposeViewController.canSendText()
	}
}
