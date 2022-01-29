//
//  NetworkOperationManager.swift
//  CarsDemo
//
//  Created by Yasmin Tahira on 2022-01-25.
//

import Foundation

typealias NetworkOperationManagerUpdateHandler = (_ carInfo: CarInfo?) -> Void

class NetworkOperationManager {
    
    var updateHandler: NetworkOperationManagerUpdateHandler?

    static let sharedInstance: NetworkOperationManager = {
        
        let networkOperationManager = NetworkOperationManager()
        networkOperationManager.operationQueue.maxConcurrentOperationCount = 1
        return networkOperationManager
    }()
    
    var operationQueue = OperationQueue()
    
    func getVinOverview(carInfoArray: [CarInfo]?, withUpdateHandler handler: NetworkOperationManagerUpdateHandler?) {
        
        self.updateHandler = handler
        
        guard let carInfoArray = carInfoArray else {
            return
        }
        
        for carInfo in carInfoArray {
            
            let operation = NetworkOperation(carInfo: carInfo) { success, carInfo in
                self.updateHandler?(carInfo)
            }
            
            NetworkOperationManager.sharedInstance.operationQueue.addOperation(operation)
        }
    }
    
    func cancelAllVinOverviewRequest() {
        NetworkOperationManager.sharedInstance.operationQueue.cancelAllOperations()
    }
}
