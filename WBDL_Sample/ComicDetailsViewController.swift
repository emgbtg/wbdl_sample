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
class ComicDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var comicSeriesTitleLabel: UILabel!
    
    @IBOutlet weak var comicSeriesCollectionView: UICollectionView!
    var comicsInSeriesDict: [String:String] = [:]
    var characters: [CharacterInfo]!
    var comic: Comic!
    var seriesKeys: [String] = []
    //var series:
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.imageFromServerURL(urlString: comic.thumbnail.path + "." + comic.thumbnail.thumbnailExtension.rawValue)
        descriptionLabel.text = comic.description ?? "No Description"
        comicSeriesTitleLabel.text = comic.series.name
        
        seriesKeys = Array(comicsInSeriesDict.keys)
        
        

        comicSeriesCollectionView.delegate = self
        comicSeriesCollectionView.dataSource = self
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width/2-10, height: 190)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        comicSeriesCollectionView.collectionViewLayout = flowLayout
//        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.itemSize = CGSize(UIScreen.main.bounds.width/2 - 10, 190)
//        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
//        flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
//        flowLayout.minimumInteritemSpacing = 0.0
//        comicSeriesCollectionView.collectionViewLayout = flowLayout
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comicsInSeriesDict.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seriesCell", for: indexPath as IndexPath) as! SeriesCollectionViewCell
        cell.titleLabel.adjustsFontSizeToFitWidth = true
        cell.titleLabel.text = seriesKeys[indexPath.row]
        
        let thumbnailURL = comicsInSeriesDict[seriesKeys[indexPath.row]]
        //let thumbnailURL = self.networking.comics[indexPath.row].thumbnail.path + "." + self.networking.comics[indexPath.row].thumbnail.thumbnailExtension.rawValue
        cell.imageView.imageFromServerURL(urlString:thumbnailURL ?? "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
//        selectedComic = networking.comics[indexPath.row]
//        networking.getComicDetails(comic: selectedComic, dataLoadedCallbackFunction: detailLoaded)
//        if selectedComic.characters.items.count > 0 {
//            networking.getAllCharactersInComic(items: selectedComic.characters.items , dataLoadedCallbackFunction: detailLoaded)
//        }
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
