--
-- PostgreSQL database dump
--

\restrict W05E86sOKJTjigycWLQzJZKISGRgSgcbQ9JdFpyQOb8n01p3gz6VbzKn3gdHDO8

-- Dumped from database version 16.11 (Ubuntu 16.11-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.11 (Ubuntu 16.11-0ubuntu0.24.04.1)

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

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: appointmentstatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.appointmentstatus AS ENUM (
    'pending',
    'confirmed',
    'cancelled',
    'completed'
);


ALTER TYPE public.appointmentstatus OWNER TO postgres;

--
-- Name: timeofftype; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.timeofftype AS ENUM (
    'vacation',
    'sick_leave',
    'break_time'
);


ALTER TYPE public.timeofftype OWNER TO postgres;

--
-- Name: userrole; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.userrole AS ENUM (
    'owner',
    'manager',
    'staff',
    'customer'
);


ALTER TYPE public.userrole OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: appointments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.appointments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    org_id uuid,
    customer_id uuid,
    staff_id uuid,
    service_id uuid,
    start_at timestamp without time zone NOT NULL,
    end_at timestamp without time zone NOT NULL,
    status public.appointmentstatus
);


ALTER TABLE public.appointments OWNER TO postgres;

--
-- Name: organizations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organizations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(255) NOT NULL,
    slug character varying(50) NOT NULL,
    timezone character varying(50) DEFAULT 'Europe/Moscow'::character varying,
    working_hours_start time without time zone,
    working_hours_end time without time zone,
    logo_url text,
    notifications_enabled boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.organizations OWNER TO postgres;

--
-- Name: services; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.services (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    org_id uuid NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    base_price numeric(10,2) NOT NULL,
    duration_minutes integer DEFAULT 60,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.services OWNER TO postgres;

--
-- Name: staff_services; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.staff_services (
    staff_id uuid NOT NULL,
    service_id uuid NOT NULL,
    price numeric(10,2),
    duration_minutes integer
);


ALTER TABLE public.staff_services OWNER TO postgres;

--
-- Name: time_off; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.time_off (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    staff_id uuid,
    start_at timestamp without time zone,
    end_at timestamp without time zone,
    type public.timeofftype
);


ALTER TABLE public.time_off OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    org_id uuid NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    role character varying(20) DEFAULT 'staff'::character varying,
    full_name character varying(255) NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: working_hours; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.working_hours (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    staff_id uuid,
    day_of_week integer,
    start_time time without time zone,
    end_time time without time zone
);


ALTER TABLE public.working_hours OWNER TO postgres;

--
-- Data for Name: appointments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.appointments (id, org_id, customer_id, staff_id, service_id, start_at, end_at, status) FROM stdin;
9756bbea-7f0f-431e-9faf-b140163b62d2	526bea64-ecb3-4031-afd3-8207661c6ce6	2d5acffd-f9cd-4ade-8313-752c9903934e	3ce496e8-2106-4c59-8a69-000684a20a8c	be5a41ff-e903-4c22-ae62-d43336a039c9	2026-02-24 19:17:07.335386	2026-02-24 20:17:07.335386	confirmed
\.


--
-- Data for Name: organizations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organizations (id, name, slug, timezone, working_hours_start, working_hours_end, logo_url, notifications_enabled, created_at) FROM stdin;
8ce35410-107e-43c8-9207-0e0bdea463a2	Барбершоп	barber-1	Europe/Moscow	09:00:00	18:00:00	string	t	2026-02-23 20:37:38.25251
\.


--
-- Data for Name: services; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.services (id, org_id, title, description, base_price, duration_minutes, is_active, created_at) FROM stdin;
76b04f05-4f5d-4836-bb68-618019a47d61	8ce35410-107e-43c8-9207-0e0bdea463a2	Стрижка бороды		1500.00	45	t	2026-02-23 19:45:29.852299
e6506291-deb3-4dd6-a222-e7da12c1f266	8ce35410-107e-43c8-9207-0e0bdea463a2	Стрижка бороды		1500.00	45	t	2026-02-23 19:45:31.21827
\.


--
-- Data for Name: staff_services; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.staff_services (staff_id, service_id, price, duration_minutes) FROM stdin;
3ce496e8-2106-4c59-8a69-000684a20a8c	be5a41ff-e903-4c22-ae62-d43336a039c9	1500.00	60
3ce496e8-2106-4c59-8a69-000684a20a8c	8b2d7cf6-577b-4922-919c-788ff48d9a2b	900.00	30
\.


--
-- Data for Name: time_off; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.time_off (id, staff_id, start_at, end_at, type) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, org_id, email, password_hash, role, full_name, is_active, created_at) FROM stdin;
715092b2-d067-459c-8318-344e83d2b8c0	8ce35410-107e-43c8-9207-0e0bdea463a2	test@test.com	$2b$12$zPXdyrVWblppYn75FAuXbuweXiJ7jpx5Nu1gBcA7rHDHDHPwL4RwC	owner	Иван Иванов	t	2026-02-23 17:43:32.911493
07b708af-032e-4d99-a8e4-0f86b255fc04	8ce35410-107e-43c8-9207-0e0bdea463a2	kosov@mail.ru	$2b$12$nNN72EF7jnoABA2hdN2HyeHqeW6WgwfwdiOK.6XoaEHY0QpTJd7x2	staff	Максим Косов	t	2026-02-23 19:16:50.586808
dd911b90-8516-424b-aa5a-da07dbb6c7b6	8ce35410-107e-43c8-9207-0e0bdea463a2	kosov@kosov.com	$2b$12$6vfQV5yp4xPMrYTtYneF.e2GjR1C8Tz/kWDtfmHnYwxhBS3ujkehe	staff	Максим Максимов	t	2026-02-23 19:17:48.893328
\.


--
-- Data for Name: working_hours; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.working_hours (id, staff_id, day_of_week, start_time, end_time) FROM stdin;
3df5e340-e4dc-497d-a326-52803c54d219	3ce496e8-2106-4c59-8a69-000684a20a8c	1	09:00:00	18:00:00
0e727c36-d42f-4806-9750-4060ae88c330	3ce496e8-2106-4c59-8a69-000684a20a8c	2	09:00:00	18:00:00
\.


--
-- Name: appointments appointments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_pkey PRIMARY KEY (id);


--
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: organizations organizations_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_slug_key UNIQUE (slug);


--
-- Name: services services_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);


--
-- Name: staff_services staff_services_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_services
    ADD CONSTRAINT staff_services_pkey PRIMARY KEY (staff_id, service_id);


--
-- Name: time_off time_off_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.time_off
    ADD CONSTRAINT time_off_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: working_hours working_hours_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.working_hours
    ADD CONSTRAINT working_hours_pkey PRIMARY KEY (id);


--
-- Name: idx_appointments_end_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_appointments_end_at ON public.appointments USING btree (end_at);


--
-- Name: idx_appointments_start_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_appointments_start_at ON public.appointments USING btree (start_at);


--
-- Name: idx_services_org; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_services_org ON public.services USING btree (org_id);


--
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_email ON public.users USING btree (email);


--
-- Name: idx_users_org; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_org ON public.users USING btree (org_id);


--
-- Name: services services_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: users users_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict W05E86sOKJTjigycWLQzJZKISGRgSgcbQ9JdFpyQOb8n01p3gz6VbzKn3gdHDO8

