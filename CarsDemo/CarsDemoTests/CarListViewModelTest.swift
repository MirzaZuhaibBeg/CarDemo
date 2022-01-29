//
//  CarListViewModelTest.swift
//  CarsDemoTests
//
//  Created by Yasmin Tahira on 27/01/22.
//

import XCTest
@testable import CarsDemo

class MockAPIService: APIServiceInteractor {
    func getCarVinsListAPICall(withCompletionBlock completion: @escaping CompletionBlock) {
        completion(true, Data(), nil)
    }
    
    func getCarVinOverviewAPICall(vin: String, withCompletionBlock completion: @escaping CompletionBlock) {
        completion(true, Data(), nil)
    }
    
    func getCarLockStatusAPICall(vin: String, withCompletionBlock completion: @escaping CompletionBlock) {
        completion(true, Data(), nil)
    }
    
    func getCarDoorsAndWindowsAPICall(vin: String, withCompletionBlock completion: @escaping CompletionBlock) {
        completion(true, Data(), nil)
    }
}

class CarListMockView: CarListViewModelProtocol {
    
    var populateCarListDelegateCalled = false
    var updateCarOverviewDelegateCalled = false

    func populateCarList() {
        self.populateCarListDelegateCalled = true
    }
    
    func updateCarOverview(carInfo: CarInfo?) {
        self.updateCarOverviewDelegateCalled = true
    }
}

class CarListViewModelTest: XCTestCase {

    var sut: CarListViewModel?
    
    let viewMock = CarListMockView()

    override func setUpWithError() throws {
        sut = CarListViewModel(service: MockAPIService())
        sut?.attachView(view: viewMock)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetCarList() {
        self.sut?.getCarList()
        XCTAssertTrue(self.viewMock.populateCarListDelegateCalled)
    }
    
    func testGetCarOverview() {
        self.sut?.getCarOverview()
        XCTAssertTrue(self.viewMock.updateCarOverviewDelegateCalled)
    }
}
