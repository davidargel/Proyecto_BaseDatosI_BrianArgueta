/*
  CRM Educativo - esquema inicial
  Motor: SQL Server / LocalDB
  Total: 48 tablas (38 entidades principales y 10 tablas puente N:M)

  Ejecucion: seleccionar la base CRM_Educativo en SSMS y ejecutar este archivo.
  Este script es de primera creacion; no volver a ejecutarlo sobre tablas existentes.
*/
USE CRM_Educativo;
GO

/* Geografia y personas */
CREATE TABLE dbo.Pais (
    PaisId INT IDENTITY(1,1) CONSTRAINT PK_Pais PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL CONSTRAINT UQ_Pais_Nombre UNIQUE,
    CodigoISO CHAR(2) NULL
);

CREATE TABLE dbo.Departamento (
    DepartamentoId INT IDENTITY(1,1) CONSTRAINT PK_Departamento PRIMARY KEY,
    PaisId INT NOT NULL,
    Nombre NVARCHAR(100) NOT NULL,
    CONSTRAINT FK_Departamento_Pais FOREIGN KEY (PaisId) REFERENCES dbo.Pais(PaisId),
    CONSTRAINT UQ_Departamento_Pais_Nombre UNIQUE (PaisId, Nombre)
);

CREATE TABLE dbo.Municipio (
    MunicipioId INT IDENTITY(1,1) CONSTRAINT PK_Municipio PRIMARY KEY,
    DepartamentoId INT NOT NULL,
    Nombre NVARCHAR(100) NOT NULL,
    CONSTRAINT FK_Municipio_Departamento FOREIGN KEY (DepartamentoId) REFERENCES dbo.Departamento(DepartamentoId),
    CONSTRAINT UQ_Municipio_Departamento_Nombre UNIQUE (DepartamentoId, Nombre)
);

CREATE TABLE dbo.Direccion (
    DireccionId INT IDENTITY(1,1) CONSTRAINT PK_Direccion PRIMARY KEY,
    MunicipioId INT NOT NULL,
    Linea1 NVARCHAR(200) NOT NULL,
    Linea2 NVARCHAR(200) NULL,
    CodigoPostal NVARCHAR(20) NULL,
    CONSTRAINT FK_Direccion_Municipio FOREIGN KEY (MunicipioId) REFERENCES dbo.Municipio(MunicipioId)
);

CREATE TABLE dbo.Persona (
    PersonaId INT IDENTITY(1,1) CONSTRAINT PK_Persona PRIMARY KEY,
    DireccionId INT NULL,
    Nombres NVARCHAR(100) NOT NULL,
    Apellidos NVARCHAR(100) NOT NULL,
    FechaNacimiento DATE NULL,
    Correo NVARCHAR(254) NULL,
    Telefono NVARCHAR(30) NULL,
    FechaCreacion DATETIME2 NOT NULL CONSTRAINT DF_Persona_FechaCreacion DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Persona_Direccion FOREIGN KEY (DireccionId) REFERENCES dbo.Direccion(DireccionId)
);

/* Seguridad y acceso */
CREATE TABLE dbo.Rol (
    RolId INT IDENTITY(1,1) CONSTRAINT PK_Rol PRIMARY KEY,
    Nombre NVARCHAR(60) NOT NULL CONSTRAINT UQ_Rol_Nombre UNIQUE,
    Descripcion NVARCHAR(250) NULL
);

CREATE TABLE dbo.Permiso (
    PermisoId INT IDENTITY(1,1) CONSTRAINT PK_Permiso PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL CONSTRAINT UQ_Permiso_Nombre UNIQUE,
    Descripcion NVARCHAR(250) NULL
);

CREATE TABLE dbo.Usuario (
    UsuarioId INT IDENTITY(1,1) CONSTRAINT PK_Usuario PRIMARY KEY,
    PersonaId INT NULL,
    NombreUsuario NVARCHAR(80) NOT NULL CONSTRAINT UQ_Usuario_Nombre UNIQUE,
    Correo NVARCHAR(254) NOT NULL CONSTRAINT UQ_Usuario_Correo UNIQUE,
    HashContrasena NVARCHAR(255) NOT NULL,
    Activo BIT NOT NULL CONSTRAINT DF_Usuario_Activo DEFAULT 1,
    CONSTRAINT FK_Usuario_Persona FOREIGN KEY (PersonaId) REFERENCES dbo.Persona(PersonaId)
);

