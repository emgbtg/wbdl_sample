//
//  ComicDetailsViewController.swift
//  WBDL_Sample
//
//  Created by Eric Gilbert on 10/13/18.
//  Copyright © 2018 Eric Gilbert. All rights reserved.
//

import UIKit

class SeriesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
}
class ComicCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
}

class ComicDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var comicSeriesTitleLabel: UILabel!
    
    @IBOutlet weak var charactersCollectionView: UICollectionView!
    @IBOutlet weak var comicSeriesCollectionView: UICollectionView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var pageCountLabel: UILabel!
    
    var comicsInSeriesDict: [String:String] = [:]
    var characters: [CharacterInfo]!
    var comic: Comic!
    var seriesKeys: [String] = []
    //var series:
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.imageFromServerURL(urlString: comic.thumbnail.path + "." + comic.thumbnail.thumbnailExtension.rawValue)
        titleLabel.adjustsFontSizeToFitWidth = true
        
        titleLabel.text = comic.title
        priceLabel.text = "Price: $" + String(comic.prices[0].price)
        pageCountLabel.text = "Pages: " + String(comic.pageCount)
        
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.text = comic.description ?? "No Description"
        comicSeriesTitleLabel.text = comic.series.name
        
        seriesKeys = Array(comicsInSeriesDict.keys)
        
        comicSeriesCollectionView.delegate  = self
        comicSeriesCollectionView.dataSource = self
        
        charactersCollectionView.delegate = self
        charactersCollectionView.dataSource = self
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width/2-10, height: 240)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        comicSeriesCollectionView.collectionViewLayout = flowLayout
        
        let flowLayout2 = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 118, height: 240)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        charactersCollectionView.collectionViewLayout = flowLayout2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return comicsInSeriesDict.count
        } else if collectionView.tag == 1{
            return characters.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seriesCell", for: indexPath as IndexPath) as! SeriesCollectionViewCell
            cell.titleLabel.adjustsFontSizeToFitWidth = true
            cell.titleLabel.text = seriesKeys[indexPath.row]
            
            let thumbnailURL = comicsInSeriesDict[seriesKeys[indexPath.row]]
            cell.imageView.imageFromServerURL(urlString:thumbnailURL ?? "")
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "charactersCell", for: indexPath as IndexPath) as! ComicCollectionViewCell
            cell.titleLabel.adjustsFontSizeToFitWidth = true
            cell.titleLabel.text = characters[indexPath.row].name
            
            let thumbnailURL = characters[indexPath.row].thumbnail.path + "." + characters[indexPath.row].thumbnail.thumbnailExtension.rawValue
            cell.imageView.imageFromServerURL(urlString: thumbnailURL)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){

    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
