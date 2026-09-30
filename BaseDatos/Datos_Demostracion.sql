/*
  Datos de demostracion para CRM_Educativo.
  Ejecutar una sola vez, luego de crear las tablas.
  Los nombres y correos son ficticios. No usar contrasenas reales.
*/
USE CRM_Educativo;
GO
SET XACT_ABORT ON;
BEGIN TRANSACTION;

IF EXISTS (SELECT 1 FROM dbo.Persona)
    THROW 50001, 'La base ya contiene personas. No vuelva a ejecutar este script.', 1;

DECLARE @PaisId INT, @DepartamentoId INT, @MunicipioId INT, @DireccionId INT;
DECLARE @PAdmin INT, @PAsesora INT, @PDocente INT, @PEstudiante1 INT, @PEstudiante2 INT;
DECLARE @PEncargado INT, @PAspirante1 INT, @PAspirante2 INT, @PAspirante3 INT;
DECLARE @AdminId INT, @AsesoraId INT, @RolAdminId INT, @RolAdmisionesId INT;
DECLARE @CampusId INT, @ProgramaId INT, @Programa2Id INT, @NivelId INT, @GradoId INT;
DECLARE @SeccionId INT, @CicloId INT, @PeriodoId INT, @AulaId INT, @Curso1Id INT, @Curso2Id INT;
DECLARE @DocenteId INT, @FuenteRedesId INT, @FuenteReferidoId INT;
DECLARE @Aspirante1Id INT, @Aspirante2Id INT, @Aspirante3Id INT;
DECLARE @EncargadoId INT, @Estudiante1Id INT, @Estudiante2Id INT;
DECLARE @CanalTelefonoId INT, @CanalCorreoId INT, @CanalWhatsAppId INT;
DECLARE @CampaniaId INT, @Matricula1Id INT, @Matricula2Id INT;
DECLARE @Inscripcion1Id INT, @Inscripcion2Id INT, @Inscripcion3Id INT;
DECLARE @Evaluacion1Id INT, @Evaluacion2Id INT, @TipoDocumentoId INT;
DECLARE @PermisoId INT, @PlantillaId INT;

INSERT dbo.Pais (Nombre, CodigoISO) VALUES (N'Guatemala', 'GT');
SET @PaisId = SCOPE_IDENTITY();
INSERT dbo.Departamento (PaisId, Nombre) VALUES (@PaisId, N'Guatemala');
SET @DepartamentoId = SCOPE_IDENTITY();
INSERT dbo.Municipio (DepartamentoId, Nombre) VALUES (@DepartamentoId, N'Guatemala');
SET @MunicipioId = SCOPE_IDENTITY();
INSERT dbo.Direccion (MunicipioId, Linea1) VALUES (@MunicipioId, N'Zona 1, Ciudad de Guatemala');
SET @DireccionId = SCOPE_IDENTITY();

