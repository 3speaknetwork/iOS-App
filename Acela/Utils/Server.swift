//
//  Server.swift
//  Acela
//
//  Created by Sagar Kothari on 29/12/21.
//

import Foundation

class Server {
	static let shared = Server()
	private let endPoint = "https://3speak.tv/apiv2/"

	private let trendingFeed = "feeds/trending"
	private let newFeed = "feeds/new"

	func getFeed(
		_ isTrending: Bool,
		handler: @escaping (Result<[FeedModel], NSError>) -> Void
	) {
		if let url = URL(string: "\(endPoint)\(isTrending ? trendingFeed : newFeed)") {
			URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
				if let http = response as? HTTPURLResponse,
						http.statusCode == 200 {
					if let data = data,
						 let model = try? JSONDecoder().decode([FeedModel].self, from: data) {
						handler(.success(model))
					} else {
						handler(.failure(NSError(domain: "Server", code: 404, userInfo: ["desc": "JSON mapping failed"])))
					}
				} else {
					handler(.failure(NSError(domain: "Server", code: 404, userInfo: ["desc": "user not found"])))
				}
			}.resume()
		} else {
			handler(.failure(NSError(domain: "Server", code: 404, userInfo: ["desc": "invalid user account url"])))
		}
	}

	func getMoreFeed(
		_ isTrending: Bool,
		skip: Int? = nil,
		handler: @escaping (Result<MoreFeedModel, NSError>) -> Void
	) {
		var string = "\(endPoint)\(isTrending ? trendingFeed : newFeed)"
		if let skip = skip {
			string = "\(string)/more?skip=\(skip)"
		}
		if let url = URL(string: string) {
			URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
				if let http = response as? HTTPURLResponse,
						http.statusCode == 200 {
					if let data = data,
						 let model = try? JSONDecoder().decode(MoreFeedModel.self, from: data) {
						handler(.success(model))
					} else {
						handler(.failure(NSError(domain: "Server", code: 404, userInfo: ["desc": "JSON mapping failed"])))
					}
				} else {
					handler(.failure(NSError(domain: "Server", code: 404, userInfo: ["desc": "user not found"])))
				}
			}.resume()
		} else {
			handler(.failure(NSError(domain: "Server", code: 404, userInfo: ["desc": "invalid user account url"])))
		}
	}
}
