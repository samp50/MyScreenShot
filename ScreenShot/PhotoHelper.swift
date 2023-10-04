//
//  PhotoHelper.swift
//  ScreenShot
//
//  Created by Samuel Phillips on 10/4/23.
//

import Foundation
import Photos

class PhotoHelper {
    static func createNewPhotoAlbum() {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                PHPhotoLibrary.shared().performChanges({
                    // Create a new album
                    let albumCreationRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: "My New Album")
                    
                    // Get the newly created album
                    let newAlbumPlaceholder = albumCreationRequest.placeholderForCreatedAssetCollection
                    
                    // Add assets to the album if needed
                    // For example, you can add photos to the album using:
                    // let assets = [PHAsset]() // An array of PHAssets to add
                    // let albumChangeRequest = PHAssetCollectionChangeRequest(for: newAlbumPlaceholder)
                    // albumChangeRequest?.addAssets(assets as NSFastEnumeration)
                    
                }, completionHandler: { success, error in
                    if success {
                        // The album was created successfully
                        print("Album created successfully")
                    } else {
                        // Handle the error
                        print("Error creating album: \(error?.localizedDescription ?? "Unknown Error")")
                    }
                })

            } else {
                // Handle the case where the user denied access
            }
        }

    }
}
