//
//  CarListViewController.swift
//  CarsDemo
//
//  Created by Yasmin Tahira on 2022-01-25.
//

import Foundation
import UIKit

class CarListViewController: UIViewController {

    // service should follow APIServiceInteractor protocol. For testing presenter, we can pass our own implementation of APIServiceInteractor which will give mocked data in place of API data
    var viewModel = CarListViewModel(service: APIService())

    weak var collectionView: UICollectionView!

    private let KCarListCollectionViewCell = "CarListCollectionViewCell"
    
    private let collectionViewCellHeight: CGFloat = 150
    private let collectionViewCellMargin: CGFloat = 20
    private let collectionViewCellSpacing: CGFloat = 10
    private let carListSectionCount  = 1
    private let carListSectionIndex  = 0

    private let refreshImage = "refresh"

    //MARK: View Life Cycle Methods

    override func loadView() {
        super.loadView()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
        self.collectionView = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.attachView(view: self)
        self.title = "Car List"
        self.setupCollectionView()
        self.addRefreshButton()
        self.viewModel.getCarList()
    }
    
    //MARK: Private Methods
    
    private func setupCollectionView() {
        self.view.backgroundColor = UIColor.black
        self.collectionView.backgroundColor = .black
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(CarListCollectionViewCell.self, forCellWithReuseIdentifier: KCarListCollectionViewCell)
    }
    
    private func addRefreshButton() {
        let refreshButton = UIBarButtonItem(image: UIImage(named: refreshImage), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.refreshCarList))
        self.navigationItem.rightBarButtonItem = refreshButton
    }
    
    private func getRowNoForCurrentCarInfo(carInfo: CarInfo?) -> Int? {
        
        guard let carInfo = carInfo, let vinCurrent = carInfo.vin, let carInfoArray = viewModel.carInfoArray else {
            return nil
        }
        
        // we can also set this index when we are sending car info operation in queue. and the saved index can be used to reload cell
        
        for (index, carInfo) in carInfoArray.enumerated() {
            if let vinCarInfo = carInfo.vin, vinCarInfo == vinCurrent {
                return index
            }
        }
        
        return nil
    }
    
    @objc func refreshCarList() {
        self.viewModel.cancelAllCarOverviewRequest()
        self.viewModel.getCarList()
    }
}

extension CarListViewController: CarListViewModelProtocol {
    
    func populateCarList() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        self.viewModel.getCarOverview()
    }
    
    func updateCarOverview(carInfo: CarInfo?) {
        
        // this method will be called for each car info object.
        // it would be better to reload once corresponding cell instead of entire table view
        
        DispatchQueue.main.async {
            if let rowNo = self.getRowNoForCurrentCarInfo(carInfo: carInfo) {
                self.collectionView.reloadItems(at: [IndexPath(item: rowNo, section: self.carListSectionIndex)])
            }
        }
    }
}

extension CarListViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return carListSectionCount
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.carInfoArray?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KCarListCollectionViewCell, for: indexPath) as! CarListCollectionViewCell
        
        guard let carInfoArray = self.viewModel.carInfoArray else {
            return cell
        }
        
        cell.populateCarInfo(carInfo: carInfoArray[indexPath.item])
        
        return cell
    }
}

extension CarListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let carInfoArray = self.viewModel.carInfoArray else {
            return
        }

        let carDetailViewController = CarDetailViewController()
        let navigationController = UINavigationController(rootViewController: carDetailViewController)
        navigationController.navigationBar.barStyle = .black
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        carDetailViewController.carInfo = carInfoArray[indexPath.item]
        self.present(navigationController, animated: true) {

        }
    }
}

extension CarListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.bounds.size.width - (collectionViewCellMargin * 2), height: collectionViewCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionViewCellSpacing
    }
}
