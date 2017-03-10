//
//  main.swift
//  Console.TIM.Café.minimaliste
//
//  Created by Alain on 17-03-08.
//  Copyright © 2017 Alain. All rights reserved.
//

import Foundation

print(MachineÀCafé.quiSuisJe())

// Démarrer la machine à café
var uneMachineÀCafé:MachineÀCafé? = MachineÀCafé()

// Fabriquer du bon café!
try? uneMachineÀCafé!.fabriquerUnCafé(.latte, crème: 1, sucre: 2)
print("---------------------------------------------------------------------------------\n")
try? uneMachineÀCafé!.fabriquerUnCafé(.espresso, crème: 0, sucre: 1)
print("---------------------------------------------------------------------------------\n")

print (uneMachineÀCafé!)
uneMachineÀCafé = nil
