Idea de despliegue: construyendo una arquitectura serverless asincronica en AWS.

Mi objetivo era construir una solución serverless en Amazon Web Services utilizando Terraform como herramienta de Infraestructura como Código.

Visualicé tres componentes principales:

Una función Lambda como motor de ejecución.

Un bucket S3 para almacenar resultados.

CloudWatch para registrar logs y monitorear la ejecución.

Primera etapa: Infraestructura como Código

Paso 1: Comencé escribiendo la configuración en Terraform para crear un bucket S3. 
La configuracion fue bastante sencilla, crear un bucket S3 incluyendo el versionado para que cada vez que se modifique el archivo quedara guardada la version anterior.  Sume el bloqueo de acceso publico por seguridad.  Por ultimo sume la notificacion para que S3 le avisara a lambda que se creo un archivo ".txt".

Paso 2 la configuracion de Lambda: 
Tomo el archivo de Lambda_function.py para que Lambda sepa que es lo que debe hacer. Luego creo el recurso de la funcion lambda, le agrego un "source_code_hash" para que detecte cambios en el código y en ese caso actualizarlo. Por ultimo creo un recurso dando un permiso para que S3 invoque a lambda.

Paso 3 archivo rol.tf: aqui es donde doy los permisos y politicas:
Primero defino un rol y especifico que servicio es el que lo puede utilizar y asumir el mismo (en este caso Lambda). Luego creo el rol IAM para que darle permiso a que pueda asumir las politicas de ese rol. En esta parte tuve algunos intentos fallidos ya que se me hacia un poco confuso como organizar y ordenarlo todo pero lo fui corrigiendo con ayuda de la IA sin pedirle el codigo completo pero si que me fuera corrigiendo y orientando. Aqui entonces le empiezo a dar todos los permisos necesarios para que lambda pueda cumplir todas las funciones solicitadas (leer objeto de s3, llamar a polly para que lea el texto y lo combierta a mp3, guardar objeto en el mismo bucket y por ultimo utilizar SNS para que avise al usuario por mail que el mp3 fue creado. Despues creo una politica IAM para que asuma todos los permisos anteriores y por ultimo adjunto la politica al rol con un "atachment".

Paso 4 la infraestructura para lambda en el archivo lambda_function.py: aca directamente le pedi a la IA que cree la funcion completa ya que yo aun no domino Phyton.

Paso 5 crear un recurso de Logs: al querer ver los registro desde cloudwatch no aparecian asi que, directamente creé el recurso de logs.

Paso 6 archivo sns.tf: cree el recurso para sns_topic para que me envie una notificacion una vez elaborado el mp3.
Un proyecto bastante sencillo en donde demuestro que puedo construir una arquitectura serverless con Lambda asincrónica.





