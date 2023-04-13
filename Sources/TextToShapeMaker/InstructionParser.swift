//
//  File.swift
//  
//
//  Created by Michael Geurtjens on 9/4/2023.
//

import Foundation
struct InstructionParser {
    
    static func execute(_ text: String) -> [InstructionModel] {
        
        // Remove all spaces and duplicated ::
        let (text, rotated) = prepareText(text: text)
        
        if text == "" {
            return []
        }
        
        
        // Extract all the left and right words
        let instructions = parse(text, rotate: rotated)

        return instructions
    }
    
    static func prepareText(text: String) -> (String, Bool) {
        
        
        var result = text
        result = result.replacingOccurrences(of: "+", with: ",") // caters for merging characters
        result = result.replacingOccurrences(of: "(", with: "") // caters for merging characters where user merges large shapes together
        result = result.replacingOccurrences(of: ")", with: "") // caters for merging characters the brackets are just syntactic sugar
        
        // This might happen as a typo
        result = result.replacingOccurrences(of: "::", with: ":")
        
        // remove all spaces
        result = result.replacingOccurrences(of: " ", with: "")
        
        if result == "" {
            return ("", false)
        }
        
        var rotateShape = false
        if result[0] == "!" {
            rotateShape = true
            result = result.replacingOccurrences(of: "!", with: "")
        }

        
        return (result, rotateShape)
    }
    
    
    static func parse(_ text: String, rotate: Bool) -> [InstructionModel] {
        let csv = getListOfInstructions(text, rotate: rotate)
        let instructions = csvToInstructionModel(csv)
        
        return instructions
    }
    
    static func getListOfInstructions(_ text: String, rotate: Bool) -> [String] {
        let csv = text.split(separator: ",")
        
        var result: [String] = []
        for instruction in csv {
            if instruction != "" {
                if rotate && result.count == 0 {
                    result.append(rotateInstruction(String(instruction)))
                } else {
                    result.append(String(instruction))
                }
            }
        }
        return result
    }
    
    static func rotateInstruction(_ instruction: String) -> String {
        let split = instruction.split(separator:":")
        
        if split.count == 2 {
            return split[1] + ":" + split[0]
        } else {
            return instruction
        }
    }
    
    // If it cannot find the interlock or there is more than one interlock then its nil
    static func findInterlock(word: String) -> Int {
        var interlockPosition = -1
        for i in 0..<word.count {
            let char = word[i]
            if String(char).lowercased() == String(char) {
                if interlockPosition != -1 {
                    // We have already set the interlock position
                    return -1
                } else {
                    interlockPosition = i
                }
            }
        }
        return interlockPosition
    }
    
    static func csvToInstructionModel(_ csv: [String]) -> [InstructionModel] {

        var result: [InstructionModel] = []
        for instruction in csv {
            let splitter = instruction.split(separator:":")
            
            if splitter.count == 2 {
                let leftWord = String(splitter[0])
                let rightWord = String(splitter[1])
                
                let leftPos = findInterlock(word: leftWord)
                let rightPos = findInterlock(word: rightWord)
                
                if leftPos == -1 || rightPos == -1 {
                    result.append(InstructionModel(
                        text: instruction,
                        fromWord: leftWord,
                        fromPos: leftPos,
                        toWord: rightWord,
                        toPos: rightPos,
                        isValid: .interlockNotFound))
                }
                else if leftWord[leftPos] != rightWord[rightPos] {
                    result.append(InstructionModel(
                        text:instruction,
                        fromWord: leftWord,
                        fromPos: leftPos,
                        toWord: rightWord,
                        toPos: rightPos,
                        isValid: .interlockNotMatching))
                }
                
                else if leftWord.uppercased() == rightWord.uppercased() {
                    result.append(InstructionModel(
                        text: instruction,
                        fromWord: leftWord,
                        fromPos: leftPos,
                        toWord: rightWord,
                        toPos: rightPos,
                        isValid: .sameWord))
                }
                else if leftWord.uppercased() != rightWord.uppercased() {
                    // This is valid so lets uppercase both words ready for shape creation
                    result.append(InstructionModel(
                        text:instruction,
                        fromWord: leftWord.uppercased(),
                        fromPos: leftPos,
                        toWord: rightWord.uppercased(),
                        toPos: rightPos,
                        isValid: .success))
                }
                
            } else {
                result.append(InstructionModel(
                    text: instruction,
                    fromWord:"",
                    fromPos: -1,
                    toWord: "",
                    toPos: -1,
                    isValid: .wordSeparatorError))
            }
            
        }
        return result
    }
}
extension StringProtocol {
    subscript(_ offset: Int) -> Element     {
        self[index(startIndex, offsetBy: offset)]
    }
}
