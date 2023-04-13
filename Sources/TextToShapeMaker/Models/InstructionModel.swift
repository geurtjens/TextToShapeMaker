//
//  InstructionModel.swift
//  
//
//  Created by Michael Geurtjens on 9/4/2023.
//

import Foundation
struct InstructionModel {
    let text: String
    let fromWord: String
    let fromPos: Int
    let toWord: String
    let toPos: Int
    let isValid: InstructionValidationType
}
