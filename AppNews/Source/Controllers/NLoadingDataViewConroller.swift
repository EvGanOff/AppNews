//
//  NLoadingDataViewConroller.swift
//  AppNews
//
//  Created by Евгений Ганусенко on 5/7/22.
//

import UIKit

class NLoadingDataViewConroller: UIViewController {
    private var containerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)

        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            self.containerView.alpha = 0.5

        }

        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])

        activityIndicator.startAnimating()
    }

    func showEmptyStateView(with massege: String, in view: UIView) {
        let emptyStateView = NEmptyStateView(message: massege)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)

    }

    func dismissLoadingView() {
        guard let containerView = containerView else { return }
        DispatchQueue.main.async {
            self.containerView.removeFromSuperview()
            self.containerView = nil
        }
    }
}
