//
//  CCAnalyzerTests.swift
//  CCAnalyzer
//
//  Created by Sviatoslav Belmeha on 8/11/17.
//

import Foundation
import XCTest
import CCAnalyzerCore

class CCAnalyzerTests: XCTestCase {
    
    func testCreateGetRequest() throws {
        let httpClient = HTTPClient(baseURL: URL(string: "https://google.com")!)
        let rq = httpClient.createRequest(withMethod: .GET, path: "/auth/login", parameters: ["q":"query"])
        
        XCTAssertEqual(rq?.url?.scheme, "https")
        XCTAssertEqual(rq?.url?.host, "google.com")
        XCTAssertEqual(rq?.url?.path, "/auth/login")
        XCTAssertEqual(rq?.url?.query, "q=query")
    }
    
}
