//
//  CarListViewModel.swift
//  CarsDemo
//
//  Created by Yasmin Tahira on 2022-01-25.
//

import Foundation

protocol CarListViewModelProtocol: AnyObject {
   
    func populateCarList()
    
    func updateCarOverview(carInfo: CarInfo?)
}

class CarListViewModel {
    
    weak var delegate: CarListViewModelProtocol?

    var carInfoArray: [CarInfo]?
      
    // apiService is mandatory for presenter to work, should be initialised in init
    fileprivate let apiService: APIServiceInteractor

    required init(service: APIServiceInteractor) {
        self.apiService = service
    }

    func attachView(view: CarListViewModelProtocol) {
        self.delegate = view
    }
    
    func getCarList() {
        self.apiService.getCarVinsListAPICall { success, data, error in
            if let data = data as? [String: Any], let vins = data["vins"] as? [String] {
                self.carInfoArray = CarInfo.getCarInfoArray(arrayVins: vins)
            }
            self.delegate?.populateCarList()
        }
    }
    
    func getCarOverview() {
        NetworkOperationManager.sharedInstance.getVinOverview(carInfoArray: self.carInfoArray) { carInfo in
            
            // update self.carInfoArray with carInfo
            if let carInfoArray = self.carInfoArray {
                var indexVin: Int?
                for (index, carInfoCurrent) in carInfoArray.enumerated() {
                    if let carInfo = carInfo, let currentVin = carInfoCurrent.vin, let vin = carInfo.vin, vin == currentVin {
                        indexVin = index
                        break
                    }
                }
                if let indexVin = indexVin, let carInfo = carInfo {
                    self.carInfoArray?[indexVin] = carInfo
                }
            }
            
            self.delegate?.updateCarOverview(carInfo: carInfo)
        }
    }
    
    func cancelAllCarOverviewRequest() {
        NetworkOperationManager.sharedInstance.cancelAllVinOverviewRequest()
    }
}
