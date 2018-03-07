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
    
    override func layoutSubviews() {
        infoImageView.contentMode = .scaleAspectFit
        infoImageView.clipsToBounds = true
        titleLabel.sizeToFit()
        descriptionLabel.sizeToFit()
        
        self.titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        self.descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    // function to asynchronously load images inside the imageview
    // if the image is present inside the local cache then no need to fetch from the internet
    // if the call could not be completed then insert a default image for broken link
    // If the app extends in functionality, this method can be moved to a separate extension to make it accessible through out the app
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
            if let _ = error {
                DispatchQueue.main.async {
                    // if the request could not load then show a broken url image
                    self.infoImageView.image = #imageLiteral(resourceName: "broken_url.png")
                }
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
            }else{
                DispatchQueue.main.async {
                    self.infoImageView.image = #imageLiteral(resourceName: "broken_url.png")
                }
            }
        }).resume()
    }
}
