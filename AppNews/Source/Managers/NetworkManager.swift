//
//  NetworkManager.swift
//  AppNews
//
//  Created by Евгений Ганусенко on 5/6/22.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://newsapi.org/v2/top-headlines?country=ru"
    private let apiKey = "b21393dbff084185b011f3acdc9bd5fb"
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}

    func getNews(page: Int, completed: @escaping (Result<[Article], NErrors>) -> Void) {
        let endpoint = baseURL + "&page=\(page)" + "&apiKey=\(apiKey)"

        // 2) Создание GET запроса (URL)
        guard let url = URL(string: endpoint) else {
            completed(.failure(.unableToComplete))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error != nil else {
                completed(.failure(.unableToComplete))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponce))
                return
            }

            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode([Article].self, from: data)
                completed(.success(result))
            } catch {
                completed(.failure(.unableToComplete))
            }
        }
        task.resume()
    }

    func downloadImage(frov urlString: String, copleted: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)

        if let image = cache.object(forKey: cacheKey) {
            copleted(image)
            return
        }
        guard let url = URL(string: urlString) else {
            copleted(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  error == nil,
                  let data = data,
                  let image = UIImage(data: data),
                  let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                      copleted(nil)
                      return
            }

            self.cache.setObject(image, forKey: cacheKey)
            copleted(image)
        }

        task.resume()
    }
}

