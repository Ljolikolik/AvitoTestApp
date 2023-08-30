//
//  ProductDetailView.swift
//  AvitoTestApp
//
//  Created by Ольга Шовгенева on 29.08.2023.
//

import UIKit
import Kingfisher


/// VIew for single product info
final class ProductDetailView: UIView {
    
    private let placeholderImage = UIImage(named: "placeholder")
    //todo это должно быть тут? О_О
    var viewModel: ProductDetailViewViewModel? = nil
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    } ()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.alpha = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 25, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private let callButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        button.backgroundColor = UIColor(named: "callButtonColor")
        button.setTitle("Позвонить", for: .normal)
        button.addTarget(self, action: #selector(callButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let sendMassgeButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        button.backgroundColor = UIColor(named: "sendMessageButton")
        button.setTitle("Написать", for: .normal)
        return button
    }()
    
    private let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "Описание"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        stackView.addArrangedSubview(priceLabel)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(addressLabel)
        buttonStackView.addArrangedSubview(callButton)
        buttonStackView.addArrangedSubview(sendMassgeButton)
        stackView.addArrangedSubview(buttonStackView)
        stackView.addArrangedSubview(descriptionTitleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        addSubviews(spinner, imageView, stackView)
        spinner.startAnimating()
        addConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func addConstrains() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 200),
            
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            //todo сделать красиво
            descriptionLabel.widthAnchor.constraint(equalToConstant: 100),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 100),
            addressLabel.widthAnchor.constraint(equalToConstant: 100),
            addressLabel.heightAnchor.constraint(equalToConstant: 100),
            
            buttonStackView.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc func callButtonTapped() {
        guard let details = viewModel?.details else {
            return
        }
        let phoneNumber = details.phoneNumber
        
        guard let number = URL(string: "tel://" + phoneNumber) else { return }
        UIApplication.shared.open(number)
    }
    
    public func configure(with viewModel: ProductDetailViewViewModel) {
        viewModel.delegate = self
        self.viewModel = viewModel
        imageView.kf.setImage(
            with: viewModel.imageURL,
            placeholder: placeholderImage
        )
        priceLabel.text = viewModel.price
        titleLabel.text = viewModel.title
    }
}

extension ProductDetailView: ProductDetailsViewViewModelDelegate {
    
    func didLoadDetails(details: DetailProduct) {
        //todo обработать случай если с бека придет nil в одном или в обоих адресах
        let finalAddress = "\(details.location), \(details.address)"
        addressLabel.text = finalAddress
        descriptionLabel.text = details.description
        descriptionLabel.alpha = 1
        buttonStackView.alpha = 1
        addressLabel.alpha = 1
        descriptionTitleLabel.alpha = 1
        spinner.stopAnimating()
    }
}
