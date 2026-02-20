### este es el archivo que busca lambda con data_archive_file ###
import json
import boto3
import urllib.parse
import os

s3 = boto3.client('s3')
polly = boto3.client('polly')
sns = boto3.client('sns')
SNS_TOPIC_ARN = os.environ["SNS_TOPIC_ARN"] # Usa el ARN de tu recurso

def lambda_handler(event, context):
    print("Evento recibido:", json.dumps(event))

    # Obtener bucket y key desde el evento S3
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'])

    print(f"Leyendo archivo desde bucket: {bucket}, key: {key}")

    # Leer contenido del archivo .txt
    response = s3.get_object(Bucket=bucket, Key=key)
    text = response['Body'].read().decode('utf-8')

    print("Texto leído:", text)

    # Llamar a Polly
    polly_response = polly.synthesize_speech(
        Text=text,
        OutputFormat='mp3',
        VoiceId='Andres', # ID para Andrés (Español, México)
        Engine='neural'   # Andrés es una voz Neural (alta calidad)
    )

    # Nombre del archivo de salida
    import os
    file_name = os.path.basename(key) # Extrae 'archivo.txt' sin importar la carpeta de origen
    clean_name = file_name.replace(".txt", ".mp3")
    output_key = f"output/{clean_name}" # Siempre lo guarda en la carpeta /output/

    print(f"Guardando audio en: {output_key}")

    # Guardar el audio en S3
    s3.put_object(
        Bucket=bucket,
        Key=output_key,
        Body=polly_response['AudioStream'].read(),
        ContentType='audio/mpeg'
    )
    
    # Enviar notificación SNS
    sns.publish(
        TopicArn=SNS_TOPIC_ARN,
        Subject="¡Tu audio de Polly está listo!",
        Message=f"El archivo {clean_name} ha sido procesado exitosamente y guardado en la carpeta output."
    )

    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "Proceso completado con éxito",
            "s3_key": output_key,
            "notification": "Mensaje enviado a SNS"
        })
    }
