/*
  CRM Educativo - 8 reportes parametrizados para SQL Server
  Cada consulta contiene al menos 5 INNER JOIN y 5 filtros opcionales.
  Ejecutar cada bloque por separado y ajustar los valores de DECLARE.
*/
USE CRM_Educativo;
GO

/* REPORTE 1: Aspirantes por programa, fuente y responsable */
DECLARE @R1_Desde DATE = NULL, @R1_Hasta DATE = NULL;
DECLARE @R1_Estado NVARCHAR(30) = NULL, @R1_ProgramaId INT = NULL;
DECLARE @R1_FuenteId INT = NULL, @R1_ResponsableId INT = NULL;
SELECT a.AspiranteId, p.Nombres, p.Apellidos, p.Correo,
       pr.Nombre AS Programa, f.Nombre AS Fuente, u.NombreUsuario AS Responsable,
       a.Estado, a.FechaRegistro
FROM dbo.Aspirante AS a
INNER JOIN dbo.Persona AS p ON p.PersonaId = a.PersonaId
INNER JOIN dbo.FuenteAspirante AS f ON f.FuenteAspiranteId = a.FuenteAspiranteId
INNER JOIN dbo.Usuario AS u ON u.UsuarioId = a.UsuarioResponsableId
INNER JOIN dbo.AspirantePrograma AS ap ON ap.AspiranteId = a.AspiranteId
INNER JOIN dbo.Programa AS pr ON pr.ProgramaId = ap.ProgramaId
WHERE (@R1_Desde IS NULL OR a.FechaRegistro >= @R1_Desde)
  AND (@R1_Hasta IS NULL OR a.FechaRegistro < DATEADD(day, 1, @R1_Hasta))
  AND (@R1_Estado IS NULL OR a.Estado = @R1_Estado)
  AND (@R1_ProgramaId IS NULL OR pr.ProgramaId = @R1_ProgramaId)
  AND (@R1_FuenteId IS NULL OR f.FuenteAspiranteId = @R1_FuenteId)
  AND (@R1_ResponsableId IS NULL OR u.UsuarioId = @R1_ResponsableId)
ORDER BY a.FechaRegistro DESC;
GO

/* REPORTE 2: Historial de interacciones y canal */
DECLARE @R2_Desde DATE = NULL, @R2_Hasta DATE = NULL;
DECLARE @R2_EstadoAspirante NVARCHAR(30) = NULL, @R2_CanalId INT = NULL;
DECLARE @R2_UsuarioId INT = NULL, @R2_Texto NVARCHAR(100) = NULL;
SELECT i.InteraccionId, i.FechaHora, p.Nombres, p.Apellidos,
       cc.Nombre AS Canal, i.Asunto, i.Detalle, i.Resultado,
       u.NombreUsuario AS Usuario, pu.Nombres AS NombresUsuario
FROM dbo.Interaccion AS i
INNER JOIN dbo.Aspirante AS a ON a.AspiranteId = i.AspiranteId
INNER JOIN dbo.Persona AS p ON p.PersonaId = a.PersonaId
INNER JOIN dbo.CanalComunicacion AS cc ON cc.CanalComunicacionId = i.CanalComunicacionId
INNER JOIN dbo.Usuario AS u ON u.UsuarioId = i.UsuarioId
INNER JOIN dbo.Persona AS pu ON pu.PersonaId = u.PersonaId
WHERE (@R2_Desde IS NULL OR i.FechaHora >= @R2_Desde)
  AND (@R2_Hasta IS NULL OR i.FechaHora < DATEADD(day, 1, @R2_Hasta))
  AND (@R2_EstadoAspirante IS NULL OR a.Estado = @R2_EstadoAspirante)
  AND (@R2_CanalId IS NULL OR cc.CanalComunicacionId = @R2_CanalId)
  AND (@R2_UsuarioId IS NULL OR u.UsuarioId = @R2_UsuarioId)
  AND (@R2_Texto IS NULL OR i.Detalle LIKE N'%' + @R2_Texto + N'%'
       OR i.Asunto LIKE N'%' + @R2_Texto + N'%')
ORDER BY i.FechaHora DESC;
GO

