//
//  GameTurn.swift
//  ColorWars
//
//  Created by Kirill Botalov on 20.07.17.
//  Copyright © 2016 Kirill Botalov. All rights reserved.
//

extension Game {
    
    func calcMove(ai: Bool, newColor: Color, inPole: [Color], inCell: Cell ) -> (outPole: [Color], outCell: Cell) {
        
        //создание первичных переменных
        var poleT = inPole
        var savePoleT = inPole
        let poleTsize = poleT.count
        var newBorderCell: [Int] = []

        var playerCurentCell = inCell

        var playerOtherCell: Cell = Cell(border: [], inside: [])
        var playerOtherColor = Color.Block
        
        if ai {
            playerOtherCell = players[0].cell
            playerOtherColor = poleT[players[0].cell.all[0]]
        } else {
            playerOtherCell = players[1].cell
            playerOtherColor = poleT[players[0].cell.all[0]]
        }
        
        var check = false
        var cellsForCheck: [Int] = []
        var newCellsForCheck: [Int] = []
        
        //отсекание лишних ячеек из расчета и перекраска поля в технические ячейки
        for i in playerCurentCell.all {
            
            poleT[i] = .cellCurentPlayer
        }
        
        for i in playerOtherCell.all {
            
            poleT[i] = .cellOtherPlayer
        }
        
        //функция перевода border в inside
        func borderToInside() {
            
            newBorderCell.append(contentsOf: playerCurentCell.border)
            playerCurentCell.border = []

            for cell in newBorderCell {
                
                var checkCell = false
                
                for aroundCell in cellsAroundCell(inCell: cell, sizePole: poleTsize) {
                    
                    if !(poleT[aroundCell] == .Block ||
                        poleT[aroundCell] == .cellCurentPlayer) {
                        
                        checkCell = true
                        break
                    }
                }
                
                if checkCell {
                    playerCurentCell.border.append(cell)
                } else {
                    playerCurentCell.inside.append(cell)
                }
            }

            playerCurentCell.all = playerCurentCell.border + playerCurentCell.inside
            
            newBorderCell = []
        }

        //расчет добавления соседних ячеек
        newCellsForCheck = playerCurentCell.border

        repeat {

            check = false
            cellsForCheck = newCellsForCheck
            newCellsForCheck = []
            
            for cell in cellsForCheck { //поиск элементов на добавление

                for aroundCell in cellsAroundCell(inCell: cell, sizePole: poleTsize) {

                    if poleT[aroundCell] == newColor {

                        poleT[aroundCell] = .cellCurentPlayer
                        newCellsForCheck.append(aroundCell)
                        check = true
                    }
                }
            }
            
            newBorderCell.append(contentsOf: newCellsForCheck)
        } while check
        
        borderToInside()

        //расчет замкнутых пространств
        newCellsForCheck = playerCurentCell.border
        //глубина поиска
        for _ in 0..<4 {
            
            cellsForCheck = newCellsForCheck
            newCellsForCheck = []
            
            for cell in cellsForCheck {
                
                for arroundCell in cellsAroundCell(inCell: cell, sizePole: poleTsize) {
                    
                    let checkCellColor = poleT[arroundCell]
                    if checkCellColor == .Block ||
                            checkCellColor == .cellCurentPlayer ||
                                checkCellColor == .cellOtherPlayer ||
                                    checkCellColor == .Tech {
                        continue
                    }
                    
                    newCellsForCheck.append(arroundCell)
                    poleT[arroundCell] = .Tech
                }
            }
            
            newBorderCell.append(contentsOf: newCellsForCheck)
        }
        
        //отсечение лишник клеток
        newCellsForCheck = newBorderCell
        
        repeat {
            
            check = false
            cellsForCheck = newCellsForCheck
            newCellsForCheck = []
            
            for cell in cellsForCheck {
                
                var chekCell = true
                for arroundCell in cellsAroundCell(inCell: cell, sizePole: poleTsize) {
                    
                    let checkCellColor = poleT[arroundCell]
                    if !(checkCellColor == .Block ||
                        checkCellColor == .Tech ||
                            checkCellColor == .cellCurentPlayer) {
                    
                        chekCell = false
                        break
                    }
                }
                
                if chekCell {
                    newCellsForCheck.append(cell)
                } else {
                    poleT[cell] = savePoleT[cell]
                    check = true
                }
            }
        } while check
        
        newBorderCell = newCellsForCheck

        borderToInside()

        //перекраска поля в цвет из технического
        for i in 0..<poleTsize {
            
            if poleT[i] == .cellCurentPlayer || poleT[i] == .Tech {
                
                poleT[i] = newColor
                continue
            }
            
            if poleT[i] == .cellOtherPlayer {
                
                poleT[i] = playerOtherColor
                continue
            }
        }

        return (outPole: poleT, outCell: playerCurentCell)
    }

    //масив клеток вокруг базовой клетки
    func cellsAroundCell(inCell:Int, sizePole: Int) -> [Int] {

        let offset = GameConfig.poleSizeX
        var aroundСells: [Int] = []
        
        switch inCell {
        //лево нечет
        case 0, 57, 114, 171, 228, 285, 342, 399, 456, 513:
            aroundСells.append(offset)
            aroundСells.append(-(offset + 1))
            aroundСells.append(offset + 1)
            aroundСells.append(-offset)
            aroundСells.append(1)
        //лево чет
        case 28, 85, 142, 199, 256, 313, 370, 427, 484:
            aroundСells.append(offset + 1)
            aroundСells.append(-offset)
            aroundСells.append(1)
        //право нечет
        case 27, 84, 141, 198, 255, 312, 369, 426, 483, 540:
            aroundСells.append(-1)
            aroundСells.append(offset)
            aroundСells.append(-(offset + 1))
            aroundСells.append(offset + 1)
            aroundСells.append(-offset)
        //право чет
        case 56, 113, 170, 227, 284, 341, 398, 455, 512:
            aroundСells.append(-1)
            aroundСells.append(offset)
            aroundСells.append(-(offset + 1))
        default:
            aroundСells.append(-1)
            aroundСells.append(offset)
            aroundСells.append(-(offset + 1))
            aroundСells.append(offset + 1)
            aroundСells.append(-offset)
            aroundСells.append(1)
        }
        
        var returnedCell: [Int] = []
        for cell in aroundСells {
            
            let calcCellForCheck = cell + inCell
            if calcCellForCheck >= 0 && calcCellForCheck < sizePole {
                
                returnedCell.append(calcCellForCheck)
            }
        }

        return returnedCell
    }
}
