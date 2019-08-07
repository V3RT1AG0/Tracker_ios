//
//  HomeViewController.swift
//  Showtracker
//
//  Created by Adityaraj Pednekar on 7/19/19.
//  Copyright © 2019 Adityaraj Pednekar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher


class HomeViewController: UIViewController {
    @IBOutlet weak var AnimeTableView: UITableView!
    
    var animeModelList = [AnimeModel]()
    let seasonalUrl = Constants.ANIME_URL + "/season/2019/summer"

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDataFromApi()
        // Do any additional setup after loading the view.
    }
    

    func fetchDataFromApi(){
        Alamofire.request(seasonalUrl).responseJSON { response in
            if response.result.isSuccess{
                let data = JSON(response.result.value)
                self.parseJsonData(data: data)
            }
            else{
                print("error")
            }
        }
    }
    
    func parseJsonData(data:JSON){
        data["anime"].arrayValue.map{item in
            let anime = AnimeModel(title:item["title"].stringValue,imageUrl:item["image_url"].stringValue,
                                   description: item["synopsis"].stringValue,id: item["mal_id"].intValue)
            animeModelList.append(anime)
        }
        AnimeTableView.reloadData()
       
    }

}

extension HomeViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animeModelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let anime = animeModelList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnimeCell") as! AnimeTableViewCell
        cell.Title.text = anime.title
        let url = URL(string: anime.imageUrl)
        cell.Poster.kf.setImage(with: url)
        cell.Description.text = anime.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = storyboard?.instantiateViewController(withIdentifier: "AnimeDetailsViewController") as? AnimeDetailsViewController
        let anime = animeModelList[indexPath.row]
        vc?.anime = anime
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
}
