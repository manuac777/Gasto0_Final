--
-- PostgreSQL database dump
--

-- Dumped from database version 16.0
-- Dumped by pg_dump version 16.0

-- Started on 2025-05-30 15:29:27

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
-- TOC entry 215 (class 1259 OID 16451)
-- Name: gastos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gastos (
    gasto_id integer NOT NULL,
    usuario_id character varying(40) NOT NULL,
    descripcion text,
    monto numeric(10,2) NOT NULL,
    categoria character varying(50) NOT NULL,
    fecha character varying(15) NOT NULL
);


ALTER TABLE public.gastos OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16456)
-- Name: gastos_gasto_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.gastos_gasto_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.gastos_gasto_id_seq OWNER TO postgres;

--
-- TOC entry 4849 (class 0 OID 0)
-- Dependencies: 216
-- Name: gastos_gasto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.gastos_gasto_id_seq OWNED BY public.gastos.gasto_id;


--
-- TOC entry 217 (class 1259 OID 16457)
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios (
    id character varying(40) NOT NULL,
    nombre character varying(40) NOT NULL,
    edad integer NOT NULL,
    correo character varying(40) NOT NULL,
    password character varying(65) NOT NULL
);


ALTER TABLE public.usuarios OWNER TO postgres;

--
-- TOC entry 4692 (class 2604 OID 16460)
-- Name: gastos gasto_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gastos ALTER COLUMN gasto_id SET DEFAULT nextval('public.gastos_gasto_id_seq'::regclass);


--
-- TOC entry 4841 (class 0 OID 16451)
-- Dependencies: 215
-- Data for Name: gastos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.gastos (gasto_id, usuario_id, descripcion, monto, categoria, fecha) FROM stdin;
1	3e2c251e-0a00-49a9-b0ec-faf796caf19e	Compra de libros	350.75	Educación	2025-05-21
2	807a60a1-5aa3-4763-bf8f-c4572e685903	Compra de mandado	500.00	Comida	2025-01-01
3	807a60a1-5aa3-4763-bf8f-c4572e685903	Compra de mandado	1500.00	Comida	2025-01-15
5	807a60a1-5aa3-4763-bf8f-c4572e685903	Viaje a san luis	500.00	comida	01/02/2025
6	807a60a1-5aa3-4763-bf8f-c4572e685903	Comida china	500.00	comida	02/02/2025
12	807a60a1-5aa3-4763-bf8f-c4572e685903	Alimeto gato	800.00	Mascotas	02/12/2025
13	807a60a1-5aa3-4763-bf8f-c4572e685903	Consulta medica	500.00	Salud	10/12/2025
14	807a60a1-5aa3-4763-bf8f-c4572e685903	Viaje	5000.00	Educacion	02/12/2025
\.


--
-- TOC entry 4843 (class 0 OID 16457)
-- Dependencies: 217
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuarios (id, nombre, edad, correo, password) FROM stdin;
51361a79-c824-40a0-a967-0da255a1937d	Juan	21	ja@gmail.com	$2b$10$OzneN63NV5gx9S9SKtfjWexjIMnoR8t9faES/yHiIiPHIqXEMR97y
3e2c251e-0a00-49a9-b0ec-faf796caf19e	Manuel	21	manuelacuna78398@gmail.com	$2b$10$d4n5bHqGn6Yc9ER6av0oh.2g7tlmrwtRBddPiArE3mFhYsf5aosL.
807a60a1-5aa3-4763-bf8f-c4572e685903	Emanuel	22	Emanuel@gmail.com	$2b$10$lX2LkyTZr1kuJvsjQrzqveK8Mc06hEhsQ06CDM08MONxaU3JxhBbq
\.


--
-- TOC entry 4850 (class 0 OID 0)
-- Dependencies: 216
-- Name: gastos_gasto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.gastos_gasto_id_seq', 14, true);


--
-- TOC entry 4694 (class 2606 OID 16462)
-- Name: gastos gastos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gastos
    ADD CONSTRAINT gastos_pkey PRIMARY KEY (gasto_id);


--
-- TOC entry 4696 (class 2606 OID 16464)
-- Name: usuarios usuarios_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pk PRIMARY KEY (id);


--
-- TOC entry 4697 (class 2606 OID 16465)
-- Name: gastos gastos_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gastos
    ADD CONSTRAINT gastos_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;


-- Completed on 2025-05-30 15:29:27

--
-- PostgreSQL database dump complete
--

