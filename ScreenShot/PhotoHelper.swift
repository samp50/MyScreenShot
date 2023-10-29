//
//  PhotoHelper.swift
//  ScreenShot
//
//  Created by Samuel Phillips on 10/4/23.
//

import Foundation
import Photos
import UIKit

// To-do: Keep a text list of screenshots created with this app
//        Check if potential album name already exists, cancel if so
//        In general, app should detect screenshot, place path to SR
//        in memory for easy retrieval

class PhotoHelper {
    func addImageToAlbum(image: PHAsset, albumName: String) {
        if doesAlbumExist(albumTitle: albumName) {
            print("Adding to preexisting album: \(albumName)")
            addAssetToAlbum(asset: image, albumName: albumName)
            
        } else {
            PHPhotoLibrary.shared().performChanges {
                let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
                createAlbumRequest.addAssets([image] as NSFastEnumeration)
            } completionHandler: { success, error in
                if success {
                    print("Image added to album successfully.")
                } else if let error = error {
                    print("Error adding image to album: \(error)")
                }
            }
        }
    }
    
    func addExistingAssetToAlbum(albumName: String, asset: PHAsset) {
        // Fetch the album with the specified name
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        let album = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions).firstObject

        if let album = album {
            // Create a change request to add the asset to the album
            PHPhotoLibrary.shared().performChanges {
                let assetChangeRequest = PHAssetChangeRequest(for: asset)
                guard let albumChangeRequest = PHAssetCollectionChangeRequest(for: album) else {
                    return
                }
                albumChangeRequest.addAssets([assetChangeRequest.placeholderForCreatedAsset] as NSArray)
            } completionHandler: { (success, error) in
                if success {
                    print("Asset added to the album.")
                } else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        } else {
            print("Album not found.")
        }
    }
    
    func doesAlbumExist(albumTitle: String) -> Bool {
        // Create a predicate to search for the album by title
        let albumFetchOptions = PHFetchOptions()
        albumFetchOptions.predicate = NSPredicate(format: "title = %@", albumTitle)
        
        // Fetch user's albums
        let userAlbums = PHAssetCollection.fetchAssetCollections(
            with: .album,
            subtype: .any,
            options: albumFetchOptions
        )
        
        // If there's at least one album with the given title, return true
        return userAlbums.count > 0
    }
    
    
    
    func fetchMostRecentImage() -> PHAsset? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        return fetchResult.firstObject
    }
    
    static func createNewPhotoAlbum(albumName: String) {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                PHPhotoLibrary.shared().performChanges({
                    // Create a new album
                    let albumCreationRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
                    let newAlbumPlaceholder = albumCreationRequest.placeholderForCreatedAssetCollection
                    
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
    
    public func imageFromAsset(asset: PHAsset) -> UIImage? {
        let imageManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = false
        requestOptions.deliveryMode = .highQualityFormat
        
        var resultImage: UIImage?
        
        // Use a semaphore to make the request synchronous
        let semaphore = DispatchSemaphore(value: 0)
        
        imageManager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFit, options: requestOptions) { (image, info) in
            resultImage = image
            semaphore.signal()
        }
        
        // Wait for the request to complete
        semaphore.wait()
        
        return resultImage
    }
    
    static func getUIImage(asset: PHAsset, completion: @escaping (UIImage?) -> Void) {
        let imageManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = false
        requestOptions.deliveryMode = .highQualityFormat
        
        imageManager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFit, options: requestOptions) { (image, info) in
            completion(image)
        }
    }
    
    // Return path to most recent photo
    static func fetchMostRecentPhoto() -> PHFetchResult<PHAsset>? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 1
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        if let mostRecentPhoto = fetchResult.firstObject {
            print("Most recent photo found: \(mostRecentPhoto.localIdentifier)")
            var mostRecentAsset = PHAsset.fetchAssets(withLocalIdentifiers: [mostRecentPhoto.localIdentifier], options: nil)
            return mostRecentAsset
        } else {
            print("No photos found or access denied")
            //return "nil" // This should not happen
            return nil
        }
        
    }
    
    func addAssetToAlbum(asset: PHAsset, albumName: String) {
        // Fetch the photo album by its name
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        let album = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if let firstAlbum = album.firstObject {
            // Album found, now add the asset to it
            PHPhotoLibrary.shared().performChanges {
                let assetChangeRequest = PHAssetCollectionChangeRequest(for: firstAlbum)
                assetChangeRequest?.addAssets([asset] as NSFastEnumeration)
            } completionHandler: { success, error in
                if success {
                    print("Asset added to the album successfully.")
                } else {
                    print("Error adding asset to the album: \(error?.localizedDescription ?? "Unknown error").")
                }
            }
        } else {
            print("Album not found.")
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
