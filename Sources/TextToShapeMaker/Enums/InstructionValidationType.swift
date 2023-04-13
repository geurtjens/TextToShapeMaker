//
//  ValidationType.swift
//  
//
//  Created by Michael Geurtjens on 9/4/2023.
//

import Foundation
enum InstructionValidationType {
    case success
    
    case sameWord
    case wordSeparatorError
    case interlockNotFound
    case interlockNotMatching
}
