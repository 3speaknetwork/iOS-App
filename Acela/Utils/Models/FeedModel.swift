//
//  FeedModel.swift
//  Acela
//
//  Created by Sagar Kothari on 29/12/21.
//

import Foundation

struct MoreFeedModel: Codable {
	var trends: [FeedModel]?
	let recommended: [FeedModel]?
}

struct FeedModel: Codable {
	let created: String
	let title: String
	let views: Int
	let duration: Double
	let author: String?
	let owner: String?
	let permlink: String
	let images: FeedModelImage?
	let isIpfs: Bool?
	let ipfs: String?
	let thumbUrl: String?
}

struct FeedModelImage: Codable {
	let thumbnail: String?
}
