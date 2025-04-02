//
//  MenuViewController.swift
//  Wordle-5B
//
//  Created by mac on 30/03/25.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var EfectosSwitch: UISwitch!
    @IBOutlet weak var MusicaSwitch: UISwitch!
    override func viewDidLoad() {
          super.viewDidLoad()
          configurarSwitches()
          _ = RecordsManager.shared.cargarRecords()
          AudioManager.shared.playBackgroundMusic()
      }
      
      override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          // Actualizar switches cuando se vuelve a esta pantalla
          configurarSwitches()
      }
      
      private func configurarSwitches() {
          // Configurar switches con los valores actuales
          MusicaSwitch.isOn = AudioManager.shared.isMusicEnabled
          EfectosSwitch.isOn = AudioManager.shared.isSoundEnabled
          
          // Añadir acciones
          MusicaSwitch.addTarget(self, action: #selector(musicaSwitchChanged), for: .valueChanged)
          EfectosSwitch.addTarget(self, action: #selector(efectosSwitchChanged), for: .valueChanged)
      }
      
      @objc private func musicaSwitchChanged(_ sender: UISwitch) {
          AudioManager.shared.isMusicEnabled = sender.isOn
      }
      
      @objc private func efectosSwitchChanged(_ sender: UISwitch) {
          AudioManager.shared.isSoundEnabled = sender.isOn
      }
      
 
}
