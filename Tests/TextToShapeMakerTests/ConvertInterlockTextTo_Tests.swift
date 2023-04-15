//
//  ConvertInterlockTextTo_Tests.swift
//  
//
//  Created by Michael Geurtjens on 13/4/2023.
//

import XCTest
@testable import TextToShapeMaker
final class ConvertInterlockTextTo_Tests: XCTestCase {

    
    func test_shapesArray() throws {
        let input = "nAZARETH:nUTS + NAzARETH:zION + sING:NUTs + SInG:ZIOn"
        
        let (a,_,c) = ConvertInterlockTextTo.shapes(input)
        
        print(c)
        print(a[0].text)
        print(a[1].text)
        print(a[2].text)
        print(a[3].text)
        
        let expectedWords = ["NAZARETH", "NUTS", "ZION", "SING"]
        //let id = [0, 1, 2, 3] // Just to help reader recognize where the id comes from, its the order that the expected words are in
        
        let (indexArray, shapeArray, _, _) = ConvertInterlockTextTo.shapesGpuArrays(input, expectedWords: expectedWords)
        
        // We gave four shapes so we should receive four shapes back
        XCTAssertEqual(4, indexArray.count)
        
        let shape1_startPos = Int(indexArray[0])
        let shape2_startPos = Int(indexArray[1])
        let shape3_startPos = Int(indexArray[2])
        let shape4_startPos = Int(indexArray[3])
        
        
        let shape1_wordCount = Int(shapeArray[shape1_startPos])
        let shape1_interlockScoreLow = Int(shapeArray[shape1_startPos + 1])
        let shape1_interlockScoreHigh = Int(shapeArray[shape1_startPos + 2])
        let shape1_width = Int(shapeArray[shape1_startPos + 3])
        let shape1_height = Int(shapeArray[shape1_startPos + 4])
        let shape1_id1 = Int(shapeArray[shape1_startPos + 5])
        let shape1_id2 = Int(shapeArray[shape1_startPos + 6])
        let shape1_isHorizontal1 = Int(shapeArray[shape1_startPos + 7]) == 1
        let shape1_isHorizontal2 = Int(shapeArray[shape1_startPos + 8]) == 1
        let shape1_x1 = Int(shapeArray[shape1_startPos + 9])
        let shape1_x2 = Int(shapeArray[shape1_startPos + 10])
        let shape1_y1 = Int(shapeArray[shape1_startPos + 11])
        let shape1_y2 = Int(shapeArray[shape1_startPos + 12])
        
        let shape1_interlockScore = shape1_interlockScoreLow + shape1_interlockScoreHigh * 0xFF
        
        XCTAssertEqual(2, shape1_wordCount)
        XCTAssertEqual(8, shape1_interlockScore)
        XCTAssertEqual(10, shape1_width)
        XCTAssertEqual(6, shape1_height)
        
        /*
         .
        .NAZARETH.
         U
         T
         S
         .
         */
        
        XCTAssertEqual(0, shape1_id1)
        XCTAssertTrue(shape1_isHorizontal1)
        XCTAssertEqual(0, shape1_x1)
        XCTAssertEqual(1, shape1_y1)
        
        XCTAssertEqual(1, shape1_id2)
        XCTAssertFalse(shape1_isHorizontal2)
        XCTAssertEqual(1, shape1_x2)
        XCTAssertEqual(0, shape1_y2)
        
        
        
        let shape2_wordCount = Int(shapeArray[shape2_startPos])
        let shape2_interlockScoreLow = Int(shapeArray[shape2_startPos + 1])
        let shape2_interlockScoreHigh = Int(shapeArray[shape2_startPos + 2])
        let shape2_width = Int(shapeArray[shape2_startPos + 3])
        let shape2_height = Int(shapeArray[shape2_startPos + 4])
        let shape2_id1 = Int(shapeArray[shape2_startPos + 5])
        let shape2_id2 = Int(shapeArray[shape2_startPos + 6])
        let shape2_isHorizontal1 = Int(shapeArray[shape2_startPos + 7]) == 1
        let shape2_isHorizontal2 = Int(shapeArray[shape2_startPos + 8]) == 1
        let shape2_x1 = Int(shapeArray[shape2_startPos + 9])
        let shape2_x2 = Int(shapeArray[shape2_startPos + 10])
        let shape2_y1 = Int(shapeArray[shape2_startPos + 11])
        let shape2_y2 = Int(shapeArray[shape2_startPos + 12])
        
        let shape2_interlockScore = shape2_interlockScoreLow + shape2_interlockScoreHigh * 0xFF
        
        XCTAssertEqual(2, shape2_wordCount)
        XCTAssertEqual(64, shape2_interlockScore)
        XCTAssertEqual(10, shape2_width)
        XCTAssertEqual(6, shape2_height)
        
        /*
         .
      .NAZARETH.
         I
         O
         N
         .
         */
        XCTAssertEqual(0, shape2_id1)
        XCTAssertTrue(shape2_isHorizontal1)
        XCTAssertEqual(0, shape2_x1)
        XCTAssertEqual(1, shape2_y1)
        
        XCTAssertEqual(2, shape2_id2)
        XCTAssertFalse(shape2_isHorizontal2)
        XCTAssertEqual(3, shape2_x2)
        XCTAssertEqual(0, shape2_y2)
        

        
        let shape3_wordCount = Int(shapeArray[shape3_startPos])
        let shape3_interlockScoreLow = Int(shapeArray[shape3_startPos + 1])
        let shape3_interlockScoreHigh = Int(shapeArray[shape3_startPos + 2])
        let shape3_width = Int(shapeArray[shape3_startPos + 3])
        let shape3_height = Int(shapeArray[shape3_startPos + 4])
        let shape3_id1 = Int(shapeArray[shape3_startPos + 5])
        let shape3_id2 = Int(shapeArray[shape3_startPos + 6])
        let shape3_isHorizontal1 = Int(shapeArray[shape3_startPos + 7]) == 1
        let shape3_isHorizontal2 = Int(shapeArray[shape3_startPos + 8]) == 1
        let shape3_x1 = Int(shapeArray[shape3_startPos + 9])
        let shape3_x2 = Int(shapeArray[shape3_startPos + 10])
        let shape3_y1 = Int(shapeArray[shape3_startPos + 11])
        let shape3_y2 = Int(shapeArray[shape3_startPos + 12])
        
        let shape3_interlockScore = shape3_interlockScoreLow + shape3_interlockScoreHigh * 0xFF
        
        XCTAssertEqual(2, shape3_wordCount)
        XCTAssertEqual(16, shape3_interlockScore)
        XCTAssertEqual(6, shape3_width)
        XCTAssertEqual(6, shape3_height)

        /*
         .
         N
         U
         T
        .SING.
         .
         */
        
        XCTAssertEqual(3, shape3_id1)
        XCTAssertTrue(shape3_isHorizontal1)
        XCTAssertEqual(0, shape3_x1)
        XCTAssertEqual(4, shape3_y1)
        
        XCTAssertEqual(1, shape3_id2)
        XCTAssertFalse(shape3_isHorizontal2)
        XCTAssertEqual(1, shape3_x2)
        XCTAssertEqual(0, shape3_y2)
        
        
        
        let shape4_wordCount = Int(shapeArray[shape4_startPos])
        let shape4_interlockScoreLow = Int(shapeArray[shape4_startPos + 1])
        let shape4_interlockScoreHigh = Int(shapeArray[shape4_startPos + 2])
        let shape4_width = Int(shapeArray[shape4_startPos + 3])
        let shape4_height = Int(shapeArray[shape4_startPos + 4])
        
        let shape4_id1 = Int(shapeArray[shape4_startPos + 5])
        let shape4_id2 = Int(shapeArray[shape4_startPos + 6])
        let shape4_isHorizontal1 = Int(shapeArray[shape4_startPos + 7]) == 1
        let shape4_isHorizontal2 = Int(shapeArray[shape4_startPos + 8]) == 1
        let shape4_x1 = Int(shapeArray[shape4_startPos + 9])
        let shape4_x2 = Int(shapeArray[shape4_startPos + 10])
        let shape4_y1 = Int(shapeArray[shape4_startPos + 11])
        let shape4_y2 = Int(shapeArray[shape4_startPos + 12])
        
        let shape4_interlockScore = shape4_interlockScoreLow + shape4_interlockScoreHigh * 0xFF
        
        XCTAssertEqual(2, shape4_wordCount)
        XCTAssertEqual(8, shape4_interlockScore)
        XCTAssertEqual(6, shape4_width)
        XCTAssertEqual(6, shape4_height)
        
        /*
         .
         Z
         I
         O
      .SING.
         .
         */
        
        XCTAssertEqual(3, shape4_id1)
        XCTAssertTrue(shape4_isHorizontal1)
        XCTAssertEqual(0, shape4_x1)
        XCTAssertEqual(4, shape4_y1)
        
        XCTAssertEqual(2, shape4_id2)
        XCTAssertFalse(shape4_isHorizontal2)
        XCTAssertEqual(3, shape4_x2)
        XCTAssertEqual(0, shape4_y2)
    }
    
    
    
    
    
    
    func test_8612() throws {
    
        let input = "nAZARETH:nUTS,NAzARETH:zION,sING:NUTs,SInG:ZIOn + NAZAReTH:eVE,NAZARETh:hOLLY,BeLLS:EVe,BELlS:HOlLY + JOy:HOLLy + jOY:jELLY,HAZElNUT:JElLY,HAZELNUt:StAR + HAzELNUT:AzURE,HAZElNUT:JElLY,MErRY:AZUrE,MERRy:JELLy + hAZELNUT:hYMN,HAzELNUT:AzURE,mERRY:HYmN,MErRY:AZUrE + TURKEy:HyMN + TuRKEY:SAuCE + tOYS:tOAST,TOYs:sAUCE,tREE:TOASt,TREe:SAUCe + TOyS:FAMILy + INn:HYMn + TURkEY:PORk + WHiTE:FAMiLY + wHITE:SNOw + WHITe:CAKe"
        
        let (shape, success, wordsInShape) = ConvertInterlockTextTo.shape(input)
        
        let expected = "" +
            " . . . . .  . .  \n" +
            " S F C.NAZARETH. \n" +
            " N A A U I  V O  \n" +
            " O M K T O.BELLS.\n" +
            ".WHITE.SING.. L  \n" +
            " . L..P. ...JOY. \n" +
            ".TOYS.O . A E .S \n" +
            " O .A R.HAZELNUT.\n" +
            " A.TURKEY.U L  A \n" +
            " S  C ..MERRY. R \n" +
            ".TREE.INN.E .  . \n" +
            " .  .   . .      "
        
        XCTAssertEqual(expected, shape.text)
        XCTAssertTrue(success)
        XCTAssertEqual(694, shape.score)
        XCTAssertEqual(17, shape.width)
        XCTAssertEqual(12, shape.height)
        print(shape.text)
        print(wordsInShape)
        
    
    }

