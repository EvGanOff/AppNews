//
//  NShadowView.swift
//  AppNews
//
//  Created by Евгений Ганусенко on 5/11/22.
//

import UIKit

class NShadowView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        backgroundColor = .black
        layer.cornerRadius = 5
        layer.borderWidth = 2
        layer.backgroundColor = UIColor.black.cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }
}
