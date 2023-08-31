//
//  SnackbarView.swift
//  AvitoTestApp
//
//  Created by Ольга Шовгенева on 30.08.2023.
//

import UIKit

class SnackbarView: UIView {
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 12
        layer.masksToBounds = true
        addSubview(label)
        setLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLabelConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func show(root: UIView, message: String) {
        
        label.text = message
        
        root.addSubview(self)
        alpha = 1
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: root.leadingAnchor,constant: 20),
            trailingAnchor.constraint(equalTo: root.trailingAnchor, constant: -20),
            bottomAnchor.constraint(equalTo: root.bottomAnchor),
            heightAnchor.constraint(equalToConstant: 44),
        ])
            
        //появление
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                UIView.animate(withDuration: 0.3) {
                    self.transform = .identity
                }
            }
        }
        //исчезновение
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            UIView.animate(withDuration: 0.8, animations: {
                self.alpha = 0.0
            }) { _ in
                self.removeFromSuperview()
            }
        }
    }

}
