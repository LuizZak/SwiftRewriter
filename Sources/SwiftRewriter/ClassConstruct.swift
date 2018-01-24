//
//  ClassConstruct.swift
//  SwiftRewriter
//
//  Created by Luiz Silva on 23/01/2018.
//

import Foundation
import GrammarModels

public class ClassConstruct: Context {
    var name: String
    var properties: [Property] = []
    
    public init(name: String) {
        self.name = name
    }
    
    public func addProperty(named name: String, type: String, source: ObjcClassInterface.Property) {
        let prop = Property(source: source, name: name, type: type)
        self.properties.append(prop)
    }
}

public extension ClassConstruct {
    public struct Property {
        var source: ObjcClassInterface.Property?
        var name: String
        var type: String
    }
}
