//
//  ImageCachable.swift
//  iOS Proficiency Exercise
//
//  Created by Saipujith on 27/06/20.
//  Copyright © 2020 Saipujith. All rights reserved.
//

import Foundation
import UIKit

//1 Create the protocol
protocol ImageCachable {}

//2 creating a imageCache private instance
private  let imageCache = NSCache<NSString, UIImage>()

//3 UIImageview conforms to Cachable
extension UIImageView: ImageCachable {}

//4 creating a protocol extension to add optional function implementations,
extension ImageCachable where Self: UIImageView {
    
    //5 creating the function
    typealias SuccessCompletion = (Bool) -> ()
    func loadImageUsingCacheWithURLString(_ URLString: String, placeHolder: UIImage?, completion: @escaping SuccessCompletion) {
        
        self.image = nil
        if let cachedImage = imageCache.object(forKey: NSString(string: URLString)) {
            DispatchQueue.main.async {
                self.image = cachedImage
                completion(true)//Image exists then returning true
            }
            return
        }else{
            self.image = placeHolder
            if let url = URL(string: URLString) {
                URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                    if(error == nil){
                        guard let httpResponse = response as? HTTPURLResponse else {
                            return
                        }
                        if httpResponse.statusCode == 200 {
                            
                            if let data = data {
                                if let downloadedImage = UIImage(data: data) {
                                    imageCache.setObject(downloadedImage, forKey: NSString(string: URLString))
                                    DispatchQueue.main.async {
                                        self.image = downloadedImage
                                        completion(true)
                                    }
                                }
                            }
                        }
                        else {
                            DispatchQueue.main.sync {
                                self.image = placeHolder
                                completion(false)//If Image doesnt exists then returning false
                            }
                        }}else{
                        DispatchQueue.main.async {
                            self.image = placeHolder
                            completion(false)
                        }          }
                }).resume()
            } else {
                DispatchQueue.main.async {
                    self.image = placeHolder
                    completion(false)
                }
            }
        }
    }
}


