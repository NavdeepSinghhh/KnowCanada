//
//  InfoCell.swift
//  KnowCanada
//
//  Created by Navdeep's Mac on 3/3/18.
//  Copyright © 2018 Navdeep. All rights reserved.
//

import UIKit

class InfoCell: UITableViewCell {
    
    
    @IBOutlet weak var infoImageView: UIImageView! 
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var imageUrlString : String?
    
    let imageCache = NSCache<NSString , UIImage>()
    func setupInfoImage(){
        if let propertyImageUrl = infoModel?.imageHref{
            // Call the method to load images asynchronously
            self.loadImageUsingURLString(urlString: propertyImageUrl)
        }
    }
    
    var infoModel : InfoModel? {
        didSet {
            self.titleLabel.text = nil
            self.descriptionLabel.text = nil
            self.infoImageView.image = nil
            if let infoModel = infoModel {
                self.titleLabel.text = infoModel.title
                if let description = infoModel.description{
                    self.descriptionLabel.text = description
                    setupInfoImage()
                }
            }
        }
    }
    
    func loadImageUsingURLString(urlString: String){
        
        imageUrlString = urlString
        guard let url = URL(string: urlString) else {
            return
        }
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString){
            DispatchQueue.main.async {
                self.infoImageView.image = imageFromCache
            }
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print(error)
                return
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                DispatchQueue.main.async {
                    if let imageToBeStoredInCache = UIImage(data: data){
                        if self.imageUrlString == urlString{
                            self.infoImageView.image = imageToBeStoredInCache
                        }
                        self.imageCache.setObject(imageToBeStoredInCache, forKey: urlString as NSString)
                    }
                }
            }
        }).resume()
    }
}
