//
//  NewsListViewController.swift
//  AppNews
//
//  Created by Евгений Ганусенко on 5/6/22.
//

import UIKit
class NewsListViewController: NLoadingDataViewConroller {

    let tableView = UITableView()
    var articles: [Article] = []
    var page = 1
    var isPaging = false
    var hasMoreArticles = true
    var isRefresh = false
    var networkDelegate: NetworkManagerProtocol? = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureTableView()
        getArticles(page: page)
    }

    private func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Новости"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func configureTableView() {

        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        tableView.register(NewsListCell.self, forCellReuseIdentifier: NewsListCell.identifier)
        tableView.rowHeight = 120
        view.addSubview(tableView)

        configureRefreshControl()
    }

    private func configureRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didSwipeToRefresh), for: .valueChanged)
    }

    @objc
    private func didSwipeToRefresh() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }

        self.articles.removeAll()
        isRefresh = true
        isPaging = false
        hasMoreArticles = true
        page = 1
        
        getArticles(page: page)
    }

    func getArticles(page: Int) {
        showLoadingView()
        isPaging = true
        Task {
            do {
                let articles = try await networkDelegate?.getNews(page: page)
                updateUI(with: articles ?? [])
                dismissLoadingView()
                isPaging = false
                isRefresh = false
            } catch {
                if let nErrors = error as? NErrors {
                    self.presentsNAlertController(title: "Упс!", massage: nErrors.rawValue, buttonTitle: "ОК")
                }
            }
        }
    }

    private func updateUI(with articles: [Article]) {
        if articles.count < 20 {
            hasMoreArticles = false
        }

        self.articles.append(contentsOf: articles)

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
            self.view.bringSubviewToFront(self.tableView)
        }
    }
}