/* Estructura educativa */
CREATE TABLE dbo.Campus (
    CampusId INT IDENTITY(1,1) CONSTRAINT PK_Campus PRIMARY KEY,
    DireccionId INT NULL,
    Nombre NVARCHAR(120) NOT NULL CONSTRAINT UQ_Campus_Nombre UNIQUE,
    Telefono NVARCHAR(30) NULL,
    Activo BIT NOT NULL CONSTRAINT DF_Campus_Activo DEFAULT 1,
    CONSTRAINT FK_Campus_Direccion FOREIGN KEY (DireccionId) REFERENCES dbo.Direccion(DireccionId)
);

CREATE TABLE dbo.Programa (
    ProgramaId INT IDENTITY(1,1) CONSTRAINT PK_Programa PRIMARY KEY,
    Nombre NVARCHAR(120) NOT NULL CONSTRAINT UQ_Programa_Nombre UNIQUE,
    Descripcion NVARCHAR(300) NULL,
    Activo BIT NOT NULL CONSTRAINT DF_Programa_Activo DEFAULT 1
);

CREATE TABLE dbo.NivelEducativo (
    NivelEducativoId INT IDENTITY(1,1) CONSTRAINT PK_NivelEducativo PRIMARY KEY,
    Nombre NVARCHAR(80) NOT NULL CONSTRAINT UQ_NivelEducativo_Nombre UNIQUE
);

CREATE TABLE dbo.Grado (
    GradoId INT IDENTITY(1,1) CONSTRAINT PK_Grado PRIMARY KEY,
    NivelEducativoId INT NOT NULL,
    Nombre NVARCHAR(80) NOT NULL,
    CONSTRAINT FK_Grado_Nivel FOREIGN KEY (NivelEducativoId) REFERENCES dbo.NivelEducativo(NivelEducativoId),
    CONSTRAINT UQ_Grado_Nivel_Nombre UNIQUE (NivelEducativoId, Nombre)
);

CREATE TABLE dbo.Seccion (
    SeccionId INT IDENTITY(1,1) CONSTRAINT PK_Seccion PRIMARY KEY,
    CampusId INT NOT NULL,
    GradoId INT NOT NULL,
    Nombre NVARCHAR(40) NOT NULL,
    CONSTRAINT FK_Seccion_Campus FOREIGN KEY (CampusId) REFERENCES dbo.Campus(CampusId),
    CONSTRAINT FK_Seccion_Grado FOREIGN KEY (GradoId) REFERENCES dbo.Grado(GradoId),
    CONSTRAINT UQ_Seccion_Campus_Grado_Nombre UNIQUE (CampusId, GradoId, Nombre)
);

CREATE TABLE dbo.CicloEscolar (
    CicloEscolarId INT IDENTITY(1,1) CONSTRAINT PK_CicloEscolar PRIMARY KEY,
    Nombre NVARCHAR(30) NOT NULL CONSTRAINT UQ_CicloEscolar_Nombre UNIQUE,
    FechaInicio DATE NOT NULL,
    FechaFin DATE NOT NULL,
    CONSTRAINT CK_CicloEscolar_Fechas CHECK (FechaFin >= FechaInicio)
);

CREATE TABLE dbo.PeriodoAcademico (
    PeriodoAcademicoId INT IDENTITY(1,1) CONSTRAINT PK_PeriodoAcademico PRIMARY KEY,
    CicloEscolarId INT NOT NULL,
    Nombre NVARCHAR(40) NOT NULL,
    FechaInicio DATE NOT NULL,
    FechaFin DATE NOT NULL,
    CONSTRAINT FK_Periodo_Ciclo FOREIGN KEY (CicloEscolarId) REFERENCES dbo.CicloEscolar(CicloEscolarId),
    CONSTRAINT UQ_Periodo_Ciclo_Nombre UNIQUE (CicloEscolarId, Nombre),
    CONSTRAINT CK_Periodo_Fechas CHECK (FechaFin >= FechaInicio)
);

