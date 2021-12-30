//
//  FeedModel.swift
//  Acela
//
//  Created by Sagar Kothari on 29/12/21.
//

import Foundation

struct MoreFeedModel: Codable {
	let trends: [FeedModel]?
	let recommended: [FeedModel]?
}

struct FeedModel: Codable {
	let created: String
	let title: String
	let views: Int
	let duration: Double
	let author: String
	let permlink: String
	let images: FeedModelImage
}

struct FeedModelImage: Codable {
	let thumbnail: String?
}
