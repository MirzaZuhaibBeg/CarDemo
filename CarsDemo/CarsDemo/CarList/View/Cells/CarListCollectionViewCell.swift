//
//  CarListCollectionViewCell.swift
//  CarsDemo
//
//  Created by Yasmin Tahira on 2022-01-25.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class CarListCollectionViewCell: UICollectionViewCell {
    
    weak var labelTitle: UILabel!
    weak var labelLicense: UILabel!
    weak var imageView: UIImageView!

    override init(frame: CGRect) {
        
        super.init(frame: frame)
                
        let imageViewCar = UIImageView(frame: .zero)
        imageViewCar.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(imageViewCar)
        NSLayoutConstraint.activate([
            imageViewCar.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20.0),
            imageViewCar.heightAnchor.constraint(equalToConstant: 100),
            imageViewCar.widthAnchor.constraint(equalToConstant: 100),
            imageViewCar.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
        ])
        self.imageView = imageViewCar

        let textLabel = UILabel(frame: .zero)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textAlignment = .left
        textLabel.numberOfLines = 0
        textLabel.textColor = .white
        self.contentView.addSubview(textLabel)
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            textLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            self.imageView.leadingAnchor.constraint(equalTo: textLabel.trailingAnchor, constant: 10),
        ])
        self.labelTitle = textLabel

        let licenseLabel = UILabel(frame: .zero)
        licenseLabel.translatesAutoresizingMaskIntoConstraints = false
        licenseLabel.textAlignment = .left
        licenseLabel.numberOfLines = 0
        licenseLabel.textColor = .white
        self.contentView.addSubview(licenseLabel)
        NSLayoutConstraint.activate([
            licenseLabel.topAnchor.constraint(equalTo: self.labelTitle.bottomAnchor),
            licenseLabel.bottomAnchor.constraint(greaterThanOrEqualTo: self.contentView.bottomAnchor, constant: -10),
            licenseLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            self.imageView.leadingAnchor.constraint(equalTo: licenseLabel.trailingAnchor, constant: 10),
        ])
        self.labelLicense = licenseLabel
        
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
        self.labelLicense.text = nil
    }
    
    //MARK: Internal Methods
    
    func populateCarInfo(carInfo: CarInfo?) {
        guard let carInfo = carInfo else {
            return
        }
        
        if let vin = carInfo.vin {
            self.labelTitle.text = "VIN NUMBER: \(vin)"
        }
        
        if let licensePlate = carInfo.licensePlate {
            self.labelLicense.text = "LICENSE PLATE: \(licensePlate)"
        } else {
            self.labelLicense.text = "LICENSE PLATE: loading..."
        }

        self.imageView.image = nil
        if let imagePath = carInfo.imagePath {
            let url = Constants.baseURLImage + imagePath
            AF.request(url).responseImage { response in
                
                if case .success(let image) = response.result {
                    self.imageView.image = image
                }
            }
        }
    }
}
