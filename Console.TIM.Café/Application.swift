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
        print("### Je suis le constructeur de la classe Application ###")
    }
    
    func menu() -> String {
        var texteMenu  = "\n┌─────────────────────────────────┐"
        texteMenu     += "\n│  Bienvenue à la machine à café  │"
        texteMenu     += "\n╞═════════════════════════════════╡"
        texteMenu     += "\n│ 1.Café noir                     │"
        texteMenu     += "\n│ 2.Espresso Double               │"
        texteMenu     += "\n│ 3.Cappuccino                    │"
        texteMenu     += "\n│ 4.Latte                         │"
        texteMenu     += "\n│ 5.Mocha                         │"
        texteMenu     += "\n│                                 │"
        texteMenu     += "\n│ 8.Inventaire de la machine      │"
        texteMenu     += "\n│ 9.\(red)Quitter\(black)                       │"
        texteMenu     += "\n└─────────────────────────────────┘"
        
        print(texteMenu + "\nVotre choix?")
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
                    try uneMachineÀCafé.fabriquerUnCafé(typeCafé: .espresso, crème: 0, sucre: 2)
                    
                case "8": print(uneMachineÀCafé.texteInventaire())
                default: break
                }
            } catch
            {
                print(error)
                break
            }
            
        } while choix != "9"
        
    } // loop()
    
} // Application
