import UIKit

class PlayViewController: UIViewController {

    @IBOutlet weak var vidasLabel: UILabel!
    @IBOutlet weak var palabraStackView: UIStackView!
    @IBOutlet weak var tecladoStackView: UIStackView!
    @IBOutlet weak var borrarButton: UIButton!
    @IBOutlet weak var enterButton: UIButton!
    var letrasLabels: [UILabel] = []
    var vidas = 3
    var palabra: String = ""
    var palabraAdivinada: String = ""  // Almacena la palabra que el jugador está adivinando
    var letrasIntentadas: [String: UIColor] = [:] // Diccionario para rastrear letras intentadas
    var currentRow = 0 // Fila actual en el StackView de palabras
    var currentColumn = 0 // Columna actual en la fila
    var rowStackViews: [UIStackView] = [] // Almacena todas las filas de letras
    
    var currentAttempt: Int = 0
    var attempts: [[String]] = [] // Almacena todos los intentos
    var currentLetters: [String] = [] // Letras del intento actual
    
    let letras = "QWERTYUIOPASDFGHJKLZXCVBNM"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        palabra = palabraAleatoria()  // Asigna la palabra aleatoria
        palabraAdivinada = ""
        configurarEspacios(palabra: palabra)
        print("Palabra a adivinar: \(palabra)") // Para debug

