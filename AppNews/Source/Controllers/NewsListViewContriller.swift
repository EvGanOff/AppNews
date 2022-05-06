//
//  NewsListViewContriller.swift
//  AppNews
//
//  Created by Евгений Ганусенко on 5/6/22.
//

import UIKit

class NewsListViewContriller: UIViewController {

    let tableView = UITableView()
    var articles: [Article] = []
    var page = 0

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
        NetworkManager.shared.getNews(page: page) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let articles):
                self.updateUI(with: articles)
            case .failure(let error):
                self.presentsNAlertControllerOnMainTread(title: "Упс!", massage: error.rawValue, buttonTitle: "ОК")
            }
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


}

extension NewsListViewContriller: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsListCell.identifier, for: indexPath) as? NewsListCell else {
            let cell = NewsListCell(style: .default, reuseIdentifier: NewsListCell.identifier)
            return cell
        }

        let article = articles[indexPath.row]
        cell.setupCell(article: article)
        return cell
    }
}