/* REPORTE 3: Solicitudes de admision por programa, campus y estado */
DECLARE @R3_Desde DATE = NULL, @R3_Hasta DATE = NULL;
DECLARE @R3_Estado NVARCHAR(25) = NULL, @R3_ProgramaId INT = NULL;
DECLARE @R3_CampusId INT = NULL, @R3_FuenteId INT = NULL;
DECLARE @R3_ResponsableId INT = NULL;
SELECT sa.SolicitudAdmisionId, sa.FechaSolicitud, sa.Estado AS EstadoSolicitud,
       p.Nombres, p.Apellidos, pr.Nombre AS Programa, c.Nombre AS Campus,
       f.Nombre AS Fuente, u.NombreUsuario AS Responsable
FROM dbo.SolicitudAdmision AS sa
INNER JOIN dbo.Aspirante AS a ON a.AspiranteId = sa.AspiranteId
INNER JOIN dbo.Persona AS p ON p.PersonaId = a.PersonaId
INNER JOIN dbo.Programa AS pr ON pr.ProgramaId = sa.ProgramaId
INNER JOIN dbo.Campus AS c ON c.CampusId = sa.CampusId
INNER JOIN dbo.FuenteAspirante AS f ON f.FuenteAspiranteId = a.FuenteAspiranteId
INNER JOIN dbo.Usuario AS u ON u.UsuarioId = a.UsuarioResponsableId
WHERE (@R3_Desde IS NULL OR sa.FechaSolicitud >= @R3_Desde)
  AND (@R3_Hasta IS NULL OR sa.FechaSolicitud <= @R3_Hasta)
  AND (@R3_Estado IS NULL OR sa.Estado = @R3_Estado)
  AND (@R3_ProgramaId IS NULL OR pr.ProgramaId = @R3_ProgramaId)
  AND (@R3_CampusId IS NULL OR c.CampusId = @R3_CampusId)
  AND (@R3_FuenteId IS NULL OR f.FuenteAspiranteId = @R3_FuenteId)
  AND (@R3_ResponsableId IS NULL OR u.UsuarioId = @R3_ResponsableId)
ORDER BY sa.FechaSolicitud DESC;
GO

/* REPORTE 4: Citas de aspirantes vinculados a campanias */
DECLARE @R4_Desde DATE = NULL, @R4_Hasta DATE = NULL;
DECLARE @R4_EstadoCita NVARCHAR(20) = NULL, @R4_UsuarioId INT = NULL;
DECLARE @R4_FuenteId INT = NULL, @R4_CampaniaId INT = NULL;
SELECT ci.CitaId, ci.FechaHora, ci.Motivo, ci.Estado AS EstadoCita,
       p.Nombres, p.Apellidos, u.NombreUsuario AS Responsable,
       f.Nombre AS Fuente, ca.Nombre AS Campania
FROM dbo.Cita AS ci
INNER JOIN dbo.Aspirante AS a ON a.AspiranteId = ci.AspiranteId
INNER JOIN dbo.Persona AS p ON p.PersonaId = a.PersonaId
INNER JOIN dbo.Usuario AS u ON u.UsuarioId = ci.UsuarioId
INNER JOIN dbo.FuenteAspirante AS f ON f.FuenteAspiranteId = a.FuenteAspiranteId
INNER JOIN dbo.AspiranteCampania AS ac ON ac.AspiranteId = a.AspiranteId
INNER JOIN dbo.Campania AS ca ON ca.CampaniaId = ac.CampaniaId
WHERE (@R4_Desde IS NULL OR ci.FechaHora >= @R4_Desde)
  AND (@R4_Hasta IS NULL OR ci.FechaHora < DATEADD(day, 1, @R4_Hasta))
  AND (@R4_EstadoCita IS NULL OR ci.Estado = @R4_EstadoCita)
  AND (@R4_UsuarioId IS NULL OR u.UsuarioId = @R4_UsuarioId)
  AND (@R4_FuenteId IS NULL OR f.FuenteAspiranteId = @R4_FuenteId)
  AND (@R4_CampaniaId IS NULL OR ca.CampaniaId = @R4_CampaniaId)
ORDER BY ci.FechaHora;
GO

