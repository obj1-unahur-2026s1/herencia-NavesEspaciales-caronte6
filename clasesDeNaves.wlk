/*
  hay varias naves por tipo

  todas empiezan por una clase 
  y luego se diversifican en distintas
  subclases

*/
/*
  cada subclase debe entender el mensaje
  prepararViaje()
*/
class Nave {
  var velocidadPorSegundo= 0
  var direccionRespectoAlSol= 0
  var combustible =0
  /*
    direccionRespectoAlSol= 10 ir al sol
    direccionRespectoAlSol= 0 es rodear el 
    sol

    direccionRespectoAlSol= -10 alejarse de sol
  */
  method acelerar(cantidadAAcelerar) {
    velocidadPorSegundo= (velocidadPorSegundo 
      + cantidadAAcelerar).min(100000)
  }
  
  method Desacelerar(cantidadADisminuir) {
    velocidadPorSegundo-= cantidadADisminuir.min(velocidadPorSegundo)
  }

  method IrHaciaElSol() {
    direccionRespectoAlSol= 10
  }
  method escaparDelSol() {
    direccionRespectoAlSol=-10
  }
  method PonerseParaleloAlSol() {
    direccionRespectoAlSol=0
  }
  method acercarseUnPocoAlSol() {
     direccionRespectoAlSol =(direccionRespectoAlSol + 1).min(10)
  }
  method alejarseUnPocoDelSol() {
    direccionRespectoAlSol= (direccionRespectoAlSol -1).max(0)
  }
  method cargarCombustible(cantidadDeCombustible) {
    combustible+=cantidadDeCombustible
  }

  method DescargarConbustible(cantidadDeCombustible) {
    combustible-=(combustible - cantidadDeCombustible).max(0)
  }

  method PrepararViaje() {
    self.cargarCombustible(30000)
    self.acelerar(5000)
  }
  //las subclases deben agregar sus metodos aqui
  method estaTranquila() {
    return(combustible>=4000 && velocidadPorSegundo <= 12000)
  }
  //las subclases deben agregar sus metodos aqui
  method RecibirAmenaza() {
    self.escaparDelSol()
  }
  //las subclases deben agregar sus metodos aqui
  method puedeRelajarse() {
    return(self.estaTranquila())
  }
}

class NaveBaliza inherits Nave {
    var color= "rojo"
    var cambioDeColor=false
    method CambiarColorDeBaliza(colorNuevo){
      color=colorNuevo
      cambioDeColor=true
    }
  override method PrepararViaje() {
    self.CambiarColorDeBaliza("verde")
    self.PonerseParaleloAlSol()
    super()
  }
  override method estaTranquila(){return(super()&& color != "rojo")}

  override method RecibirAmenaza(){
    self.IrHaciaElSol()
    self.CambiarColorDeBaliza("rojo")
  }

  override  method puedeRelajarse(){
    return(super() && cambioDeColor)
  }

}

class NaveDePasajeros inherits Nave{
  /*
  -crear una lista de comidas y bebidas
  - metodos de descargar y cargar por *cantidad*
  */
  var comidas = 0
  var bebidas = 0
  const cantidaDePasajeros = 0
  method Cargar_Comidas(cantidadDeComida) {
    comidas+=cantidadDeComida
  }

  method Cargar_Bebidas(cantidadDeBebidas) {
    bebidas+=cantidadDeBebidas
  }

  method Racionar_Comidas(cantidadAdescargar) {
    
    comidas-=(cantidadAdescargar *cantidaDePasajeros).min(comidas)
  }

  method Racionar_Bebidas(cantidadAdescargar) {
    bebidas-=(cantidadAdescargar *cantidaDePasajeros).min(bebidas)
  }
  override method PrepararViaje() {
    self.Cargar_Bebidas(6)
    self.Cargar_Comidas(4)
    super()
    self.acercarseUnPocoAlSol()
  }
  
  override method RecibirAmenaza(){
    self.acelerar(velocidadPorSegundo *2)
    self.Racionar_Comidas(1)
    self.Racionar_Bebidas(2)
  }
  
  override method puedeRelajarse(){
    return(super() && comidas<50)
  }
}

class NaveDeCombate inherits Nave{
  var estaVisible=true
  var misilesDesplegados=false
  const mensajes =[] 
  method PonerseVisible() {
    estaVisible=true
  }

  method PonerseInvisible() {
    estaVisible=false
  }

  method DesplegarMisiles() {
    misilesDesplegados=true
  }
  method replegarMisiles() {
    misilesDesplegados=false
  }
  method misilesDesplegados() = misilesDesplegados 

  method emitirMensajes(mensaje) {

    mensajes.add(mensaje)
  }

  method primerMensajeEmitido()= mensajes.first()
  method ultimoMensajeEmitido()= mensajes.last()
  method emitioMensaje(mensajeEmitido){
    return(mensajes.contains(mensajeEmitido))
  }
  method esEscueta() {
    return(mensajes.any({mensaje=>mensaje.length() <= 30}))
  }
  override method PrepararViaje() {
    self.PonerseVisible()
    self.replegarMisiles()
    self.emitirMensajes("Saliendo en mision")
    super()
    self.acelerar(15000)
  }
  override method estaTranquila(){
    return(super()&& !misilesDesplegados)}
  
  override method RecibirAmenaza(){
    self.acercarseUnPocoAlSol()
    self.acercarseUnPocoAlSol()
    self.emitirMensajes("Amenaza recibida")
  }

}

class NaveHospital inherits NaveDePasajeros{
  /*
  -debe registrar si tiene o no quirofanos 
  preparados: booleano
  
  */
  var quirofanosEstanPreparados=true
  method PrepararQuirofanos() { 
    quirofanosEstanPreparados=true
  }
  method RelajarQuirofanos() {
    quirofanosEstanPreparados=false
  }

   override method estaTranquila(){
     return(super()&& quirofanosEstanPreparados)
   }
   override method RecibirAmenaza(){
      super()
      self.PrepararQuirofanos()
   }
}

class NaveDeCombateSilenciosa inherits NaveDeCombate{
   override method estaTranquila(){
    return(super() && estaVisible)
   }
   override method RecibirAmenaza(){
    super()
    self.DesplegarMisiles()
    self.PonerseInvisible()
   }
}
