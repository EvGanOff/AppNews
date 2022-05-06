//
//  NTitleLabel.swift
//  AppNews
//
//  Created by Евгений Ганусенко on 5/6/22.
//

import Foundation
import UIKit

class NTitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(fontSize: CGFloat) {
        self.init(frame: .zero)
        font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
    }

    private func configure() {
        textColor = .label
        numberOfLines = 4
        minimumScaleFactor = 0.90
        translatesAutoresizingMaskIntoConstraints = false
        lineBreakMode = .byTruncatingTail
    }
}

