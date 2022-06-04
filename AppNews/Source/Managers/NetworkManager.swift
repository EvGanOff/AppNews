//
//  NetworkManager.swift
//  AppNews
//
//  Created by Евгений Ганусенко on 5/6/22.
//

import UIKit

protocol NetworkManagerProtocol: AnyObject {
//    func getNews(page: Int, completion: @escaping (Result<[Article], NErrors>) -> Void)
    func getNews(page: Int) async throws -> [Article]
//    func getArticleInfo(completed: @escaping (Result<[Article], NErrors>) -> Void)
    func getArticleInfo(completed: String) async throws -> [Article]
//    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void)
    func downloadImage(from urlString: String) async throws -> UIImage?
}

class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    //weak var networkDelegate: NetworkManagerProtocol?
    
    var cache = NSCache<NSString, UIImage>()
    private let baseURL = "https://newsapi.org/v2/top-headlines?country=us"
    private let apiKey = "b21393dbff084185b011f3acdc9bd5fb"
    let decoder = JSONDecoder()

    init () {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }

    /*
     https://newsapi.org/v2/top-headlines?country=us&page=1&apiKey=b21393dbff084185b011f3acdc9bd5fb
     */

    func getNews(page: Int) async throws -> [Article] {
        let endpoint = baseURL + "&page=\(page)" + "&apiKey=\(apiKey)"

        guard let url = URL(string: endpoint) else {
            throw NErrors.unableToComplete
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NErrors.invalidResponce
        }

        do {
            return try decoder.decode(News.self, from: data).articles
        } catch {
            throw NErrors.invalidData
        }
    }

    func getArticleInfo(completed: String) async throws -> [Article] {
        let endpoint = baseURL + "&pageSize=100" + "&apiKey=\(apiKey)"

        guard let url = URL(string: endpoint) else { throw NErrors.invalidData }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw NErrors.invalidResponce }

        do {
            return try decoder.decode(News.self, from: data).articles
        } catch {
            throw NErrors.invalidData
        }
    }

    func downloadImage(from urlString: String) async throws -> UIImage? {
        let cacheKey = NSString(string: urlString)

        if let image = cache.object(forKey: cacheKey) { return image }

        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            cache.setObject(image, forKey: cacheKey)

            return image
        } catch {

            return nil
        }
    }
}