    func test_8612_Shapes() throws {
    
        let input = "nAZARETH:nUTS,NAzARETH:zION,sING:NUTs,SInG:ZIOn + NAZAReTH:eVE,NAZARETh:hOLLY,BeLLS:EVe,BELlS:HOlLY + JOy:HOLLy + jOY:jELLY,HAZElNUT:JElLY,HAZELNUt:StAR + HAzELNUT:AzURE,HAZElNUT:JElLY,MErRY:AZUrE,MERRy:JELLy + hAZELNUT:hYMN,HAzELNUT:AzURE,mERRY:HYmN,MErRY:AZUrE + TURKEy:HyMN + TuRKEY:SAuCE + tOYS:tOAST,TOYs:sAUCE,tREE:TOASt,TREe:SAUCe + TOyS:FAMILy + INn:HYMn + TURkEY:PORk + WHiTE:FAMiLY + wHITE:SNOw + WHITe:CAKe"
        
        let (shapes, success, wordsInShapes) = ConvertInterlockTextTo.shapes(input)
        
        print(wordsInShapes)
        XCTAssertTrue(success)
        XCTAssertEqual(15, shapes.count)
        
        let a0 = shapes[0];
        let a1 = shapes[1];
        let a2 = shapes[2];
        let a3 = shapes[3];
        let a4 = shapes[4];
        let a5 = shapes[5];
        let a6 = shapes[6];
        let a7 = shapes[7];
        let a8 = shapes[8];
        let a9 = shapes[9];
        let a10 = shapes[10];
        let a11 = shapes[11];
        let a12 = shapes[12];
        let a13 = shapes[13];
        let a14 = shapes[14];
        
        
        let a0_e = "" +
        " . .      \n" +
        ".nAzARETH.\n" +
        " U I      \n" +
        " T O      \n" +
        ".sInG.    \n" +
        " . .      "
        XCTAssertEqual(a0_e.uppercased(), a0.text)
        XCTAssertEqual(136, a0.score)
        XCTAssertEqual(10, a0.width)
        XCTAssertEqual(6, a0.height)
        
        let a1_e = "" +
        "      . .  \n" +
        ".NAZAReTh. \n" +
        "      V O  \n" +
        "    .BeLlS.\n" +
        "      . L  \n" +
        "        Y  \n" +
        "        .  "
        XCTAssertEqual(a1_e.uppercased(), a1.text)
        XCTAssertEqual(52, a1.score)
        XCTAssertEqual(11, a1.width)
        XCTAssertEqual(7, a1.height)
        
        let a2_e = "" +
        "   . \n" +
        "   H \n" +
        "   O \n" +
        "   L \n" +
        "   L \n" +
        ".JOy.\n" +
        "   . "
        XCTAssertEqual(a2_e.uppercased(), a2.text)
        XCTAssertEqual(52, a2.score)
        XCTAssertEqual(5, a2.width)
        XCTAssertEqual(7, a2.height)
        
        let a3_e = "" +
        "     .    \n" +
        "    .jOY. \n" +
        "     E  S \n" +
        ".HAZElNUt.\n" +
        "     L  A \n" +
        "     Y  R \n" +
        "     .  . "
        XCTAssertEqual(a3_e.uppercased(), a3.text)
        XCTAssertEqual(64, a3.score)
        XCTAssertEqual(10, a3.width)
        XCTAssertEqual(7, a3.height)
        
        let a4_e = "" +
        "     .    \n" +
        "   . J    \n" +
        "   A E    \n" +
        ".HAzElNUT.\n" +
        "   U L    \n" +
        ".MErRy.   \n" +
        "   E .    \n" +
        "   .      "
        XCTAssertEqual(a4_e.uppercased(), a4.text)
        XCTAssertEqual(148, a4.score)
        XCTAssertEqual(10, a4.width)
        XCTAssertEqual(8, a4.height)
        
        let a5_e = "" +
        "   .      \n" +
        " . A      \n" +
        ".hAzELNUT.\n" +
        " Y U      \n" +
        ".mErRY.   \n" +
        " N E      \n" +
        " . .      "
        XCTAssertEqual(a5_e.uppercased(), a5.text)
        XCTAssertEqual(124, a5.score)
        XCTAssertEqual(10, a5.width)
        XCTAssertEqual(7, a5.height)
        
        let a6_e = "" +
        "      . \n" +
        "      H \n" +
        ".TURKEy.\n" +
        "      M \n" +
        "      N \n" +
        "      . "
        XCTAssertEqual(a6_e.uppercased(), a6.text)
        XCTAssertEqual(52, a6.score)
        XCTAssertEqual(8, a6.width)
        XCTAssertEqual(6, a6.height)
        
        let a7_e = "" +
        "  .     \n" +
        "  S     \n" +
        "  A     \n" +
        ".TuRKEY.\n" +
        "  C     \n" +
        "  E     \n" +
        "  .     "
        XCTAssertEqual(a7_e.uppercased(), a7.text)
        XCTAssertEqual(36, a7.score)
        XCTAssertEqual(8, a7.width)
        XCTAssertEqual(7, a7.height)
        
        let a8_e = "" +
        " .  . \n" +
        ".tOYs.\n" +
        " O  A \n" +
        " A  U \n" +
        " S  C \n" +
        ".tREe.\n" +
        " .  . "
        XCTAssertEqual(a8_e.uppercased(), a8.text)
        XCTAssertEqual(90, a8.score)
        XCTAssertEqual(6, a8.width)
        XCTAssertEqual(7, a8.height)
        
        let a9_e = "" +
        "   .  \n" +
        "   F  \n" +
        "   A  \n" +
        "   M  \n" +
        "   I  \n" +
        "   L  \n" +
        ".TOyS.\n" +
        "   .  "
        XCTAssertEqual(a9_e.uppercased(), a9.text)
        XCTAssertEqual(52, a9.score)
        XCTAssertEqual(6, a9.width)
        XCTAssertEqual(8, a9.height)
        
        let a10_e = "" +
        "   . \n" +
        "   H \n" +
        "   Y \n" +
        "   M \n" +
        ".INn.\n" +
        "   . "
        XCTAssertEqual(a10_e.uppercased(), a10.text)
        XCTAssertEqual(28, a10.score)
        XCTAssertEqual(5, a10.width)
        XCTAssertEqual(6, a10.height)
        
        let a11_e = "" +
        "    .   \n" +
        "    P   \n" +
        "    O   \n" +
        "    R   \n" +
        ".TURkEY.\n" +
        "    .   "
        XCTAssertEqual(a11_e.uppercased(), a11.text)
        XCTAssertEqual(24, a11.score)
        XCTAssertEqual(8, a11.width)
        XCTAssertEqual(6, a11.height)
        
        let a12_e = "" +
        "   .   \n" +
        "   F   \n" +
        "   A   \n" +
        "   M   \n" +
        ".WHiTE.\n" +
        "   L   \n" +
        "   Y   \n" +
        "   .   "
        XCTAssertEqual(a12_e.uppercased(), a12.text)
        XCTAssertEqual(24, a12.score)
        XCTAssertEqual(7, a12.width)
        XCTAssertEqual(8, a12.height)
        
        let a13_e = "" +
        " .     \n" +
        " S     \n" +
        " N     \n" +
        " O     \n" +
        ".wHITE.\n" +
        " .     "
        XCTAssertEqual(a13_e.uppercased(), a13.text)
        XCTAssertEqual(36, a13.score)
        XCTAssertEqual(7, a13.width)
        XCTAssertEqual(6, a13.height)
        
        let a14_e = "" +
        "     . \n" +
        "     C \n" +
        "     A \n" +
        "     K \n" +
        ".WHITe.\n" +
        "     . "
        XCTAssertEqual(a14_e.uppercased(), a14.text)
        XCTAssertEqual(22, a14.score)
        XCTAssertEqual(7, a14.width)
        XCTAssertEqual(6, a14.height)
        
    }
}