INSERT dbo.Persona (DireccionId, Nombres, Apellidos, FechaNacimiento, Correo, Telefono)
VALUES (NULL, N'Andrea', N'Administradora', '1990-01-10', N'admin.demo@ejemplo.edu', N'5550-1000');
SET @PAdmin = SCOPE_IDENTITY();
INSERT dbo.Persona (DireccionId, Nombres, Apellidos, FechaNacimiento, Correo, Telefono)
VALUES (NULL, N'Carlos', N'Asesor', '1992-05-15', N'asesor.demo@ejemplo.edu', N'5550-1001');
SET @PAsesora = SCOPE_IDENTITY();
INSERT dbo.Persona (DireccionId, Nombres, Apellidos, FechaNacimiento, Correo, Telefono)
VALUES (@DireccionId, N'Marta', N'Docente', '1985-03-21', N'docente.demo@ejemplo.edu', N'5550-1002');
SET @PDocente = SCOPE_IDENTITY();
INSERT dbo.Persona (DireccionId, Nombres, Apellidos, FechaNacimiento, Correo, Telefono)
VALUES (@DireccionId, N'Lucia', N'Lopez', '2010-04-02', N'lucia.demo@ejemplo.edu', N'5550-1003');
SET @PEstudiante1 = SCOPE_IDENTITY();
INSERT dbo.Persona (DireccionId, Nombres, Apellidos, FechaNacimiento, Correo, Telefono)
VALUES (@DireccionId, N'Mateo', N'Garcia', '2009-08-18', N'mateo.demo@ejemplo.edu', N'5550-1004');
SET @PEstudiante2 = SCOPE_IDENTITY();
INSERT dbo.Persona (DireccionId, Nombres, Apellidos, FechaNacimiento, Correo, Telefono)
VALUES (@DireccionId, N'Elena', N'Lopez', '1980-11-07', N'elena.demo@ejemplo.edu', N'5550-1005');
SET @PEncargado = SCOPE_IDENTITY();
INSERT dbo.Persona (DireccionId, Nombres, Apellidos, FechaNacimiento, Correo, Telefono)
VALUES (NULL, N'Sofia', N'Perez', '2008-02-19', N'sofia.demo@ejemplo.edu', N'5550-1006');
SET @PAspirante1 = SCOPE_IDENTITY();
INSERT dbo.Persona (DireccionId, Nombres, Apellidos, FechaNacimiento, Correo, Telefono)
VALUES (NULL, N'Juan', N'Ramos', '2007-07-09', N'juan.demo@ejemplo.edu', N'5550-1007');
SET @PAspirante2 = SCOPE_IDENTITY();
INSERT dbo.Persona (DireccionId, Nombres, Apellidos, FechaNacimiento, Correo, Telefono)
VALUES (NULL, N'Paola', N'Mendez', '2008-10-12', N'paola.demo@ejemplo.edu', N'5550-1008');
SET @PAspirante3 = SCOPE_IDENTITY();

INSERT dbo.Usuario (PersonaId, NombreUsuario, Correo, HashContrasena)
VALUES (@PAdmin, N'admin.demo', N'admin.demo@ejemplo.edu', N'DEMO-SIN-ACCESO');
SET @AdminId = SCOPE_IDENTITY();
INSERT dbo.Usuario (PersonaId, NombreUsuario, Correo, HashContrasena)
VALUES (@PAsesora, N'asesor.demo', N'asesor.demo@ejemplo.edu', N'DEMO-SIN-ACCESO');
SET @AsesoraId = SCOPE_IDENTITY();
INSERT dbo.Rol (Nombre, Descripcion) VALUES (N'Administrador', N'Rol demostrativo de administracion');
SET @RolAdminId = SCOPE_IDENTITY();
INSERT dbo.Rol (Nombre, Descripcion) VALUES (N'Admisiones', N'Seguimiento de aspirantes');
SET @RolAdmisionesId = SCOPE_IDENTITY();
INSERT dbo.Permiso (Nombre, Descripcion) VALUES (N'Consultar CRM', N'Permiso demostrativo de consulta');
SET @PermisoId = SCOPE_IDENTITY();
INSERT dbo.UsuarioRol (UsuarioId, RolId) VALUES (@AdminId, @RolAdminId), (@AsesoraId, @RolAdmisionesId);
INSERT dbo.RolPermiso (RolId, PermisoId) VALUES (@RolAdminId, @PermisoId), (@RolAdmisionesId, @PermisoId);