CREATE TABLE dbo.Aula (
    AulaId INT IDENTITY(1,1) CONSTRAINT PK_Aula PRIMARY KEY,
    CampusId INT NOT NULL,
    Codigo NVARCHAR(30) NOT NULL,
    Capacidad INT NOT NULL,
    CONSTRAINT FK_Aula_Campus FOREIGN KEY (CampusId) REFERENCES dbo.Campus(CampusId),
    CONSTRAINT UQ_Aula_Campus_Codigo UNIQUE (CampusId, Codigo),
    CONSTRAINT CK_Aula_Capacidad CHECK (Capacidad > 0)
);

CREATE TABLE dbo.Curso (
    CursoId INT IDENTITY(1,1) CONSTRAINT PK_Curso PRIMARY KEY,
    Codigo NVARCHAR(30) NOT NULL CONSTRAINT UQ_Curso_Codigo UNIQUE,
    Nombre NVARCHAR(120) NOT NULL,
    Descripcion NVARCHAR(300) NULL,
    Creditos TINYINT NOT NULL CONSTRAINT DF_Curso_Creditos DEFAULT 1,
    Activo BIT NOT NULL CONSTRAINT DF_Curso_Activo DEFAULT 1
);

CREATE TABLE dbo.Docente (
    DocenteId INT IDENTITY(1,1) CONSTRAINT PK_Docente PRIMARY KEY,
    PersonaId INT NOT NULL CONSTRAINT UQ_Docente_Persona UNIQUE,
    FechaContratacion DATE NULL,
    Especialidad NVARCHAR(120) NULL,
    Activo BIT NOT NULL CONSTRAINT DF_Docente_Activo DEFAULT 1,
    CONSTRAINT FK_Docente_Persona FOREIGN KEY (PersonaId) REFERENCES dbo.Persona(PersonaId)
);

/* CRM, admision y relaciones */
CREATE TABLE dbo.FuenteAspirante (
    FuenteAspiranteId INT IDENTITY(1,1) CONSTRAINT PK_FuenteAspirante PRIMARY KEY,
    Nombre NVARCHAR(80) NOT NULL CONSTRAINT UQ_FuenteAspirante_Nombre UNIQUE
);

CREATE TABLE dbo.Aspirante (
    AspiranteId INT IDENTITY(1,1) CONSTRAINT PK_Aspirante PRIMARY KEY,
    PersonaId INT NOT NULL CONSTRAINT UQ_Aspirante_Persona UNIQUE,
    FuenteAspiranteId INT NULL,
    UsuarioResponsableId INT NULL,
    Estado NVARCHAR(30) NOT NULL CONSTRAINT DF_Aspirante_Estado DEFAULT N'Nuevo',
    FechaRegistro DATETIME2 NOT NULL CONSTRAINT DF_Aspirante_Fecha DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Aspirante_Persona FOREIGN KEY (PersonaId) REFERENCES dbo.Persona(PersonaId),
    CONSTRAINT FK_Aspirante_Fuente FOREIGN KEY (FuenteAspiranteId) REFERENCES dbo.FuenteAspirante(FuenteAspiranteId),
    CONSTRAINT FK_Aspirante_Responsable FOREIGN KEY (UsuarioResponsableId) REFERENCES dbo.Usuario(UsuarioId),
    CONSTRAINT CK_Aspirante_Estado CHECK (Estado IN (N'Nuevo',N'Contactado',N'En proceso',N'Admitido',N'Rechazado'))
);

CREATE TABLE dbo.Encargado (
    EncargadoId INT IDENTITY(1,1) CONSTRAINT PK_Encargado PRIMARY KEY,
    PersonaId INT NOT NULL CONSTRAINT UQ_Encargado_Persona UNIQUE,
    Ocupacion NVARCHAR(100) NULL,
    CONSTRAINT FK_Encargado_Persona FOREIGN KEY (PersonaId) REFERENCES dbo.Persona(PersonaId)
);

CREATE TABLE dbo.Estudiante (
    EstudianteId INT IDENTITY(1,1) CONSTRAINT PK_Estudiante PRIMARY KEY,
    PersonaId INT NOT NULL CONSTRAINT UQ_Estudiante_Persona UNIQUE,
    CodigoEstudiante NVARCHAR(30) NOT NULL CONSTRAINT UQ_Estudiante_Codigo UNIQUE,
    FechaIngreso DATE NOT NULL CONSTRAINT DF_Estudiante_FechaIngreso DEFAULT CONVERT(date, GETDATE()),
    Estado NVARCHAR(20) NOT NULL CONSTRAINT DF_Estudiante_Estado DEFAULT N'Activo',
    CONSTRAINT FK_Estudiante_Persona FOREIGN KEY (PersonaId) REFERENCES dbo.Persona(PersonaId),
    CONSTRAINT CK_Estudiante_Estado CHECK (Estado IN (N'Activo',N'Inactivo',N'Egresado',N'Retirado'))
);

