//
//  HTTPClient.swift
//  CCAnalyzer
//
//  Created by Sviatoslav Belmeha on 8/11/17.
//

import Foundation

protocol Currency {
    var id: String { get }
    var name: String { get }
    var symbol: String { get }
    var priceUSD: Double { get }
    var priceBTC: Double { get }
    var lastUpdate: Int64 { get }
}

struct CCurrency: Currency, Decodable {
    let id: String
    var name: String
    var symbol: String
    var priceUSD: Double
    var priceBTC: Double
    var lastUpdate: Int64
}

enum CoinMarketCapkeys: String, CodingKey {
    case id, name, symbol, price_usd, price_btc
}
