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
try? uneMachineÀCafé!.infuser(.latte, crème: 1, sucre: 2)
print("---------------------------------------------------------------------------------\n")
try? uneMachineÀCafé!.infuser(.espresso)
print("---------------------------------------------------------------------------------\n")

print (uneMachineÀCafé!)
uneMachineÀCafé = nil