CREATE TABLE dbo.TipoDocumento (
    TipoDocumentoId INT IDENTITY(1,1) CONSTRAINT PK_TipoDocumento PRIMARY KEY,
    Nombre NVARCHAR(80) NOT NULL CONSTRAINT UQ_TipoDocumento_Nombre UNIQUE,
    Obligatorio BIT NOT NULL CONSTRAINT DF_TipoDocumento_Obligatorio DEFAULT 0
);

CREATE TABLE dbo.DocumentoPersona (
    DocumentoPersonaId INT IDENTITY(1,1) CONSTRAINT PK_DocumentoPersona PRIMARY KEY,
    PersonaId INT NOT NULL,
    TipoDocumentoId INT NOT NULL,
    NumeroDocumento NVARCHAR(60) NULL,
    RutaArchivo NVARCHAR(400) NULL,
    FechaEmision DATE NULL,
    FechaVencimiento DATE NULL,
    CONSTRAINT FK_DocumentoPersona_Persona FOREIGN KEY (PersonaId) REFERENCES dbo.Persona(PersonaId),
    CONSTRAINT FK_DocumentoPersona_Tipo FOREIGN KEY (TipoDocumentoId) REFERENCES dbo.TipoDocumento(TipoDocumentoId)
);

CREATE TABLE dbo.SolicitudAdmision (
    SolicitudAdmisionId INT IDENTITY(1,1) CONSTRAINT PK_SolicitudAdmision PRIMARY KEY,
    AspiranteId INT NOT NULL,
    ProgramaId INT NOT NULL,
    CampusId INT NOT NULL,
    FechaSolicitud DATE NOT NULL CONSTRAINT DF_Solicitud_Fecha DEFAULT CONVERT(date, GETDATE()),
    Estado NVARCHAR(25) NOT NULL CONSTRAINT DF_Solicitud_Estado DEFAULT N'Pendiente',
    CONSTRAINT FK_Solicitud_Aspirante FOREIGN KEY (AspiranteId) REFERENCES dbo.Aspirante(AspiranteId),
    CONSTRAINT FK_Solicitud_Programa FOREIGN KEY (ProgramaId) REFERENCES dbo.Programa(ProgramaId),
    CONSTRAINT FK_Solicitud_Campus FOREIGN KEY (CampusId) REFERENCES dbo.Campus(CampusId),
    CONSTRAINT CK_Solicitud_Estado CHECK (Estado IN (N'Pendiente',N'En revision',N'Aprobada',N'Rechazada'))
);

CREATE TABLE dbo.CanalComunicacion (
    CanalComunicacionId INT IDENTITY(1,1) CONSTRAINT PK_CanalComunicacion PRIMARY KEY,
    Nombre NVARCHAR(60) NOT NULL CONSTRAINT UQ_Canal_Nombre UNIQUE
);

CREATE TABLE dbo.Campania (
    CampaniaId INT IDENTITY(1,1) CONSTRAINT PK_Campania PRIMARY KEY,
    Nombre NVARCHAR(120) NOT NULL,
    FechaInicio DATE NULL,
    FechaFin DATE NULL,
    Presupuesto DECIMAL(12,2) NULL,
    Activa BIT NOT NULL CONSTRAINT DF_Campania_Activa DEFAULT 1,
    CONSTRAINT CK_Campania_Fechas CHECK (FechaFin IS NULL OR FechaInicio IS NULL OR FechaFin >= FechaInicio),
    CONSTRAINT CK_Campania_Presupuesto CHECK (Presupuesto IS NULL OR Presupuesto >= 0)
);

