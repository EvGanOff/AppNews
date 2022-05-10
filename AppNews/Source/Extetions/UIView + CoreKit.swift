//
//  UIView + CoreKit.swift
//  AppNews
//
//  Created by Евгений Ганусенко on 5/8/22.
//

import Foundation
import UIKit

extension UIView {
    
    func pinToEdges(of superview: UIView) {
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }

    func transformButton() {
        UIView.animate(withDuration: 0.9, animations: {
            self.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }, completion: { _ in
            UIView.animate(withDuration: 0.9) {
                self.transform = CGAffineTransform.identity
            }
        })
    }
}
