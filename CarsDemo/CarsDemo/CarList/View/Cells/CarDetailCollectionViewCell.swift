//
//  CarDetailCollectionViewCell.swift
//  CarsDemo
//
//  Created by Yasmin Tahira on 25/01/22.
//

import UIKit

enum CarDetailViewType: Int {
    case CarDetailViewType_License = 0
    case CarDetailViewType_LockStatus
    case CarDetailViewType_LeftBackDoor
    case CarDetailViewType_RightFrontDoor
    case CarDetailViewType_RightBackDoor
    case CarDetailViewType_LeftFrontDoor
}

class CarDetailCollectionViewCell: UICollectionViewCell {
    
    weak var labelTitle: UILabel!
    weak var imageView: UIImageView!
    
    private let lockImage = "lock"
    private let unlockImage = "unlock"

    override init(frame: CGRect) {
        
        super.init(frame: frame)
                
        let textLabel = UILabel(frame: .zero)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        textLabel.textColor = .white
        self.contentView.addSubview(textLabel)
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            textLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            textLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
        ])
        textLabel.backgroundColor = UIColor.clear
        self.labelTitle = textLabel
        
        let imageViewCar = UIImageView(frame: .zero)
        imageViewCar.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(imageViewCar)
        NSLayoutConstraint.activate([
            imageViewCar.topAnchor.constraint(equalTo: self.labelTitle.bottomAnchor, constant: 0),
            imageViewCar.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: 0),
        ])
        self.imageView = imageViewCar
        self.imageView.backgroundColor = UIColor.clear

        self.contentView.backgroundColor = .black
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.borderColor = UIColor.white.cgColor
        self.contentView.layer.borderWidth = 1.0
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.labelTitle.text = nil
    }
    
    private func getLockImage(carStatus: CarStatus) -> UIImage? {
        if carStatus == .CarStatus_Open {
            return UIImage(named: unlockImage)
        } else if carStatus == .CarStatus_Close {
            return UIImage(named: lockImage)
        } else {
            return nil
        }
    }
    
    //MARK: Internal Methods
    
    func populateCarInfo(carInfo: CarInfo?, indexpath: IndexPath) {
        guard let carInfo = carInfo else {
            return
        }
        
        self.imageView.isHidden = false

        switch indexpath.item {
            
        case CarDetailViewType.CarDetailViewType_License.rawValue:
            let licenseText = carInfo.licensePlate ?? ""
            self.labelTitle.text = "License Plate" + "\n" + licenseText
            self.imageView.isHidden = true

        case CarDetailViewType.CarDetailViewType_LockStatus.rawValue:
            self.labelTitle.text = "Car Lock"
            self.imageView.image = self.getLockImage(carStatus: carInfo.lockedStatus)

        case CarDetailViewType.CarDetailViewType_LeftBackDoor.rawValue:
            self.labelTitle.text = "Left Back Door"
            self.imageView.image = self.getLockImage(carStatus: carInfo.doorLeftBackStatus)
            
        case CarDetailViewType.CarDetailViewType_RightFrontDoor.rawValue:
            self.labelTitle.text = "Right Front Door"
            self.imageView.image = self.getLockImage(carStatus: carInfo.doorRightFrontStatus)

        case CarDetailViewType.CarDetailViewType_RightBackDoor.rawValue:
            self.labelTitle.text = "Right Back Door"
            self.imageView.image = self.getLockImage(carStatus: carInfo.doorRightBackStatus)

        case CarDetailViewType.CarDetailViewType_LeftFrontDoor.rawValue:
            self.labelTitle.text = "Left Front Door"
            self.imageView.image = self.getLockImage(carStatus: carInfo.doorLeftFrontStatus)

        default:
            return
        }
    }
}