CREATE TABLE dbo.Cita (
    CitaId INT IDENTITY(1,1) CONSTRAINT PK_Cita PRIMARY KEY,
    AspiranteId INT NOT NULL,
    UsuarioId INT NULL,
    FechaHora DATETIME2 NOT NULL,
    Motivo NVARCHAR(200) NOT NULL,
    Estado NVARCHAR(20) NOT NULL CONSTRAINT DF_Cita_Estado DEFAULT N'Programada',
    CONSTRAINT FK_Cita_Aspirante FOREIGN KEY (AspiranteId) REFERENCES dbo.Aspirante(AspiranteId),
    CONSTRAINT FK_Cita_Usuario FOREIGN KEY (UsuarioId) REFERENCES dbo.Usuario(UsuarioId)
);

CREATE TABLE dbo.Interaccion (
    InteraccionId INT IDENTITY(1,1) CONSTRAINT PK_Interaccion PRIMARY KEY,
    AspiranteId INT NOT NULL,
    UsuarioId INT NULL,
    CanalComunicacionId INT NOT NULL,
    FechaHora DATETIME2 NOT NULL CONSTRAINT DF_Interaccion_Fecha DEFAULT SYSUTCDATETIME(),
    Asunto NVARCHAR(160) NULL,
    Detalle NVARCHAR(1000) NOT NULL,
    Resultado NVARCHAR(300) NULL,
    CONSTRAINT FK_Interaccion_Aspirante FOREIGN KEY (AspiranteId) REFERENCES dbo.Aspirante(AspiranteId),
    CONSTRAINT FK_Interaccion_Usuario FOREIGN KEY (UsuarioId) REFERENCES dbo.Usuario(UsuarioId),
    CONSTRAINT FK_Interaccion_Canal FOREIGN KEY (CanalComunicacionId) REFERENCES dbo.CanalComunicacion(CanalComunicacionId)
);

CREATE TABLE dbo.Seguimiento (
    SeguimientoId INT IDENTITY(1,1) CONSTRAINT PK_Seguimiento PRIMARY KEY,
    AspiranteId INT NOT NULL,
    UsuarioId INT NULL,
    FechaProgramada DATETIME2 NOT NULL,
    FechaCompletada DATETIME2 NULL,
    Tarea NVARCHAR(250) NOT NULL,
    Estado NVARCHAR(20) NOT NULL CONSTRAINT DF_Seguimiento_Estado DEFAULT N'Pendiente',
    CONSTRAINT FK_Seguimiento_Aspirante FOREIGN KEY (AspiranteId) REFERENCES dbo.Aspirante(AspiranteId),
    CONSTRAINT FK_Seguimiento_Usuario FOREIGN KEY (UsuarioId) REFERENCES dbo.Usuario(UsuarioId)
);

/* Matricula y actividad academica */
CREATE TABLE dbo.Matricula (
    MatriculaId INT IDENTITY(1,1) CONSTRAINT PK_Matricula PRIMARY KEY,
    EstudianteId INT NOT NULL,
    SeccionId INT NOT NULL,
    CicloEscolarId INT NOT NULL,
    FechaMatricula DATE NOT NULL CONSTRAINT DF_Matricula_Fecha DEFAULT CONVERT(date, GETDATE()),
    Estado NVARCHAR(20) NOT NULL CONSTRAINT DF_Matricula_Estado DEFAULT N'Activa',
    CONSTRAINT FK_Matricula_Estudiante FOREIGN KEY (EstudianteId) REFERENCES dbo.Estudiante(EstudianteId),
    CONSTRAINT FK_Matricula_Seccion FOREIGN KEY (SeccionId) REFERENCES dbo.Seccion(SeccionId),
    CONSTRAINT FK_Matricula_Ciclo FOREIGN KEY (CicloEscolarId) REFERENCES dbo.CicloEscolar(CicloEscolarId),
    CONSTRAINT UQ_Matricula_Estudiante_Ciclo UNIQUE (EstudianteId, CicloEscolarId)
);

