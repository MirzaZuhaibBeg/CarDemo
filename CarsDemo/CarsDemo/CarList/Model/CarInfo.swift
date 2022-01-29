//
//  CarInfo.swift
//  CarsDemo
//
//  Created by Yasmin Tahira on 2022-01-25.
//

import Foundation

enum CarStatus: Int {
    case CarStatus_None = 0
    case CarStatus_Open
    case CarStatus_Close
}

struct CarInfo {
   
    var vin: String?
    
    var licensePlate: String?
    
    var imagePath: String?
    
    var lockedStatus: CarStatus = .CarStatus_None
    
    var doorLeftFrontStatus: CarStatus = .CarStatus_None
    var doorRightBackStatus: CarStatus = .CarStatus_None
    var doorLeftBackStatus: CarStatus = .CarStatus_None
    var doorRightFrontStatus: CarStatus = .CarStatus_None

    static func getCarInfoArray(arrayVins: [String]?) -> [CarInfo] {
        
        var carInfoArray = [CarInfo]()
        
        guard let arrayVins = arrayVins else {
            return carInfoArray
        }
        
        for vin in arrayVins {
            var carInfo = CarInfo()
            carInfo.vin = vin
            carInfoArray.append(carInfo)
        }
        
        return carInfoArray
    }
}