        actualizarVidas()
        configurarTeclado()
        configurarBotones()
    }
    
    func configurarEspacios(palabra: String) {
        palabraStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        letrasLabels = []

        for _ in palabra {
            let label = UILabel()
            label.text = "_"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
            label.backgroundColor = UIColor.lightGray
            label.layer.borderColor = UIColor.black.cgColor
            label.layer.borderWidth = 2
            label.layer.cornerRadius = 8
            label.clipsToBounds = true
            label.widthAnchor.constraint(equalToConstant: 50).isActive = true
            label.heightAnchor.constraint(equalToConstant: 50).isActive = true

            letrasLabels.append(label)
            palabraStackView.addArrangedSubview(label)
        }
    }
    
    
    func configurarTeclado() {
        let filas = ["QWERTYUIOP", "ASDFGHJKL", "ZXCVBNM"]
        
        tecladoStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for filaLetras in filas {
            let filaStackView = UIStackView()
            filaStackView.axis = .horizontal
            filaStackView.distribution = .fillEqually
            filaStackView.spacing = 5
            filaStackView.alignment = .center

            for letra in filaLetras {
                let boton = UIButton(type: .system)
                boton.setTitle(String(letra), for: .normal)
                boton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
                boton.backgroundColor = UIColor.darkGray
                boton.setTitleColor(.white, for: .normal)
                boton.layer.cornerRadius = 5
                boton.addTarget(self, action: #selector(letraPresionada(_:)), for: .touchUpInside)
                
                boton.widthAnchor.constraint(equalToConstant: 35).isActive = true
                boton.heightAnchor.constraint(equalToConstant: 45).isActive = true
                
                filaStackView.addArrangedSubview(boton)
            }
            tecladoStackView.addArrangedSubview(filaStackView)
        }
    }
    
    func actualizarTeclado() {
        for fila in tecladoStackView.arrangedSubviews {
            if let filaStack = fila as? UIStackView {
                for view in filaStack.arrangedSubviews {
                    if let boton = view as? UIButton, let letra = boton.titleLabel?.text?.lowercased() {
                        if palabraAdivinada.contains(letra) {
                            if palabra.contains(letra) {
                                boton.backgroundColor = palabraAdivinada.contains(letra) ? .green : .yellow
                            } else {
                                boton.backgroundColor = .red
                            }
                            boton.isEnabled = false
                        }
                    }
                }
            }
        }
    }
    
    @objc func borrarUltimaLetra() {
        // Elimina el último carácter de la palabraAdivinada si tiene caracteres
        if !palabraAdivinada.isEmpty {
            palabraAdivinada.removeLast()
            actualizarInterfaz()  // Aquí puedes actualizar la interfaz, como mostrar la palabra actualizada
        }
    }

    func actualizarInterfaz() {
        // Actualizar todos los labels
        for (index, label) in letrasLabels.enumerated() {
            if index < palabraAdivinada.count {
                let letra = palabraAdivinada[palabraAdivinada.index(palabraAdivinada.startIndex, offsetBy: index)]
                label.text = String(letra).uppercased() // Mostrar en mayúsculas
            } else {
                label.text = "_"
            }
        }
    }
    
    func configurarBotones() {
        enterButton.addTarget(self, action: #selector(verificarPalabra), for: .touchUpInside)
        borrarButton.addTarget(self, action: #selector(borrarUltimaLetra), for: .touchUpInside)
    }
    
    
    @objc func letraPresionada(_ sender: UIButton) {
        guard let letra = sender.titleLabel?.text else { return }
        
        // Solo agregar la letra si no hemos alcanzado el límite
        if palabraAdivinada.count < palabra.count {
            palabraAdivinada += letra.lowercased() // Usamos minúsculas para consistencia
            actualizarInterfaz()
        }
    }

    
    @objc func verificarPalabra() {
        // Verificar que la longitud sea correcta
        guard palabraAdivinada.count == palabra.count else {
            mostrarAlerta(titulo: "Incompleto", mensaje: "La palabra debe tener \(palabra.count) letras")
            return
        }
        
        // Verificar si la palabra es correcta
        if palabraAdivinada == palabra {
            // Palabra correcta - todas las letras verdes
            for label in letrasLabels {
                label.backgroundColor = .green
            }
            mostrarMensajeVictoria()
        } else {
            // Palabra incorrecta - verificar letras
            for (index, char) in palabraAdivinada.enumerated() {
                let palabraIndex = palabra.index(palabra.startIndex, offsetBy: index)
                let palabraChar = palabra[palabraIndex]
                
                if char == palabraChar {
                    // Letra correcta en posición correcta (verde)
                    letrasLabels[index].backgroundColor = .green
                } else if palabra.contains(char) {
                    // Letra correcta en posición incorrecta (amarillo)
                    letrasLabels[index].backgroundColor = .yellow
                } else {
                    // Letra incorrecta (rojo o gris)
                    letrasLabels[index].backgroundColor = .red
                }
            }
            
            perderVida()
        }
        
        // No reiniciamos palabraAdivinada aquí para que el usuario vea los colores
    }

    func mostrarAlerta(titulo: String, mensaje: String) {
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func actualizarPalabraAdivinada() {
        for (index, letra) in palabraAdivinada.enumerated() {
            letrasLabels[index].text = String(letra)
        }
    }
    
    func palabraAleatoria() -> String {
        let palabras: [String] = ["aviso", "bingo", "campo", "dardo", "elote", "fruta", "globo", "hongo", "ideas", "jugar", "koala", "lente", "mismo", "nieve", "orden", "pluma", "quiso", "rueda", "salto", "tango", "datos", "verde", "error", "yogur", "zorro", "trama", "robot", "nudos", "brisa"]
        let randomIndex = Int.random(in: 0..<palabras.count)
        return palabras[randomIndex]
    }

    func perderVida() {
        if vidas > 0 {
            vidas -= 1
            actualizarVidas()
        }

        if vidas == 0 {
            gameOver()
        }
    }

    func actualizarVidas() {
        let corazones = String(repeating: "❤️ ", count: vidas).trimmingCharacters(in: .whitespaces)
        vidasLabel.text = corazones
    }

    func gameOver() {
        let alert = UIAlertController(title: "Game Over", message: "Te quedaste sin vidas 😭", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Reiniciar", style: .default, handler: { _ in
            self.reiniciarJuego()
        }))
        present(alert, animated: true, completion: nil)
    }

    func mostrarMensajeVictoria() {
        let alert = UIAlertController(title: "¡Victoria!", message: "¡Has adivinado la palabra!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Reiniciar", style: .default, handler: { _ in
            self.reiniciarJuego()
        }))
        present(alert, animated: true, completion: nil)
    }

    func reiniciarJuego() {
        vidas = 3
        actualizarVidas()
        palabra = palabraAleatoria()  // Nueva palabra aleatoria
        palabraAdivinada = ""
        configurarEspacios(palabra: palabra)  // Configura los espacios con la nueva palabra
    }
}