CREATE TABLE dbo.InscripcionCurso (
    InscripcionCursoId INT IDENTITY(1,1) CONSTRAINT PK_InscripcionCurso PRIMARY KEY,
    MatriculaId INT NOT NULL,
    CursoId INT NOT NULL,
    DocenteId INT NULL,
    AulaId INT NULL,
    PeriodoAcademicoId INT NOT NULL,
    CONSTRAINT FK_Inscripcion_Matricula FOREIGN KEY (MatriculaId) REFERENCES dbo.Matricula(MatriculaId),
    CONSTRAINT FK_Inscripcion_Curso FOREIGN KEY (CursoId) REFERENCES dbo.Curso(CursoId),
    CONSTRAINT FK_Inscripcion_Docente FOREIGN KEY (DocenteId) REFERENCES dbo.Docente(DocenteId),
    CONSTRAINT FK_Inscripcion_Aula FOREIGN KEY (AulaId) REFERENCES dbo.Aula(AulaId),
    CONSTRAINT FK_Inscripcion_Periodo FOREIGN KEY (PeriodoAcademicoId) REFERENCES dbo.PeriodoAcademico(PeriodoAcademicoId),
    CONSTRAINT UQ_Inscripcion_Matricula_Curso_Periodo UNIQUE (MatriculaId, CursoId, PeriodoAcademicoId)
);

CREATE TABLE dbo.Asistencia (
    AsistenciaId INT IDENTITY(1,1) CONSTRAINT PK_Asistencia PRIMARY KEY,
    InscripcionCursoId INT NOT NULL,
    Fecha DATE NOT NULL,
    Estado NVARCHAR(15) NOT NULL,
    Observacion NVARCHAR(250) NULL,
    CONSTRAINT FK_Asistencia_Inscripcion FOREIGN KEY (InscripcionCursoId) REFERENCES dbo.InscripcionCurso(InscripcionCursoId),
    CONSTRAINT UQ_Asistencia_Inscripcion_Fecha UNIQUE (InscripcionCursoId, Fecha),
    CONSTRAINT CK_Asistencia_Estado CHECK (Estado IN (N'Presente',N'Ausente',N'Tardanza',N'Justificada'))
);

CREATE TABLE dbo.Evaluacion (
    EvaluacionId INT IDENTITY(1,1) CONSTRAINT PK_Evaluacion PRIMARY KEY,
    InscripcionCursoId INT NOT NULL,
    Nombre NVARCHAR(120) NOT NULL,
    Fecha DATE NOT NULL,
    PunteoMaximo DECIMAL(6,2) NOT NULL,
    CONSTRAINT FK_Evaluacion_Inscripcion FOREIGN KEY (InscripcionCursoId) REFERENCES dbo.InscripcionCurso(InscripcionCursoId),
    CONSTRAINT CK_Evaluacion_Punteo CHECK (PunteoMaximo > 0)
);

CREATE TABLE dbo.Nota (
    NotaId INT IDENTITY(1,1) CONSTRAINT PK_Nota PRIMARY KEY,
    EvaluacionId INT NOT NULL,
    EstudianteId INT NOT NULL,
    Punteo DECIMAL(6,2) NOT NULL,
    Observacion NVARCHAR(250) NULL,
    CONSTRAINT FK_Nota_Evaluacion FOREIGN KEY (EvaluacionId) REFERENCES dbo.Evaluacion(EvaluacionId),
    CONSTRAINT FK_Nota_Estudiante FOREIGN KEY (EstudianteId) REFERENCES dbo.Estudiante(EstudianteId),
    CONSTRAINT UQ_Nota_Evaluacion_Estudiante UNIQUE (EvaluacionId, EstudianteId),
    CONSTRAINT CK_Nota_Punteo CHECK (Punteo >= 0)
);

CREATE TABLE dbo.Incidencia (
    IncidenciaId INT IDENTITY(1,1) CONSTRAINT PK_Incidencia PRIMARY KEY,
    EstudianteId INT NOT NULL,
    UsuarioId INT NULL,
    FechaHora DATETIME2 NOT NULL CONSTRAINT DF_Incidencia_Fecha DEFAULT SYSUTCDATETIME(),
    Tipo NVARCHAR(50) NOT NULL,
    Descripcion NVARCHAR(1000) NOT NULL,
    Estado NVARCHAR(20) NOT NULL CONSTRAINT DF_Incidencia_Estado DEFAULT N'Abierta',
    CONSTRAINT FK_Incidencia_Estudiante FOREIGN KEY (EstudianteId) REFERENCES dbo.Estudiante(EstudianteId),
    CONSTRAINT FK_Incidencia_Usuario FOREIGN KEY (UsuarioId) REFERENCES dbo.Usuario(UsuarioId)
);

