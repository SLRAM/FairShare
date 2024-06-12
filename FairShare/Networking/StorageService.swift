//
//  StorageService.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 6/15/24.
//

import Foundation
import FirebaseStorage

final class StorageService {
	static var storageRef: StorageReference = {
		let ref = Storage.storage().reference()
		return ref
	}()
}

extension StorageService {
	static public func postImage(imageData: Data, imageName: String) async throws -> URL {
		let metadata = StorageMetadata()
		metadata.contentType = Constants.StorageContentType
		let imageRef = storageRef.child(Constants.StorageKeys.ImagesKey + "/\(imageName)")

		let _ = try await imageRef.putDataAsync(imageData, metadata: metadata)
		return try await imageRef.downloadURL()

	}
}
