-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 25-11-2024 a las 13:24:36
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `zaino`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `asisEst` ()   BEGIN 
SELECT Estudiante.Est_nombres AS NombreEstudiante, Asistencia.Ast_fecha AS FechaAsistencia, Asistencia.Ast_estado AS EstadoAsistencia 
FROM Estudiante 
INNER JOIN Asistencia 
ON 
Estudiante.Est_id = Asistencia.Estudiante_Est_id; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eliMatApo` (IN `materialTitulo` VARCHAR(45))   BEGIN
    DELETE FROM Materialapoyo
    WHERE Mat_titulo = materialTitulo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `estEstud` (IN `idEstudiante` INT, IN `nuevoEstado` VARCHAR(45))   BEGIN 
UPDATE Estudiante 
SET Est_estado = nuevoEstado 
WHERE Est_id = idEstudiante; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `estMatri` ()   BEGIN 
SELECT Estudiante.Est_nombres AS NombreEstudiante, Estudiante.Est_documento AS Documento, 
Matricula.Mat_fecha AS FechaMatricula, 
Matricula.Mat_valor AS ValorMatricula, Matricula.Mat_metodoPago AS MetodoPago 
FROM Estudiante 
INNER JOIN Matricula 
ON 
Estudiante.Matricula_Mat_id = Matricula.Mat_id; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `inserProf` (IN `documento` INT, IN `nombre` VARCHAR(45), IN `correo` VARCHAR(45), IN `estado` VARCHAR(45))   BEGIN 
INSERT INTO Profesores (Pro_documento, Pro_nombre, Pro_correo, Pro_estado) 
VALUES (nombre, documento, correo, estado); 
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `actividad`
--

CREATE TABLE `actividad` (
  `Act_id` int(11) NOT NULL,
  `Act_descripcion` varchar(45) DEFAULT NULL,
  `Act_fechaInicio` datetime DEFAULT NULL,
  `Act_fechaLimite` datetime DEFAULT NULL,
  `Act_estado` varchar(45) DEFAULT NULL,
  `Act_calificacion` varchar(45) DEFAULT NULL,
  `Estudiante_Est_id` int(11) DEFAULT NULL,
  `Materia_Mat_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `actividad`
--

INSERT INTO `actividad` (`Act_id`, `Act_descripcion`, `Act_fechaInicio`, `Act_fechaLimite`, `Act_estado`, `Act_calificacion`, `Estudiante_Est_id`, `Materia_Mat_id`) VALUES
(1, 'Examen de Álgebra', '2024-11-15 08:00:00', '2024-11-20 18:00:00', 'Finalizado', '90', 1, 1),
(2, 'Práctica de Biología', '2024-11-16 10:00:00', '2024-11-21 16:00:00', 'Finalizado', '85', 2, 2),
(3, 'Ensayo de Historia', '2024-11-17 09:00:00', '2024-11-22 17:00:00', 'Pendiente', NULL, 3, 3),
(4, 'Mapa físico', '2024-11-18 11:00:00', '2024-11-23 19:00:00', 'Pendiente', NULL, 4, 4),
(5, 'Examen de Gramática', '2024-11-19 14:00:00', '2024-11-24 20:00:00', 'Finalizado', '92', 5, 5),
(6, 'Dibujo artístico', '2024-11-20 15:00:00', '2024-11-25 21:00:00', 'Finalizado', '88', 6, 6),
(7, 'Competencia de atletismo', '2024-11-21 16:00:00', '2024-11-26 22:00:00', 'Pendiente', NULL, 7, 7);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `acudiente`
--

