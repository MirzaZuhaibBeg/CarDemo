//
//  CarDetailViewModel.swift
//  CarsDemo
//
//  Created by Yasmin Tahira on 2022-01-25.
//

import Foundation

protocol CarDetailViewModelProtocol: AnyObject {
   
    func populateCarLockStatus()
    
    func populateCarDoorWindowsStatus()
}

class CarDetailViewModel {
    
    weak var delegate: CarDetailViewModelProtocol?

    var carInfo: CarInfo?
       
    // apiService is mandatory for presenter to work, should be initialised in init
    fileprivate let apiService: APIServiceInteractor

    required init(service: APIServiceInteractor) {
        self.apiService = service
    }

    func attachView(view: CarDetailViewModelProtocol) {
        self.delegate = view
    }
    
    func getCarLockStatus() {
        guard let carInfo = self.carInfo, let vin = carInfo.vin else {
            return
        }
        
        self.apiService.getCarLockStatusAPICall(vin: vin) { success, data, error in
            if let data = data as? [String: Any], let locked = data["locked"] as? Int, locked == 1 {
                self.carInfo?.lockedStatus = .CarStatus_Close
            } else {
                self.carInfo?.lockedStatus = .CarStatus_Open
            }
            self.delegate?.populateCarLockStatus()
        }
    }
    
    func getCarDoorWindowsStatus() {
        guard let carInfo = self.carInfo, let vin = carInfo.vin else {
            return
        }
        
        self.apiService.getCarDoorsAndWindowsAPICall(vin: vin) { success, data, error in
            
            if let data = data as? [String: Any] {

                if let doorLeftFront = data["doorLeftFront"] as? String {
                    self.carInfo?.doorLeftFrontStatus = (doorLeftFront == "closed") ? CarStatus.CarStatus_Close : CarStatus.CarStatus_Open
                }
                
                if let doorRightBack = data["doorRightBack"] as? String {
                    self.carInfo?.doorRightBackStatus = (doorRightBack == "closed") ? CarStatus.CarStatus_Close : CarStatus.CarStatus_Open
                }
                
                if let doorLeftBack = data["doorLeftBack"] as? String {
                    self.carInfo?.doorLeftBackStatus = (doorLeftBack == "closed") ? CarStatus.CarStatus_Close : CarStatus.CarStatus_Open
                }
                
                if let doorRightFront = data["doorRightFront"] as? String {
                    self.carInfo?.doorRightFrontStatus = (doorRightFront == "closed") ? CarStatus.CarStatus_Close : CarStatus.CarStatus_Open
                }
            }
            
            self.delegate?.populateCarDoorWindowsStatus()
        }
    }
}
