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
    var viewModel: ProductDetailViewViewModel? = nil
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    } ()
    
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
        return button
    }()
    
    private let sendMassgeButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        button.backgroundColor = UIColor(named: "sendMessageButton")
        button.setTitle("Написать", for: .normal)
        return button
    }()
    
    private let contactsTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "Контакты"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
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
    
    private let retryButton: RetryButton = {
        let retryButton = RetryButton()
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        return retryButton
    }()
    
    private let snackbarView: SnackbarView = {
        let snackbarView = SnackbarView()
        snackbarView.backgroundColor = UIColor(named: "errorColor")
        snackbarView.translatesAutoresizingMaskIntoConstraints = false
        return snackbarView
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        buttonStackView.addArrangedSubview(callButton)
        buttonStackView.addArrangedSubview(sendMassgeButton)
        addSubviews(scrollView)
        retryButton.setRetryAction(retryAction: retry)
        contentView.addSubviews(spinner, imageView, titleLabel, priceLabel, addressLabel, buttonStackView, contactsTitleLabel, emailLabel, phoneNumberLabel, descriptionTitleLabel, descriptionLabel, retryButton)
        scrollView.addSubview(contentView)
        spinner.startAnimating()
        addConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func retry() {
        retryButton.hide()
        spinner.startAnimating()
        viewModel?.fetchProductData()
        if let imageUrl = viewModel?.imageURL {
            loadImage(imageUrl: imageUrl)
        }

    }
    
    private func addConstrains() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 200),

            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 300),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            addressLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10),
            addressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            addressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            buttonStackView.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 20),
            buttonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            buttonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            buttonStackView.heightAnchor.constraint(equalToConstant: 50),

            contactsTitleLabel.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 20),
            contactsTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            contactsTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            phoneNumberLabel.topAnchor.constraint(equalTo: contactsTitleLabel.bottomAnchor, constant: 20),
            phoneNumberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            phoneNumberLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            emailLabel.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor, constant: 10),
            emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            emailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            descriptionTitleLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 20),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            descriptionTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            retryButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 150),
            retryButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    public func configure(with viewModel: ProductDetailViewViewModel) {
        viewModel.delegate = self
        self.viewModel = viewModel
        if let imageUrl = viewModel.imageURL {
            loadImage(imageUrl: imageUrl)
        }
        priceLabel.text = viewModel.price
        titleLabel.text = viewModel.title
    }
    
    private func loadImage(imageUrl: URL) {
        imageView.kf.setImage(
            with: imageUrl,
            placeholder: placeholderImage
        )
    }
}

extension ProductDetailView: ProductDetailsViewViewModelDelegate {
    
    func didLoadDetails(details: DetailProduct) {
        let finalAddress = "\(details.location), \(details.address)"
        addressLabel.text = finalAddress
        descriptionLabel.text = details.description
        phoneNumberLabel.text = "Номер телефона: \(details.phoneNumber)"
        emailLabel.text = "Email: \(details.email)"
        descriptionLabel.alpha = 1
        buttonStackView.alpha = 1
        addressLabel.alpha = 1
        descriptionTitleLabel.alpha = 1
        contactsTitleLabel.alpha = 1
        phoneNumberLabel.alpha = 1
        emailLabel.alpha = 1
        spinner.stopAnimating()
        retryButton.hide()
    }
    
    func errorHasBeenOccured(message: String) {
        snackbarView.show(root: self, message: message)
        spinner.stopAnimating()
        retryButton.show()
    }
}