INSERT dbo.Campus (DireccionId, Nombre, Telefono) VALUES (@DireccionId, N'Campus Central', N'5550-2000');
SET @CampusId = SCOPE_IDENTITY();
INSERT dbo.Programa (Nombre, Descripcion) VALUES (N'Bachillerato en Computacion', N'Programa de diversificado');
SET @ProgramaId = SCOPE_IDENTITY();
INSERT dbo.Programa (Nombre, Descripcion) VALUES (N'Perito en Administracion', N'Programa de diversificado');
SET @Programa2Id = SCOPE_IDENTITY();
INSERT dbo.NivelEducativo (Nombre) VALUES (N'Diversificado');
SET @NivelId = SCOPE_IDENTITY();
INSERT dbo.Grado (NivelEducativoId, Nombre) VALUES (@NivelId, N'Quinto');
SET @GradoId = SCOPE_IDENTITY();
INSERT dbo.Seccion (CampusId, GradoId, Nombre) VALUES (@CampusId, @GradoId, N'A');
SET @SeccionId = SCOPE_IDENTITY();
INSERT dbo.CicloEscolar (Nombre, FechaInicio, FechaFin) VALUES (N'2026', '2026-01-15', '2026-10-31');
SET @CicloId = SCOPE_IDENTITY();
INSERT dbo.PeriodoAcademico (CicloEscolarId, Nombre, FechaInicio, FechaFin)
VALUES (@CicloId, N'Primer bimestre', '2026-01-15', '2026-03-31');
SET @PeriodoId = SCOPE_IDENTITY();
INSERT dbo.Aula (CampusId, Codigo, Capacidad) VALUES (@CampusId, N'A-101', 30);
SET @AulaId = SCOPE_IDENTITY();
INSERT dbo.Curso (Codigo, Nombre, Descripcion, Creditos)
VALUES (N'BD-101', N'Bases de Datos', N'Introduccion a bases de datos', 4);
SET @Curso1Id = SCOPE_IDENTITY();
INSERT dbo.Curso (Codigo, Nombre, Descripcion, Creditos)
VALUES (N'MAT-101', N'Matematica', N'Matematica general', 4);
SET @Curso2Id = SCOPE_IDENTITY();
INSERT dbo.Docente (PersonaId, FechaContratacion, Especialidad)
VALUES (@PDocente, '2020-01-15', N'Informatica');
SET @DocenteId = SCOPE_IDENTITY();

INSERT dbo.FuenteAspirante (Nombre) VALUES (N'Redes sociales');
SET @FuenteRedesId = SCOPE_IDENTITY();
INSERT dbo.FuenteAspirante (Nombre) VALUES (N'Referido');
SET @FuenteReferidoId = SCOPE_IDENTITY();
INSERT dbo.Aspirante (PersonaId, FuenteAspiranteId, UsuarioResponsableId, Estado)
VALUES (@PAspirante1, @FuenteRedesId, @AsesoraId, N'Contactado');
SET @Aspirante1Id = SCOPE_IDENTITY();
INSERT dbo.Aspirante (PersonaId, FuenteAspiranteId, UsuarioResponsableId, Estado)
VALUES (@PAspirante2, @FuenteReferidoId, @AsesoraId, N'En proceso');
SET @Aspirante2Id = SCOPE_IDENTITY();
INSERT dbo.Aspirante (PersonaId, FuenteAspiranteId, UsuarioResponsableId, Estado)
VALUES (@PAspirante3, @FuenteRedesId, @AdminId, N'Nuevo');
SET @Aspirante3Id = SCOPE_IDENTITY();
INSERT dbo.Encargado (PersonaId, Ocupacion) VALUES (@PEncargado, N'Comerciante');
SET @EncargadoId = SCOPE_IDENTITY();
INSERT dbo.Estudiante (PersonaId, CodigoEstudiante) VALUES (@PEstudiante1, N'EST-2026-001');
SET @Estudiante1Id = SCOPE_IDENTITY();
INSERT dbo.Estudiante (PersonaId, CodigoEstudiante) VALUES (@PEstudiante2, N'EST-2026-002');
SET @Estudiante2Id = SCOPE_IDENTITY();

