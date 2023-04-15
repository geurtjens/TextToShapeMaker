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
    
    static public func fromGpuArraysToShapes( indexArray: [UInt32], shapeArray: [UInt8], words: [String]) -> ([ShapeModel], Bool) {

        var success = true

        var shapes: [ShapeModel] = []
        for i in indexArray {
            let startPos = Int(i)
            let wordCount = Int(shapeArray[startPos])
            
            let interlockScoreLow = Int(shapeArray[startPos + 1])
            let interlockScoreHigh = Int(shapeArray[startPos + 2])
            let interlockScore = interlockScoreLow + interlockScoreHigh * 0xFF
            let width = Int(shapeArray[startPos + 3])
            let height = Int(shapeArray[startPos + 4])
            
            var placements: [PlacementModel] = []
            
            for j in 0..<wordCount {
                // when j = 1 idx should be 13
                let idx = startPos + 5 + j
                
                let wordId = Int(shapeArray[idx])
                let word = words[wordId]
                
                let isHorizontal = Int(shapeArray[idx + wordCount]) == 1
                let x = Int(shapeArray[idx + wordCount * 2])
                let y = Int(shapeArray[idx + wordCount * 3])
            
                placements.append(PlacementModel(word: word, isHorizontal: isHorizontal, x: x, y: y))
            }

            let score = interlockScore + placements.count * 10
            
            let blockOffsetsCateredFor = ShapeCalculator.allowForBlockOffsetsBeingAppliedLater(placements: placements)
            // We dont really need width, height and score to make a shape, only the placements
            let shape = ShapeCalculator.execute(placements: blockOffsetsCateredFor)
            
            if shape.width != width || shape.height != height || shape.score != score {
                success = false
            }
            
            shapes.append(shape)
        }
        return (shapes, success)
    }
    
}
