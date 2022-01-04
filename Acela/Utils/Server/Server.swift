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

	let trendingFeed = "feeds/trending"
	let newFeed = "feeds/new"

	func m3u8(isIpfs: Bool, identifier: String) -> String {
		if !isIpfs {
			return "https://threespeakvideo.b-cdn.net/\(identifier)/default.m3u8"
		} else {
			return "https://ipfs-3speak.b-cdn.net/ipfs/\(identifier)/default.m3u8"
		}
	}
}
