//
//  ComicListViewController.swift
//  WBDL_Sample
//
//  Created by Eric Gilbert on 10/11/18.
//  Copyright © 2018 Eric Gilbert. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    
}

class ComicListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    let networking = Networking()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up collectionview
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 23, left: 16, bottom: 10, right: 16)

        networking.getComics(dataLoadedCallbackFunction: dataLoaded)
    }
    func dataLoaded() {
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return networking.comics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! CollectionViewCell
        cell.label.adjustsFontSizeToFitWidth = true
        cell.label.text = self.networking.comics[indexPath.row].title
        
        let thumbnailURL = self.networking.comics[indexPath.row].thumbnail.path + "." + self.networking.comics[indexPath.row].thumbnail.thumbnailExtension.rawValue
        cell.imageView.imageFromServerURL(urlString:thumbnailURL)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()

        return true
    }

}

// extension to load images from url into an imageview
extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        self.image = nil
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }}
