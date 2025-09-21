import os
import csv
import tkinter as tk
from tkinter import filedialog

def leer_y_transformar_datos(archivo):
    with open(archivo, mode='r', encoding='ISO-8859-1') as f:
        reader = csv.reader(f, delimiter=',')
        next(reader)  # Saltar la cabecera
        
        alumnos = []
        for row in reader:
            if len(row) >= 5:
                email = row[4]
                nombre = f"{row[3]} {row[2]}"
                alumnos.append({"email": email, "nombre": nombre})
            else:
                print(f"Fila ignorada (menos de 5 columnas): {row}")
        
    return alumnos

def guardar_datos_en_script(alumnos, nombre_profesor, nombre_curso, nombre_grupo, plataforma):
    plataforma_dict = {
        1: "EDUCAFI01",
        2: "EDUCAFI02",
        3: "EDUCAFI03",
        4: "EDUCAFIUNICA"
    }
    
    plataforma_nombre = plataforma_dict.get(plataforma, "Plataforma no valida")

    script = f"""
function enviarCorreosConPlantilla() {{
  var nombreCurso = "{nombre_curso}";
  var nombreGrupo = "{nombre_grupo}";
  var plataforma = "{plataforma_nombre}";
  var nombreProfesor = "{nombre_profesor}";
  var alumnos = {alumnos};
  var asunto = "Aviso de Alta de Grupo"; 
  var nombreBorrador = "Plantilla_Aviso_Alumnos"; 
  var borrador = null;
  var borradores = GmailApp.getDrafts();

  for (var i = 0; i < borradores.length; i++) {{
    if (borradores[i].getMessage().getSubject() === nombreBorrador) {{
      borrador = borradores[i];
      break;
    }}
  }}

  if (!borrador) {{
    Logger.log("No se encontro un borrador con el nombre exacto: " + nombreBorrador);
    return;
  }}

  var plantilla = borrador.getMessage();

  for (var i = 0; i < alumnos.length; i++) {{
    var emailDestinatario = alumnos[i].email;  
    var nombreAlumno = alumnos[i].nombre;      
    var cuerpoCorreo = plantilla.getBody()
      .replace("{{nombreAlumno}}", nombreAlumno)
      .replace("{{nombreCurso}}", nombreCurso)
      .replace("{{nombreGrupo}}", nombreGrupo)
      .replace("{{plataforma}}", plataforma)
      .replace("{{nombreProfesor}}", nombreProfesor);

    GmailApp.sendEmail(emailDestinatario, asunto, cuerpoCorreo, {{
      htmlBody: cuerpoCorreo,
    }});

    Logger.log("Correo enviado a: " + emailDestinatario);
  }}
}}
"""
    return script

def seleccionar_archivo():
    root = tk.Tk()
    root.withdraw()
    archivo = filedialog.askopenfilename(
        title="Selecciona el archivo CSV", 
        filetypes=[("Archivos CSV", "*.csv")]
    )
    return archivo

def main():
    archivo = seleccionar_archivo()
    if not archivo:
        print("No se selecciono ningún archivo.")
        return

    alumnos = leer_y_transformar_datos(archivo)

    if not alumnos:
        print("No se encontraron alumnos en el archivo.")
        return

    nombre_profesor = input("Ingrese el nombre del profesor: ")
    nombre_curso = input("Ingrese el nombre del curso: ")
    nombre_grupo = input("Ingrese el número o nombre del grupo: ")
    plataforma = int(input("Ingrese el número de la plataforma (1-4): "))

    script = guardar_datos_en_script(alumnos, nombre_profesor, nombre_curso, nombre_grupo, plataforma)

    # Obtener el nombre base del archivo CSV y cambiar la extensión a .js
    nombre_archivo_js = os.path.splitext(archivo)[0] + '.js'

    # Guardar el script generado en un archivo .js
    with open(nombre_archivo_js, "w") as f:
        f.write(script)

    print(f"El script se ha guardado exitosamente como '{nombre_archivo_js}'.")

if __name__ == "__main__":
    main()
