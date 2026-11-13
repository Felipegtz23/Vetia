# 🐾 VetIA

<div align="center">

### Sistema inteligente de apoyo al diagnóstico veterinario

Software de asistencia veterinaria orientado a la identificación de posibles enfermedades en caninos mediante la evaluación de síntomas clínicos.

![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![FastAPI](https://img.shields.io/badge/FastAPI-009688?style=for-the-badge&logo=fastapi&logoColor=white)
![React](https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB)
![TypeScript](https://img.shields.io/badge/TypeScript-3178C6?style=for-the-badge&logo=typescript&logoColor=white)
![Prolog](https://img.shields.io/badge/Prolog-74283C?style=for-the-badge)

</div>

---

## 📌 Descripción

**VetIA** es un software desarrollado con el propósito de ayudar a los médicos veterinarios en la identificación de posibles enfermedades en la especie canina, mediante un sistema de evaluación de síntomas clínicos.

La aplicación analiza los síntomas seleccionados y genera posibles diagnósticos, acompañados de un porcentaje hipotético de coincidencia basado en la relación entre los síntomas identificados y las enfermedades registradas en su base de conocimientos.

VetIA funciona como una herramienta de apoyo a la decisión clínica. No pretende sustituir el criterio de un profesional veterinario ni reemplazar los exámenes clínicos necesarios para confirmar un diagnóstico.

## 🚀 Características principales

- **Evaluación de síntomas:** permite seleccionar los síntomas presentes y ausentes en el paciente canino.
- **Generación de posibles diagnósticos:** identifica enfermedades relacionadas con los síntomas seleccionados.
- **Porcentaje de coincidencia:** proporciona un valor hipotético basado en la cantidad de síntomas relacionados con cada enfermedad.
- **Información clínica:** ofrece información detallada sobre síntomas, pruebas diagnósticas y fuentes de consulta de las enfermedades registradas.
- **Base de conocimientos:** utiliza Prolog para almacenar y gestionar las enfermedades y sus relaciones con los síntomas.
- **Interfaz gráfica:** desarrollada con React y TypeScript para facilitar la interacción con el sistema.

## 🛠️ Tecnologías utilizadas

### Backend

| Tecnología | Descripción |
|---|---|
| Python | Lenguaje principal del backend. |
| FastAPI | Framework para el desarrollo de la API. |
| Uvicorn | Servidor ASGI para ejecutar la aplicación. |
| Pydantic | Validación y gestión de datos. |
| Prolog | Gestión de la base de conocimientos y reglas lógicas. |

### Frontend

| Tecnología | Descripción |
|---|---|
| React | Biblioteca para construir la interfaz gráfica. |
| TypeScript | Lenguaje utilizado para desarrollar el frontend. |
| TSX | Sintaxis para integrar componentes visuales con TypeScript. |

## 📋 Requisitos previos

Antes de instalar y ejecutar el proyecto, es necesario contar con las siguientes herramientas:

- Python 3.x
- Node.js
- npm (incluido con Node.js).
- Git
- Intérprete de Prolog compatible con el proyecto.

## ⚙️ Instalación

Sigue los siguientes pasos para configurar el proyecto en tu entorno local.

### 1. Clonar el repositorio

Abre una terminal y ejecuta:

```bash
git clone https://github.com/Felipegtz23/Vetia.git
```

Ingresa a la carpeta del proyecto:

```bash
cd Vetia
```

### 2. Configurar el backend

Desde la carpeta raíz del proyecto, crea un entorno virtual:

```bash
python -m venv venv
```

Activa el entorno virtual en Windows:

```bash
venv\Scripts\activate
```

Instala las dependencias del backend:

```bash
pip install -r requirements.txt
```

### 3. Configurar el frontend

Ingresa a la carpeta del frontend:

```bash
cd frontend
```

Instala las dependencias necesarias:

```bash
npm install
```

## ▶️ Ejecución del proyecto

Para ejecutar VetIA es necesario iniciar el backend y el frontend en terminales independientes.

### 1. Iniciar el backend

Desde la carpeta raíz del proyecto, con el entorno virtual activado, ejecuta:

```bash
uvicorn backend.main:app --reload
```

Una vez iniciado, el backend estará disponible en:

- **API:** http://127.0.0.1:8000
- **Documentación de la API:** http://127.0.0.1:8000/docs

### 2. Iniciar el frontend

Abre una segunda terminal, ingresa a la carpeta `frontend` y ejecuta:

```bash
npm run dev
```

La dirección local del frontend aparecerá en la terminal. Ábrela en tu navegador para utilizar la aplicación.

## ⚠️ Consideraciones importantes

VetIA es una herramienta de apoyo a la decisión clínica veterinaria. Los resultados generados son orientativos y no constituyen un diagnóstico definitivo.

La evaluación de cada paciente debe ser realizada por un médico veterinario, quien determinará los procedimientos y pruebas clínicas necesarios.

## 👥 Autores

- Andres Felipe Gutierrez
- Thomas Andres Barragan Mendez
- Andres Felipe Gomez Parra

---

<div align="center">

**VetIA 🐾**

*Tecnología e inteligencia computacional al servicio del bienestar animal.*

</div>