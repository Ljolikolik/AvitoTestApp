//
//  RetryButton.swift
//  AvitoTestApp
//
//  Created by Ольга Шовгенева on 30.08.2023.
//

import UIKit

class RetryButton: UIButton {
    
    private var retryAction: (() -> Void)? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitle("Повторить", for: .normal)
        setTitleColor(.systemBlue, for: .normal)
        isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setRetryAction(retryAction: @escaping () -> Void) {
        self.retryAction = retryAction
        addTarget(self, action: #selector(retry(_:)), for: .touchUpInside)
    }
    
    func show() {
        isHidden = false
    }
    
    func hide() {
        isHidden = true
    }

    @objc private func retry(_ sender: UIButton) {
        (retryAction ?? {})()
    }
}
