//
//  InstructionSequencer_Tests.swift
//  
//
//  Created by Michael Geurtjens on 13/4/2023.
//

import XCTest
@testable import TextToShapeMaker
final class InstructionSequencer_Tests: XCTestCase {

   
    func testExample() throws {
        let input = "nAZARETH:nUTS,NAzARETH:zION,sING:NUTs,SInG:ZIOn"
        
        let instructions = InstructionParser.parse(input, rotate: false)
        
        let (output, success, wordsInShape) = InstructionSequencer.executeGivingText(instructions: instructions)
        
        print(input)
        print(output)
        print(success)
        print(wordsInShape)
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func test_8612() throws {
        let input = "nAZARETH:nUTS,NAzARETH:zION,sING:NUTs,SInG:ZIOn + NAZAReTH:eVE,NAZARETh:hOLLY,BeLLS:EVe,BELlS:HOlLY + JOy:HOLLy + jOY:jELLY,HAZElNUT:JElLY,HAZELNUt:StAR + HAzELNUT:AzURE,HAZElNUT:JElLY,MErRY:AZUrE,MERRy:JELLy + hAZELNUT:hYMN,HAzELNUT:AzURE,mERRY:HYmN,MErRY:AZUrE + TURKEy:HyMN + TuRKEY:SAuCE + tOYS:tOAST,TOYs:sAUCE,tREE:TOASt,TREe:SAUCe + TOyS:FAMILy + INn:HYMn + TURkEY:PORk + WHiTE:FAMiLY + wHITE:SNOw + WHITe:CAKe"
        
       
        
        let instructions = InstructionParser.execute(input)
        
        let (output, success, wordsInShape) = InstructionSequencer.executeGivingText(instructions: instructions)
        
        
        let expected = "nAZARETH:nUTS,NAzARETH:zION,NUTs:sING,NAZAReTH:eVE,NAZARETh:hOLLY,EVe:BeLLS,HOLLy:JOy,jOY:jELLY,JElLY:HAZElNUT,HAZELNUt:StAR,HAzELNUT:AzURE,AZUrE:MErRY,hAZELNUT:hYMN,HyMN:TURKEy,TuRKEY:SAuCE,sAUCE:TOYs,tOYS:tOAST,TOASt:tREE,TOyS:FAMILy,HYMn:INn,TURkEY:PORk,FAMiLY:WHiTE,wHITE:SNOw,WHITe:CAKe"
        
        print(output)
        XCTAssertEqual(expected, output)
        XCTAssertTrue(success)
        print(wordsInShape)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
}
