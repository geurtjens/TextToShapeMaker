//
//  InstructionParserTests.swift
//  
//
//  Created by Michael Geurtjens on 9/4/2023.
//

import XCTest
@testable import TextToShapeMaker
final class InstructionParserTests: XCTestCase {

    func test_Blank() throws {
        let result = InstructionParser.execute("")
        XCTAssertEqual(0,result.count)
    }
    
    func test_Same() throws {
        let result = InstructionParser.execute("KaORI:KaORI")
        XCTAssertEqual(1,result.count)
        let a = result[0]
        XCTAssertEqual("KaORI",a.fromWord)
        XCTAssertEqual(1, a.fromPos)
        XCTAssertEqual("KaORI", a.toWord)
        XCTAssertEqual(1, a.toPos)
        XCTAssertEqual(InstructionValidationType.sameWord, a.isValid)
    }
    
    func test_One() throws {
        let result = InstructionParser.execute("MiCHAEL:KAORi")
        XCTAssertEqual(1,result.count)
        
        let a = result[0]
        XCTAssertEqual("MICHAEL",a.fromWord)
        XCTAssertEqual(1, a.fromPos)
        XCTAssertEqual("KAORI", a.toWord)
        XCTAssertEqual(4, a.toPos)
        XCTAssertEqual(InstructionValidationType.success, a.isValid)
    }
    
    func test_One_WordBlankLeft() throws {
        let result = InstructionParser.execute(":KaORI")
        XCTAssertEqual(1,result.count)
        
        let a = result[0]
        XCTAssertEqual("",a.fromWord)
        XCTAssertEqual(-1, a.fromPos)
        XCTAssertEqual("", a.toWord)
        XCTAssertEqual(-1, a.toPos)
        XCTAssertEqual(InstructionValidationType.wordSeparatorError, a.isValid)
    }
    
    func test_One_WordBlankRight() throws {
        let result = InstructionParser.execute("MiCHAEL:")
        XCTAssertEqual(1,result.count)
        
        let a = result[0]
        XCTAssertEqual("",a.fromWord)
        XCTAssertEqual(-1, a.fromPos)
        XCTAssertEqual("", a.toWord)
        XCTAssertEqual(-1, a.toPos)
        XCTAssertEqual(InstructionValidationType.wordSeparatorError, a.isValid)
    }
    
    func test_One_TwoManyInterlocksLeft() throws {
        let result = InstructionParser.execute("miCHAEL:KAORi")
        XCTAssertEqual(1,result.count)
        
        let a = result[0]
        XCTAssertEqual("miCHAEL",a.fromWord)
        XCTAssertEqual(-1, a.fromPos)
        XCTAssertEqual("KAORi", a.toWord)
        XCTAssertEqual(4, a.toPos)
        XCTAssertEqual(InstructionValidationType.interlockNotFound, a.isValid)
    }
    
    func test_One_TwoManyInterlocksRight() throws {
        let result = InstructionParser.execute("MiCHAEL:kAORi")
        XCTAssertEqual(1,result.count)
        
        let a = result[0]
        XCTAssertEqual("MiCHAEL",a.fromWord)
        XCTAssertEqual(1, a.fromPos)
        XCTAssertEqual("kAORi", a.toWord)
        XCTAssertEqual(-1, a.toPos)
        XCTAssertEqual(InstructionValidationType.interlockNotFound, a.isValid)
    }
    
    func test_One_NoInterlocksLeft() throws {
        let result = InstructionParser.execute("MICHAEL:KAORi")
        XCTAssertEqual(1,result.count)
        
        let a = result[0]
        XCTAssertEqual("MICHAEL",a.fromWord)
        XCTAssertEqual(-1, a.fromPos)
        XCTAssertEqual("KAORi", a.toWord)
        XCTAssertEqual(4, a.toPos)
        XCTAssertEqual(InstructionValidationType.interlockNotFound, a.isValid)
    }
    
    func test_One_NoInterlocksRight() throws {
        let result = InstructionParser.execute("MiCHAEL:KAORI")
        XCTAssertEqual(1,result.count)
        
        let a = result[0]
        XCTAssertEqual("MiCHAEL",a.fromWord)
        XCTAssertEqual(1, a.fromPos)
        XCTAssertEqual("KAORI", a.toWord)
        XCTAssertEqual(-1, a.toPos)
        XCTAssertEqual(InstructionValidationType.interlockNotFound, a.isValid)
    }
    
