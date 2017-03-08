//
//  main.swift
//  Console.TIM.Café
//
//  Created by Alain on 17-03-07.
//  Copyright © 2017 Alain. All rights reserved.
//

import Foundation

let uneMachineÀCafé = MachineÀCafé()

func menu() -> String {
    print("\n\nBienvenue à la machine à café")
    print("-----------------------------")
    print("1.Café noir")
    print("2.Espresso Double")
    print("3.Cappuccino")
    print("4.Latte")
    print("5.Mocha")
    print("\n8.Inventaire de la machine")
    print("9.Quitter")
    print("-----------------------------")
    print("Votre choix?")
    let response = readLine()!
    print("response = \(response)")
    return response
}

func FormaterInventaire() -> String{

    let inventaire = uneMachineÀCafé.obtenirInventaire()
    
    var texteInventaire = "\n\nInventaire de la machine à café:"
    texteInventaire += "\n\tCafé: \(inventaire.café)"
    texteInventaire += "\n\tGoblet: \(inventaire.goblet)"
    texteInventaire += "\n\tSucre: \(inventaire.sucre)"
    texteInventaire += "\n\tCrème: \(inventaire.crème)"
    texteInventaire += "\n\tVente: \(String(format: "%2.2f $" , inventaire.vente))"
    
    return texteInventaire
} // FormaterInventaire

func main() {
    var choix = ""
    repeat  {
        choix = menu()
        do {
            switch choix {
            case "1":
                try uneMachineÀCafé.fabriquerUnCafé(typeCafé: .espresso, crème: 0, sucre: 2)
                
            case "8": print(FormaterInventaire())
            default: break
            }
        } catch
        {
            print(error)
            break
        }
        
    } while choix != "9"

} // main()

main()

