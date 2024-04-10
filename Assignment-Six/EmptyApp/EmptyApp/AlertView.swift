//
//  AlertView.swift
//  EmptyApp
//
//  Created by Nagarjun Mallesh on 23/02/24.
//  Copyright © 2024 rab. All rights reserved.
//

import SwiftUI

class CustomAlertView : UIView {
    
    private let messageLabel = UILabel()
    private let dismissButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder: ) has not been implemented.")
    }
    
    
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.borderWidth   = 1
        layer.borderColor = UIColor.black.cgColor
        
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        
        dismissButton.setTitle("OK", for: .normal)
        dismissButton.backgroundColor = .systemOrange
        dismissButton.setTitleColor(.white, for: .normal)
        dismissButton.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [messageLabel, dismissButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
    
    
    func showMessage(_ message: String){
        messageLabel.text = message
    }
    
    @objc private func dismissAction() {
        self.removeFromSuperview()
    }
    
    func showAlert(on view: UIView, withMessage message: String) {
        view.addSubview(self)
        self.center = view.center
        self.alpha = 0
        self.showMessage(message)
        UIView.animate(withDuration: 0.4){
            self.alpha = 1
        }
    }
}