CREATE TABLE `acudiente` (
  `Acu_id` int(11) NOT NULL,
  `Acu_documento` int(11) DEFAULT NULL,
  `Acu_nombre` varchar(45) DEFAULT NULL,
  `Acu_estado` varchar(45) DEFAULT NULL,
  `Estudiante_Est_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `acudiente`
--

INSERT INTO `acudiente` (`Acu_id`, `Acu_documento`, `Acu_nombre`, `Acu_estado`, `Estudiante_Est_id`) VALUES
(1, 123456, 'Juan Pérez', 'Activo', 1),
(2, 654321, 'Ana Gómez', 'Activo', 2),
(3, 112233, 'Pedro López', 'Activo', 3),
(4, 223344, 'Carla Ruiz', 'Inactivo', 4),
(5, 334455, 'Luis Martínez', 'Activo', 5),
(6, 445566, 'Marta Jiménez', 'Activo', 6),
(7, 556677, 'Sofía Fernández', 'Inactivo', 7);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `acudiente_estudiante`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `acudiente_estudiante` (
`Documento Estudiante` int(11)
,`Documento Acudiente` int(11)
,`Nombre Acudiente` varchar(45)
,`Estado Acudiente` varchar(45)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `asistencia`
--

CREATE TABLE `asistencia` (
  `Ast_fecha` date NOT NULL,
  `Ast_estado` varchar(45) DEFAULT NULL,
  `Estudiante_Est_id` int(11) NOT NULL,
  `Curso_Cur_id` int(11) DEFAULT NULL,
  `Materia_Mat_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `asistencia`
--

INSERT INTO `asistencia` (`Ast_fecha`, `Ast_estado`, `Estudiante_Est_id`, `Curso_Cur_id`, `Materia_Mat_id`) VALUES
('2024-11-20', 'Presente', 1, 1, 1),
('2024-11-20', 'Ausente', 2, 2, 2),
('2024-11-21', 'Presente', 3, 3, 3),
('2024-11-21', 'Presente', 4, 4, 4),
('2024-11-22', 'Tarde', 5, 5, 5),
('2024-11-22', 'Presente', 6, 6, 6),
('2024-11-23', 'Ausente', 7, 7, 7);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `audi_estudiante`
--

CREATE TABLE `audi_estudiante` (
  `id_auditoria` int(11) NOT NULL,
  `Est_id` int(11) DEFAULT NULL,
  `Est_nombres_ant` varchar(45) DEFAULT NULL,
  `Est_correo_ant` varchar(45) DEFAULT NULL,
  `Est_estado_ant` varchar(45) DEFAULT NULL,
  `Est_documento_ant` int(11) DEFAULT NULL,
  `Est_direccion_ant` varchar(45) DEFAULT NULL,
  `Est_genero_ant` varchar(45) DEFAULT NULL,
  `Est_añoAcademico_ant` varchar(45) DEFAULT NULL,
  `Est_colegioanterior_ant` varchar(45) DEFAULT NULL,
  `Est_tipoJornada_ant` varchar(45) DEFAULT NULL,
  `Est_eps_ant` varchar(45) DEFAULT NULL,
  `Est_enfermedad_ant` varchar(200) DEFAULT NULL,
  `Est_nombres_nuevo` varchar(45) DEFAULT NULL,
  `Est_correo_nuevo` varchar(45) DEFAULT NULL,
  `Est_estado_nuevo` varchar(45) DEFAULT NULL,
  `Est_documento_nuevo` int(11) DEFAULT NULL,
  `Est_direccion_nuevo` varchar(45) DEFAULT NULL,
  `Est_genero_nuevo` varchar(45) DEFAULT NULL,
  `Est_añoAcademico_nuevo` varchar(45) DEFAULT NULL,
  `Est_colegioanterior_nuevo` varchar(45) DEFAULT NULL,
  `Est_tipoJornada_nuevo` varchar(45) DEFAULT NULL,
  `Est_eps_nuevo` varchar(45) DEFAULT NULL,
  `Est_enfermedad_nuevo` varchar(200) DEFAULT NULL,
  `audi_fechamodificacion` datetime DEFAULT NULL,
  `audi_usuario` varchar(45) DEFAULT NULL,
  `audi_accion` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `calificacion`
--

CREATE TABLE `calificacion` (
  `Calf_nota` decimal(10,2) DEFAULT NULL,
  `Cal_promedio` decimal(10,2) DEFAULT NULL,
  `Estudiante_Est_id` int(11) NOT NULL,
  `Actividad_Act_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `calificacion`
--

INSERT INTO `calificacion` (`Calf_nota`, `Cal_promedio`, `Estudiante_Est_id`, `Actividad_Act_id`) VALUES
(90.00, 85.00, 1, 1),
(85.00, 82.50, 2, 2),
(78.00, 80.00, 3, 3),
(NULL, NULL, 4, 4),
(92.00, 89.50, 5, 5),
(88.00, 87.00, 6, 6),
(NULL, NULL, 7, 7);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `curso`
--

CREATE TABLE `curso` (
  `Cur_id` int(11) NOT NULL,
  `Cur_nombre` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `curso`
--

INSERT INTO `curso` (`Cur_id`, `Cur_nombre`) VALUES
(1, 'Matemáticas'),
(2, 'Ciencias'),
(3, 'Historia'),
(4, 'Geografía'),
(5, 'Inglés'),
(6, 'Arte'),
(7, 'Educación Física');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `directivos`
--

CREATE TABLE `directivos` (
  `Dir_id` int(11) NOT NULL,
  `Dir_nombres` varchar(45) DEFAULT NULL,
  `Dir_correo` varchar(45) DEFAULT NULL,
  `Dir_telefono` varchar(45) DEFAULT NULL,
  `Dir_cargo` varchar(45) DEFAULT NULL,
  `Dir_estado` varchar(45) DEFAULT NULL,
  `Dir_documentos` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `directivos`
--

INSERT INTO `directivos` (`Dir_id`, `Dir_nombres`, `Dir_correo`, `Dir_telefono`, `Dir_cargo`, `Dir_estado`, `Dir_documentos`) VALUES
(1, 'Fernando Díaz', 'fernando@gmail.com', '123456789', 'Rector', 'Activo', 123),
(2, 'Mónica López', 'monica@gmail.com', '987654321', 'Coordinadora', 'Activo', 456),
(3, 'Luis Torres', 'luis@gmail.com', '567890123', 'Rector', 'Activo', 789),
(4, 'Ana Pérez', 'ana@gmail.com', '345678901', 'Coordinadora', 'Activo', 101),
(5, 'Carlos Ruiz', 'carlos@gmail.com', '901234567', 'Rector', 'Activo', 112),
(6, 'Laura Gómez', 'laura@gmail.com', '234567890', 'Coordinadora', 'Activo', 113),
(7, 'David Martínez', 'david@gmail.com', '890123456', 'Rector', 'Activo', 114);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estudiante`
--

CREATE TABLE `estudiante` (
  `Est_id` int(11) NOT NULL,
  `Est_nombres` varchar(45) DEFAULT NULL,
  `Est_correo` varchar(45) DEFAULT NULL,
  `Est_estado` varchar(45) DEFAULT NULL,
  `Est_documento` int(11) DEFAULT NULL,
  `Est_direccion` varchar(45) DEFAULT NULL,
  `Est_genero` varchar(45) DEFAULT NULL,
  `Est_añoAcademico` varchar(45) DEFAULT NULL,
  `Est_colegioanterior` varchar(45) DEFAULT NULL,
  `Est_tipoJornada` varchar(45) DEFAULT NULL,
  `Est_eps` varchar(45) DEFAULT NULL,
  `Est_enfermedad` varchar(200) DEFAULT NULL,
  `Curso_Cur_id` int(11) DEFAULT NULL,
  `Matricula_Mat_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `estudiante`
--

INSERT INTO `estudiante` (`Est_id`, `Est_nombres`, `Est_correo`, `Est_estado`, `Est_documento`, `Est_direccion`, `Est_genero`, `Est_añoAcademico`, `Est_colegioanterior`, `Est_tipoJornada`, `Est_eps`, `Est_enfermedad`, `Curso_Cur_id`, `Matricula_Mat_id`) VALUES
(1, 'Carlos Sánchez', 'carlos@gmail.com', 'Activo', 987654, 'Calle 1', 'M', '2023', 'Colegio A', 'Mañana', 'EPS1', 'Ninguna', 1, 1),
(2, 'María Torres', 'maria@gmail.com', 'Activo', 876543, 'Calle 2', 'F', '2023', 'Colegio B', 'Tarde', 'EPS2', 'Asma', 2, 2),
(3, 'Luis Rodríguez', 'luis@gmail.com', 'Activo', 765432, 'Calle 3', 'M', '2023', 'Colegio C', 'Noche', 'EPS3', 'Ninguna', 3, 3),
(4, 'Laura Ruiz', 'laura@gmail.com', 'Inactivo', 654321, 'Calle 4', 'F', '2023', 'Colegio D', 'Mañana', 'EPS4', 'Diabetes', 4, 4),
(5, 'David Gómez', 'david@gmail.com', 'Activo', 543210, 'Calle 5', 'M', '2023', 'Colegio E', 'Tarde', 'EPS5', 'Ninguna', 5, 5),
(6, 'Lucía Ramírez', 'lucia@gmail.com', 'Activo', 432109, 'Calle 6', 'F', '2023', 'Colegio F', 'Noche', 'EPS6', 'Ninguna', 6, 6),
(7, 'Andrés Martínez', 'andres@gmail.com', 'Activo', 321098, 'Calle 7', 'M', '2023', 'Colegio G', 'Mañana', 'EPS7', 'Ninguna', 7, 7);

--
-- Disparadores `estudiante`
--
DELIMITER $$
CREATE TRIGGER `after_insert_estudiante` AFTER INSERT ON `estudiante` FOR EACH ROW BEGIN
    INSERT INTO audi_estudiante (
        Est_id,
        Est_nombres_nuevo, Est_correo_nuevo, Est_estado_nuevo, Est_documento_nuevo,
        Est_direccion_nuevo, Est_genero_nuevo, Est_añoAcademico_nuevo, Est_colegioanterior_nuevo,
        Est_tipoJornada_nuevo, Est_eps_nuevo, Est_enfermedad_nuevo,
        audi_fechamodificacion, audi_usuario, audi_accion
    )
    VALUES (
        NEW.Est_id,
        NEW.Est_nombres, NEW.Est_correo, NEW.Est_estado, NEW.Est_documento,
        NEW.Est_direccion, NEW.Est_genero, NEW.Est_añoAcademico, NEW.Est_colegioanterior,
        NEW.Est_tipoJornada, NEW.Est_eps, NEW.Est_enfermedad,
        NOW(), USER(), 'inserción'
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_update_estudiante` AFTER UPDATE ON `estudiante` FOR EACH ROW BEGIN
    INSERT INTO audi_estudiante (
        Est_id,
        Est_nombres_ant, Est_correo_ant, Est_estado_ant, Est_documento_ant, Est_direccion_ant,
        Est_genero_ant, Est_añoAcademico_ant, Est_colegioanterior_ant, Est_tipoJornada_ant,
        Est_eps_ant, Est_enfermedad_ant,
        Est_nombres_nuevo, Est_correo_nuevo, Est_estado_nuevo, Est_documento_nuevo,
        Est_direccion_nuevo, Est_genero_nuevo, Est_añoAcademico_nuevo, Est_colegioanterior_nuevo,
        Est_tipoJornada_nuevo, Est_eps_nuevo, Est_enfermedad_nuevo,
        audi_fechamodificacion, audi_usuario, audi_accion
    )
    VALUES (
        OLD.Est_id,
        OLD.Est_nombres, OLD.Est_correo, OLD.Est_estado, OLD.Est_documento, OLD.Est_direccion,
        OLD.Est_genero, OLD.Est_añoAcademico, OLD.Est_colegioanterior, OLD.Est_tipoJornada,
        OLD.Est_eps, OLD.Est_enfermedad,
        NEW.Est_nombres, NEW.Est_correo, NEW.Est_estado, NEW.Est_documento,
        NEW.Est_direccion, NEW.Est_genero, NEW.Est_añoAcademico, NEW.Est_colegioanterior,
        NEW.Est_tipoJornada, NEW.Est_eps, NEW.Est_enfermedad,
        NOW(), CURRENT_USER(), 'actualización'
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estudiante_curso`
--

CREATE TABLE `estudiante_curso` (
  `Estudiante_Est_id` int(11) NOT NULL,
  `Curso_Cur_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `estudiante_curso`
--

INSERT INTO `estudiante_curso` (`Estudiante_Est_id`, `Curso_Cur_id`) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `materia`
--

CREATE TABLE `materia` (
  `Mat_id` int(11) NOT NULL,
  `Mat_nombre` varchar(45) DEFAULT NULL,
  `Curso_Cur_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `materia`
--

INSERT INTO `materia` (`Mat_id`, `Mat_nombre`, `Curso_Cur_id`) VALUES
(1, 'Álgebra', 1),
(2, 'Biología', 2),
(3, 'Historia', 3),
(4, 'Geografía', 4),
(5, 'Quimica', 5),
(6, 'Artes', 6),
(7, 'Ed.Fisica', 7);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `materialapoyo`
--

CREATE TABLE `materialapoyo` (
  `Mat_id` int(11) NOT NULL,
  `Mat_descripcion` varchar(45) DEFAULT NULL,
  `Mat_titulo` varchar(45) DEFAULT NULL,
  `Profesores_Pro_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `materialapoyo`
--

INSERT INTO `materialapoyo` (`Mat_id`, `Mat_descripcion`, `Mat_titulo`, `Profesores_Pro_id`) VALUES
(1, 'Guía de Álgebra básica', 'Guía de Álgebra', 1),
(2, 'Presentación sobre células', 'Células y su función', 2),
(3, 'Documentos históricos', 'Historia Universal', 3),
(4, 'Mapas interactivos', 'Mapas Físicos', 4),
(5, 'Química Orgánica', 'Química', 5),
(6, 'Técnicas de pintura', 'Guía de Dibujo', 6),
(7, 'Plan de entrenamiento', 'Atletismo y técnica', 7);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `materia_profesor`
--

CREATE TABLE `materia_profesor` (
  `Materia_Mat_id` int(11) NOT NULL,
  `Profesores_Pro_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `materia_profesor`
--

INSERT INTO `materia_profesor` (`Materia_Mat_id`, `Profesores_Pro_id`) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `matricula`
--

CREATE TABLE `matricula` (
  `Mat_id` int(11) NOT NULL,
  `Mat_fecha` date DEFAULT NULL,
  `Mat_valor` varchar(45) DEFAULT NULL,
  `Mat_estado` varchar(45) DEFAULT NULL,
  `Mat_metodoPago` varchar(45) DEFAULT NULL,
  `Mat_fechaPago` date DEFAULT NULL,
  `Mat_comprobante` varchar(200) DEFAULT NULL,
  `Directivos_Dir_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `matricula`
--

INSERT INTO `matricula` (`Mat_id`, `Mat_fecha`, `Mat_valor`, `Mat_estado`, `Mat_metodoPago`, `Mat_fechaPago`, `Mat_comprobante`, `Directivos_Dir_id`) VALUES
(1, '2024-01-01', '580000', 'Pagado', 'Efectivo', '2024-01-05', 'Comprobante1', 1),
(2, '2024-01-02', '580000', 'Pendiente', 'Tarjeta', '2024-01-05', 'SinComprobante', 2),
(3, '2024-01-03', '580000', 'Pagado', 'Transferencia', '2024-01-06', 'Comprobante2', 3),
(4, '2024-01-04', '580000', 'Pendiente', 'Efectivo', '0204-01-04', 'Comprobante3', 4),
(5, '2024-01-05', '580000', 'Pagado', 'Tarjeta', '2024-01-10', 'Comprobante3', 5),
(6, '2024-01-06', '580000', 'Pagado', 'Transferencia', '2024-01-11', 'Comprobante4', 6),
(7, '2024-01-07', '580000', 'Pendiente', 'Efectivo', '2024-01-11', 'Comprobante5', 7);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `profesores`
--

CREATE TABLE `profesores` (
  `Pro_id` int(11) NOT NULL,
  `Pro_documento` int(11) DEFAULT NULL,
  `Pro_nombre` varchar(45) DEFAULT NULL,
  `Pro_correo` varchar(45) DEFAULT NULL,
  `Pro_estado` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `profesores`
--

INSERT INTO `profesores` (`Pro_id`, `Pro_documento`, `Pro_nombre`, `Pro_correo`, `Pro_estado`) VALUES
(1, 101234, 'Luis García', 'luis.garcia@zaino.com', 'Activo'),
(2, 102345, 'María López', 'maria.lopez@zaino.com', 'Activo'),
(3, 103456, 'Carlos Ruiz', 'carlos.ruiz@zaino.com', 'Activo'),
(4, 104567, 'Ana Torres', 'ana.torres@zaino.com', 'Activo'),
(5, 105678, 'Fernando Díaz', 'fernando.diaz@zaino.com', 'Activo'),
(6, 106789, 'Marta Gómez', 'marta.gomez@zaino.com', 'Activo'),
(7, 107890, 'Andrés Ramírez', 'andres.ramirez@zaino.com', 'Activo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipousuario`
--

CREATE TABLE `tipousuario` (
  `Tus_id` int(11) NOT NULL,
  `Tus_tipoUsuario` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tipousuario`
--

INSERT INTO `tipousuario` (`Tus_id`, `Tus_tipoUsuario`) VALUES
(1, 'Admin'),
(2, 'Profesor'),
(3, 'Estudiante'),
(4, 'Acudiente'),
(5, 'Directivo'),
(6, 'Secretaría'),
(7, 'Invitado');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `Us_id` int(11) NOT NULL,
  `Us_usuario` varchar(45) DEFAULT NULL,
  `Us_contraseña` varchar(45) DEFAULT NULL,
  `TipoUsuario_Tus_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`Us_id`, `Us_usuario`, `Us_contraseña`, `TipoUsuario_Tus_id`) VALUES
(1, 'admin1', '12345', 1),
(2, 'profesor1', '23456', 2),
(3, 'estudiante1', '34567', 3),
(4, 'acudiente1', '45678', 4),
(5, 'directivo1', '56789', 5),
(6, 'secretaria1', '67890', 6),
(7, 'invitado1', '78901', 7);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_calificaciones`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_calificaciones` (
`Nombre Estudiante` varchar(45)
,`Nombre Profesor` varchar(45)
,`Calificación Estudiante` decimal(10,2)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `acudiente_estudiante`
--
DROP TABLE IF EXISTS `acudiente_estudiante`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `acudiente_estudiante`  AS SELECT `e`.`Est_documento` AS `Documento Estudiante`, `a`.`Acu_documento` AS `Documento Acudiente`, `a`.`Acu_nombre` AS `Nombre Acudiente`, `a`.`Acu_estado` AS `Estado Acudiente` FROM (`acudiente` `a` join `estudiante` `e` on(`e`.`Est_id` = `a`.`Estudiante_Est_id`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_calificaciones`
--
DROP TABLE IF EXISTS `vista_calificaciones`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_calificaciones`  AS SELECT `e`.`Est_nombres` AS `Nombre Estudiante`, `p`.`Pro_nombre` AS `Nombre Profesor`, `c`.`Calf_nota` AS `Calificación Estudiante` FROM ((`calificacion` `c` join `estudiante` `e` on(`c`.`Estudiante_Est_id` = `e`.`Est_id`)) join `profesores` `p` on(`c`.`Estudiante_Est_id` = `p`.`Pro_id`)) ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `actividad`
--
ALTER TABLE `actividad`
  ADD PRIMARY KEY (`Act_id`),
  ADD KEY `Estudiante_Est_id` (`Estudiante_Est_id`),
  ADD KEY `Materia_Mat_id` (`Materia_Mat_id`);

--
-- Indices de la tabla `acudiente`
--
ALTER TABLE `acudiente`
  ADD PRIMARY KEY (`Acu_id`),
  ADD KEY `Estudiante_Est_id` (`Estudiante_Est_id`),
  ADD KEY `idx_acudiente_nombre` (`Acu_nombre`);

--
-- Indices de la tabla `asistencia`
--
ALTER TABLE `asistencia`
  ADD PRIMARY KEY (`Ast_fecha`,`Estudiante_Est_id`,`Materia_Mat_id`),
  ADD KEY `Estudiante_Est_id` (`Estudiante_Est_id`),
  ADD KEY `Curso_Cur_id` (`Curso_Cur_id`),
  ADD KEY `Materia_Mat_id` (`Materia_Mat_id`);

--
-- Indices de la tabla `audi_estudiante`
--
ALTER TABLE `audi_estudiante`
  ADD PRIMARY KEY (`id_auditoria`);

--
-- Indices de la tabla `calificacion`
--
ALTER TABLE `calificacion`
  ADD PRIMARY KEY (`Estudiante_Est_id`,`Actividad_Act_id`),
  ADD KEY `Actividad_Act_id` (`Actividad_Act_id`);

--
-- Indices de la tabla `curso`
--
ALTER TABLE `curso`
  ADD PRIMARY KEY (`Cur_id`);

--
-- Indices de la tabla `directivos`
--
ALTER TABLE `directivos`
  ADD PRIMARY KEY (`Dir_id`);

--
-- Indices de la tabla `estudiante`
--
ALTER TABLE `estudiante`
  ADD PRIMARY KEY (`Est_id`),
  ADD KEY `Curso_Cur_id` (`Curso_Cur_id`),
  ADD KEY `Matricula_Mat_id` (`Matricula_Mat_id`),
  ADD KEY `idx_estudiante_documento` (`Est_documento`);

--
-- Indices de la tabla `estudiante_curso`
--
ALTER TABLE `estudiante_curso`
  ADD PRIMARY KEY (`Estudiante_Est_id`,`Curso_Cur_id`),
  ADD KEY `Curso_Cur_id` (`Curso_Cur_id`);

--
-- Indices de la tabla `materia`
--
ALTER TABLE `materia`
  ADD PRIMARY KEY (`Mat_id`),
  ADD KEY `Curso_Cur_id` (`Curso_Cur_id`);

--
-- Indices de la tabla `materialapoyo`
--
ALTER TABLE `materialapoyo`
  ADD PRIMARY KEY (`Mat_id`),
  ADD KEY `Profesores_Pro_id` (`Profesores_Pro_id`);

--
-- Indices de la tabla `materia_profesor`
--
ALTER TABLE `materia_profesor`
  ADD PRIMARY KEY (`Materia_Mat_id`,`Profesores_Pro_id`),
  ADD KEY `Profesores_Pro_id` (`Profesores_Pro_id`);

--
-- Indices de la tabla `matricula`
--
ALTER TABLE `matricula`
  ADD PRIMARY KEY (`Mat_id`),
  ADD KEY `Directivos_Dir_id` (`Directivos_Dir_id`);

--
-- Indices de la tabla `profesores`
--
ALTER TABLE `profesores`
  ADD PRIMARY KEY (`Pro_id`);

--
-- Indices de la tabla `tipousuario`
--
ALTER TABLE `tipousuario`
  ADD PRIMARY KEY (`Tus_id`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`Us_id`),
  ADD KEY `TipoUsuario_Tus_id` (`TipoUsuario_Tus_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `actividad`
--
ALTER TABLE `actividad`
  MODIFY `Act_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `acudiente`
--
ALTER TABLE `acudiente`
  MODIFY `Acu_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `audi_estudiante`
--
ALTER TABLE `audi_estudiante`
  MODIFY `id_auditoria` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `curso`
--
ALTER TABLE `curso`
  MODIFY `Cur_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `directivos`
--
ALTER TABLE `directivos`
  MODIFY `Dir_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `estudiante`
--
ALTER TABLE `estudiante`
  MODIFY `Est_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `materia`
--
ALTER TABLE `materia`
  MODIFY `Mat_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `materialapoyo`
--
ALTER TABLE `materialapoyo`
  MODIFY `Mat_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `matricula`
--
ALTER TABLE `matricula`
  MODIFY `Mat_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `profesores`
--
ALTER TABLE `profesores`
  MODIFY `Pro_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `tipousuario`
--
ALTER TABLE `tipousuario`
  MODIFY `Tus_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `Us_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `actividad`
--
ALTER TABLE `actividad`
  ADD CONSTRAINT `actividad_ibfk_1` FOREIGN KEY (`Estudiante_Est_id`) REFERENCES `estudiante` (`Est_id`),
  ADD CONSTRAINT `actividad_ibfk_2` FOREIGN KEY (`Materia_Mat_id`) REFERENCES `materia` (`Mat_id`);

--
-- Filtros para la tabla `acudiente`
--
ALTER TABLE `acudiente`
  ADD CONSTRAINT `acudiente_ibfk_1` FOREIGN KEY (`Estudiante_Est_id`) REFERENCES `estudiante` (`Est_id`);

--
-- Filtros para la tabla `asistencia`
--
ALTER TABLE `asistencia`
  ADD CONSTRAINT `asistencia_ibfk_1` FOREIGN KEY (`Estudiante_Est_id`) REFERENCES `estudiante` (`Est_id`),
  ADD CONSTRAINT `asistencia_ibfk_2` FOREIGN KEY (`Curso_Cur_id`) REFERENCES `curso` (`Cur_id`),
  ADD CONSTRAINT `asistencia_ibfk_3` FOREIGN KEY (`Materia_Mat_id`) REFERENCES `materia` (`Mat_id`);

--
-- Filtros para la tabla `calificacion`
--
ALTER TABLE `calificacion`
  ADD CONSTRAINT `calificacion_ibfk_1` FOREIGN KEY (`Estudiante_Est_id`) REFERENCES `estudiante` (`Est_id`),
  ADD CONSTRAINT `calificacion_ibfk_2` FOREIGN KEY (`Actividad_Act_id`) REFERENCES `actividad` (`Act_id`);

--
-- Filtros para la tabla `estudiante`
--
ALTER TABLE `estudiante`
  ADD CONSTRAINT `estudiante_ibfk_1` FOREIGN KEY (`Curso_Cur_id`) REFERENCES `curso` (`Cur_id`),
  ADD CONSTRAINT `estudiante_ibfk_2` FOREIGN KEY (`Matricula_Mat_id`) REFERENCES `matricula` (`Mat_id`);

--
-- Filtros para la tabla `estudiante_curso`
--
ALTER TABLE `estudiante_curso`
  ADD CONSTRAINT `estudiante_curso_ibfk_1` FOREIGN KEY (`Estudiante_Est_id`) REFERENCES `estudiante` (`Est_id`),
  ADD CONSTRAINT `estudiante_curso_ibfk_2` FOREIGN KEY (`Curso_Cur_id`) REFERENCES `curso` (`Cur_id`);

--
-- Filtros para la tabla `materia`
--
ALTER TABLE `materia`
  ADD CONSTRAINT `materia_ibfk_1` FOREIGN KEY (`Curso_Cur_id`) REFERENCES `curso` (`Cur_id`);

--
-- Filtros para la tabla `materialapoyo`
--
ALTER TABLE `materialapoyo`
  ADD CONSTRAINT `materialapoyo_ibfk_1` FOREIGN KEY (`Profesores_Pro_id`) REFERENCES `profesores` (`Pro_id`);

--
-- Filtros para la tabla `materia_profesor`
--
ALTER TABLE `materia_profesor`
  ADD CONSTRAINT `materia_profesor_ibfk_1` FOREIGN KEY (`Materia_Mat_id`) REFERENCES `materia` (`Mat_id`),
  ADD CONSTRAINT `materia_profesor_ibfk_2` FOREIGN KEY (`Profesores_Pro_id`) REFERENCES `profesores` (`Pro_id`);

--
-- Filtros para la tabla `matricula`
--
ALTER TABLE `matricula`
  ADD CONSTRAINT `matricula_ibfk_1` FOREIGN KEY (`Directivos_Dir_id`) REFERENCES `directivos` (`Dir_id`);

--
-- Filtros para la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `usuario_ibfk_1` FOREIGN KEY (`TipoUsuario_Tus_id`) REFERENCES `tipousuario` (`Tus_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
