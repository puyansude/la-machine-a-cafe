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
        printCouleur("### Je suis le constructeur de la classe 'Application' ###", .green)
    }
    
    func menu() -> String {
        
        Boite.entete("Bienvenue à la machine à café")
        Boite.afficher(" 1.Café maison: 1 crème, 1 sucre")
        Boite.afficher(" 2.Espresso")
        Boite.afficher(" 3.Cappuccino")
        Boite.afficher(" 4.Latte")
        Boite.afficher(" 5.Mocha")
        Boite.afficher(" 6.Affogato")
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
                case "1": try uneMachineÀCafé.infuser(.caféMaison, sucre: 1)
                case "2": try uneMachineÀCafé.infuser(.espresso, crème: 1)
                case "3": try uneMachineÀCafé.infuser(.cappuccino)
                case "4": try uneMachineÀCafé.infuser(.latte)
                case "5": try uneMachineÀCafé.infuser(.mocha)
                case "6": try uneMachineÀCafé.infuser(.affogato)
                    
                case "8": print(uneMachineÀCafé)
                case "9": break  // Pour de pas obtenir le msg de default
                    
                default: printCouleur("Erreur: Choix invalide", .red)
                }
            } catch
            {
                printCouleur("Erreur de la machine à café: \(error)", .red)
                break // Va sortir du 'while'
            }	
            
        } while choix != "9"
        
    } // loop()
    
} // Application
