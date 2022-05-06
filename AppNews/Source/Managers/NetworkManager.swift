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
    let decoder = JSONDecoder()
    
    private init() {}

    func getNews(page: Int, completion: @escaping (Result<[Article], NErrors>) -> Void) {
        let endpoint = baseURL + "&page=\(page)" + "&apiKey=\(apiKey)"

        guard let url = URL(string: endpoint) else {
            completion(.failure(.unableToComplete))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.unableToComplete))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponce))
                return
            }

            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }

            do {
                let result = try self.decoder.decode(News.self, from: data)
                completion(.success(result.articles))
            } catch {
                completion(.failure(.invalidData))
            }
        }

        task.resume()
    }

    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)

        if let image = cache.object(forKey: cacheKey) {
            completion(image)
            return
        }
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  error == nil,
                  let data = data,
                  let image = UIImage(data: data),
                  let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                      completion(nil)
                      return
            }

            self.cache.setObject(image, forKey: cacheKey)
            completion(image)
        }

        task.resume()
    }
}

