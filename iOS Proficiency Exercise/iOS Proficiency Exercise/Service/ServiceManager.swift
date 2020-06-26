//
//  ServiceManager.swift
//  iOS Proficiency Exercise
//
//  Created by Saipujith on 26/06/20.
//  Copyright © 2020 Saipujith. All rights reserved.
//
import UIKit

class ServiceManager: NSObject {

    static let sharedInstance = ServiceManager()
    func getData(baseURL: String, onSuccess: @escaping(Data) -> Void, onFailure: @escaping(Error) -> Void) {
        let url : String = baseURL
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest,
                                    completionHandler: {data, _, error -> Void in
            if(error != nil) {
                onFailure(error!)
            } else {
                guard let data = data else {
                    print(String(describing: error))
                    return
                }
                let str = String(decoding: data, as: UTF8.self)
                let jsonData = str.data(using: .utf8)!
                onSuccess(jsonData)
            }
        })
        task.resume()
    }
}
