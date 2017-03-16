//
//  ViewController.swift
//  TIM.Café
//
//  Created by Alain on 17-03-06.
//  Copyright © 2017 Alain. All rights reserved.
//

import UIKit


class ViewController: UIViewController, MachineÀCaféDelegate {
    
    let uneMachineÀCafé = MachineÀCafé()
    
    @IBAction func acheterUnCafé(_ sender: Any) {
        do {
            try uneMachineÀCafé.infuser(.cappuccino)
            print(uneMachineÀCafé)
        }catch
        {
            print("Erreur:  Problème avec la machine à café!: error = \(error)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uneMachineÀCafé.delegate = self
    } // viewDidLoad
    
    func plusAccesADeLeau(sender: MachineÀCafé) {
        print("Erreur: La machine à café n'a plus accès à de l'eau!")
    } // plusAccesADeLeau
    
} // ViewController

