//
//  APIService.swift
//  CarsDemo
//
//  Created by Yasmin Tahira on 2022-01-25.
//

import Foundation

typealias CompletionBlock = (_ success: Bool, _ data: Any?, _ error: String?) -> Void

public struct ServiceHelperConstant {
    
    public static let KSuccessCode = 200
    
    // should obfuscate key instead of directly writing the key in code
    public static let KAPIKeyValue = "5040E884-11DF-4450-809F-E339506E1377"
    
    public static let KGET = "GET"
}

protocol APIServiceInteractor {
    
    func getCarVinsListAPICall(withCompletionBlock completion: @escaping CompletionBlock)

    func getCarVinOverviewAPICall(vin: String, withCompletionBlock completion: @escaping CompletionBlock)
    
    func getCarLockStatusAPICall(vin: String, withCompletionBlock completion: @escaping CompletionBlock)

    func getCarDoorsAndWindowsAPICall(vin: String, withCompletionBlock completion: @escaping CompletionBlock)
}

class APIService: APIServiceInteractor {
    
    typealias ErrorBlock = (_ error: String?) -> Void

    typealias ParseDataCompletionBlock = (_ success: Bool, _ data: Any?, _ error: Error?) -> Void

    let baseURL = "https://lynkco-interview-test.herokuapp.com/"
    
    let KCarsAPI = "cars/"
    let KOverviewAPI = "/overview"
    let KDoorsandwindowsAPI = "/doorsandwindows"
    let KLockstatusAPI = "/lockstatus"
    
    //MARK: APIServiceInteractor Methods

    func getCarVinsListAPICall(withCompletionBlock completion: @escaping CompletionBlock) {

        let api : String = self.baseURL + self.KCarsAPI
        guard let request: NSMutableURLRequest = self.getGETURLRequest(nil, api: api)  else {
            completion(false,nil,nil)
            return
        }
                
        let networkManager = NetworkManager()
        networkManager.makeWebAPICall(request: request) { [weak self] (data, response, error) in
            if let data = data, let httpResponse = response as? HTTPURLResponse,  httpResponse.statusCode == ServiceHelperConstant.KSuccessCode {
                self?.parseData(withData: data, completionHandler: { (success, data, error) in
                    completion(success, data, error?.localizedDescription)
                })
            } else {
                if let error = error {
                    completion(false, nil, error.localizedDescription)
                } else {
                    completion(false, nil, "Something went wrong")
                }
            }
        }
    }
    
    func getCarVinOverviewAPICall(vin: String, withCompletionBlock completion: @escaping CompletionBlock) {

        let api : String = self.baseURL + self.KCarsAPI + vin + self.KOverviewAPI
        guard let request: NSMutableURLRequest = self.getGETURLRequest(nil, api: api)  else {
            completion(false,nil,nil)
            return
        }
                
        let networkManager = NetworkManager()
        networkManager.makeWebAPICall(request: request) { [weak self] (data, response, error) in
            if let data = data, let httpResponse = response as? HTTPURLResponse,  httpResponse.statusCode == ServiceHelperConstant.KSuccessCode {
                self?.parseData(withData: data, completionHandler: { (success, data, error) in
                    completion(success, data, error?.localizedDescription)
                })
            } else {
                if let error = error {
                    completion(false, nil, error.localizedDescription)
                } else {
                    completion(false, nil, "Something went wrong")
                }
            }
        }
    }
    
    func getCarLockStatusAPICall(vin: String, withCompletionBlock completion: @escaping CompletionBlock) {

        let api : String = self.baseURL + self.KCarsAPI + vin + self.KLockstatusAPI
        guard let request: NSMutableURLRequest = self.getGETURLRequest(nil, api: api)  else {
            completion(false,nil,nil)
            return
        }
                
        let networkManager = NetworkManager()
        networkManager.makeWebAPICall(request: request) { [weak self] (data, response, error) in
            if let data = data, let httpResponse = response as? HTTPURLResponse,  httpResponse.statusCode == ServiceHelperConstant.KSuccessCode {
                self?.parseData(withData: data, completionHandler: { (success, data, error) in
                    completion(success, data, error?.localizedDescription)
                })
            } else {
                if let error = error {
                    completion(false, nil, error.localizedDescription)
                } else {
                    completion(false, nil, "Something went wrong")
                }
            }
        }
    }

    func getCarDoorsAndWindowsAPICall(vin: String, withCompletionBlock completion: @escaping CompletionBlock) {

        let api : String = self.baseURL + self.KCarsAPI + vin + self.KDoorsandwindowsAPI
        guard let request: NSMutableURLRequest = self.getGETURLRequest(nil, api: api)  else {
            completion(false,nil,nil)
            return
        }
                
        let networkManager = NetworkManager()
        networkManager.makeWebAPICall(request: request) { [weak self] (data, response, error) in
            if let data = data, let httpResponse = response as? HTTPURLResponse,  httpResponse.statusCode == ServiceHelperConstant.KSuccessCode {
                self?.parseData(withData: data, completionHandler: { (success, data, error) in
                    completion(success, data, error?.localizedDescription)
                })
            } else {
                if let error = error {
                    completion(false, nil, error.localizedDescription)
                } else {
                    completion(false, nil, "Something went wrong")
                }
            }
        }
    }
        
    //MARK: Private Methods
    
    func getGETURLRequest(_ parameters: [String: Any]?, api: String) -> NSMutableURLRequest? {
        if let url = URL(string: api) {
            let request: NSMutableURLRequest = NSMutableURLRequest(url: url)
            request.httpMethod = ServiceHelperConstant.KGET
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(ServiceHelperConstant.KAPIKeyValue, forHTTPHeaderField: "token")
            return request
        } else {
            return nil
        }
    }
    
    fileprivate func parseData(withData data: Data, completionHandler: @escaping ParseDataCompletionBlock) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
            if let json = json {
                
                #if DEBUG
                print("json")
                print(json)

                #else
           
                #endif
                
                completionHandler(true, json, nil)
            } else {
                completionHandler(false, nil, nil)
            }
        } catch let error {
            completionHandler(false, nil, error)
        }
    }
}
