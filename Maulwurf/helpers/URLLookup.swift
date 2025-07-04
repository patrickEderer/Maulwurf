//
//  URLLookup.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 02.06.25.
//

import Foundation

enum URLLookup {
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let SaveData = createURL(URLString: "save_data");
    
    private static func createURL(URLString: String) -> URL {
        documentsDirectory.appendingPathComponent(URLString + ".txt")
    }
}
