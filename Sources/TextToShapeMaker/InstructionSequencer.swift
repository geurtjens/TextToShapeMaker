//
//  InstructionSequencer.swift
//  
//
//  Created by Michael Geurtjens on 13/4/2023.
//

import Foundation
struct InstructionSequencer {
    
    static func executeGivingText(instructions: [InstructionModel]) -> (String, Bool) {
        let (instructions, success) = execute(instructions: instructions)
        
        var result = ""
        for instruction in instructions {
            if result != "" {
                result += ","
            }
            result += instruction.text
        }
        return (result, success)
    }
    
    // The bool means that was this successful, that is have all the instructions been processed now
    static func execute(instructions:[InstructionModel]) -> ([InstructionModel], Bool) {

        // We only want to calculate using the valid instructions
        var instructions = instructions.filter {$0.isValid == .success}
        
        // So if there are no valid instructions then lets exit immediately
        if instructions.count == 0 {
            return ([],true)
        }
        
        
        // container that stores all words that we have placed
        var wordsInGrid: [String] = []
        
        // We must seed our placements with the first instruction
        let firstInstruction = instructions[0]
        wordsInGrid.append(firstInstruction.fromWord.uppercased())
        wordsInGrid.append(firstInstruction.toWord.uppercased())
        var result:[InstructionModel] = [firstInstruction]
        instructions.removeFirst()
        
        
        // This just cannot be null and that is why we have done this
        var nextInstruction: InstructionModel? = firstInstruction

        var isToWord: Bool = true
        while instructions.count > 0 && nextInstruction != nil {

            // remove instructions whose leftWord and rightWord are both in placements, we dont need them, they are redundant
            instructions = removeRedundantInstructions(instructions: instructions, wordsInGrid: wordsInGrid)
            
            (nextInstruction, isToWord) = findNextInstruction(instructions: &instructions, wordsInGrid: wordsInGrid)
            
            if nextInstruction != nil {
                if isToWord {
                    wordsInGrid.append(nextInstruction!.toWord.uppercased())
                    result.append(nextInstruction!)
                } else {
                    wordsInGrid.append(nextInstruction!.fromWord.uppercased())
                    // Here we have the opportunity to reverse the instruction to make it a proper from:to relationship
                    result.append(reverseInstruction(nextInstruction!))
                }
            }
        }
        
        var haveAllInstructionsBeenProcessed = true
        if instructions.count > 0 {
            haveAllInstructionsBeenProcessed = false
        }
        
        return (result, haveAllInstructionsBeenProcessed)
    }
    
    static func reverseInstruction(_ i: InstructionModel) -> InstructionModel {
        let split = i.text.split(separator: ":")
        let fromWord = split[0]
        let toWord = split[1]
        
        return InstructionModel(text: toWord + ":" + fromWord, fromWord: i.toWord, fromPos: i.toPos, toWord: i.fromWord, toPos: i.fromPos, isValid: i.isValid)
    }
    static func findNextInstruction(instructions: inout [InstructionModel], wordsInGrid: [String]) -> (InstructionModel?, Bool) {
        // We are going to look through the instructions to find something that has a word in the from or to that is in the grid
        
        // And get rid of anything that is in both
        for i in 0..<instructions.count {
            
            let instruction = instructions[i]
            
            if wordsInGrid.contains(instruction.fromWord.uppercased()) && !wordsInGrid.contains(instruction.toWord.uppercased()) {
                instructions.remove(at: i)
                return (instruction, true)
            } else if !wordsInGrid.contains(instruction.fromWord.uppercased()) && wordsInGrid.contains(instruction.toWord.uppercased()) {
                instructions.remove(at: i)
                return (instruction, false)
            }
        }

        // We cannot find any matches
        return (nil,true)
        
    }
    
    static func removeRedundantInstructions(instructions: [InstructionModel], wordsInGrid:[String]) -> [InstructionModel] {
        // We are going to look through the instructions to find something that has a word in the from or to that is in the grid
        
        var removeItemsPosition: [Int] = []
        
        // And get rid of anything that is in both
        for i in 0..<instructions.count {
            
            let instruction = instructions[i]
            
            if wordsInGrid.contains(instruction.fromWord.uppercased()) && wordsInGrid.contains(instruction.toWord.uppercased()) {
                removeItemsPosition.append(i)
            }
        }
        
        if removeItemsPosition.count == 0 {
            return instructions
        }

        var result: [InstructionModel] = []
        for i in 0..<instructions.count {
            if !removeItemsPosition.contains(i) {
                result.append(instructions[i])
            }
        }
        return result
    }
    
}
