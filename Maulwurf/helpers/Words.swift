//
//  Words.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 01.06.25.
//

import Foundation

public class Words {
    let fileSaver = FileSaver.getInstance()
    
    
    var selectedCategories: [String: Bool] = [:]
    
    let categories: [String] = [
        "Lebensmittel",
        "Berufe",
        "Tiere",
        "Orte",
        "Filme",
        "Sportarten",
        "Technologie",
        "Emotionen",
        "Musikinstrumente",
        "Farben"
    ]
    let words: [String: [(String, [String])]] = [
        "Lebensmittel": [
            ("Apfel", ["Baum", "Rot", "Frucht", "Saftig"]),
            ("Käse", ["Gelb", "Milchprodukt", "Reifen", "Brotaufstrich"]),
            ("Pizza", ["Rund", "Ofen", "Italien", "Belag"]),
            ("Brot", ["Mahlzeit", "Backen", "Kruste", "Sandwich"]),
            ("Schokolade", ["Verpackung", "Süß", "Kakao", "Naschen"]),
            ("Wasser", ["Klar", "Durst", "Flüssigkeit", "Trinken"]),
            ("Milch", ["Frühstück", "Weiß", "Kuh", "Kalzium"]),
            ("Banane", ["Krumm", "Gelb", "Tropisch", "Pflanze"]),
            ("Kaffee", ["Tasse", "Bohnen", "Heiß", "Morgens"]),
            ("Nudeln", ["Gabel", "Italienisch", "Soße", "Teig"])
        ],
        "Berufe": [
            ("Arzt", ["Weiß", "Krankenhaus", "Behandlung", "Medizin"]),
            ("Lehrer", ["Tafel", "Unterricht", "Schule", "Erklären"]),
            ("Polizist", ["Blau", "Dienst", "Sicherheit", "Verkehr"]),
            ("Bäcker", ["Früh", "Backen", "Brot", "Mehl"]),
            ("Programmierer", ["Tastatur", "Code", "Computer", "Software"]),
            ("Musiker", ["Konzert", "Instrument", "Note", "Auftritt"]),
            ("Pilot", ["Fenster", "Fliegen", "Cockpit", "Flugzeug"]),
            ("Kellner", ["Tablett", "Restaurant", "Bestellen", "Service"]),
            ("Mechaniker", ["Öl", "Werkstatt", "Auto", "Reparatur"]),
            ("Schauspieler", ["Maske", "Bühne", "Film", "Rolle"])
        ],
        "Tiere": [
            ("Hund", ["Treu", "Bellen", "Pfote", "Haustier"]),
            ("Katze", ["Fensterbank", "Miau", "Schnurren", "Jagd"]),
            ("Elefant", ["Groß", "Rüssel", "Stoßzähne", "Savanne"]),
            ("Löwe", ["Majestätisch", "Mähne", "König", "Savanne"]),
            ("Hai", ["Gefahr", "Zähne", "Meer", "Jagd"]),
            ("Maus", ["Leise", "Klein", "Nager", "Käse"]),
            ("Eule", ["Weise", "Nacht", "Fliegen", "Federn"]),
            ("Giraffe", ["Aussicht", "Hals", "Flecken", "Baum"]),
            ("Pferd", ["Rennen", "Mähne", "Reiten", "Hufe"]),
            ("Schaf", ["Feld", "Wolle", "Blöken", "Herde"])
        ],
        "Orte": [
            ("Schule", ["Pause", "Unterricht", "Klassenzimmer", "Lernen"]),
            ("Krankenhaus", ["Warten", "Patient", "Arzt", "Notaufnahme"]),
            ("Supermarkt", ["Wagen", "Einkauf", "Regale", "Kasse"]),
            ("Kino", ["Dunkel", "Film", "Popcorn", "Leinwand"]),
            ("Bahnhof", ["Plattform", "Zug", "Fahrplan", "Warten"]),
            ("Flughafen", ["Koffer", "Fliegen", "Check-in", "Terminal"]),
            ("Strand", ["Handtuch", "Sand", "Meer", "Sonne"]),
            ("Wald", ["Pfad", "Bäume", "Tiere", "Natur"]),
            ("Bibliothek", ["Still", "Bücher", "Lesen", "Studieren"]),
            ("Restaurant", ["Tisch", "Essen", "Kellner", "Menü"])
        ],
        "Filme": [
            ("Titanic", ["Eis", "Schiff", "Liebe", "Untergang"]),
            ("Harry Potter", ["Brief", "Zauber", "Hogwarts", "Magie"]),
            ("Star Wars", ["Vater", "Raumschiff", "Lichtschwert", "Kampf"]),
            ("Game of Thrones", ["Stuhl", "Drachen", "Thron", "Königreich"]),
            ("Die Simpsons", ["Cartoon", "Familie", "Gelb", "Springfield"]),
            ("Herr der Ringe", ["Reise", "Ring", "Mittelerde", "Kampf"]),
            ("Breaking Bad", ["Chemie", "Drogen", "Labor", "Krimi"]),
            ("Avatar", ["Welt", "Blau", "Natur", "Alien"]),
            ("Stranger Things", ["Lichter", "Geheimnis", "Horror", "Kinder"]),
            ("James Bond", ["Anzug", "Agent", "Geheim", "Action"])
        ],
        "Sportarten": [
            ("Fußball", ["Rasen", "Schuh", "Lärm", "90"]),
            ("Basketball", ["Höhe", "Orange", "Halle", "Tempo"]),
            ("Schwimmen", ["Brille", "Kacheln", "Rhythmus", "Stille"]),
            ("Tennis", ["Linien", "Weiß", "Duell", "Pause"]),
            ("Boxen", ["Ecke", "Sekunden", "Zählen", "Schweiß"]),
            ("Skifahren", ["Hang", "Stöcke", "Pulver", "Kälte"]),
            ("Radsport", ["Kette", "Straße", "Helm", "Rundfahrt"]),
            ("Turnen", ["Balance", "Sprung", "Matte", "Körper"]),
            ("Reiten", ["Stall", "Helm", "Takt", "Bewegung"]),
            ("Klettern", ["Griff", "Wand", "Höhe", "Routen"])
        ],
        "Technologie": [
            ("Smartphone", ["Taschenformat", "Berührung", "Sucht", "Update"]),
            ("Laptop", ["Falten", "Lüfter", "Sitzplatz", "Schnell"]),
            ("Internet", ["Vernetzt", "Unsichtbar", "Global", "Sofort"]),
            ("Künstliche Intelligenz", ["Entscheidung", "Lernen", "System", "Verhalten"]),
            ("Cloud", ["Fern", "Platz", "Zugriff", "Synchron"]),
            ("Drohne", ["Fernbedienung", "Blickwinkel", "Luft", "Geräusch"]),
            ("Smartwatch", ["Ziffer", "Vibration", "Schritt", "Band"]),
            ("3D-Druck", ["Schicht", "Modell", "Plastik", "Schmelze"]),
            ("Robotik", ["Wiederholung", "Gliedmaßen", "Steuerung", "Fabrik"]),
            ("Quantencomputer", ["Teilchen", "Wahrscheinlichkeit", "Zustand", "Logik"])
        ],
        "Emotionen": [
            ("Freude", ["Leicht", "Sprung", "Lächeln", "Offen"]),
            ("Wut", ["Kraft", "Rot", "Knall", "Kante"]),
            ("Trauer", ["Stille", "Schwere", "Regen", "Vergangenheit"]),
            ("Angst", ["Schatten", "Puls", "Flucht", "Früh"]),
            ("Ekel", ["Ziehen", "Geruch", "Flüssig", "Unwohl"]),
            ("Scham", ["Rot", "Stille", "Innen", "Gedanke"]),
            ("Liebe", ["Nah", "Puls", "Sanft", "Zeit"]),
            ("Neid", ["Blick", "Vergleich", "Wunsch", "Ferne"]),
            ("Stolz", ["Gerade", "Licht", "Zeigen", "Moment"]),
            ("Überraschung", ["Plötzlich", "Sprung", "Öffnen", "Kalt"])
        ],
        "Musikinstrumente": [
            ("Gitarre", ["Saiten", "Holz", "Greifen", "Lagerfeuer"]),
            ("Klavier", ["Tasten", "Schwarzweiß", "Zimmer", "Fühlen"]),
            ("Geige", ["Kinn", "Bogen", "Ziehen", "Leise"]),
            ("Schlagzeug", ["Fell", "Stäbe", "Laut", "Sitz"]),
            ("Flöte", ["Luft", "Längs", "Öffnung", "Ton"]),
            ("Saxophon", ["Kurve", "Glanz", "Jazz", "Pusten"]),
            ("Trompete", ["Druck", "Blech", "Spitz", "Kurz"]),
            ("Harfe", ["Ziehen", "Rahmen", "Sanft", "Strom"]),
            ("Cello", ["Tief", "Sitzend", "Bogen", "Halt"]),
            ("Akkordeon", ["Ziehen", "Knopf", "Luft", "Tanz"])
        ],
        "Farben": [
            ("Rot", ["Signal", "Reife", "Spannung", "Wärme"]),
            ("Blau", ["Tiefe", "Weite", "Kühle", "Tragen"]),
            ("Gelb", ["Licht", "Früh", "Wach", "Hell"]),
            ("Grün", ["Ruhig", "Natur", "Wachsen", "Zart"]),
            ("Schwarz", ["Abend", "Ende", "Form", "Leere"]),
            ("Weiß", ["Neu", "Still", "Klar", "Flausch"]),
            ("Orange", ["Übergang", "Scharf", "Leuchten", "Unruh"]),
            ("Lila", ["Mischung", "Königlich", "Dunkel", "Duft"]),
            ("Braun", ["Erde", "Alt", "Wurzel", "Rund"]),
            ("Pink", ["Frech", "Süß", "Jung", "Laut"])
        ]
    ]


    
    private static var INSTANCE: Words? = Words()
    
    private init() {
        for category in categories {
            selectedCategories[category] = fileSaver.read(key: "categorySelection:\(category)") != "false"
        }
    }
    
    public func toggleCategorySelection(_ category: String) {
        selectedCategories[category]!.toggle()
        
        fileSaver.save(key: "categorySelection:\(category)", value: "\(selectedCategories[category]!)")
    }
    
    public static func getInstance() -> Words {
        if (INSTANCE == nil) {
            INSTANCE = Words()
        }
        return INSTANCE!
    }
    
    public func getRandom() -> (String, [String]) {
        let filteredCategories = categories.filter { selectedCategories[$0]! }
        
        let category = filteredCategories[Int.random(in: 0..<filteredCategories.count)]
        
        let pickableWords = words[category]!
        let word = pickableWords[Int.random(in: 0..<pickableWords.count)]
        
        return word
    }
}
