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
    @IBOutlet weak var containerView: UIView!
    
}

class ComicListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, UIScrollViewDelegate {
    
    
    
    @IBOutlet weak var parallaxScrollview: UIScrollView!
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
        
        searchTextField.delegate = self
        parallaxScrollview.isScrollEnabled = true
        parallaxScrollview.contentSize = CGSize(width: self.view.frame.size.width, height: 3000)
        
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
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
        
        cell.containerView.layer.cornerRadius = 8
        cell.containerView.layer.masksToBounds = true

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
        collectionView.allowsSelection = false
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
        collectionView.allowsSelection = true
        performSegue(withIdentifier: "toDetail", sender: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        if textField.text != "" {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            
            networking.getComics(searchQuerry: textField.text!, dataLoadedCallbackFunction: searchLoaded)
        }
        
        return true
    }
    
    // controlls parallax scrolling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        parallaxScrollview.contentOffset.y = collectionView.contentOffset.y * 0.1
        print(parallaxScrollview.contentOffset.y)
    }
    func searchLoaded() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        
        collectionView.reloadData()
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
extension CALayer {
    func applyShadow(
        color: UIColor = .black,
        alpha: Float = 0.1,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 1)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
extension UIScrollView {
    func updateContentView() {
        contentSize.height = subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? contentSize.height
    }
}