/* REPORTE 5: Seguimientos pendientes y vencidos por responsable */
DECLARE @R5_Desde DATE = NULL, @R5_Hasta DATE = NULL;
DECLARE @R5_EstadoSeguimiento NVARCHAR(20) = NULL;
DECLARE @R5_UsuarioId INT = NULL, @R5_EstadoAspirante NVARCHAR(30) = NULL;
DECLARE @R5_CampaniaId INT = NULL;
SELECT s.SeguimientoId, s.FechaProgramada, s.FechaCompletada, s.Tarea,
       s.Estado AS EstadoSeguimiento, p.Nombres, p.Apellidos,
       u.NombreUsuario AS Responsable, ca.Nombre AS Campania
FROM dbo.Seguimiento AS s
INNER JOIN dbo.Aspirante AS a ON a.AspiranteId = s.AspiranteId
INNER JOIN dbo.Persona AS p ON p.PersonaId = a.PersonaId
INNER JOIN dbo.Usuario AS u ON u.UsuarioId = s.UsuarioId
INNER JOIN dbo.AspiranteCampania AS ac ON ac.AspiranteId = a.AspiranteId
INNER JOIN dbo.Campania AS ca ON ca.CampaniaId = ac.CampaniaId
WHERE (@R5_Desde IS NULL OR s.FechaProgramada >= @R5_Desde)
  AND (@R5_Hasta IS NULL OR s.FechaProgramada < DATEADD(day, 1, @R5_Hasta))
  AND (@R5_EstadoSeguimiento IS NULL OR s.Estado = @R5_EstadoSeguimiento)
  AND (@R5_UsuarioId IS NULL OR u.UsuarioId = @R5_UsuarioId)
  AND (@R5_EstadoAspirante IS NULL OR a.Estado = @R5_EstadoAspirante)
  AND (@R5_CampaniaId IS NULL OR ca.CampaniaId = @R5_CampaniaId)
ORDER BY s.FechaProgramada;
GO

/* REPORTE 6: Matriculas por campus, grado y ciclo escolar */
DECLARE @R6_Desde DATE = NULL, @R6_Hasta DATE = NULL;
DECLARE @R6_Estado NVARCHAR(20) = NULL, @R6_CampusId INT = NULL;
DECLARE @R6_GradoId INT = NULL, @R6_CicloId INT = NULL;
SELECT m.MatriculaId, m.FechaMatricula, m.Estado AS EstadoMatricula,
       e.CodigoEstudiante, p.Nombres, p.Apellidos, sec.Nombre AS Seccion,
       g.Nombre AS Grado, n.Nombre AS Nivel, c.Nombre AS Campus,
       ce.Nombre AS CicloEscolar
FROM dbo.Matricula AS m
INNER JOIN dbo.Estudiante AS e ON e.EstudianteId = m.EstudianteId
INNER JOIN dbo.Persona AS p ON p.PersonaId = e.PersonaId
INNER JOIN dbo.Seccion AS sec ON sec.SeccionId = m.SeccionId
INNER JOIN dbo.Grado AS g ON g.GradoId = sec.GradoId
INNER JOIN dbo.NivelEducativo AS n ON n.NivelEducativoId = g.NivelEducativoId
INNER JOIN dbo.Campus AS c ON c.CampusId = sec.CampusId
INNER JOIN dbo.CicloEscolar AS ce ON ce.CicloEscolarId = m.CicloEscolarId
WHERE (@R6_Desde IS NULL OR m.FechaMatricula >= @R6_Desde)
  AND (@R6_Hasta IS NULL OR m.FechaMatricula <= @R6_Hasta)
  AND (@R6_Estado IS NULL OR m.Estado = @R6_Estado)
  AND (@R6_CampusId IS NULL OR c.CampusId = @R6_CampusId)
  AND (@R6_GradoId IS NULL OR g.GradoId = @R6_GradoId)
  AND (@R6_CicloId IS NULL OR ce.CicloEscolarId = @R6_CicloId)
ORDER BY ce.Nombre, g.Nombre, sec.Nombre, p.Apellidos;
GO

