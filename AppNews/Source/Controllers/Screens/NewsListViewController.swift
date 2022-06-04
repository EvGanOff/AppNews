//
//  NewsListViewController.swift
//  AppNews
//
//  Created by Евгений Ганусенко on 5/6/22.
//

import UIKit
// написать рефреш контролл
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

    private func getArticles(page: Int) {
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

    func updateUI(with articles: [Article]) {
        if articles.count < 20 {
            hasMoreArticles = false
        }

        self.articles.append(contentsOf: articles)

        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
            self.view.bringSubviewToFront(self.tableView)
        }
    }
}

extension NewsListViewController: UITableViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        // Постраничная загрузка.
        if offsetY > contentHeight - height {
            guard hasMoreArticles, !isPaging else { return }
            page += 1
            isPaging = true
            getArticles(page: page)
        }
    }
    
    // написать метод выбора ячейки и загрузки в сафари
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let article = articles[indexPath.row]
        let destVC = ArticleInfoVC(article: article)
        let navigationController = UINavigationController(rootViewController: destVC)
        present(navigationController, animated: true)
    }
}

extension NewsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsListCell.identifier) as? NewsListCell else {
            let cell = NewsListCell(style: .default, reuseIdentifier: NewsListCell.identifier)
            return cell
        }

        let article = articles[indexPath.row]
        cell.setupCell(article: article)
        return cell
    }
}
