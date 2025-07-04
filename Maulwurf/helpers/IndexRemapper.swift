//
//  IndexRemapper.swift
//  GymApp2
//
//  Created by Ederer Patrick on 18.02.25.
//

class IndexRemapper {
    private var takenIndexes: Set<Int> = Set()
    private var takenIndexesCount: Int = 0
    private var length: Int
    private var resetPercentage: Double
    
    init(length: Int, resetPercentage: Double = 1) {
        self.length = length
        self.resetPercentage = resetPercentage
    }
    
    init(length: Int) {
        self.length = length
        self.resetPercentage = 1
    }
    
    func getRemainingLength() -> Int {
        return length - takenIndexesCount
    }
    
    func getIndex(index: Int) -> Int {
        while takenIndexes.count >= Int(Double(length) * resetPercentage) {
            if resetPercentage == 1 {
                takenIndexesCount = 0
                takenIndexes.removeAll()
            } else {
                takenIndexesCount -= 1
                takenIndexes.removeFirst()
            }
        }
        
        var result = index
        for i in takenIndexes.sorted() {
            if i <= result {
                result += 1
            }
        }
        
        takenIndexes.insert(result)
        takenIndexesCount += 1
        
        return result
    }
    
    func removeIndex(index: Int) {
        takenIndexes.insert(index)
        takenIndexesCount += 1
    }
}
