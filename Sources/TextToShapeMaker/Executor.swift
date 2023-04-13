//
//  Executor.swift
//  
//
//  Created by Michael Geurtjens on 11/4/2023.
//

import Foundation
public struct Executor {
    static public func execute(_ text: String) -> (ShapeModel, Bool) {
        let unsequencedInstructions = InstructionParser.execute(text)
        let (instructions, success) = InstructionSequencer.execute(instructions: unsequencedInstructions)
        
        let placements = PlacementCalculator.execute(instructions: instructions)
        let shape = ShapeCalculator.execute(placements: placements)
        return (shape, success)
    }
}
