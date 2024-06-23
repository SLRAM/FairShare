//
//  CameraView.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 5/25/24.
//

import PhotosUI
import SwiftUI
import VisionKit
import Vision

struct CameraView: UIViewControllerRepresentable {
	@Environment(\.presentationMode) var presentationMode

	@Binding var recognizedTexts: [any ReceiptText]
	//TODO: remove visualizedImage. For testing purposes only.
	@Binding var visualizedImage: UIImage?
	@Binding var selectedImage: UIImage?

	func makeCoordinator() -> Coordinator {
		Coordinator(visualizedImage: $visualizedImage, selectedImage: $selectedImage,recognizedTexts: $recognizedTexts, parent: self)
	}

	func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
		let documentViewController = VNDocumentCameraViewController()
		documentViewController.delegate = context.coordinator
		return documentViewController
	}

	func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {
	}

	class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
		var recognizedTexts: Binding<[any ReceiptText]>
		var visualizedImage: Binding<UIImage?>
		var selectedImage: Binding<UIImage?>

		var parent: CameraView

		init(visualizedImage: Binding<UIImage?>, selectedImage: Binding<UIImage?>, recognizedTexts: Binding<[any ReceiptText]>, parent: CameraView) {
			self.visualizedImage = visualizedImage
			self.recognizedTexts = recognizedTexts
			self.selectedImage = selectedImage
			self.parent = parent
		}

		func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
			let extractedImage = Processor.extractImage(from: scan)

			let processedImage = Processor.visualizeImage(from: extractedImage)
			let processedText = Processor.recognizeText(from: extractedImage)

			visualizedImage.wrappedValue = processedImage
			selectedImage.wrappedValue = extractedImage
			recognizedTexts.wrappedValue = processedText

			parent.presentationMode.wrappedValue.dismiss()
		}
	}
}

enum Processor {
	static func extractImage(from scan: VNDocumentCameraScan) -> UIImage {
		let extractedImage = scan.imageOfPage(at: 0)

		return extractedImage
	}

	static func extractImage(from item: PhotosPickerItem?) async -> UIImage {
		var extractedImage: UIImage = UIImage()

			if let item = item {
				var image: UIImage?
				if let data = try? await item.loadTransferable(type: Data.self) {
					image = UIImage(data: data)
				}

				if let image = image {
					extractedImage = image
			}
		}

		return extractedImage

	}

	static func visualizeImage(from image: UIImage) -> UIImage {
		var visualizedImage = UIImage()

		let recognizeTextRequest = VNRecognizeTextRequest { request, error in
			guard let observations = request.results as? [VNRecognizedTextObservation] else {
				print("Error: \(error! as NSError)")
				return
			}

			visualizedImage = self.visualization(image, observations: observations)
		}

		recognizeTextRequest.recognitionLevel = .accurate

		if let cgImage = image.cgImage {
			let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])

			try? requestHandler.perform([recognizeTextRequest])
		}

		return visualizedImage
	}

	static func visualization(_ image: UIImage, observations: [VNDetectedObjectObservation]) -> UIImage {
		var transform = CGAffineTransform.identity
			.scaledBy(x: 1, y: -1)
			.translatedBy(x: 1, y: -image.size.height)

		transform = transform.scaledBy(x: image.size.width, y: image.size.height)

		UIGraphicsBeginImageContextWithOptions(image.size, true, 0.0)
		let context = UIGraphicsGetCurrentContext()

		image.draw(in: CGRect(origin: .zero, size: image.size))
		context?.saveGState()

		context?.setLineWidth(2)
		context?.setLineJoin(CGLineJoin.round)
		context?.setStrokeColor(UIColor.black.cgColor)
		context?.setFillColor(red: 0, green: 1, blue: 0, alpha: 0.3)

		observations.forEach { observation in
			let bounds = observation.boundingBox.applying(transform)
			context?.addRect(bounds)
		}

		context?.drawPath(using: CGPathDrawingMode.fillStroke)
		context?.restoreGState()

		let resultImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return resultImage!
	}

	static func recognizeText(from image: UIImage) -> [any ReceiptText] {
		var entireRecognizedTexts: [any ReceiptText] = []

		let recognizeTextRequest = VNRecognizeTextRequest { (request, error) in
			guard error == nil else { return }
			guard let observations = request.results as? [VNRecognizedTextObservation] else { return }

			entireRecognizedTexts = self.makeReceiptText(from: observations)
		}

		recognizeTextRequest.recognitionLevel = .accurate

		if let cgImage = image.cgImage {
			let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])

			try? requestHandler.perform([recognizeTextRequest])
		}

		return entireRecognizedTexts
	}

	static func sortObservations(from observations: [VNRecognizedTextObservation]) -> [VNRecognizedTextObservation] {
		let yRange: CGFloat = 0.02
		return observations.sorted {
			let midYFirst = $0.boundingBox.midY
			let midYSecond = $1.boundingBox.midY

			if abs(midYFirst - midYSecond) > yRange {
				return midYFirst > midYSecond
			} else {
				return $0.boundingBox.minX < $1.boundingBox.minX
			}
		}
	}

	static func makeReceiptText(from observations: [VNRecognizedTextObservation]) -> [any ReceiptText] {
		let yRange: CGFloat = 0.02

		var receiptText: [any ReceiptText] = []

		let sortedObservations = sortObservations(from: observations)
		let maximumRecognitionCandidates = 1

		var index = 0
		while index < sortedObservations.count - 1 {
			let current = sortedObservations[index]
			let next = sortedObservations[index + 1]

			guard let candidateOne = current.topCandidates(maximumRecognitionCandidates).first else {
				index += 1
				continue
			}
			guard let candidateTwo = next.topCandidates(maximumRecognitionCandidates).first else {
				index += 1
				continue
			}

			let midYCurrent = current.boundingBox.midY
			let midYNext = next.boundingBox.midY

			if abs(midYCurrent - midYNext) <= yRange {
				let key = current.boundingBox.minX < next.boundingBox.minX ? candidateOne.string : candidateTwo.string
				let valueString = current.boundingBox.minX < next.boundingBox.minX ? candidateTwo.string : candidateOne.string

				if let value = Double(valueString) {
					let type: ReceiptItemType = {
						if key.lowercased() == "tax" {
							return .tax
						} else if key.lowercased() == "tip" {
							return .tip
						} else if key.lowercased() == "sub total" {
							return .subTotal
						} else if key.lowercased() == "total" {
							return .total
						} else {
							return .item
						}
					}()

					receiptText.append(ReceiptItem(title: key, cost: value, type: type))
				}
				index += 2
			} else {
				//TODO: reintroduce ReceiptInformation
//				let title = candidateOne.string
//				receiptText.append(ReceiptInformation(title: title))
//
				index += 1
			}
		}

		return receiptText
	}
}
