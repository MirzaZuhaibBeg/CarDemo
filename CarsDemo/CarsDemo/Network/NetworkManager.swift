//
//  NetworkManager.swift
//  CarsDemo
//
//  Created by Yasmin Tahira on 2022-01-25.
//

import Foundation

class NetworkManager {
    
    /// Get Data From Server Completion block
    internal typealias DataFromServerCompletionClosure = (_ data:Data?, _ response: URLResponse?, _ error: Error?) -> Void

    func makeWebAPICall(request: NSMutableURLRequest, withCompletionBlock completion: @escaping DataFromServerCompletionClosure) {
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            completion(data,response,error)
        })
        task.resume()
    }
}
