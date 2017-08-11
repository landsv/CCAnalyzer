//
//  CCAnalyzerAssembler.swift
//  CCAnalyzer
//
//  Created by Sviatoslav Belmeha on 8/11/17.
//

import Swinject

private let assembler = Assembler()
let container = assembler.resolver

struct CCAnalyzerAssembler {
    
    func assemble() {
        assembler.apply(assembly: HTTPAssembly())
    }
    
}