INSERT dbo.TipoDocumento (Nombre, Obligatorio) VALUES (N'Certificado de nacimiento', 1);
SET @TipoDocumentoId = SCOPE_IDENTITY();
INSERT dbo.DocumentoPersona (PersonaId, TipoDocumentoId, NumeroDocumento)
VALUES (@PEstudiante1, @TipoDocumentoId, N'DEMO-001');
INSERT dbo.SolicitudAdmision (AspiranteId, ProgramaId, CampusId, Estado)
VALUES (@Aspirante1Id, @ProgramaId, @CampusId, N'En revision'),
       (@Aspirante2Id, @Programa2Id, @CampusId, N'Pendiente');

INSERT dbo.CanalComunicacion (Nombre) VALUES (N'Telefono');
SET @CanalTelefonoId = SCOPE_IDENTITY();
INSERT dbo.CanalComunicacion (Nombre) VALUES (N'Correo electronico');
SET @CanalCorreoId = SCOPE_IDENTITY();
INSERT dbo.CanalComunicacion (Nombre) VALUES (N'WhatsApp');
SET @CanalWhatsAppId = SCOPE_IDENTITY();
INSERT dbo.Campania (Nombre, FechaInicio, FechaFin, Presupuesto)
VALUES (N'Admisiones 2026', '2025-10-01', '2026-02-28', 2500.00);
SET @CampaniaId = SCOPE_IDENTITY();
INSERT dbo.Cita (AspiranteId, UsuarioId, FechaHora, Motivo, Estado)
VALUES (@Aspirante1Id, @AsesoraId, '2026-09-25T10:00:00', N'Informacion de admision', N'Programada'),
       (@Aspirante2Id, @AsesoraId, '2026-09-26T11:00:00', N'Entrega de documentos', N'Programada');
INSERT dbo.Interaccion (AspiranteId, UsuarioId, CanalComunicacionId, Asunto, Detalle, Resultado)
VALUES (@Aspirante1Id, @AsesoraId, @CanalWhatsAppId, N'Seguimiento inicial', N'Se envio informacion del programa.', N'Interesada'),
       (@Aspirante2Id, @AsesoraId, @CanalTelefonoId, N'Consulta de admision', N'Se explicaron los requisitos.', N'Pendiente de documentos');
INSERT dbo.Seguimiento (AspiranteId, UsuarioId, FechaProgramada, Tarea, Estado)
VALUES (@Aspirante1Id, @AsesoraId, '2026-09-27T09:00:00', N'Confirmar visita al campus', N'Pendiente'),
       (@Aspirante2Id, @AsesoraId, '2026-09-28T09:00:00', N'Revisar documentos', N'Pendiente');

INSERT dbo.Matricula (EstudianteId, SeccionId, CicloEscolarId, Estado)
VALUES (@Estudiante1Id, @SeccionId, @CicloId, N'Activa');
SET @Matricula1Id = SCOPE_IDENTITY();
INSERT dbo.Matricula (EstudianteId, SeccionId, CicloEscolarId, Estado)
VALUES (@Estudiante2Id, @SeccionId, @CicloId, N'Activa');
SET @Matricula2Id = SCOPE_IDENTITY();
INSERT dbo.InscripcionCurso (MatriculaId, CursoId, DocenteId, AulaId, PeriodoAcademicoId)
VALUES (@Matricula1Id, @Curso1Id, @DocenteId, @AulaId, @PeriodoId);
SET @Inscripcion1Id = SCOPE_IDENTITY();
INSERT dbo.InscripcionCurso (MatriculaId, CursoId, DocenteId, AulaId, PeriodoAcademicoId)
VALUES (@Matricula1Id, @Curso2Id, @DocenteId, @AulaId, @PeriodoId);
SET @Inscripcion2Id = SCOPE_IDENTITY();
INSERT dbo.InscripcionCurso (MatriculaId, CursoId, DocenteId, AulaId, PeriodoAcademicoId)
VALUES (@Matricula2Id, @Curso1Id, @DocenteId, @AulaId, @PeriodoId);
SET @Inscripcion3Id = SCOPE_IDENTITY();
INSERT dbo.Asistencia (InscripcionCursoId, Fecha, Estado, Observacion)
VALUES (@Inscripcion1Id, '2026-02-02', N'Presente', N'Asistencia de demostracion'),
       (@Inscripcion2Id, '2026-02-02', N'Tardanza', N'Asistencia de demostracion'),
       (@Inscripcion3Id, '2026-02-02', N'Presente', N'Asistencia de demostracion');
