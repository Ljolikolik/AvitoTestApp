//
//  ProductViewController.swift
//  AvitoTestApp
//
//  Created by Ольга Шовгенева on 24.08.2023.
//

import UIKit

/// Controller to show Products
final class ProductViewController: UIViewController, ProductListViewDelegate {

    private let productListView = ProductListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Товары"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        view.addSubview(productListView)
        setupView()
    }
    
    private func setupView() {
        productListView.delegate = self
        view.addSubview(productListView)
        NSLayoutConstraint.activate([
            productListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            productListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            productListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            productListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - ProductListViewDelegate
    
    func productListView(_ productListView: ProductListView, didSelectProduct product: Product) {
        // Open detail controller for that product
        let viewModel = ProductDetailViewViewModel(product: product)
        let detailVC = ProductDetailViewController(viewModel: viewModel)
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

