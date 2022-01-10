//
//  Server.swift
//  Acela
//
//  Created by Sagar Kothari on 29/12/21.
//

import Foundation

class Server {
	static let shared = Server()
	let server = "https://3speak.tv/"
	let endPoint = "https://3speak.tv/apiv2/"
	let hiveServer = "https://api.hive.blog"

	let trendingFeed = "feeds/trending"
	let newFeed = "feeds/new"

	let invalidUrlError = NSError(domain: "Server", code: 404, userInfo: ["desc": "invalid url"])
	let statusCodeNot200 = NSError(domain: "Server", code: 404, userInfo: ["desc": "Status code is not 200"])
	let jsonMappingFailed = NSError(domain: "Server", code: 404, userInfo: ["desc": "JSON mapping failed"])
	let requestEncodingFailed = NSError(domain: "Server", code: 404, userInfo: ["desc": "Request Encoding failed"])

	func m3u8(isIpfs: Bool, identifier: String) -> String {
		if !isIpfs {
			return "https://threespeakvideo.b-cdn.net/\(identifier)/default.m3u8"
		} else {
			return "https://ipfs-3speak.b-cdn.net/ipfs/\(identifier)/default.m3u8"
		}
	}
}
