import wollok.game.*


object juego{

	method configurar(){
		game.width(18)
		game.height(8)
		game.title("Dino Game")
		game.boardGround("fondo.png")
		game.addVisual(suelo)
		game.addVisual(cactus)
		game.addVisual(dino)
		game.addVisual(reloj)
	
		keyboard.space().onPressDo{ self.jugar()}
		game.onCollideDo(dino,{ obstaculo => obstaculo.chocar()})
	
	}
	
	method iniciar(){
		dino.iniciar()
		reloj.iniciar()
		cactus.iniciar()
	}
	
	method jugar(){
		if (dino.estaVivo()) 
			dino.saltar()
		else {
			game.removeVisual(gameOver)
			self.iniciar()
		}
		
	}
	
	method terminar(){
		game.addVisual(gameOver)
        reloj.tiempo(0)
		cactus.detener()
		reloj.detener()
	}
	
}

object gameOver {
	method position() = game.center()
	method text() = "GAME OVER"
}

object reloj {
	var property tiempo = 0 
	method text() = tiempo.toString()
  //method textColor() = "00FF00FF"
	method position() = game.at(1, game.height()-1)
	
	method pasarTiempo() {
		tiempo = tiempo + 1
	}
	method iniciar(){
		tiempo = 0
		game.onTick(100,"tiempo",{self.pasarTiempo()})
	}
	method detener(){
		game.removeTickEvent("tiempo")
	}
}

object cactus {
	var property position = self.posicionInicial()
	var property velocidad = 210

	method image() = "cactus.png"
	method posicionInicial() = game.at(11,suelo.position().y())

	method iniciar(){
		position = self.posicionInicial()
		game.onTick(velocidad,"moverCactus",{self.mover()})
	}

	method aumentoVelocidad() {
		if (velocidad != 10) {velocidad = velocidad - 10}
	}

	method mover(){
    	position = position.left(1)
		if (position.x() < 0)
			position = game.at(11,suelo.position().y())	
		}
	
	method chocar(){
		dino.morir()
		self.detener()
	}
    method detener(){
		game.removeTickEvent("moverCactus")
	}
}

object suelo{

	method position() = game.origin().up(1)
	method image() = "suelo.png"
}


object dino {
	var vivo = true
	var property position = game.at(1,suelo.position().y())
	
	method image() = "dino.png"

	method estaEnPiso() = position.y() == suelo.position().y()

	method saltar(){
		if (self.estaEnPiso()) {
			self.subir()
			game.schedule(reloj.tiempo() + 200, {self.subir()})
			game.schedule(reloj.tiempo() + 400, {self.bajar()})
			game.schedule(reloj.tiempo() + 600, {self.bajar()})
		}
	}
	
	method subir(){
		position = position.up(1)
	}
	
	method bajar(){
		position = position.down(1)
	}
	method morir(){
		game.say(self,"¡Auch!")
        juego.terminar()
		vivo = false
	}
	method iniciar() {
		vivo = true
	}
	method estaVivo() {
		return vivo
	}
}
