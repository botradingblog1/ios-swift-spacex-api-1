//
//  PhotosViewController.swift
//  SpaceX
//
//  Created by Chris Scheid on 3/3/18.
//  Copyright © 2018 Chris Scheid. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class PhotosViewController: UIViewController {
    var photoArray = [Photo]()
    let itemsPerRow: CGFloat = 2
    let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    var alertShown = false

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var newCollectionButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the photos - either from core data or Flickr
        loadPhotos()
    }

    // Load photos - either from Flickr or cached from Core Data
    func loadPhotos(){
        // clear photo array
        self.photoArray = [Photo]()
        
        startSpinner(spin: true)
        if let fetchResult = fetchPhotosFromCache() {
            startSpinner(spin: false)
            photoArray = fetchResult
            collectionView.reloadData()

        } else {
            // Fetch images from Flickr
            FlickrApiClient.getPhotoImages() { (imageUrls, error) in
                
                DispatchQueue.main.async {
                    self.startSpinner(spin: false)
                }
                
                // handle network errors
                if(!(error?.isEmpty)!){
                    DispatchQueue.main.async {
                        self.showError(error: error!)
                    }
                }
                else if (imageUrls == nil || imageUrls?.count == 0)
                {
                    DispatchQueue.main.async {
                        self.showError(error: "No Images found.")
                    }
                }
                else{
                    if let imageUrls = imageUrls {
                        for imageUrl in imageUrls {
                            // Store image url as a Photo
                            let photo = Photo(context: CoreDataStack.shared.context)
                            photo.url = imageUrl
                            photo.id = Utils.getUniqueId()
                            photo.title = imageUrl
                            
                            // add photo to array
                            self.photoArray.append(photo)
                        }
                        // Save Core Data
                        CoreDataStack.shared.save()
                        
                        DispatchQueue.main.async {
                            // Reload the collection view
                            self.collectionView.reloadData()
                        }
                    }
                    
                }
            }
        }
    }
    
    @IBAction func refreshButtonAction(_ sender: Any) {
        infoLabel.isHidden = true;
        collectionView.isHidden = false;
        alertShown = false
        
        // Delete all existing photos
        for photo in photoArray {
            CoreDataStack.shared.context.delete(photo)
        }
        
        CoreDataStack.shared.save()
        photoArray = [Photo]()
        collectionView.reloadData()
        
        // Get new set of photos
        loadPhotos()
    }
    
    private func fetchPhotosFromCache() -> [Photo]? {
        
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
            
            if let result = try CoreDataStack.shared.context.fetch(fetchRequest) as? [Photo] {
                return result.count > 0 ? result : nil
            }
        } catch {
            DispatchQueue.main.async {
                self.showError(error: "Error loading photos from cache")
            }
        }
        return nil
    }
    
    func showError(error: String){
        let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func startSpinner(spin: Bool){
        DispatchQueue.main.async{
            self.activityIndicator.isHidden = !spin
            if (spin){
                self.activityIndicator.startAnimating()
            }
            else{
                self.activityIndicator.stopAnimating()
            }
        }
    }
}

// Collection View
extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegate {
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        let photo = self.photoArray[indexPath.row]
        
        // Set placeholder picture
        cell.imageView.image = UIImage(named: "icons8-picture-2")
        cell.activityIndicator.isHidden = false
        cell.activityIndicator.startAnimating()
        
        if let imageData = photo.image {
            let image = UIImage(data: imageData as Data)
            cell.activityIndicator.isHidden = true
            cell.activityIndicator.stopAnimating()
            cell.imageView.image = image

        } else {
            FlickrApiClient.getImage(with: photo.url!) { (data, error) in
                // Hide activity indicator
                DispatchQueue.main.async {
                    cell.activityIndicator.isHidden = true
                    cell.activityIndicator.stopAnimating()
                }

                if error == nil {
                    photo.image = data as NSData?
                    
                    DispatchQueue.main.async {
                        // Reload the collection view
                        self.collectionView.reloadData()
                    }
                }
                else {
                    // getImage returned an error
                    // -> Show allert only once
                    if (!self.alertShown){
                        self.alertShown = true;
                        DispatchQueue.main.async {
                            self.showError(error: error!)
                        }
                    }

                }
            }
        }
        
        return cell
    }
    
    func setupFlowLayout() {
        collectionView.allowsMultipleSelection = true
        
        let space: CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
}
