//
//  AlertComponents.swift
//  Digital Softs
//
//  Created by Muhammad Afnan on 13/06/2024.
//



import SwiftUI
import UIKit

struct AlertComponent {
    enum AlertType: String {
        case success
        case info
        case warning
        case danger
        
        var icon: String {
            switch self {
            case .success: return "checkmark.circle"
            case .info: return "info.circle"
            case .warning: return "exclamationmark.circle"
            case .danger: return "xmark.circle"
            }
        }
        
        var color: UIColor {
            switch self {
            case .success: return UIColor.systemGreen
            case .info: return UIColor.systemBlue
            case .warning: return UIColor.systemYellow
            case .danger: return UIColor.systemRed
            }
        }
    }
    
    struct AlertOptions {
        var title: String = "Success"
        var message: String = "Operation completed successfully."
        var type: AlertType = .success
        var duration: TimeInterval = 3.0
        var placementFrom: String = "top"
        var placementAlign: String = "center"
    }
    
    static func showAlert(options: AlertOptions) {
        guard let window = UIApplication.shared.windows.first else { return }
        
        let alertView = UIView()
        alertView.backgroundColor = options.type.color
        alertView.layer.cornerRadius = 10
        alertView.layer.shadowOpacity = 0.3
        alertView.layer.shadowOffset = CGSize(width: 0, height: 5)
        
        let icon = UIImageView(image: UIImage(systemName: options.type.icon))
        icon.tintColor = .white
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = options.title
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let messageLabel = UILabel()
        messageLabel.text = options.message
        messageLabel.textColor = .white
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        alertView.addSubview(icon)
        alertView.addSubview(titleLabel)
        alertView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 10),
            icon.centerYAnchor.constraint(equalTo: alertView.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 30),
            icon.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -10),
            
            messageLabel.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10),
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            messageLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -10),
            messageLabel.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -10)
        ])
        
        window.addSubview(alertView)
        
        alertView.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint: NSLayoutConstraint
        switch options.placementAlign {
        case "left":
            horizontalConstraint = alertView.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 20)
        case "right":
            horizontalConstraint = alertView.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -20)
        default:
            horizontalConstraint = alertView.centerXAnchor.constraint(equalTo: window.centerXAnchor)
        }
        
        let verticalConstraint: NSLayoutConstraint
        switch options.placementFrom {
        case "bottom":
            verticalConstraint = alertView.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: -20)
        default:
            verticalConstraint = alertView.topAnchor.constraint(equalTo: window.topAnchor, constant: 50)
        }
        
        NSLayoutConstraint.activate([
            horizontalConstraint,
            verticalConstraint,
            alertView.widthAnchor.constraint(lessThanOrEqualToConstant: 300),
            alertView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])
        
        UIView.animate(withDuration: 0.5, animations: {
            alertView.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: options.duration, options: [], animations: {
                alertView.alpha = 0.0
            }) { _ in
                alertView.removeFromSuperview()
            }
        }
    }
}

