-- Table: public.customer_info
-- DROP TABLE IF EXISTS public.customer_info;
CREATE TABLE IF NOT EXISTS public.customer_info (
    id integer NOT NULL DEFAULT 'nextval(' customer_info_id_seq '::regclass)',
    customer_no integer NOT NULL,
    customer_name character(1) COLLATE pg_catalog."default",
    customer_email character(1) COLLATE pg_catalog."default",
    is_active boolean,
    CONSTRAINT customer_info_pkey PRIMARY KEY (id, customer_no)
) TABLESPACE pg_default;

ALTER TABLE
    IF EXISTS public.customer_info OWNER to postgres;