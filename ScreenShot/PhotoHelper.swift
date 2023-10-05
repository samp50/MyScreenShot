//
//  PhotoHelper.swift
//  ScreenShot
//
//  Created by Samuel Phillips on 10/4/23.
//

import Foundation
import Photos

// To-do: Keep a text list of screenshots created with this app
//        Check if potential album name already exists, cancel if so
//        In general, app should detect screenshot, place path to SR
//        in memory for easy retrieval

class PhotoHelper {
    static func createNewPhotoAlbum(albumName: String) {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                PHPhotoLibrary.shared().performChanges({
                    // Create a new album
                    let albumCreationRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
                    
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
                        print("Album '\(albumName)' created successfully")
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
    
    // Return path to most recent photo
    static func fetchMostRecentPhoto() -> String {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 1
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        if let mostRecentPhoto = fetchResult.firstObject {
            print("Most recent photo found: \(mostRecentPhoto.localIdentifier)")
            return mostRecentPhoto.localIdentifier
        } else {
            print("No photos found or access denied")
            return "nil" // This should not happen
        }
        
    }
    
    func handleTap(for index: Int) {
            switch index {
            case 0:
                // Handle tap for the first item
                print("Tapped Item 1")
            case 1:
                // Handle tap for the second item
                print("Tapped Item 2")
            case 2:
                // Handle tap for the third item
                print("Tapped Item 3")
            default:
                break
            }
        }
    
}
