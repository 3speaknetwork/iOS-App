//
//  Server+UserFeed.swift
//  Acela
//
//  Created by Sagar Kothari on 30/12/21.
//

import Foundation

extension Server {
	func getUserFeed(
		_ userName: String,
		handler: @escaping (Result<[FeedModel], NSError>) -> Void
	) {
		if let url = URL(string: "\(endPoint)feeds/@\(userName)") {
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
}
