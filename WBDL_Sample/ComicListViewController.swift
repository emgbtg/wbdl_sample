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
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    let networking = Networking()
    var selectedComic: Comic!
    var loadedCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        // set up collectionview
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 23, left: 16, bottom: 10, right: 16)
        
        networking.getComics(dataLoadedCallbackFunction: dataLoaded)
    }
    func dataLoaded() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        selectedComic = networking.comics[indexPath.row]
        networking.getComicDetails(comic: selectedComic, dataLoadedCallbackFunction: detailLoaded)
        networking.getAllCharactersInComic(items: selectedComic.characters.items , dataLoadedCallbackFunction: detailLoaded)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC = segue.destination as! ComicDetailsViewController
        detailVC.characters = self.networking.comicCharactersArray
        detailVC.comicsInSeriesDict = self.networking.seriesComicsDict
        detailVC.comic = self.selectedComic
    }
    func detailLoaded() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        
        performSegue(withIdentifier: "toDetail", sender: self)
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
