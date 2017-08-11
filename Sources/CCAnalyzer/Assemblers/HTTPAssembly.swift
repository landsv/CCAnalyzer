//
//  HTTPAssembly.swift
//  CCAnalyzer
//
//  Created by Sviatoslav Belmeha on 8/11/17.
//

import Swinject
import Foundation
import CCAnalyzerCore

struct HTTPAssembly: Assembly {
    
    func assemble(container: Container) {
        
        // HTTP Client
        container.register(HTTPClient.self) { resolver in
            return HTTPClient(baseURL: URL(string: "http://api.com")!)
        }.inObjectScope(.container)
        
    }
    
}
