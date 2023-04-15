//
//  ConvertInterlockTextTo.swift
//  
//
//  Created by Michael Geurtjens on 11/4/2023.
//

import Foundation
public struct ConvertInterlockTextTo {
    static public func shape(_ text: String) -> (ShapeModel, Bool, [String]) {
        let unsequencedInstructions = InstructionParser.execute(text)
        let (instructions, success, wordsInShape) = InstructionSequencer.execute(instructions: unsequencedInstructions)
        
        let placements = PlacementCalculator.execute(instructions: instructions)
        let shape = ShapeCalculator.execute(placements: placements)
        return (shape, success, wordsInShape)
    }
    
    static public func shapes(_ text: String) -> ([ShapeModel], Bool, [String]) {
        
        // We are going to separate by the +
        let textSplit = text.split(separator: "+")

        var isSuccess = true

        var wordsInShapes: Set<String> = []
        
        var shapeArray:[ShapeModel] = []
        for textItem in textSplit {
            
            let instructionText = String(textItem).replacingOccurrences(of: " ", with: "")
            let (shape, success, wordsInShape) = shape(String(instructionText))
            
            for wordInShape in wordsInShape {
                wordsInShapes.insert(wordInShape)
            }
            
            if success == false {
                isSuccess = false
            }
            shapeArray.append(shape)
        }
        return (shapeArray, isSuccess, Array(wordsInShapes))
    }
    
    static public func shapesArray(_ text: String) -> ([[UInt8]], Bool, [String]) {
        
        // We are going to separate by the +
        let (shapes, success, wordsInGrid) = shapes(text)

        let array = ConvertShapesToArray.execute(shapes: shapes, words: wordsInGrid)
        
        return (array, success, wordsInGrid)
    }
    
    static public func shapesArray(_ text: String, expectedWords: [String]) -> ([[UInt8]], Bool, [String]) {
        
        // We are going to separate by the +
        let (shapes, success, _) = shapes(text)

        let array = ConvertShapesToArray.execute(shapes: shapes, words: expectedWords)
        
        if array.count == 0 {
            return ([], false, [])
        } else {
            return (array, success, expectedWords)
        }
        
    }
    static public func shapesGpuArrays(_ text: String, expectedWords: [String]) -> ([UInt32], [UInt8], Bool, [String]) {
        
        let (arrayOfArrays, success, wordsInGrid) = shapesArray(text, expectedWords: expectedWords)

        var indexArray: [UInt32] = []
        var shapeArray: [UInt8] = []
        
        for array in arrayOfArrays {
            indexArray.append(UInt32(shapeArray.count))
            shapeArray += array
        }
        
        return (indexArray, shapeArray, success, wordsInGrid)
    }
}
