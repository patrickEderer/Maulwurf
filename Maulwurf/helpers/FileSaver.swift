//
//  FileSaver.swift
//  Gyzz
//
//  Created by Ederer Patrick on 26.03.25.
//

import Foundation

public class FileSaver {
    private static var INSTANCE: FileSaver? = FileSaver()
    
    private var saveFileURL: URL
    private var savedata: [String:String] = [:]
    
    private init() {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        saveFileURL = documentDirectory.appendingPathComponent("save_data.txt")
        
        if !FileManager.default.fileExists(atPath: saveFileURL.path()) {
            do {
                try "".write(to: saveFileURL, atomically: true, encoding: .utf8)
            } catch {
                print("Error creating save file :( \(error)")
            }
        }
        
        readFromFile()
    }
    
    public static func getInstance() -> FileSaver {
        if (INSTANCE == nil) {
            INSTANCE = FileSaver()
        }
        return INSTANCE!
    }
    
    private func readFromFile() {
        do {
            let readText = try String(contentsOf: saveFileURL, encoding: .utf8)
            let lineSplitText = readText.split(separator: "\n")
            for line in lineSplitText {
                let splitLine = line.split(separator: "|")
                if splitLine.count == 2 {
                    savedata[String(splitLine[0])] = String(splitLine[1])
                } else {
                    print("Error reading. Read line: \(splitLine)")
                }
            }
        } catch {
            print("Error reading save data :( \(error)")
        }
    }
    
    public func saveToFile() {
        var res: String = ""
        for entry in savedata {
            res.append("\(entry.key)|\(entry.value)\n")
        }
        do {
            try res.write(to: saveFileURL, atomically: true, encoding: .utf8)
        } catch {
            print("Error saving save data :( \(error)")
        }
    }
    
    public func containsKey(_ key: String) -> Bool {
        return savedata[key] != nil
    }
    
    public func remove(key:String) {
        savedata.removeValue(forKey: key)
    }
    
    public func saveIfAbsent(key: String, value: String) {
        if savedata[key] == nil {
            savedata[key] = value
        }
    }
    
    public func save(key: String, value: String) {
        savedata[key] = value
    }
    
    public func read(key: String) -> String {
        return savedata[key] ?? "0:0"
    }
    
    public func resetSaveData() {
        do {
            try "".write(to: URLLookup.SaveData, atomically: true, encoding: .utf8)
            savedata = [:]
        } catch {
            print("Error resetting save data")
        }
    }
}