    func test_One_InterlockNotMatching() throws {
        let result = InstructionParser.execute("MiCHAEL:KaORI")
        XCTAssertEqual(1,result.count)
        
        let a = result[0]
        XCTAssertEqual("MiCHAEL",a.fromWord)
        XCTAssertEqual(1, a.fromPos)
        XCTAssertEqual("KaORI", a.toWord)
        XCTAssertEqual(1, a.toPos)
        XCTAssertEqual(InstructionValidationType.interlockNotMatching, a.isValid)
    }
    
    /// We find that the words are now uppercased ready for creating a shape
    func test_Two() throws {
        let result = InstructionParser.execute("MiCHAEL:KAORi,kAORI:kAREN")
        XCTAssertEqual(2,result.count)
        
        let a = result[0]
        let b = result[1]
        XCTAssertEqual("MICHAEL",a.fromWord)
        XCTAssertEqual(1, a.fromPos)
        XCTAssertEqual("KAORI", a.toWord)
        XCTAssertEqual(4, a.toPos)
        XCTAssertEqual(InstructionValidationType.success, a.isValid)
        
        XCTAssertEqual("KAORI",b.fromWord)
        XCTAssertEqual(0, b.fromPos)
        XCTAssertEqual("KAREN", b.toWord)
        XCTAssertEqual(0, b.toPos)
        XCTAssertEqual(InstructionValidationType.success, b.isValid)
    }
    
    /// The words are still capitalized because they are validly extracted from text
    /// but they are not found in the sequence above them and that is a rule to follow.
    func test_Two_WordsNotFoundInGrid() throws {
        let instructions = InstructionParser.execute("MiCHAEL:KAORi,JAMeS:KAReN")
        XCTAssertEqual(2,instructions.count)
        
        let a = instructions[0]
        let b = instructions[1]
        XCTAssertEqual("MICHAEL",a.fromWord)
        XCTAssertEqual(1, a.fromPos)
        XCTAssertEqual("KAORI", a.toWord)
        XCTAssertEqual(4, a.toPos)
        XCTAssertEqual(InstructionValidationType.success, a.isValid)
        
        XCTAssertEqual("JAMES",b.fromWord)
        XCTAssertEqual(3, b.fromPos)
        XCTAssertEqual("KAREN", b.toWord)
        XCTAssertEqual(3, b.toPos)
        
        let (game, success) = InstructionSequencer.execute(instructions: instructions)
        XCTAssertFalse(success)
        XCTAssertEqual(1,game.count)
        let c = game[0]
        XCTAssertEqual("MICHAEL",c.fromWord)
        XCTAssertEqual(1, c.fromPos)
        XCTAssertEqual("KAORI", c.toWord)
        XCTAssertEqual(4, c.toPos)
        XCTAssertEqual(InstructionValidationType.success, c.isValid)
        
        let (resultText, resultTextSuccess) = InstructionSequencer.executeGivingText(instructions: instructions)
        XCTAssertEqual("MiCHAEL:KAORi",resultText)
        XCTAssertFalse(resultTextSuccess)
    }

    /// The point of this test is:
    /// If future instructions are already placed into the grid then we do not have to accept it
    func test_Two_WordsBothFoundInGrid() throws {
        let instructions = InstructionParser.execute("MiCHAEL:KAORi,MICHaEL:KaORI")
        XCTAssertEqual(2,instructions.count)
        
        let a = instructions[0]
        let b = instructions[1]
        XCTAssertEqual("MICHAEL",a.fromWord)
        XCTAssertEqual(1, a.fromPos)
        XCTAssertEqual("KAORI", a.toWord)
        XCTAssertEqual(4, a.toPos)
        XCTAssertEqual(InstructionValidationType.success, a.isValid)
        
        XCTAssertEqual("MICHAEL",b.fromWord)
        XCTAssertEqual(4, b.fromPos)
        XCTAssertEqual("KAORI", b.toWord)
        XCTAssertEqual(1, b.toPos)
        
        let (game, isConnected) = InstructionSequencer.execute(instructions: instructions)
        
        // Success means that we eliminated the instruction that contained words we already have but that is not an error, just that we have a collection of interlocks of which the last one is redundant
        // But the whole structure is all connected just that we did not act on one of the instructions
        XCTAssertTrue(isConnected)
        XCTAssertEqual(1,game.count)
        let c = game[0]
        XCTAssertEqual("MICHAEL",c.fromWord)
        XCTAssertEqual(1, c.fromPos)
        XCTAssertEqual("KAORI", c.toWord)
        XCTAssertEqual(4, c.toPos)
        XCTAssertEqual(InstructionValidationType.success, c.isValid)
        
        let (resultText, success) = InstructionSequencer.executeGivingText(instructions: instructions)
        XCTAssertEqual("MiCHAEL:KAORi",resultText)
        XCTAssertTrue(success)
        
    }

}
