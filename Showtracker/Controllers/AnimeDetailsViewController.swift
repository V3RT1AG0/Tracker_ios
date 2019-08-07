//
//  AnimeDetailsViewController.swift
//  Showtracker
//
//  Created by Adityaraj Pednekar on 8/6/19.
//  Copyright © 2019 Adityaraj Pednekar. All rights reserved.
//

import UIKit
import PromiseKit
import Alamofire
import SwiftyJSON
import Kingfisher

class AnimeDetailsViewController: UIViewController {
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var Summary: UILabel!
    @IBOutlet weak var Poster: UIImageView!
    var similarUrl:String!
    var charactersUrl:String!
    var CharactersList = [PosterModel]()
    var SimilarList = [PosterModel]()
    var anime:AnimeModel!
    @IBOutlet weak var similarCollection: UICollectionView!
    @IBOutlet weak var characterCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        charactersUrl = Constants.ANIME_URL+"/anime/\(anime.id)/characters_staff"
        similarUrl = Constants.ANIME_URL+"/anime/\(anime.id)/recommendations"
        TitleLabel.text = anime.title
        let url = URL(string: anime.imageUrl)
        Poster.kf.setImage(with: url)
        Summary.text = anime.description
        fetchDataFromApi()
    }
    
    
    func fetchDataFromApi(){
        
        
        
        when(resolved: fetchCharacters(),fetchSimilar()).done{response in
//            print(response)
            if response[0].isFulfilled&&response[1].isFulfilled{
                print("reached2")
                print(self.SimilarList)
                print(self.CharactersList)
                self.similarCollection.reloadData()
               self.characterCollection.reloadData()
                
            }
            else
            {
                print("error fetching data ",response)
            }
        }
    }
    
    
    func fetchSimilar()->Promise<JSON>{
        return Alamofire.request(similarUrl, method: .get).responseJSON()
            .map{jsonResponse in
            
                let json = JSON(jsonResponse.json)
                json["recommendations"].arrayValue.map{item in
                    self.SimilarList.append(PosterModel(title: item["title"].stringValue, imageUrl: item["image_url"].stringValue))
                }
                return json
        }
    }
    
    func fetchCharacters()->Promise<JSON>{
        return Alamofire.request(charactersUrl, method: .get).responseJSON()
            .map{jsonResponse in
                let json = JSON(jsonResponse.json)
                json["characters"].arrayValue.map{item in
//                    print(item)
                    self.CharactersList.append(PosterModel(title: item["name"].stringValue, imageUrl: item["image_url"].stringValue))
                }
//                print(self.CharactersList)
                return json
        }
    }
    
    
}

extension AnimeDetailsViewController:UICollectionViewDelegate,UICollectionViewDataSource{
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView==similarCollection){
            return SimilarList.count
        }
return CharactersList.count
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var item:PosterModel
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCell", for:indexPath) as! PosterCollectionViewCell
        if(collectionView==similarCollection){
            item = SimilarList[indexPath.row]
        }
        else
        {
            item = CharactersList[indexPath.row]
        }
        cell.textView.text = item.title
        let url = URL(string: item.imageUrl)
        cell.imageView.kf.setImage(with: url)
        return cell
    }
    
    
}

