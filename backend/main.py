
from contextlib import asynccontextmanager

from fastapi import FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field

from prolog_service import PrologService, PrologServiceError


@asynccontextmanager
async def lifespan(app: FastAPI):
    service = PrologService()
    app.state.prolog = service

    try:
        yield
    finally:
        service.close()


app = FastAPI(
    title="VetIA API",
    description="API de apoyo al diagnóstico veterinario canino.",
    version="1.0.0",
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:5173",
        "http://127.0.0.1:5173",
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


class DiagnosticRequest(BaseModel):
    presentes: list[str] = Field(default_factory=list, max_length=200)
    ausentes: list[str] = Field(default_factory=list, max_length=200)


def get_service(request: Request) -> PrologService:
    service = getattr(request.app.state, "prolog", None)

    if service is None:
        raise HTTPException(
            status_code=503,
            detail="El motor de inferencia no está disponible.",
        )

    return service


@app.get("/")
def root():
    return {
        "nombre": "VetIA API",
        "estado": "activo",
        "documentacion": "/docs",
    }


@app.get("/api/health")
def health(request: Request):
    try:
        return get_service(request).health()
    except PrologServiceError as exc:
        raise HTTPException(status_code=503, detail=str(exc))


@app.get("/api/enfermedades")
def enfermedades(request: Request):
    try:
        return get_service(request).enfermedades()
    except PrologServiceError as exc:
        raise HTTPException(status_code=500, detail=str(exc))

@app.get("/api/enfermedades/{disease_id}")
def detalle_enfermedad(disease_id: str, request: Request):
    try:
        return get_service(request).detalle_enfermedad(disease_id)

    except ValueError as exc:
        raise HTTPException(
            status_code=404,
            detail=str(exc)
        )

    except PrologServiceError as exc:
        raise HTTPException(
            status_code=500,
            detail=str(exc)
        )

@app.get("/api/sintomas")
def sintomas(request: Request):
    try:
        return get_service(request).sintomas()
    except PrologServiceError as exc:
        raise HTTPException(status_code=500, detail=str(exc))


@app.get("/api/pruebas")
def pruebas(request: Request):
    try:
        return get_service(request).pruebas()
    except PrologServiceError as exc:
        raise HTTPException(status_code=500, detail=str(exc))


@app.post("/api/diagnostico")
def diagnostico(
    data: DiagnosticRequest,
    request: Request,
):
    try:
        return get_service(request).diagnosticar(
            presentes=data.presentes,
            ausentes=data.ausentes,
        )
    except ValueError as exc:
        raise HTTPException(status_code=422, detail=str(exc))
    except PrologServiceError as exc:
        raise HTTPException(status_code=500, detail=str(exc))
