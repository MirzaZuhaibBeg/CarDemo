//
//  CarDetailViewController.swift
//  CarsDemo
//
//  Created by Yasmin Tahira on 2022-01-25.
//

import Foundation
import UIKit

class CarDetailViewController: UIViewController {
    
    // service should follow APIServiceInteractor protocol. For testing presenter, we can pass our own implementation of APIServiceInteractor which will give mocked data in place of API data
    var viewModel = CarDetailViewModel(service: APIService())

    weak var collectionView: UICollectionView!

    var carInfo: CarInfo?
    
    private let KCarDetailCollectionViewCell = "CarDetailCollectionViewCell"
    
    private let collectionViewCellHeight: CGFloat = 120
    private let collectionViewCellMargin: CGFloat = 30
    private let collectionViewCellSpacing: CGFloat = 10

    private let carDetailSectionCount  = 1
    private let carDetailRowCount  = 6

    //MARK: View Life Cycle Methods

    override func loadView() {
        super.loadView()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10.0),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10.0),
        ])
        self.collectionView = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.attachView(view: self)
        self.viewModel.carInfo = self.carInfo
        self.title = "Car Detail"
        self.setupCollectionView()
        self.viewModel.getCarLockStatus()
    }
    
    //MARK: Private Methods
    
    private func setupCollectionView() {
        self.view.backgroundColor = UIColor.black
        self.collectionView.backgroundColor = .black
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(CarDetailCollectionViewCell.self, forCellWithReuseIdentifier: KCarDetailCollectionViewCell)
    }
}

extension CarDetailViewController: CarDetailViewModelProtocol {
    
    func populateCarLockStatus() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        self.viewModel.getCarDoorWindowsStatus()
    }
    
    func populateCarDoorWindowsStatus() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension CarDetailViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return carDetailSectionCount
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carDetailRowCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KCarDetailCollectionViewCell, for: indexPath) as! CarDetailCollectionViewCell
        
        guard let carInfo = self.viewModel.carInfo else {
            return cell
        }
        
        cell.populateCarInfo(carInfo: carInfo, indexpath: indexPath)
        
        return cell
    }
}

extension CarDetailViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: (collectionView.bounds.size.width - (collectionViewCellMargin))/2, height: collectionViewCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionViewCellSpacing
    }
}
