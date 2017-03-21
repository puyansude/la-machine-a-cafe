//
//  main.swift
//  Console.TIM.Café
//
//  Created by Alain on 17-03-07.
//  Copyright © 2017 Alain. All rights reserved.
//

import Foundation

class MonApplication: Application, MachineÀCaféDelegate {

    internal func plusAccesADeLeau(sender: MachineÀCafé) {
        print("MachineÀCaféDelegate: La machine à café n'a plus accès à de l'eau!")
    } // plusAccesADeLeau

    override init(){
        super.init()
        uneMachineÀCafé.delegate = self
        Boite.cls()
    }
}

let uneApplication = MonApplication()
uneApplication.loop()