CREATE TABLE dbo.PlantillaMensaje (
    PlantillaMensajeId INT IDENTITY(1,1) CONSTRAINT PK_PlantillaMensaje PRIMARY KEY,
    Nombre NVARCHAR(120) NOT NULL CONSTRAINT UQ_PlantillaMensaje_Nombre UNIQUE,
    Asunto NVARCHAR(200) NULL,
    Cuerpo NVARCHAR(MAX) NOT NULL,
    Activa BIT NOT NULL CONSTRAINT DF_Plantilla_Activa DEFAULT 1
);

CREATE TABLE dbo.Notificacion (
    NotificacionId INT IDENTITY(1,1) CONSTRAINT PK_Notificacion PRIMARY KEY,
    UsuarioId INT NOT NULL,
    PlantillaMensajeId INT NULL,
    FechaCreacion DATETIME2 NOT NULL CONSTRAINT DF_Notificacion_Fecha DEFAULT SYSUTCDATETIME(),
    Mensaje NVARCHAR(500) NOT NULL,
    Leida BIT NOT NULL CONSTRAINT DF_Notificacion_Leida DEFAULT 0,
    CONSTRAINT FK_Notificacion_Usuario FOREIGN KEY (UsuarioId) REFERENCES dbo.Usuario(UsuarioId),
    CONSTRAINT FK_Notificacion_Plantilla FOREIGN KEY (PlantillaMensajeId) REFERENCES dbo.PlantillaMensaje(PlantillaMensajeId)
);

/* Diez tablas puente para relaciones muchos a muchos */
CREATE TABLE dbo.UsuarioRol (
    UsuarioId INT NOT NULL,
    RolId INT NOT NULL,
    FechaAsignacion DATETIME2 NOT NULL CONSTRAINT DF_UsuarioRol_Fecha DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_UsuarioRol PRIMARY KEY (UsuarioId, RolId),
    CONSTRAINT FK_UsuarioRol_Usuario FOREIGN KEY (UsuarioId) REFERENCES dbo.Usuario(UsuarioId),
    CONSTRAINT FK_UsuarioRol_Rol FOREIGN KEY (RolId) REFERENCES dbo.Rol(RolId)
);

CREATE TABLE dbo.RolPermiso (
    RolId INT NOT NULL,
    PermisoId INT NOT NULL,
    CONSTRAINT PK_RolPermiso PRIMARY KEY (RolId, PermisoId),
    CONSTRAINT FK_RolPermiso_Rol FOREIGN KEY (RolId) REFERENCES dbo.Rol(RolId),
    CONSTRAINT FK_RolPermiso_Permiso FOREIGN KEY (PermisoId) REFERENCES dbo.Permiso(PermisoId)
);

CREATE TABLE dbo.AspiranteCampania (
    AspiranteId INT NOT NULL,
    CampaniaId INT NOT NULL,
    FechaVinculacion DATE NOT NULL CONSTRAINT DF_AspiranteCampania_Fecha DEFAULT CONVERT(date, GETDATE()),
    CONSTRAINT PK_AspiranteCampania PRIMARY KEY (AspiranteId, CampaniaId),
    CONSTRAINT FK_AspiranteCampania_Aspirante FOREIGN KEY (AspiranteId) REFERENCES dbo.Aspirante(AspiranteId),
    CONSTRAINT FK_AspiranteCampania_Campania FOREIGN KEY (CampaniaId) REFERENCES dbo.Campania(CampaniaId)
);

CREATE TABLE dbo.EstudianteEncargado (
    EstudianteId INT NOT NULL,
    EncargadoId INT NOT NULL,
    Parentesco NVARCHAR(50) NOT NULL,
    EsContactoPrincipal BIT NOT NULL CONSTRAINT DF_EstudianteEncargado_Principal DEFAULT 0,
    CONSTRAINT PK_EstudianteEncargado PRIMARY KEY (EstudianteId, EncargadoId),
    CONSTRAINT FK_EstudianteEncargado_Estudiante FOREIGN KEY (EstudianteId) REFERENCES dbo.Estudiante(EstudianteId),
    CONSTRAINT FK_EstudianteEncargado_Encargado FOREIGN KEY (EncargadoId) REFERENCES dbo.Encargado(EncargadoId)
);

