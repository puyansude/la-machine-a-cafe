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
    let quitterMenu = "9"
    let _menu = Boite(titre: "Un titre", ligne: 0, colonne: 0)
    
    init() {
        
        Boite.printCouleur("### Je suis le constructeur de la classe 'Application' ###", .green)
    }
    
    func afficherMenu() {
        _menu.entete("Bienvenue à la machine à café")
        _menu.afficher(" 1.Café maison: 1 crème, 1 sucre")
        _menu.afficher(" 2.Espresso")
        _menu.afficher(" 3.Cappuccino")
        _menu.afficher(" 4.Latte")
        _menu.afficher(" 5.Mocha")
        _menu.afficher(" 6.Affogato")
        _menu.tracerLigne(position: .séparateur)
        _menu.afficher(" 8.Inventaire de la machine")
        _menu.afficher(" \(quitterMenu).Quitter")
        _menu.tracerLigne(position: .bas)
    } // afficherMenu()
    
    func loop() {
        var choix = ""
        repeat  {
            #if !DEBUG
                Boite.cls()
            #endif

            afficherMenu()
            print(uneMachineÀCafé)
            choix = Boite.pause("Votre choix?")
            do {
                switch choix {
                case "1": try uneMachineÀCafé.infuser(.caféMaison, sucre: 1)
                case "2": try uneMachineÀCafé.infuser(.espresso, crème: 1)
                case "3": try uneMachineÀCafé.infuser(.cappuccino)
                case "4": try uneMachineÀCafé.infuser(.latte)
                case "5": try uneMachineÀCafé.infuser(.mocha)
                case "6": try uneMachineÀCafé.infuser(.affogato)
                    
                case "8": print(uneMachineÀCafé)
                case quitterMenu: break  // Pour de pas obtenir le msg de default
                    
                default: Boite.printCouleur("Erreur: Choix invalide", .red)
                }
            } catch
            {
                Boite.printCouleur("Erreur de la machine à café: \(error)", .red)
                break // Va sortir du 'while'
            }	
            
        } while choix != quitterMenu
        
    } // loop()
    
} // Application
