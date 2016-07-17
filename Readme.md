# HackerBooks 
Práctica fundamentos de Programacion iOS con Swift

**Preguntas**

- *isKindOfClass*: ¿En que otros modos podemos trabajar?¿is, as?
	
	*Nos indica si un elemento es de una clase determinada*
	
	*IS se usaria para comprobar el tipo de algo, mientras que AS nos ayudaria a realizar algo parecido a casting*

- ¿Donde guardarias las imagenes de portada y los pdfs?
	 
	*Lo correcto seria en la Sandbox, y dentro de esta ya dependeria un poco del tiempo de guardado que queramos, o si queremos una persistencia permanente o no. Si usamos TEMP los archivos pueden ser borrados y CACHE realmente seria para otra cosa*
	
	*He usado DOCUMENTS para los PDF porque los podriamos eliminar si los necesitamos y solo se descargan los que leemos*
	
	*Para las imagenes hemos usado NSUserDefaults que realmente es para preferencias pero como las imagenes es una cosa que cargamos siempre que arrancamos la aplicacion creo que el que las podamos borrar no aportaria gran ventaja si no las necesitamos es porque tenemos intención de borrar la aplicación.(Me la he jugado un poco jejeje ya me diras si el planteamiento es correcto o mejor sandbox siempre)*
	
- ¿Como harias que persistiera la informacion de isFavorite?¿Se te ocurre más de una forma de hacerlo?.Explica la decisión de diseño que hayas tomado

	*Yo he usado un diccionario dentro de NSUserDefaults que me almacena los titulos de los libros favoritos y luego ya se realizan comprobaciones para el switch la tabla y demás*
	
	*Tambien se podria guardar en la Sandbox pero como es un dato que no interesa que se borre ya que el usuario perderia información que a lo mejor es relevante creo que es mejor meterlo como preferencias de la app que para borrarlas te lo tienes que proponer*
	
- Cómo enviarías información de un AGTBook a un AGTLibraryTableViewController? ¿Se te ocurre más de una forma de hacerlo? ¿Cual te parece mejor? Explica tu elección.

	*Realmente creo que depende mas de una decisión de diseño, tenemos opciones tales como TARGET-ACTION, DELEGADOS o NOTIFICACIONES. En general yo he usado notificaciones ya que te permite avisar si tienes mas de un elemento implicado de una manera mas sencilla, aunque se pierde un poco el control si tienes muchas notificaciones o muchas clases, esto complicaria la parte de DEBUG. El delegado tambien es una opción pero como solo se puede tener un delegado, estamos mas limitados, aunque para el DEBUGGING es una opción mas facil de seguir*
	
- ReloadData() ¿Es esto una aberración desde el punto de rendimiento (volver a cargar datos que en su mayoría ya estaban correctos)? Explica por qué no es así. ¿Hay una forma alternativa? ¿Cuando crees que vale la pena usarlo?

 *Bueno es cierto que andar solicitando los datos repetidamente si no hay muchos cambios puede parecer un poco innecesario pero como en la vista de la tabla realmente solo carga un poco mas que lo que se esta viendo, no sobrecargamos mucho mas de lo que haria normalmente*
 
 *Como alternativa puede que tengamos reloadSections entre otros pero en cuanto a la carga de datos creo que seria cuando en la vista cargaramos ya muchisimos datos de manera habitual y andar pidiendo de nuevo todos nos suponga una gran perdida de rendimiento*
 
 *¿Seria posible tambien jugando con el lifeCycle de la app o de la vista mas bien?*
 
- Cuando el usuario cambia en la tabla el libro seleccionado, el AGTSimplePDFViewController debe de actualizarse. ¿Cómo lo harías?
 
 *Usando notificaciones ya que tenemos que avisar a dos ViewControllers el de la vist Libro y el del PDF*
 
- ¿Que funcionalidades añadirias antes de subirla a la App Store?

	*Poder añadir libros, eliminarlos si realmente no me interesan, ponerle nota segun valoraciones de lectores, poder leer opiniones del libro, a lo mejor poder leer algun fragmento antes de realizar la descarga completa, poder guardar notas o fragmentos que nos interesen y poder mandarlos por mail(por ejemplo)*
 
- Usando esta App como "plantilla", ¿qué otras versiones se teocurren? ¿Algo que puedas monetizar?

	*Podiamos sacar versiones especificas por temática, no solo de programación, tambien una versión genérica*
	*Tambien se podia sacar una versión pensada para educación que haga preguntas sobre el libro, para que las reciba el profesor o a lo mejor un tipo test para confirmar conocimientos adquiridos*
	
	*En cuanto a monetización podemos jugar con algo de publi, ponerle libros en venta, añadirle (y esto nos valdria tambien para la otra pregunta) algún elemento de gamificación en plan puntos por leer X páginas de libros y con X puntos te regalamos tal libro, podria generarnos algo de fidelización con eso*
	
	*Estas son solo algunas el limite es la imaginación jajajajajjaja*
	


**Comentarios**

El libro de GO no existe, pulsa y veras quien es el culpable ;)

Lo primero es que he sufrido mucho jejejejejeje, creo que ha sido la que más me ha costado hasta el momento, pasar del online de fundamentos de Objective-C a Swift me ha costado bastante(y supongo que realmente tengo un montón de fallos de diseño, o me he complidado la vida en algunos puntos demasiado), aunque tambien a influido que a 3 dias de entregar lo perdí casi todo por no hacer commits(ya sabes programador newbie)

Aunque creo que cuando haga mas cosas con swift ya me sentire mas comodo.

Tengo un par de problemas que no he logrado resolver, he intentado hacer la aplicación compatible para IPHONE y en un principio mas o menos funciona, pero no me actualiza los favoritos y en la vista de libros no me muestra nada excepto la imagen, la comunicacion entre Views y eso bien creo. No queria tocar demasiado el código porque me estaba funcionando todo(creo). EL caso es que realmente no se porque la tabla me ignora con los favoritos y el tema de los XIB me esta volviendo loco porque hace lo que quiere,¿puedes ayudarme?



 