INSERT dbo.Evaluacion (InscripcionCursoId, Nombre, Fecha, PunteoMaximo)
VALUES (@Inscripcion1Id, N'Laboratorio 1', '2026-02-20', 100.00);
SET @Evaluacion1Id = SCOPE_IDENTITY();
INSERT dbo.Evaluacion (InscripcionCursoId, Nombre, Fecha, PunteoMaximo)
VALUES (@Inscripcion3Id, N'Laboratorio 1', '2026-02-20', 100.00);
SET @Evaluacion2Id = SCOPE_IDENTITY();
INSERT dbo.Nota (EvaluacionId, EstudianteId, Punteo, Observacion)
VALUES (@Evaluacion1Id, @Estudiante1Id, 92.50, N'Nota demostrativa'),
       (@Evaluacion2Id, @Estudiante2Id, 85.00, N'Nota demostrativa');
INSERT dbo.Incidencia (EstudianteId, UsuarioId, Tipo, Descripcion, Estado)
VALUES (@Estudiante1Id, @AsesoraId, N'Academica', N'Registro demostrativo de incidencia.', N'Abierta');
INSERT dbo.PlantillaMensaje (Nombre, Asunto, Cuerpo)
VALUES (N'Bienvenida', N'Bienvenido al centro educativo', N'Plantilla demostrativa.');
SET @PlantillaId = SCOPE_IDENTITY();
INSERT dbo.Notificacion (UsuarioId, PlantillaMensajeId, Mensaje)
VALUES (@AsesoraId, @PlantillaId, N'Notificacion demostrativa de CRM.');

/* Poblar las diez relaciones muchos a muchos del modelo */
INSERT dbo.AspiranteCampania (AspiranteId, CampaniaId)
VALUES (@Aspirante1Id, @CampaniaId), (@Aspirante2Id, @CampaniaId), (@Aspirante3Id, @CampaniaId);
INSERT dbo.EstudianteEncargado (EstudianteId, EncargadoId, Parentesco, EsContactoPrincipal)
VALUES (@Estudiante1Id, @EncargadoId, N'Madre', 1);
INSERT dbo.DocenteCurso (DocenteId, CursoId, PeriodoAcademicoId)
VALUES (@DocenteId, @Curso1Id, @PeriodoId), (@DocenteId, @Curso2Id, @PeriodoId);
INSERT dbo.CursoPrograma (CursoId, ProgramaId, EsObligatorio)
VALUES (@Curso1Id, @ProgramaId, 1), (@Curso2Id, @ProgramaId, 1), (@Curso2Id, @Programa2Id, 1);
INSERT dbo.CursoPrerequisito (CursoId, CursoPrerequisitoId) VALUES (@Curso2Id, @Curso1Id);
INSERT dbo.CampaniaCanal (CampaniaId, CanalComunicacionId)
VALUES (@CampaniaId, @CanalCorreoId), (@CampaniaId, @CanalWhatsAppId);
INSERT dbo.AspirantePrograma (AspiranteId, ProgramaId, Preferencia)
VALUES (@Aspirante1Id, @ProgramaId, 1), (@Aspirante2Id, @Programa2Id, 1),
       (@Aspirante3Id, @ProgramaId, 1), (@Aspirante3Id, @Programa2Id, 2);
INSERT dbo.UsuarioCampus (UsuarioId, CampusId, EsPrincipal)
VALUES (@AdminId, @CampusId, 1), (@AsesoraId, @CampusId, 1);

COMMIT TRANSACTION;
PRINT N'Datos demostrativos insertados correctamente.';
GO
