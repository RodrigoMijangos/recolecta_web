--
-- PostgreSQL database dump
--

\restrict zWgKMpnTds0nyjvBn5wewtU6VdqhnhY97guO6LGZcuzMsrbe5Mu3N2RYleinZVK

-- Dumped from database version 16.11
-- Dumped by pg_dump version 16.11

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alerta_mantenimiento; Type: TABLE; Schema: public; Owner: recolecta
--

CREATE TABLE public.alerta_mantenimiento (
    alerta_id integer NOT NULL,
    camion_id integer,
    tipo_mantenimiento_id integer,
    descripcion character varying(255),
    observaciones text,
    created_at timestamp without time zone,
    atendido boolean DEFAULT false
);


ALTER TABLE public.alerta_mantenimiento OWNER TO recolecta;

--
-- Name: alerta_mantenimiento_alerta_id_seq; Type: SEQUENCE; Schema: public; Owner: recolecta
--

CREATE SEQUENCE public.alerta_mantenimiento_alerta_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.alerta_mantenimiento_alerta_id_seq OWNER TO recolecta;

--
-- Name: alerta_mantenimiento_alerta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: recolecta
--

ALTER SEQUENCE public.alerta_mantenimiento_alerta_id_seq OWNED BY public.alerta_mantenimiento.alerta_id;


--
-- Name: alerta_usuario; Type: TABLE; Schema: public; Owner: recolecta
--

CREATE TABLE public.alerta_usuario (
    alerta_id integer NOT NULL,
    titulo character varying(50),
    mensaje text,
    created_at timestamp without time zone
);


ALTER TABLE public.alerta_usuario OWNER TO recolecta;

--
-- Name: alerta_usuario_alerta_id_seq; Type: SEQUENCE; Schema: public; Owner: recolecta
--

CREATE SEQUENCE public.alerta_usuario_alerta_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.alerta_usuario_alerta_id_seq OWNER TO recolecta;

--
-- Name: alerta_usuario_alerta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: recolecta
--

ALTER SEQUENCE public.alerta_usuario_alerta_id_seq OWNED BY public.alerta_usuario.alerta_id;


--
-- Name: anomalia; Type: TABLE; Schema: public; Owner: recolecta
--

CREATE TABLE public.anomalia (
    anomalia_id integer NOT NULL,
    punto_id integer,
    tipo_anomalia character varying(50),
    descripcion text,
    fecha_reporte timestamp without time zone,
    estado character varying(30),
    fecha_resolucion timestamp without time zone,
    id_chofer_id integer
);


ALTER TABLE public.anomalia OWNER TO recolecta;

--
-- Name: anomalia_anomalia_id_seq; Type: SEQUENCE; Schema: public; Owner: recolecta
--

CREATE SEQUENCE public.anomalia_anomalia_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.anomalia_anomalia_id_seq OWNER TO recolecta;

--
-- Name: anomalia_anomalia_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: recolecta
--

ALTER SEQUENCE public.anomalia_anomalia_id_seq OWNED BY public.anomalia.anomalia_id;


--
-- Name: aviso_general; Type: TABLE; Schema: public; Owner: recolecta
--

CREATE TABLE public.aviso_general (
    aviso_id integer NOT NULL,
    titulo character varying(50),
    mensaje text,
    activo boolean DEFAULT true,
    created_at timestamp without time zone
);


ALTER TABLE public.aviso_general OWNER TO recolecta;

--
-- Name: aviso_general_aviso_id_seq; Type: SEQUENCE; Schema: public; Owner: recolecta
--

CREATE SEQUENCE public.aviso_general_aviso_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.aviso_general_aviso_id_seq OWNER TO recolecta;

--
-- Name: aviso_general_aviso_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: recolecta
--

ALTER SEQUENCE public.aviso_general_aviso_id_seq OWNED BY public.aviso_general.aviso_id;


--
-- Name: camion; Type: TABLE; Schema: public; Owner: recolecta
--

