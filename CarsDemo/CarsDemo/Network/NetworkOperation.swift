//
//  NetworkOperation.swift
//  CarsDemo
//
//  Created by Yasmin Tahira on 2022-01-25.
//

import Foundation

typealias OperationCompletionHandler = (_ success: Bool, _ carInfo: CarInfo?) -> Void

class NetworkOperation: Operation {
    
    var vinString: String?
    
    var timer: Timer?
    
    var timeout: Double = 10.0
    
    let semaphore = DispatchSemaphore(value: 0)

    var operationCompletionHandler: OperationCompletionHandler?

    var carInfo: CarInfo?
    
    let Kplate = "plate"
    let KimagePath = "imagePath"

    fileprivate let apiService: APIServiceInteractor

    //MARK: Operation Methods
    
    required init (carInfo: CarInfo?, withCompletionHandler handler: OperationCompletionHandler?) {
        self.carInfo = carInfo
        if let carInfo = carInfo, let vin = carInfo.vin {
            self.vinString = vin
        }
        self.operationCompletionHandler = handler
        self.apiService = APIService()
    }
    
    override func main() {
        guard isCancelled == false else {
            self.operationCompletionHandler?(false, nil)
            return
        }
        
        self.getVinOverview()
    }
    
    //MARK: Private Methods

    private func getVinOverview() {
        
        guard let vinString = vinString else {
            self.operationCompletionHandler?(false, nil)
            return
        }
        
        self.startTimer()
        
        self.apiService.getCarVinOverviewAPICall(vin: vinString) { success, data, error in
            
            if success == true, let data = data as? [String: Any] {
                if let plate = data[self.Kplate] as? String {
                    self.carInfo?.licensePlate = plate
                }
                if let imagePath = data[self.KimagePath] as? String {
                    self.carInfo?.imagePath = imagePath
                }
                self.handleAPISuccess()
            } else {
                self.handleAPIError()
            }
        }
                        
        semaphore.wait()
    }
    
    private func handleAPISuccess() {
        
        self.invalidateTimer()
        
        self.operationCompletionHandler?(true, self.carInfo)
        
        self.signalSemaphore()
    }

    private func handleAPIError() {
        
        self.invalidateTimer()
        
        self.operationCompletionHandler?(false, nil)
        
        self.signalSemaphore()
    }
    
    @objc private func handleTimeout() {
        
        self.invalidateTimer()
        
        self.operationCompletionHandler?(false, nil)

        self.signalSemaphore()
    }
    
    //MARK: Helper Methods
    
    /// Method to start Timer
    private func startTimer() {
        self.timer = Timer.init(timeInterval: timeout, target: self, selector: #selector(self.handleTimeout), userInfo: nil, repeats: false)
        RunLoop.main.add(self.timer!, forMode: .default)
    }

    /// Method to invalidate Timer
    private func invalidateTimer() {
        self.timer?.invalidate()
    }
    
    /// Method to signal Semaphore
    private func signalSemaphore() {
        semaphore.signal()
    }
}