CREATE TABLE dbo.DocenteCurso (
    DocenteId INT NOT NULL,
    CursoId INT NOT NULL,
    PeriodoAcademicoId INT NOT NULL,
    CONSTRAINT PK_DocenteCurso PRIMARY KEY (DocenteId, CursoId, PeriodoAcademicoId),
    CONSTRAINT FK_DocenteCurso_Docente FOREIGN KEY (DocenteId) REFERENCES dbo.Docente(DocenteId),
    CONSTRAINT FK_DocenteCurso_Curso FOREIGN KEY (CursoId) REFERENCES dbo.Curso(CursoId),
    CONSTRAINT FK_DocenteCurso_Periodo FOREIGN KEY (PeriodoAcademicoId) REFERENCES dbo.PeriodoAcademico(PeriodoAcademicoId)
);

CREATE TABLE dbo.CursoPrograma (
    CursoId INT NOT NULL,
    ProgramaId INT NOT NULL,
    EsObligatorio BIT NOT NULL CONSTRAINT DF_CursoPrograma_Obligatorio DEFAULT 1,
    CONSTRAINT PK_CursoPrograma PRIMARY KEY (CursoId, ProgramaId),
    CONSTRAINT FK_CursoPrograma_Curso FOREIGN KEY (CursoId) REFERENCES dbo.Curso(CursoId),
    CONSTRAINT FK_CursoPrograma_Programa FOREIGN KEY (ProgramaId) REFERENCES dbo.Programa(ProgramaId)
);

CREATE TABLE dbo.CursoPrerequisito (
    CursoId INT NOT NULL,
    CursoPrerequisitoId INT NOT NULL,
    CONSTRAINT PK_CursoPrerequisito PRIMARY KEY (CursoId, CursoPrerequisitoId),
    CONSTRAINT FK_CursoPrerequisito_Curso FOREIGN KEY (CursoId) REFERENCES dbo.Curso(CursoId),
    CONSTRAINT FK_CursoPrerequisito_Requisito FOREIGN KEY (CursoPrerequisitoId) REFERENCES dbo.Curso(CursoId),
    CONSTRAINT CK_CursoPrerequisito_NoMismoCurso CHECK (CursoId <> CursoPrerequisitoId)
);

CREATE TABLE dbo.CampaniaCanal (
    CampaniaId INT NOT NULL,
    CanalComunicacionId INT NOT NULL,
    CONSTRAINT PK_CampaniaCanal PRIMARY KEY (CampaniaId, CanalComunicacionId),
    CONSTRAINT FK_CampaniaCanal_Campania FOREIGN KEY (CampaniaId) REFERENCES dbo.Campania(CampaniaId),
    CONSTRAINT FK_CampaniaCanal_Canal FOREIGN KEY (CanalComunicacionId) REFERENCES dbo.CanalComunicacion(CanalComunicacionId)
);

CREATE TABLE dbo.AspirantePrograma (
    AspiranteId INT NOT NULL,
    ProgramaId INT NOT NULL,
    Preferencia TINYINT NOT NULL CONSTRAINT DF_AspirantePrograma_Preferencia DEFAULT 1,
    CONSTRAINT PK_AspirantePrograma PRIMARY KEY (AspiranteId, ProgramaId),
    CONSTRAINT FK_AspirantePrograma_Aspirante FOREIGN KEY (AspiranteId) REFERENCES dbo.Aspirante(AspiranteId),
    CONSTRAINT FK_AspirantePrograma_Programa FOREIGN KEY (ProgramaId) REFERENCES dbo.Programa(ProgramaId),
    CONSTRAINT CK_AspirantePrograma_Preferencia CHECK (Preferencia > 0)
);

CREATE TABLE dbo.UsuarioCampus (
    UsuarioId INT NOT NULL,
    CampusId INT NOT NULL,
    EsPrincipal BIT NOT NULL CONSTRAINT DF_UsuarioCampus_Principal DEFAULT 0,
    CONSTRAINT PK_UsuarioCampus PRIMARY KEY (UsuarioId, CampusId),
    CONSTRAINT FK_UsuarioCampus_Usuario FOREIGN KEY (UsuarioId) REFERENCES dbo.Usuario(UsuarioId),
    CONSTRAINT FK_UsuarioCampus_Campus FOREIGN KEY (CampusId) REFERENCES dbo.Campus(CampusId)
);
GO

PRINT N'CRM_Educativo: se crearon las 48 tablas del esquema.';
