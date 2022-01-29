//
//  CarDetailViewModelTest.swift
//  CarsDemoTests
//
//  Created by Yasmin Tahira on 27/01/22.
//

import XCTest
@testable import CarsDemo

class CarDetailMockView: CarDetailViewModelProtocol {
    
    var populateCarLockStatusDelegateCalled = false
    var populateCarDoorWindowsStatusDelegateCalled = false

    func populateCarLockStatus() {
        self.populateCarLockStatusDelegateCalled = true
    }
    
    func populateCarDoorWindowsStatus() {
        self.populateCarDoorWindowsStatusDelegateCalled = true
    }
}

class CarDetailViewModelTestTest: XCTestCase {

    var sut: CarDetailViewModel?
    
    let viewMock = CarDetailMockView()

    override func setUpWithError() throws {
        sut = CarDetailViewModel(service: MockAPIService())
        sut?.attachView(view: viewMock)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func getCarLockStatus() {
        self.sut?.getCarLockStatus()
        XCTAssertTrue(self.viewMock.populateCarLockStatusDelegateCalled)
    }
    
    func testGetCarDoorWindowsStatus() {
        self.sut?.getCarDoorWindowsStatus()
        XCTAssertTrue(self.viewMock.populateCarDoorWindowsStatusDelegateCalled)
    }
}
