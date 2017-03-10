//
//  main.swift
//  Console.TIM.Café.minimaliste
//
//  Created by Alain on 17-03-08.
//  Copyright © 2017 Alain. All rights reserved.
//

import Foundation

Boite.entete("Je suis le titre")
Boite.afficher(" yo ", "man!")
Boite.afficher(" Coucou", couleur: "rouge", gras: true )

Boite.tracerLigne(position: .séparateur)
Boite.afficher(" 1.", "Option 1")
Boite.afficher(" 2.", "Option 2")
Boite.tracerLigne(position: .bas)


print(MachineÀCafé.quiSuisJe())

// Démarrer la machine à café
var uneMachineÀCafé:MachineÀCafé? = MachineÀCafé()

// Fabriquer du bon café!
try? uneMachineÀCafé!.fabriquerUnCafé(typeCafé: .latte, crème: 1, sucre: 2)
try? uneMachineÀCafé!.fabriquerUnCafé(typeCafé: .espresso, crème: 0, sucre: 1)

print (uneMachineÀCafé!.texteInventaire())
uneMachineÀCafé = nil
