//
//  Application.swift
//  TIM.Café
//
//  Created by Alain on 17-03-07.
//  Copyright © 2017 Alain. All rights reserved.
//

import Foundation

class Application {

    let uneMachineÀCafé = MachineÀCafé()
    
    init() {
        print(ANSIColors.green.rawValue, "### Je suis le constructeur de la classe 'Application' ###", ANSIColors.black.rawValue)
    }
    
    func menu() -> String {
        
        Boite.entete("Bienvenue à la machine à café")
        Boite.afficher(" 1.Café noir")
        Boite.afficher(" 2.Espresso Double")
        Boite.afficher(" 3.Cappuccino")
        Boite.afficher(" 4.Latte")
        Boite.afficher(" 5.Mocha")
        Boite.tracerLigne(position: .séparateur)
        Boite.afficher(" 8.Inventaire de la machine")
        Boite.afficher(" 9.Quitter")
        Boite.tracerLigne(position: .bas)
        
        print("Votre choix?")
        let response = readLine()!
        print("response = \(response)")
        return response
    }
    
    
    func loop() {
        var choix = ""
        repeat  {
            choix = menu()
            do {
                switch choix {
                case "1":
                    try uneMachineÀCafé.fabriquerUnCafé(typeCafé: .café, crème: 0, sucre: 2)
                case "2":
                    try uneMachineÀCafé.fabriquerUnCafé(typeCafé: .espresso, crème: 0, sucre: 0)
                case "3":
                    try uneMachineÀCafé.fabriquerUnCafé(typeCafé: .cappuccino, crème: 0, sucre: 0)
                case "4":
                    try uneMachineÀCafé.fabriquerUnCafé(typeCafé: .latte, crème: 0, sucre: 0)
                case "5":
                    try uneMachineÀCafé.fabriquerUnCafé(typeCafé: .mocha, crème: 0, sucre: 0)
                    
                case "8": print(uneMachineÀCafé.texteInventaire())
                    
                case "9": break
                    
                default: print("Erreur: Choix invalide")
                }
            } catch
            {
                print("Erreur de la machine à café:", error)
                break
            }
            
        } while choix != "9"
        
    } // loop()
    
} // Application
