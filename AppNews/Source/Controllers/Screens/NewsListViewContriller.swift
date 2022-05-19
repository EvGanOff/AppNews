//
//  NewsListViewContriller.swift
//  AppNews
//
//  Created by Евгений Ганусенко on 5/6/22.
//

import UIKit

class NewsListViewContriller: NLoadingDataViewConroller {

    let tableView = UITableView()
    var articles: [Article] = []
    var page = 1
    var isPaging = false
    var hasMoreArticles = true
    var isRefresh = false
    let networkDelegate: NetworkManagerProtocol? = NetworkManager()

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
    }

    private func getArticles(page: Int) {
        showLoadingView()
        isPaging = true

        networkDelegate?.getNews(page: page) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            switch result {
            case .success(let articles):
                self.updateUI(with: articles)
            case .failure(let error):
                self.presentsNAlertControllerOnMainTread(title: "Упс!", massage: error.rawValue, buttonTitle: "ОК")
            }
            self.isPaging = false
        }
    }

    func updateUI(with articles: [Article]) {
        self.articles.append(contentsOf: articles)

        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.view.bringSubviewToFront(self.tableView)
        }
    }
}

extension NewsListViewContriller: UITableViewDelegate {
    // написать метод постраничной загрузки
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

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

extension NewsListViewContriller: UITableViewDataSource {
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
