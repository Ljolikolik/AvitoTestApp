//
//  ProductCollectionViewCell.swift
//  AvitoTestApp
//
//  Created by Ольга Шовгенева on 24.08.2023.
//

import UIKit
import Kingfisher

/// Single cell for a product
final class ProductCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "ProductCollectionViewCell"
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    } ()
    
    private let placeholderImage = UIImage(named: "placeholder")
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 13, weight: .light)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 13, weight: .light)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        contentView.addSubviews(imageView, titleLabel, priceLabel, locationLabel, dateLabel)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func addConstraints() {
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            
            locationLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 5),
            
            dateLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 5)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        priceLabel.text = nil
        locationLabel.text = nil
        dateLabel.text = nil
        imageView.image = nil
    }
    
    public func configure(with viewModel: ProductCollectionViewCellViewModel) {
        titleLabel.text = viewModel.productTitle
        priceLabel.text = formatPrice(viewModel.productPrice)
        locationLabel.text = viewModel.productLocation
        dateLabel.text = formatDate(viewModel.productDate)
        imageView.kf.setImage(
            with: viewModel.productImageUrl,
            placeholder: placeholderImage
        )
    }
    
    
}