CREATE TABLE public.camion (
    camion_id integer NOT NULL,
    placa character varying(20),
    modelo character varying(100),
    tipo_camion_id integer,
    es_rentado boolean DEFAULT false,
    eliminado boolean DEFAULT false,
    disponibilidad_id integer DEFAULT 1,
    nombre_disponibilidad character varying(50),
    color_disponibilidad character varying(20),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.camion OWNER TO recolecta;

--
-- Name: camion_camion_id_seq; Type: SEQUENCE; Schema: public; Owner: recolecta
--

CREATE SEQUENCE public.camion_camion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.camion_camion_id_seq OWNER TO recolecta;

--
-- Name: camion_camion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: recolecta
--

ALTER SEQUENCE public.camion_camion_id_seq OWNED BY public.camion.camion_id;


--
-- Name: colonia; Type: TABLE; Schema: public; Owner: recolecta
--

CREATE TABLE public.colonia (
    colonia_id integer NOT NULL,
    nombre character varying(255) NOT NULL,
    zona character varying(50),
    created_at timestamp without time zone
);


ALTER TABLE public.colonia OWNER TO recolecta;

--
-- Name: colonia_colonia_id_seq; Type: SEQUENCE; Schema: public; Owner: recolecta
--

CREATE SEQUENCE public.colonia_colonia_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.colonia_colonia_id_seq OWNER TO recolecta;

--
-- Name: colonia_colonia_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: recolecta
--

ALTER SEQUENCE public.colonia_colonia_id_seq OWNED BY public.colonia.colonia_id;


--
-- Name: domicilio; Type: TABLE; Schema: public; Owner: recolecta
--

CREATE TABLE public.domicilio (
    domicilio_id integer NOT NULL,
    usuario_id integer,
    alias character varying(100),
    direccion character varying(255),
    colonia_id integer,
    eliminado boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.domicilio OWNER TO recolecta;

--
-- Name: domicilio_domicilio_id_seq; Type: SEQUENCE; Schema: public; Owner: recolecta
--

CREATE SEQUENCE public.domicilio_domicilio_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.domicilio_domicilio_id_seq OWNER TO recolecta;

--
-- Name: domicilio_domicilio_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: recolecta
--

ALTER SEQUENCE public.domicilio_domicilio_id_seq OWNED BY public.domicilio.domicilio_id;


--
-- Name: estado_camion; Type: TABLE; Schema: public; Owner: recolecta
--

CREATE TABLE public.estado_camion (
    estado_id integer NOT NULL,
    camion_id integer,
    estado character varying(50),
    "timestamp" timestamp without time zone,
    observaciones text
);


ALTER TABLE public.estado_camion OWNER TO recolecta;

--
-- Name: estado_camion_estado_id_seq; Type: SEQUENCE; Schema: public; Owner: recolecta
--

CREATE SEQUENCE public.estado_camion_estado_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.estado_camion_estado_id_seq OWNER TO recolecta;

--
-- Name: estado_camion_estado_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: recolecta
--

ALTER SEQUENCE public.estado_camion_estado_id_seq OWNED BY public.estado_camion.estado_id;


--
-- Name: historial_asignacion_camion; Type: TABLE; Schema: public; Owner: recolecta
--

CREATE TABLE public.historial_asignacion_camion (
    id_historial integer NOT NULL,
    id_chofer integer,
    id_camion integer,
    fecha_asignacion timestamp without time zone,
    fecha_baja timestamp without time zone,
    eliminado boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.historial_asignacion_camion OWNER TO recolecta;

--
-- Name: historial_asignacion_camion_id_historial_seq; Type: SEQUENCE; Schema: public; Owner: recolecta
--

CREATE SEQUENCE public.historial_asignacion_camion_id_historial_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.historial_asignacion_camion_id_historial_seq OWNER TO recolecta;

--
-- Name: historial_asignacion_camion_id_historial_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: recolecta
--

ALTER SEQUENCE public.historial_asignacion_camion_id_historial_seq OWNED BY public.historial_asignacion_camion.id_historial;


--
-- Name: incidencia; Type: TABLE; Schema: public; Owner: recolecta
--

CREATE TABLE public.incidencia (
    incidencia_id integer NOT NULL,
    punto_recoleccion_id integer,
    conductor_id integer,
    descripcion character varying(255),
    json_ruta json,
    fecha_reporte timestamp without time zone,
    eliminado boolean DEFAULT false
);


ALTER TABLE public.incidencia OWNER TO recolecta;

--
-- Name: incidencia_incidencia_id_seq; Type: SEQUENCE; Schema: public; Owner: recolecta
--

CREATE SEQUENCE public.incidencia_incidencia_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.incidencia_incidencia_id_seq OWNER TO recolecta;

--
-- Name: incidencia_incidencia_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: recolecta
--

ALTER SEQUENCE public.incidencia_incidencia_id_seq OWNED BY public.incidencia.incidencia_id;


--
-- Name: notificacion; Type: TABLE; Schema: public; Owner: recolecta
--

CREATE TABLE public.notificacion (
    notificacion_id integer NOT NULL,
    usuario_id integer,
    tipo character varying(50),
    titulo character varying(100),
    mensaje text,
    activa boolean DEFAULT true,
    id_camion_relacionado integer,
    id_falla_relacionado integer,
    id_mantenimiento_relacionado integer,
    creado_por integer,
    created_at timestamp without time zone
);


ALTER TABLE public.notificacion OWNER TO recolecta;

--
-- Name: notificacion_notificacion_id_seq; Type: SEQUENCE; Schema: public; Owner: recolecta
--

CREATE SEQUENCE public.notificacion_notificacion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.notificacion_notificacion_id_seq OWNER TO recolecta;

--
-- Name: notificacion_notificacion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: recolecta
--

ALTER SEQUENCE public.notificacion_notificacion_id_seq OWNED BY public.notificacion.notificacion_id;


--
-- Name: punto_recoleccion; Type: TABLE; Schema: public; Owner: recolecta
--

CREATE TABLE public.punto_recoleccion (
    punto_id integer NOT NULL,
    ruta_id integer,
    cp character varying(20),
    eliminado boolean DEFAULT false
);


ALTER TABLE public.punto_recoleccion OWNER TO recolecta;

--
-- Name: punto_recoleccion_punto_id_seq; Type: SEQUENCE; Schema: public; Owner: recolecta
--

CREATE SEQUENCE public.punto_recoleccion_punto_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.punto_recoleccion_punto_id_seq OWNER TO recolecta;

--
-- Name: punto_recoleccion_punto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: recolecta
--

ALTER SEQUENCE public.punto_recoleccion_punto_id_seq OWNED BY public.punto_recoleccion.punto_id;


--
-- Name: registro_mantenimiento; Type: TABLE; Schema: public; Owner: recolecta
--

CREATE TABLE public.registro_mantenimiento (
    registro_id integer NOT NULL,
    alerta_id integer,
    camion_id integer,
    coordinador_id integer,
    mecanico_responsable character varying(255),
    fecha_realizada timestamp without time zone,
    kilometraje_mantenimiento double precision,
    observaciones text,
    created_at timestamp without time zone
);


ALTER TABLE public.registro_mantenimiento OWNER TO recolecta;

--
-- Name: registro_mantenimiento_registro_id_seq; Type: SEQUENCE; Schema: public; Owner: recolecta
--

CREATE SEQUENCE public.registro_mantenimiento_registro_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.registro_mantenimiento_registro_id_seq OWNER TO recolecta;

--
-- Name: registro_mantenimiento_registro_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: recolecta
--

ALTER SEQUENCE public.registro_mantenimiento_registro_id_seq OWNED BY public.registro_mantenimiento.registro_id;


--
-- Name: registro_vaciado; Type: TABLE; Schema: public; Owner: recolecta
--

CREATE TABLE public.registro_vaciado (
    vaciado_id integer NOT NULL,
    relleno_id integer,
    ruta_camion_id integer,
    hora timestamp without time zone
);


ALTER TABLE public.registro_vaciado OWNER TO recolecta;

--
-- Name: registro_vaciado_vaciado_id_seq; Type: SEQUENCE; Schema: public; Owner: recolecta
--

CREATE SEQUENCE public.registro_vaciado_vaciado_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.registro_vaciado_vaciado_id_seq OWNER TO recolecta;

--
-- Name: registro_vaciado_vaciado_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: recolecta
--

ALTER SEQUENCE public.registro_vaciado_vaciado_id_seq OWNED BY public.registro_vaciado.vaciado_id;


--
-- Name: relleno_sanitario; Type: TABLE; Schema: public; Owner: recolecta
--

CREATE TABLE public.relleno_sanitario (
    relleno_id integer NOT NULL,
    nombre character varying(255),
    direccion character varying(255),
    es_rentado boolean DEFAULT false,
    eliminado boolean DEFAULT false,
    capacidad_toneladas numeric(10,2)
);


ALTER TABLE public.relleno_sanitario OWNER TO recolecta;

--
-- Name: relleno_sanitario_relleno_id_seq; Type: SEQUENCE; Schema: public; Owner: recolecta
--

CREATE SEQUENCE public.relleno_sanitario_relleno_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.relleno_sanitario_relleno_id_seq OWNER TO recolecta;

--
-- Name: relleno_sanitario_relleno_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: recolecta
--

ALTER SEQUENCE public.relleno_sanitario_relleno_id_seq OWNED BY public.relleno_sanitario.relleno_id;


--
-- Name: reporte_conductor; Type: TABLE; Schema: public; Owner: recolecta
--

CREATE TABLE public.reporte_conductor (
    reporte_id integer NOT NULL,
    conductor_id integer,
    camion_id integer,
    ruta_id integer,
    descripcion character varying(255),
    created_at timestamp without time zone
);


ALTER TABLE public.reporte_conductor OWNER TO recolecta;

--
-- Name: reporte_conductor_reporte_id_seq; Type: SEQUENCE; Schema: public; Owner: recolecta
--

CREATE SEQUENCE public.reporte_conductor_reporte_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reporte_conductor_reporte_id_seq OWNER TO recolecta;

--
-- Name: reporte_conductor_reporte_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: recolecta
--

ALTER SEQUENCE public.reporte_conductor_reporte_id_seq OWNED BY public.reporte_conductor.reporte_id;


--
-- Name: reporte_falla_critica; Type: TABLE; Schema: public; Owner: recolecta
--

CREATE TABLE public.reporte_falla_critica (
    falla_id integer NOT NULL,
    camion_id integer,
    conductor_id integer,
    descripcion character varying(255),
    created_at timestamp without time zone,
    eliminado boolean DEFAULT false
);


ALTER TABLE public.reporte_falla_critica OWNER TO recolecta;

--
-- Name: reporte_falla_critica_falla_id_seq; Type: SEQUENCE; Schema: public; Owner: recolecta
--

CREATE SEQUENCE public.reporte_falla_critica_falla_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reporte_falla_critica_falla_id_seq OWNER TO recolecta;

--
-- Name: reporte_falla_critica_falla_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: recolecta
--

ALTER SEQUENCE public.reporte_falla_critica_falla_id_seq OWNED BY public.reporte_falla_critica.falla_id;


--
-- Name: reporte_mantenimiento_generado; Type: TABLE; Schema: public; Owner: recolecta
--

CREATE TABLE public.reporte_mantenimiento_generado (
    reporte_id integer NOT NULL,
    coordinador_id integer,
    fecha_desde timestamp without time zone,
    fecha_hasta timestamp without time zone,
    observaciones character varying(255),
    created_at timestamp without time zone
);


ALTER TABLE public.reporte_mantenimiento_generado OWNER TO recolecta;

--
-- Name: reporte_mantenimiento_generado_reporte_id_seq; Type: SEQUENCE; Schema: public; Owner: recolecta
--

CREATE SEQUENCE public.reporte_mantenimiento_generado_reporte_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reporte_mantenimiento_generado_reporte_id_seq OWNER TO recolecta;

--
-- Name: reporte_mantenimiento_generado_reporte_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: recolecta
--

ALTER SEQUENCE public.reporte_mantenimiento_generado_reporte_id_seq OWNED BY public.reporte_mantenimiento_generado.reporte_id;


--
-- Name: rol; Type: TABLE; Schema: public; Owner: recolecta
--

CREATE TABLE public.rol (
    role_id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    eliminado boolean DEFAULT false
);


ALTER TABLE public.rol OWNER TO recolecta;

--
-- Name: rol_role_id_seq; Type: SEQUENCE; Schema: public; Owner: recolecta
--

CREATE SEQUENCE public.rol_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.rol_role_id_seq OWNER TO recolecta;

--
-- Name: rol_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: recolecta
--

ALTER SEQUENCE public.rol_role_id_seq OWNED BY public.rol.role_id;


--
-- Name: ruta; Type: TABLE; Schema: public; Owner: recolecta
--

CREATE TABLE public.ruta (
    ruta_id integer NOT NULL,
    nombre character varying(255),
    descripcion character varying(255),
    json_ruta json,
    eliminado boolean DEFAULT false,
    created_at timestamp without time zone
);


ALTER TABLE public.ruta OWNER TO recolecta;

--
-- Name: ruta_camion; Type: TABLE; Schema: public; Owner: recolecta
--

CREATE TABLE public.ruta_camion (
    ruta_camion_id integer NOT NULL,
    ruta_id integer,
    camion_id integer,
    fecha date,
    created_at timestamp without time zone,
    eliminado boolean DEFAULT false
);


ALTER TABLE public.ruta_camion OWNER TO recolecta;

--
-- Name: ruta_camion_ruta_camion_id_seq; Type: SEQUENCE; Schema: public; Owner: recolecta
--

CREATE SEQUENCE public.ruta_camion_ruta_camion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ruta_camion_ruta_camion_id_seq OWNER TO recolecta;

--
-- Name: ruta_camion_ruta_camion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: recolecta
--

ALTER SEQUENCE public.ruta_camion_ruta_camion_id_seq OWNED BY public.ruta_camion.ruta_camion_id;


--
-- Name: ruta_ruta_id_seq; Type: SEQUENCE; Schema: public; Owner: recolecta
--

CREATE SEQUENCE public.ruta_ruta_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ruta_ruta_id_seq OWNER TO recolecta;

--
-- Name: ruta_ruta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: recolecta
--

ALTER SEQUENCE public.ruta_ruta_id_seq OWNED BY public.ruta.ruta_id;


--
-- Name: schema_version; Type: TABLE; Schema: public; Owner: recolecta
--

CREATE TABLE public.schema_version (
    version_id integer NOT NULL,
    version character varying(50) NOT NULL,
    description text,
    script_name character varying(255),
    applied_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    applied_by character varying(100) DEFAULT CURRENT_USER,
    checksum character varying(64)
);


ALTER TABLE public.schema_version OWNER TO recolecta;

--
-- Name: schema_version_version_id_seq; Type: SEQUENCE; Schema: public; Owner: recolecta
--

CREATE SEQUENCE public.schema_version_version_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.schema_version_version_id_seq OWNER TO recolecta;

--
-- Name: schema_version_version_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: recolecta
--

ALTER SEQUENCE public.schema_version_version_id_seq OWNED BY public.schema_version.version_id;


--
-- Name: seguimiento_falla_critica; Type: TABLE; Schema: public; Owner: recolecta
--

CREATE TABLE public.seguimiento_falla_critica (
    seguimiento_id integer NOT NULL,
    falla_id integer,
    comentario text,
    created_at timestamp without time zone
);


ALTER TABLE public.seguimiento_falla_critica OWNER TO recolecta;

--
-- Name: seguimiento_falla_critica_seguimiento_id_seq; Type: SEQUENCE; Schema: public; Owner: recolecta
--

CREATE SEQUENCE public.seguimiento_falla_critica_seguimiento_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seguimiento_falla_critica_seguimiento_id_seq OWNER TO recolecta;

--
-- Name: seguimiento_falla_critica_seguimiento_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: recolecta
--

ALTER SEQUENCE public.seguimiento_falla_critica_seguimiento_id_seq OWNED BY public.seguimiento_falla_critica.seguimiento_id;


--
-- Name: tipo_camion; Type: TABLE; Schema: public; Owner: recolecta
--

CREATE TABLE public.tipo_camion (
    tipo_camion_id integer NOT NULL,
    nombre character varying(100),
    descripcion character varying(255),
    created_at timestamp without time zone
);


ALTER TABLE public.tipo_camion OWNER TO recolecta;

--
-- Name: tipo_camion_tipo_camion_id_seq; Type: SEQUENCE; Schema: public; Owner: recolecta
--

CREATE SEQUENCE public.tipo_camion_tipo_camion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tipo_camion_tipo_camion_id_seq OWNER TO recolecta;

--
-- Name: tipo_camion_tipo_camion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: recolecta
--

ALTER SEQUENCE public.tipo_camion_tipo_camion_id_seq OWNED BY public.tipo_camion.tipo_camion_id;


--
-- Name: tipo_mantenimiento; Type: TABLE; Schema: public; Owner: recolecta
--

CREATE TABLE public.tipo_mantenimiento (
    tipo_mantenimiento_id integer NOT NULL,
    nombre character varying(100),
    categoria character varying(20),
    eliminado boolean DEFAULT false
);


ALTER TABLE public.tipo_mantenimiento OWNER TO recolecta;

--
-- Name: tipo_mantenimiento_tipo_mantenimiento_id_seq; Type: SEQUENCE; Schema: public; Owner: recolecta
--

CREATE SEQUENCE public.tipo_mantenimiento_tipo_mantenimiento_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tipo_mantenimiento_tipo_mantenimiento_id_seq OWNER TO recolecta;

--
-- Name: tipo_mantenimiento_tipo_mantenimiento_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: recolecta
--

ALTER SEQUENCE public.tipo_mantenimiento_tipo_mantenimiento_id_seq OWNED BY public.tipo_mantenimiento.tipo_mantenimiento_id;


--
-- Name: usuario; Type: TABLE; Schema: public; Owner: recolecta
--

CREATE TABLE public.usuario (
    user_id integer NOT NULL,
    nombre character varying(255) NOT NULL,
    alias character varying(100),
    telefono character varying(10),
    email character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    role_id integer,
    residencia_id integer,
    eliminado boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.usuario OWNER TO recolecta;

--
-- Name: usuario_user_id_seq; Type: SEQUENCE; Schema: public; Owner: recolecta
--

CREATE SEQUENCE public.usuario_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuario_user_id_seq OWNER TO recolecta;

--
-- Name: usuario_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: recolecta
--

ALTER SEQUENCE public.usuario_user_id_seq OWNED BY public.usuario.user_id;


--
-- Name: alerta_mantenimiento alerta_id; Type: DEFAULT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.alerta_mantenimiento ALTER COLUMN alerta_id SET DEFAULT nextval('public.alerta_mantenimiento_alerta_id_seq'::regclass);


--
-- Name: alerta_usuario alerta_id; Type: DEFAULT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.alerta_usuario ALTER COLUMN alerta_id SET DEFAULT nextval('public.alerta_usuario_alerta_id_seq'::regclass);


--
-- Name: anomalia anomalia_id; Type: DEFAULT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.anomalia ALTER COLUMN anomalia_id SET DEFAULT nextval('public.anomalia_anomalia_id_seq'::regclass);


--
-- Name: aviso_general aviso_id; Type: DEFAULT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.aviso_general ALTER COLUMN aviso_id SET DEFAULT nextval('public.aviso_general_aviso_id_seq'::regclass);


--
-- Name: camion camion_id; Type: DEFAULT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.camion ALTER COLUMN camion_id SET DEFAULT nextval('public.camion_camion_id_seq'::regclass);


--
-- Name: colonia colonia_id; Type: DEFAULT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.colonia ALTER COLUMN colonia_id SET DEFAULT nextval('public.colonia_colonia_id_seq'::regclass);


--
-- Name: domicilio domicilio_id; Type: DEFAULT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.domicilio ALTER COLUMN domicilio_id SET DEFAULT nextval('public.domicilio_domicilio_id_seq'::regclass);


--
-- Name: estado_camion estado_id; Type: DEFAULT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.estado_camion ALTER COLUMN estado_id SET DEFAULT nextval('public.estado_camion_estado_id_seq'::regclass);


--
-- Name: historial_asignacion_camion id_historial; Type: DEFAULT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.historial_asignacion_camion ALTER COLUMN id_historial SET DEFAULT nextval('public.historial_asignacion_camion_id_historial_seq'::regclass);


--
-- Name: incidencia incidencia_id; Type: DEFAULT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.incidencia ALTER COLUMN incidencia_id SET DEFAULT nextval('public.incidencia_incidencia_id_seq'::regclass);


--
-- Name: notificacion notificacion_id; Type: DEFAULT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.notificacion ALTER COLUMN notificacion_id SET DEFAULT nextval('public.notificacion_notificacion_id_seq'::regclass);


--
-- Name: punto_recoleccion punto_id; Type: DEFAULT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.punto_recoleccion ALTER COLUMN punto_id SET DEFAULT nextval('public.punto_recoleccion_punto_id_seq'::regclass);


--
-- Name: registro_mantenimiento registro_id; Type: DEFAULT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.registro_mantenimiento ALTER COLUMN registro_id SET DEFAULT nextval('public.registro_mantenimiento_registro_id_seq'::regclass);


--
-- Name: registro_vaciado vaciado_id; Type: DEFAULT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.registro_vaciado ALTER COLUMN vaciado_id SET DEFAULT nextval('public.registro_vaciado_vaciado_id_seq'::regclass);


--
-- Name: relleno_sanitario relleno_id; Type: DEFAULT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.relleno_sanitario ALTER COLUMN relleno_id SET DEFAULT nextval('public.relleno_sanitario_relleno_id_seq'::regclass);


--
-- Name: reporte_conductor reporte_id; Type: DEFAULT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.reporte_conductor ALTER COLUMN reporte_id SET DEFAULT nextval('public.reporte_conductor_reporte_id_seq'::regclass);


--
-- Name: reporte_falla_critica falla_id; Type: DEFAULT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.reporte_falla_critica ALTER COLUMN falla_id SET DEFAULT nextval('public.reporte_falla_critica_falla_id_seq'::regclass);


--
-- Name: reporte_mantenimiento_generado reporte_id; Type: DEFAULT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.reporte_mantenimiento_generado ALTER COLUMN reporte_id SET DEFAULT nextval('public.reporte_mantenimiento_generado_reporte_id_seq'::regclass);


--
-- Name: rol role_id; Type: DEFAULT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.rol ALTER COLUMN role_id SET DEFAULT nextval('public.rol_role_id_seq'::regclass);


--
-- Name: ruta ruta_id; Type: DEFAULT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.ruta ALTER COLUMN ruta_id SET DEFAULT nextval('public.ruta_ruta_id_seq'::regclass);


--
-- Name: ruta_camion ruta_camion_id; Type: DEFAULT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.ruta_camion ALTER COLUMN ruta_camion_id SET DEFAULT nextval('public.ruta_camion_ruta_camion_id_seq'::regclass);


--
-- Name: schema_version version_id; Type: DEFAULT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.schema_version ALTER COLUMN version_id SET DEFAULT nextval('public.schema_version_version_id_seq'::regclass);


--
-- Name: seguimiento_falla_critica seguimiento_id; Type: DEFAULT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.seguimiento_falla_critica ALTER COLUMN seguimiento_id SET DEFAULT nextval('public.seguimiento_falla_critica_seguimiento_id_seq'::regclass);


--
-- Name: tipo_camion tipo_camion_id; Type: DEFAULT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.tipo_camion ALTER COLUMN tipo_camion_id SET DEFAULT nextval('public.tipo_camion_tipo_camion_id_seq'::regclass);


--
-- Name: tipo_mantenimiento tipo_mantenimiento_id; Type: DEFAULT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.tipo_mantenimiento ALTER COLUMN tipo_mantenimiento_id SET DEFAULT nextval('public.tipo_mantenimiento_tipo_mantenimiento_id_seq'::regclass);


--
-- Name: usuario user_id; Type: DEFAULT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.usuario ALTER COLUMN user_id SET DEFAULT nextval('public.usuario_user_id_seq'::regclass);


--
-- Data for Name: alerta_mantenimiento; Type: TABLE DATA; Schema: public; Owner: recolecta
--

COPY public.alerta_mantenimiento (alerta_id, camion_id, tipo_mantenimiento_id, descripcion, observaciones, created_at, atendido) FROM stdin;
\.


--
-- Data for Name: alerta_usuario; Type: TABLE DATA; Schema: public; Owner: recolecta
--

COPY public.alerta_usuario (alerta_id, titulo, mensaje, created_at) FROM stdin;
\.


--
-- Data for Name: anomalia; Type: TABLE DATA; Schema: public; Owner: recolecta
--

COPY public.anomalia (anomalia_id, punto_id, tipo_anomalia, descripcion, fecha_reporte, estado, fecha_resolucion, id_chofer_id) FROM stdin;
\.


--
-- Data for Name: aviso_general; Type: TABLE DATA; Schema: public; Owner: recolecta
--

COPY public.aviso_general (aviso_id, titulo, mensaje, activo, created_at) FROM stdin;
\.


--
-- Data for Name: camion; Type: TABLE DATA; Schema: public; Owner: recolecta
--

COPY public.camion (camion_id, placa, modelo, tipo_camion_id, es_rentado, eliminado, disponibilidad_id, nombre_disponibilidad, color_disponibilidad, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: colonia; Type: TABLE DATA; Schema: public; Owner: recolecta
--

COPY public.colonia (colonia_id, nombre, zona, created_at) FROM stdin;
1	Centro	A	2026-01-27 17:16:14.754006
2	Norte	B	2026-01-27 17:16:14.754006
\.


--
-- Data for Name: domicilio; Type: TABLE DATA; Schema: public; Owner: recolecta
--

COPY public.domicilio (domicilio_id, usuario_id, alias, direccion, colonia_id, eliminado, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: estado_camion; Type: TABLE DATA; Schema: public; Owner: recolecta
--

COPY public.estado_camion (estado_id, camion_id, estado, "timestamp", observaciones) FROM stdin;
\.


--
-- Data for Name: historial_asignacion_camion; Type: TABLE DATA; Schema: public; Owner: recolecta
--

COPY public.historial_asignacion_camion (id_historial, id_chofer, id_camion, fecha_asignacion, fecha_baja, eliminado, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: incidencia; Type: TABLE DATA; Schema: public; Owner: recolecta
--

COPY public.incidencia (incidencia_id, punto_recoleccion_id, conductor_id, descripcion, json_ruta, fecha_reporte, eliminado) FROM stdin;
\.


--
-- Data for Name: notificacion; Type: TABLE DATA; Schema: public; Owner: recolecta
--

COPY public.notificacion (notificacion_id, usuario_id, tipo, titulo, mensaje, activa, id_camion_relacionado, id_falla_relacionado, id_mantenimiento_relacionado, creado_por, created_at) FROM stdin;
\.


--
-- Data for Name: punto_recoleccion; Type: TABLE DATA; Schema: public; Owner: recolecta
--

COPY public.punto_recoleccion (punto_id, ruta_id, cp, eliminado) FROM stdin;
\.


--
-- Data for Name: registro_mantenimiento; Type: TABLE DATA; Schema: public; Owner: recolecta
--

COPY public.registro_mantenimiento (registro_id, alerta_id, camion_id, coordinador_id, mecanico_responsable, fecha_realizada, kilometraje_mantenimiento, observaciones, created_at) FROM stdin;
\.


--
-- Data for Name: registro_vaciado; Type: TABLE DATA; Schema: public; Owner: recolecta
--

COPY public.registro_vaciado (vaciado_id, relleno_id, ruta_camion_id, hora) FROM stdin;
\.


--
-- Data for Name: relleno_sanitario; Type: TABLE DATA; Schema: public; Owner: recolecta
--

COPY public.relleno_sanitario (relleno_id, nombre, direccion, es_rentado, eliminado, capacidad_toneladas) FROM stdin;
\.


--
-- Data for Name: reporte_conductor; Type: TABLE DATA; Schema: public; Owner: recolecta
--

COPY public.reporte_conductor (reporte_id, conductor_id, camion_id, ruta_id, descripcion, created_at) FROM stdin;
\.


--
-- Data for Name: reporte_falla_critica; Type: TABLE DATA; Schema: public; Owner: recolecta
--

COPY public.reporte_falla_critica (falla_id, camion_id, conductor_id, descripcion, created_at, eliminado) FROM stdin;
\.


--
-- Data for Name: reporte_mantenimiento_generado; Type: TABLE DATA; Schema: public; Owner: recolecta
--

COPY public.reporte_mantenimiento_generado (reporte_id, coordinador_id, fecha_desde, fecha_hasta, observaciones, created_at) FROM stdin;
\.


--
-- Data for Name: rol; Type: TABLE DATA; Schema: public; Owner: recolecta
--

COPY public.rol (role_id, nombre, eliminado) FROM stdin;
1	admin	f
2	operador	f
3	conductor	f
\.


--
-- Data for Name: ruta; Type: TABLE DATA; Schema: public; Owner: recolecta
--

COPY public.ruta (ruta_id, nombre, descripcion, json_ruta, eliminado, created_at) FROM stdin;
\.


--
-- Data for Name: ruta_camion; Type: TABLE DATA; Schema: public; Owner: recolecta
--

COPY public.ruta_camion (ruta_camion_id, ruta_id, camion_id, fecha, created_at, eliminado) FROM stdin;
\.


--
-- Data for Name: schema_version; Type: TABLE DATA; Schema: public; Owner: recolecta
--

COPY public.schema_version (version_id, version, description, script_name, applied_at, applied_by, checksum) FROM stdin;
1	1.0.0	Schema inicial completo	db_script.sql	2026-01-27 17:16:14.667436	recolecta	\N
2	1.0.1	Seed data inicial	seed.sql	2026-01-27 17:16:14.772388	recolecta	\N
\.


--
-- Data for Name: seguimiento_falla_critica; Type: TABLE DATA; Schema: public; Owner: recolecta
--

COPY public.seguimiento_falla_critica (seguimiento_id, falla_id, comentario, created_at) FROM stdin;
\.


--
-- Data for Name: tipo_camion; Type: TABLE DATA; Schema: public; Owner: recolecta
--

COPY public.tipo_camion (tipo_camion_id, nombre, descripcion, created_at) FROM stdin;
\.


--
-- Data for Name: tipo_mantenimiento; Type: TABLE DATA; Schema: public; Owner: recolecta
--

COPY public.tipo_mantenimiento (tipo_mantenimiento_id, nombre, categoria, eliminado) FROM stdin;
\.


--
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: recolecta
--

COPY public.usuario (user_id, nombre, alias, telefono, email, password, role_id, residencia_id, eliminado, created_at, updated_at) FROM stdin;
1	Admin Demo	admin	0000000000	admin@example.com	$2a$10$hash-demo-sin-valor	1	\N	f	2026-01-27 17:16:14.754006	2026-01-27 17:16:14.754006
\.


--
-- Name: alerta_mantenimiento_alerta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: recolecta
--

SELECT pg_catalog.setval('public.alerta_mantenimiento_alerta_id_seq', 1, false);


--
-- Name: alerta_usuario_alerta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: recolecta
--

SELECT pg_catalog.setval('public.alerta_usuario_alerta_id_seq', 1, false);


--
-- Name: anomalia_anomalia_id_seq; Type: SEQUENCE SET; Schema: public; Owner: recolecta
--

SELECT pg_catalog.setval('public.anomalia_anomalia_id_seq', 1, false);


--
-- Name: aviso_general_aviso_id_seq; Type: SEQUENCE SET; Schema: public; Owner: recolecta
--

SELECT pg_catalog.setval('public.aviso_general_aviso_id_seq', 1, false);


--
-- Name: camion_camion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: recolecta
--

SELECT pg_catalog.setval('public.camion_camion_id_seq', 1, false);


--
-- Name: colonia_colonia_id_seq; Type: SEQUENCE SET; Schema: public; Owner: recolecta
--

SELECT pg_catalog.setval('public.colonia_colonia_id_seq', 1, false);


--
-- Name: domicilio_domicilio_id_seq; Type: SEQUENCE SET; Schema: public; Owner: recolecta
--

SELECT pg_catalog.setval('public.domicilio_domicilio_id_seq', 1, false);


--
-- Name: estado_camion_estado_id_seq; Type: SEQUENCE SET; Schema: public; Owner: recolecta
--

SELECT pg_catalog.setval('public.estado_camion_estado_id_seq', 1, false);


--
-- Name: historial_asignacion_camion_id_historial_seq; Type: SEQUENCE SET; Schema: public; Owner: recolecta
--

SELECT pg_catalog.setval('public.historial_asignacion_camion_id_historial_seq', 1, false);


--
-- Name: incidencia_incidencia_id_seq; Type: SEQUENCE SET; Schema: public; Owner: recolecta
--

SELECT pg_catalog.setval('public.incidencia_incidencia_id_seq', 1, false);


--
-- Name: notificacion_notificacion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: recolecta
--

SELECT pg_catalog.setval('public.notificacion_notificacion_id_seq', 1, false);


--
-- Name: punto_recoleccion_punto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: recolecta
--

SELECT pg_catalog.setval('public.punto_recoleccion_punto_id_seq', 1, false);


--
-- Name: registro_mantenimiento_registro_id_seq; Type: SEQUENCE SET; Schema: public; Owner: recolecta
--

SELECT pg_catalog.setval('public.registro_mantenimiento_registro_id_seq', 1, false);


--
-- Name: registro_vaciado_vaciado_id_seq; Type: SEQUENCE SET; Schema: public; Owner: recolecta
--

SELECT pg_catalog.setval('public.registro_vaciado_vaciado_id_seq', 1, false);


--
-- Name: relleno_sanitario_relleno_id_seq; Type: SEQUENCE SET; Schema: public; Owner: recolecta
--

SELECT pg_catalog.setval('public.relleno_sanitario_relleno_id_seq', 1, false);


--
-- Name: reporte_conductor_reporte_id_seq; Type: SEQUENCE SET; Schema: public; Owner: recolecta
--

SELECT pg_catalog.setval('public.reporte_conductor_reporte_id_seq', 1, false);


--
-- Name: reporte_falla_critica_falla_id_seq; Type: SEQUENCE SET; Schema: public; Owner: recolecta
--

SELECT pg_catalog.setval('public.reporte_falla_critica_falla_id_seq', 1, false);


--
-- Name: reporte_mantenimiento_generado_reporte_id_seq; Type: SEQUENCE SET; Schema: public; Owner: recolecta
--

SELECT pg_catalog.setval('public.reporte_mantenimiento_generado_reporte_id_seq', 1, false);


--
-- Name: rol_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: recolecta
--

SELECT pg_catalog.setval('public.rol_role_id_seq', 1, false);


--
-- Name: ruta_camion_ruta_camion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: recolecta
--

SELECT pg_catalog.setval('public.ruta_camion_ruta_camion_id_seq', 1, false);


--
-- Name: ruta_ruta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: recolecta
--

SELECT pg_catalog.setval('public.ruta_ruta_id_seq', 1, false);


--
-- Name: schema_version_version_id_seq; Type: SEQUENCE SET; Schema: public; Owner: recolecta
--

SELECT pg_catalog.setval('public.schema_version_version_id_seq', 2, true);


--
-- Name: seguimiento_falla_critica_seguimiento_id_seq; Type: SEQUENCE SET; Schema: public; Owner: recolecta
--

SELECT pg_catalog.setval('public.seguimiento_falla_critica_seguimiento_id_seq', 1, false);


--
-- Name: tipo_camion_tipo_camion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: recolecta
--

SELECT pg_catalog.setval('public.tipo_camion_tipo_camion_id_seq', 1, false);


--
-- Name: tipo_mantenimiento_tipo_mantenimiento_id_seq; Type: SEQUENCE SET; Schema: public; Owner: recolecta
--

SELECT pg_catalog.setval('public.tipo_mantenimiento_tipo_mantenimiento_id_seq', 1, false);


--
-- Name: usuario_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: recolecta
--

SELECT pg_catalog.setval('public.usuario_user_id_seq', 1, false);


--
-- Name: alerta_mantenimiento alerta_mantenimiento_pkey; Type: CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.alerta_mantenimiento
    ADD CONSTRAINT alerta_mantenimiento_pkey PRIMARY KEY (alerta_id);


--
-- Name: alerta_usuario alerta_usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.alerta_usuario
    ADD CONSTRAINT alerta_usuario_pkey PRIMARY KEY (alerta_id);


--
-- Name: anomalia anomalia_pkey; Type: CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.anomalia
    ADD CONSTRAINT anomalia_pkey PRIMARY KEY (anomalia_id);


--
-- Name: aviso_general aviso_general_pkey; Type: CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.aviso_general
    ADD CONSTRAINT aviso_general_pkey PRIMARY KEY (aviso_id);


--
-- Name: camion camion_pkey; Type: CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.camion
    ADD CONSTRAINT camion_pkey PRIMARY KEY (camion_id);


--
-- Name: camion camion_placa_key; Type: CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.camion
    ADD CONSTRAINT camion_placa_key UNIQUE (placa);


--
-- Name: colonia colonia_pkey; Type: CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.colonia
    ADD CONSTRAINT colonia_pkey PRIMARY KEY (colonia_id);


--
-- Name: domicilio domicilio_pkey; Type: CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.domicilio
    ADD CONSTRAINT domicilio_pkey PRIMARY KEY (domicilio_id);


--
-- Name: estado_camion estado_camion_pkey; Type: CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.estado_camion
    ADD CONSTRAINT estado_camion_pkey PRIMARY KEY (estado_id);


--
-- Name: historial_asignacion_camion historial_asignacion_camion_pkey; Type: CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.historial_asignacion_camion
    ADD CONSTRAINT historial_asignacion_camion_pkey PRIMARY KEY (id_historial);


--
-- Name: incidencia incidencia_pkey; Type: CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.incidencia
    ADD CONSTRAINT incidencia_pkey PRIMARY KEY (incidencia_id);


--
-- Name: notificacion notificacion_pkey; Type: CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.notificacion
    ADD CONSTRAINT notificacion_pkey PRIMARY KEY (notificacion_id);


--
-- Name: punto_recoleccion punto_recoleccion_cp_key; Type: CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.punto_recoleccion
    ADD CONSTRAINT punto_recoleccion_cp_key UNIQUE (cp);


--
-- Name: punto_recoleccion punto_recoleccion_pkey; Type: CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.punto_recoleccion
    ADD CONSTRAINT punto_recoleccion_pkey PRIMARY KEY (punto_id);


--
-- Name: registro_mantenimiento registro_mantenimiento_pkey; Type: CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.registro_mantenimiento
    ADD CONSTRAINT registro_mantenimiento_pkey PRIMARY KEY (registro_id);


--
-- Name: registro_vaciado registro_vaciado_pkey; Type: CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.registro_vaciado
    ADD CONSTRAINT registro_vaciado_pkey PRIMARY KEY (vaciado_id);


--
-- Name: relleno_sanitario relleno_sanitario_pkey; Type: CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.relleno_sanitario
    ADD CONSTRAINT relleno_sanitario_pkey PRIMARY KEY (relleno_id);


--
-- Name: reporte_conductor reporte_conductor_pkey; Type: CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.reporte_conductor
    ADD CONSTRAINT reporte_conductor_pkey PRIMARY KEY (reporte_id);


--
-- Name: reporte_falla_critica reporte_falla_critica_pkey; Type: CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.reporte_falla_critica
    ADD CONSTRAINT reporte_falla_critica_pkey PRIMARY KEY (falla_id);


--
-- Name: reporte_mantenimiento_generado reporte_mantenimiento_generado_pkey; Type: CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.reporte_mantenimiento_generado
    ADD CONSTRAINT reporte_mantenimiento_generado_pkey PRIMARY KEY (reporte_id);


--
-- Name: rol rol_pkey; Type: CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.rol
    ADD CONSTRAINT rol_pkey PRIMARY KEY (role_id);


--
-- Name: ruta_camion ruta_camion_pkey; Type: CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.ruta_camion
    ADD CONSTRAINT ruta_camion_pkey PRIMARY KEY (ruta_camion_id);


--
-- Name: ruta ruta_pkey; Type: CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.ruta
    ADD CONSTRAINT ruta_pkey PRIMARY KEY (ruta_id);


--
-- Name: schema_version schema_version_pkey; Type: CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.schema_version
    ADD CONSTRAINT schema_version_pkey PRIMARY KEY (version_id);


--
-- Name: schema_version schema_version_version_key; Type: CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.schema_version
    ADD CONSTRAINT schema_version_version_key UNIQUE (version);


--
-- Name: seguimiento_falla_critica seguimiento_falla_critica_pkey; Type: CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.seguimiento_falla_critica
    ADD CONSTRAINT seguimiento_falla_critica_pkey PRIMARY KEY (seguimiento_id);


--
-- Name: tipo_camion tipo_camion_pkey; Type: CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.tipo_camion
    ADD CONSTRAINT tipo_camion_pkey PRIMARY KEY (tipo_camion_id);


--
-- Name: tipo_mantenimiento tipo_mantenimiento_pkey; Type: CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.tipo_mantenimiento
    ADD CONSTRAINT tipo_mantenimiento_pkey PRIMARY KEY (tipo_mantenimiento_id);


--
-- Name: usuario usuario_email_key; Type: CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_email_key UNIQUE (email);


--
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (user_id);


--
-- Name: alerta_mantenimiento fk_alerta_camion; Type: FK CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.alerta_mantenimiento
    ADD CONSTRAINT fk_alerta_camion FOREIGN KEY (camion_id) REFERENCES public.camion(camion_id);


--
-- Name: alerta_mantenimiento fk_alerta_tipo; Type: FK CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.alerta_mantenimiento
    ADD CONSTRAINT fk_alerta_tipo FOREIGN KEY (tipo_mantenimiento_id) REFERENCES public.tipo_mantenimiento(tipo_mantenimiento_id);


--
-- Name: anomalia fk_anomalia_chofer; Type: FK CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.anomalia
    ADD CONSTRAINT fk_anomalia_chofer FOREIGN KEY (id_chofer_id) REFERENCES public.usuario(user_id);


--
-- Name: anomalia fk_anomalia_punto; Type: FK CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.anomalia
    ADD CONSTRAINT fk_anomalia_punto FOREIGN KEY (punto_id) REFERENCES public.punto_recoleccion(punto_id);


--
-- Name: camion fk_camion_tipo; Type: FK CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.camion
    ADD CONSTRAINT fk_camion_tipo FOREIGN KEY (tipo_camion_id) REFERENCES public.tipo_camion(tipo_camion_id);


--
-- Name: domicilio fk_domicilio_colonia; Type: FK CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.domicilio
    ADD CONSTRAINT fk_domicilio_colonia FOREIGN KEY (colonia_id) REFERENCES public.colonia(colonia_id);


--
-- Name: domicilio fk_domicilio_usuario; Type: FK CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.domicilio
    ADD CONSTRAINT fk_domicilio_usuario FOREIGN KEY (usuario_id) REFERENCES public.usuario(user_id);


--
-- Name: estado_camion fk_estado_camion; Type: FK CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.estado_camion
    ADD CONSTRAINT fk_estado_camion FOREIGN KEY (camion_id) REFERENCES public.camion(camion_id);


--
-- Name: reporte_falla_critica fk_falla_camion; Type: FK CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.reporte_falla_critica
    ADD CONSTRAINT fk_falla_camion FOREIGN KEY (camion_id) REFERENCES public.camion(camion_id);


--
-- Name: reporte_falla_critica fk_falla_conductor; Type: FK CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.reporte_falla_critica
    ADD CONSTRAINT fk_falla_conductor FOREIGN KEY (conductor_id) REFERENCES public.usuario(user_id);


--
-- Name: historial_asignacion_camion fk_historial_camion; Type: FK CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.historial_asignacion_camion
    ADD CONSTRAINT fk_historial_camion FOREIGN KEY (id_camion) REFERENCES public.camion(camion_id);


--
-- Name: historial_asignacion_camion fk_historial_chofer; Type: FK CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.historial_asignacion_camion
    ADD CONSTRAINT fk_historial_chofer FOREIGN KEY (id_chofer) REFERENCES public.usuario(user_id);


--
-- Name: incidencia fk_incidencia_conductor; Type: FK CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.incidencia
    ADD CONSTRAINT fk_incidencia_conductor FOREIGN KEY (conductor_id) REFERENCES public.usuario(user_id);


--
-- Name: incidencia fk_incidencia_punto; Type: FK CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.incidencia
    ADD CONSTRAINT fk_incidencia_punto FOREIGN KEY (punto_recoleccion_id) REFERENCES public.punto_recoleccion(punto_id);


--
-- Name: notificacion fk_notif_camion; Type: FK CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.notificacion
    ADD CONSTRAINT fk_notif_camion FOREIGN KEY (id_camion_relacionado) REFERENCES public.camion(camion_id);


--
-- Name: notificacion fk_notif_creador; Type: FK CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.notificacion
    ADD CONSTRAINT fk_notif_creador FOREIGN KEY (creado_por) REFERENCES public.usuario(user_id);


--
-- Name: notificacion fk_notif_falla; Type: FK CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.notificacion
    ADD CONSTRAINT fk_notif_falla FOREIGN KEY (id_falla_relacionado) REFERENCES public.reporte_falla_critica(falla_id);


--
-- Name: notificacion fk_notif_mantenimiento; Type: FK CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.notificacion
    ADD CONSTRAINT fk_notif_mantenimiento FOREIGN KEY (id_mantenimiento_relacionado) REFERENCES public.registro_mantenimiento(registro_id);


--
-- Name: notificacion fk_notif_usuario; Type: FK CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.notificacion
    ADD CONSTRAINT fk_notif_usuario FOREIGN KEY (usuario_id) REFERENCES public.usuario(user_id);


--
-- Name: punto_recoleccion fk_punto_ruta; Type: FK CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.punto_recoleccion
    ADD CONSTRAINT fk_punto_ruta FOREIGN KEY (ruta_id) REFERENCES public.ruta(ruta_id);


--
-- Name: registro_mantenimiento fk_registro_alerta; Type: FK CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.registro_mantenimiento
    ADD CONSTRAINT fk_registro_alerta FOREIGN KEY (alerta_id) REFERENCES public.alerta_mantenimiento(alerta_id);


--
-- Name: registro_mantenimiento fk_registro_camion; Type: FK CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.registro_mantenimiento
    ADD CONSTRAINT fk_registro_camion FOREIGN KEY (camion_id) REFERENCES public.camion(camion_id);


--
-- Name: registro_mantenimiento fk_registro_coordinador; Type: FK CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.registro_mantenimiento
    ADD CONSTRAINT fk_registro_coordinador FOREIGN KEY (coordinador_id) REFERENCES public.usuario(user_id);


--
-- Name: reporte_conductor fk_reporte_camion; Type: FK CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.reporte_conductor
    ADD CONSTRAINT fk_reporte_camion FOREIGN KEY (camion_id) REFERENCES public.camion(camion_id);


--
-- Name: reporte_conductor fk_reporte_conductor; Type: FK CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.reporte_conductor
    ADD CONSTRAINT fk_reporte_conductor FOREIGN KEY (conductor_id) REFERENCES public.usuario(user_id);


--
-- Name: reporte_mantenimiento_generado fk_reporte_mantenimiento_coordinador; Type: FK CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.reporte_mantenimiento_generado
    ADD CONSTRAINT fk_reporte_mantenimiento_coordinador FOREIGN KEY (coordinador_id) REFERENCES public.usuario(user_id);


--
-- Name: reporte_conductor fk_reporte_ruta; Type: FK CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.reporte_conductor
    ADD CONSTRAINT fk_reporte_ruta FOREIGN KEY (ruta_id) REFERENCES public.ruta(ruta_id);


--
-- Name: ruta_camion fk_ruta_camion_camion; Type: FK CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.ruta_camion
    ADD CONSTRAINT fk_ruta_camion_camion FOREIGN KEY (camion_id) REFERENCES public.camion(camion_id);


--
-- Name: ruta_camion fk_ruta_camion_ruta; Type: FK CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.ruta_camion
    ADD CONSTRAINT fk_ruta_camion_ruta FOREIGN KEY (ruta_id) REFERENCES public.ruta(ruta_id);


--
-- Name: seguimiento_falla_critica fk_seguimiento_falla; Type: FK CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.seguimiento_falla_critica
    ADD CONSTRAINT fk_seguimiento_falla FOREIGN KEY (falla_id) REFERENCES public.reporte_falla_critica(falla_id);


--
-- Name: usuario fk_usuario_domicilio; Type: FK CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT fk_usuario_domicilio FOREIGN KEY (residencia_id) REFERENCES public.domicilio(domicilio_id);


--
-- Name: usuario fk_usuario_rol; Type: FK CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT fk_usuario_rol FOREIGN KEY (role_id) REFERENCES public.rol(role_id);


--
-- Name: registro_vaciado fk_vaciado_relleno; Type: FK CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.registro_vaciado
    ADD CONSTRAINT fk_vaciado_relleno FOREIGN KEY (relleno_id) REFERENCES public.relleno_sanitario(relleno_id);


--
-- Name: registro_vaciado fk_vaciado_ruta_camion; Type: FK CONSTRAINT; Schema: public; Owner: recolecta
--

ALTER TABLE ONLY public.registro_vaciado
    ADD CONSTRAINT fk_vaciado_ruta_camion FOREIGN KEY (ruta_camion_id) REFERENCES public.ruta_camion(ruta_camion_id);


--
-- PostgreSQL database dump complete
--

\unrestrict zWgKMpnTds0nyjvBn5wewtU6VdqhnhY97guO6LGZcuzMsrbe5Mu3N2RYleinZVK

