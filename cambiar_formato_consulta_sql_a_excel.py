import pandas as pd
import os
from tkinter import Tk
from tkinter.filedialog import askopenfilename

def pipe_to_excel():
    # Crear una ventana oculta de tkinter
    Tk().withdraw()
    
    # Abrir el explorador de archivos de Windows para seleccionar el archivo de entrada
    input_file = askopenfilename(title="Selecciona el archivo", filetypes=[("Archivos de texto", "*.txt")])

    # Verificar si se seleccionó un archivo
    if not input_file:
        print("No se seleccionó ningún archivo.")
        return

    try:
        # Validar la existencia del archivo de entrada
        if not os.path.isfile(input_file):
            print("El archivo especificado no existe. Por favor verifica el nombre del archivo.")
            return

        # Definir el nombre del archivo de salida automáticamente cambiando la extensión
        base_name = os.path.splitext(input_file)[0]
        output_file = base_name + ".xlsx"

        # Leer el archivo de texto
        with open(input_file, 'r', encoding='utf-8') as file:
            lines = file.readlines()

        # Procesar los datos para convertirlos en listas
        data = [line.strip().split('|') for line in lines]

        # Detectar automáticamente el número máximo de columnas
        max_columns = max(len(row) for row in data)

        # Normalizar filas para que todas tengan el mismo número de columnas
        normalized_data = [row + [''] * (max_columns - len(row)) for row in data]

        # Crear un DataFrame a partir de los datos normalizados
        df = pd.DataFrame(normalized_data)

        # Guardar el DataFrame en un archivo Excel
        df.to_excel(output_file, index=False, header=False)

        print(f"Los datos se han guardado exitosamente en '{output_file}'.")
    except Exception as e:
        print(f"Ocurrió un error: {e}")

if __name__ == "__main__":
    pipe_to_excel()