/* REPORTE 7: Calificaciones por estudiante, curso y ciclo escolar */
DECLARE @R7_Desde DATE = NULL, @R7_Hasta DATE = NULL;
DECLARE @R7_CursoId INT = NULL, @R7_CicloId INT = NULL;
DECLARE @R7_PunteoMin DECIMAL(6,2) = NULL, @R7_PunteoMax DECIMAL(6,2) = NULL;
SELECT no.NotaId, ev.Nombre AS Evaluacion, ev.Fecha,
       no.Punteo, ev.PunteoMaximo, e.CodigoEstudiante,
       p.Nombres, p.Apellidos, cu.Nombre AS Curso, ce.Nombre AS CicloEscolar
FROM dbo.Nota AS no
INNER JOIN dbo.Evaluacion AS ev ON ev.EvaluacionId = no.EvaluacionId
INNER JOIN dbo.InscripcionCurso AS ic ON ic.InscripcionCursoId = ev.InscripcionCursoId
INNER JOIN dbo.Matricula AS m ON m.MatriculaId = ic.MatriculaId
INNER JOIN dbo.Estudiante AS e ON e.EstudianteId = no.EstudianteId
INNER JOIN dbo.Persona AS p ON p.PersonaId = e.PersonaId
INNER JOIN dbo.Curso AS cu ON cu.CursoId = ic.CursoId
INNER JOIN dbo.CicloEscolar AS ce ON ce.CicloEscolarId = m.CicloEscolarId
WHERE (@R7_Desde IS NULL OR ev.Fecha >= @R7_Desde)
  AND (@R7_Hasta IS NULL OR ev.Fecha <= @R7_Hasta)
  AND (@R7_CursoId IS NULL OR cu.CursoId = @R7_CursoId)
  AND (@R7_CicloId IS NULL OR ce.CicloEscolarId = @R7_CicloId)
  AND (@R7_PunteoMin IS NULL OR no.Punteo >= @R7_PunteoMin)
  AND (@R7_PunteoMax IS NULL OR no.Punteo <= @R7_PunteoMax)
ORDER BY ce.Nombre, cu.Nombre, p.Apellidos;
GO

/* REPORTE 8: Asistencia por curso, estudiante, campus y ciclo */
DECLARE @R8_Desde DATE = NULL, @R8_Hasta DATE = NULL;
DECLARE @R8_Estado NVARCHAR(15) = NULL, @R8_CursoId INT = NULL;
DECLARE @R8_CampusId INT = NULL, @R8_CicloId INT = NULL;
SELECT asi.AsistenciaId, asi.Fecha, asi.Estado AS EstadoAsistencia,
       e.CodigoEstudiante, p.Nombres, p.Apellidos,
       cu.Nombre AS Curso, sec.Nombre AS Seccion,
       ca.Nombre AS Campus, ce.Nombre AS CicloEscolar
FROM dbo.Asistencia AS asi
INNER JOIN dbo.InscripcionCurso AS ic ON ic.InscripcionCursoId = asi.InscripcionCursoId
INNER JOIN dbo.Matricula AS m ON m.MatriculaId = ic.MatriculaId
INNER JOIN dbo.Estudiante AS e ON e.EstudianteId = m.EstudianteId
INNER JOIN dbo.Persona AS p ON p.PersonaId = e.PersonaId
INNER JOIN dbo.Curso AS cu ON cu.CursoId = ic.CursoId
INNER JOIN dbo.Seccion AS sec ON sec.SeccionId = m.SeccionId
INNER JOIN dbo.Campus AS ca ON ca.CampusId = sec.CampusId
INNER JOIN dbo.CicloEscolar AS ce ON ce.CicloEscolarId = m.CicloEscolarId
WHERE (@R8_Desde IS NULL OR asi.Fecha >= @R8_Desde)
  AND (@R8_Hasta IS NULL OR asi.Fecha <= @R8_Hasta)
  AND (@R8_Estado IS NULL OR asi.Estado = @R8_Estado)
  AND (@R8_CursoId IS NULL OR cu.CursoId = @R8_CursoId)
  AND (@R8_CampusId IS NULL OR ca.CampusId = @R8_CampusId)
  AND (@R8_CicloId IS NULL OR ce.CicloEscolarId = @R8_CicloId)
ORDER BY asi.Fecha DESC, cu.Nombre, p.Apellidos;
GO
