--
-- PostgreSQL database dump
--

-- Dumped from database version 12.4 (Debian 12.4-1.pgdg100+1)
-- Dumped by pg_dump version 12.2

-- Started on 2020-08-29 16:45:07 CEST

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
-- TOC entry 216 (class 1255 OID 16617)
-- Name: notify_update_markets(); Type: FUNCTION; Schema: public; Owner: flux
--

CREATE FUNCTION public.notify_update_markets() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        PERFORM pg_notify('update_markets', row_to_json(NEW)::text);
        RETURN NULL;
    END; 
$$;


ALTER FUNCTION public.notify_update_markets() OWNER TO flux;

--
-- TOC entry 215 (class 1255 OID 16615)
-- Name: notify_update_orders(); Type: FUNCTION; Schema: public; Owner: flux
--

CREATE FUNCTION public.notify_update_orders() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        PERFORM pg_notify('update_orders', row_to_json(NEW)::text);
        RETURN NULL;
    END; 
$$;


ALTER FUNCTION public.notify_update_orders() OWNER TO flux;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 202 (class 1259 OID 16385)
-- Name: account_share_balances; Type: TABLE; Schema: public; Owner: flux
--

CREATE TABLE public.account_share_balances (
    market_id bigint NOT NULL,
    account_id text NOT NULL,
    outcome bigint NOT NULL,
    balance numeric,
    spent numeric,
    to_spend numeric
);


ALTER TABLE public.account_share_balances OWNER TO flux;

--
-- TOC entry 203 (class 1259 OID 16391)
-- Name: account_stake_in_outcomes; Type: TABLE; Schema: public; Owner: flux
--

CREATE TABLE public.account_stake_in_outcomes (
    account_id text NOT NULL,
    market_id bigint NOT NULL,
    outcome bigint NOT NULL,
    stake numeric NOT NULL,
    round bigint NOT NULL
);


ALTER TABLE public.account_stake_in_outcomes OWNER TO flux;

--
-- TOC entry 204 (class 1259 OID 16397)
-- Name: accounts; Type: TABLE; Schema: public; Owner: flux
--

CREATE TABLE public.accounts (
    id text NOT NULL,
    affiliate_earnings numeric
);


ALTER TABLE public.accounts OWNER TO flux;

--
-- TOC entry 205 (class 1259 OID 16403)
-- Name: claimable_if_valids; Type: TABLE; Schema: public; Owner: flux
--

CREATE TABLE public.claimable_if_valids (
    account_id character varying(100) NOT NULL,
    market_id bigint NOT NULL,
    claimable numeric NOT NULL
);


ALTER TABLE public.claimable_if_valids OWNER TO flux;

--
-- TOC entry 206 (class 1259 OID 16409)
-- Name: claimed_markets; Type: TABLE; Schema: public; Owner: flux
--

CREATE TABLE public.claimed_markets (
    market_id bigint NOT NULL,
    account_id text NOT NULL
);


ALTER TABLE public.claimed_markets OWNER TO flux;

--
-- TOC entry 207 (class 1259 OID 16415)
-- Name: fills; Type: TABLE; Schema: public; Owner: flux
--

CREATE TABLE public.fills (
    order_id numeric NOT NULL,
    market_id bigint NOT NULL,
    outcome bigint NOT NULL,
    amount numeric NOT NULL,
    fill_time timestamp with time zone NOT NULL,
    owner character varying NOT NULL,
    price bigint NOT NULL,
    block_height numeric NOT NULL
);


ALTER TABLE public.fills OWNER TO flux;

--
-- TOC entry 208 (class 1259 OID 16421)
-- Name: fills_id_seq; Type: SEQUENCE; Schema: public; Owner: flux
--

CREATE SEQUENCE public.fills_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fills_id_seq OWNER TO flux;

--
-- TOC entry 3010 (class 0 OID 0)
-- Dependencies: 208
-- Name: fills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: flux
--

ALTER SEQUENCE public.fills_id_seq OWNED BY public.fills.block_height;


--
-- TOC entry 209 (class 1259 OID 16423)
-- Name: markets; Type: TABLE; Schema: public; Owner: flux
--

CREATE TABLE public.markets (
    id bigint NOT NULL,
    description text NOT NULL,
    extra_info text,
    creator text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    end_date_time timestamp with time zone NOT NULL,
    outcomes smallint NOT NULL,
    outcome_tags text[] NOT NULL,
    categories text[],
    winning_outcome smallint,
    resoluted boolean NOT NULL,
    resolute_bond numeric NOT NULL,
    filled_volume numeric NOT NULL,
    disputed boolean NOT NULL,
    finalized boolean NOT NULL,
    creator_fee_percentage smallint NOT NULL,
    resolution_fee_percentage smallint NOT NULL,
    affiliate_fee_percentage smallint NOT NULL,
    api_source text,
    validity_bond_claimed boolean NOT NULL
);


ALTER TABLE public.markets OWNER TO flux;

--
-- TOC entry 210 (class 1259 OID 16429)
-- Name: orderbooks; Type: TABLE; Schema: public; Owner: flux
--

CREATE TABLE public.orderbooks (
    market_id bigint NOT NULL,
    outcome bigint NOT NULL
);


ALTER TABLE public.orderbooks OWNER TO flux;

--
-- TOC entry 211 (class 1259 OID 16432)
-- Name: orders; Type: TABLE; Schema: public; Owner: flux
--

CREATE TABLE public.orders (
    id numeric NOT NULL,
    creator character varying NOT NULL,
    outcome bigint NOT NULL,
    market_id bigint NOT NULL,
    spend numeric NOT NULL,
    shares numeric NOT NULL,
    price numeric NOT NULL,
    filled numeric NOT NULL,
    shares_filled numeric NOT NULL,
    affiliate_account_id text,
    creation_time timestamp with time zone NOT NULL,
    closed boolean NOT NULL
);


ALTER TABLE public.orders OWNER TO flux;

--
-- TOC entry 212 (class 1259 OID 16438)
-- Name: processed_blocks; Type: TABLE; Schema: public; Owner: flux
--

CREATE TABLE public.processed_blocks (
    height numeric NOT NULL,
    "timestamp" numeric NOT NULL,
    hash character varying(200) NOT NULL
);


ALTER TABLE public.processed_blocks OWNER TO flux;

--
-- TOC entry 213 (class 1259 OID 16444)
-- Name: protocol; Type: TABLE; Schema: public; Owner: flux
--

CREATE TABLE public.protocol (
    owner character varying(100) NOT NULL,
    creation_bond numeric NOT NULL,
    max_fee numeric NOT NULL
);


ALTER TABLE public.protocol OWNER TO flux;

--
-- TOC entry 214 (class 1259 OID 16450)
-- Name: resolution_windows; Type: TABLE; Schema: public; Owner: flux
--

CREATE TABLE public.resolution_windows (
    market_id bigint NOT NULL,
    round bigint NOT NULL,
    bond_size numeric NOT NULL,
    end_time timestamp with time zone NOT NULL,
    outcome bigint
);


ALTER TABLE public.resolution_windows OWNER TO flux;

--
-- TOC entry 2834 (class 2604 OID 16456)
-- Name: fills block_height; Type: DEFAULT; Schema: public; Owner: flux
--

ALTER TABLE ONLY public.fills ALTER COLUMN block_height SET DEFAULT nextval('public.fills_id_seq'::regclass);


--
-- TOC entry 2992 (class 0 OID 16385)
-- Dependencies: 202
-- Data for Name: account_share_balances; Type: TABLE DATA; Schema: public; Owner: flux
--

COPY public.account_share_balances (market_id, account_id, outcome, balance, spent, to_spend) FROM stdin;
\.


--
-- TOC entry 2993 (class 0 OID 16391)
-- Dependencies: 203
-- Data for Name: account_stake_in_outcomes; Type: TABLE DATA; Schema: public; Owner: flux
--

COPY public.account_stake_in_outcomes (account_id, market_id, outcome, stake, round) FROM stdin;
\.


--
-- TOC entry 2994 (class 0 OID 16397)
-- Dependencies: 204
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: flux
--

COPY public.accounts (id, affiliate_earnings) FROM stdin;
test.near	0
\.


--
-- TOC entry 2995 (class 0 OID 16403)
-- Dependencies: 205
-- Data for Name: claimable_if_valids; Type: TABLE DATA; Schema: public; Owner: flux
--

COPY public.claimable_if_valids (account_id, market_id, claimable) FROM stdin;
\.


--
-- TOC entry 2996 (class 0 OID 16409)
-- Dependencies: 206
-- Data for Name: claimed_markets; Type: TABLE DATA; Schema: public; Owner: flux
--

COPY public.claimed_markets (market_id, account_id) FROM stdin;
\.


--
-- TOC entry 2997 (class 0 OID 16415)
-- Dependencies: 207
-- Data for Name: fills; Type: TABLE DATA; Schema: public; Owner: flux
--

COPY public.fills (order_id, market_id, outcome, amount, fill_time, owner, price, block_height) FROM stdin;
\.


--
-- TOC entry 2999 (class 0 OID 16423)
-- Dependencies: 209
-- Data for Name: markets; Type: TABLE DATA; Schema: public; Owner: flux
--

COPY public.markets (id, description, extra_info, creator, creation_date, end_date_time, outcomes, outcome_tags, categories, winning_outcome, resoluted, resolute_bond, filled_volume, disputed, finalized, creator_fee_percentage, resolution_fee_percentage, affiliate_fee_percentage, api_source, validity_bond_claimed) FROM stdin;
\.


--
-- TOC entry 3000 (class 0 OID 16429)
-- Dependencies: 210
-- Data for Name: orderbooks; Type: TABLE DATA; Schema: public; Owner: flux
--

COPY public.orderbooks (market_id, outcome) FROM stdin;
\.


--
-- TOC entry 3001 (class 0 OID 16432)
-- Dependencies: 211
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: flux
--

COPY public.orders (id, creator, outcome, market_id, spend, shares, price, filled, shares_filled, affiliate_account_id, creation_time, closed) FROM stdin;
\.


--
-- TOC entry 3002 (class 0 OID 16438)
-- Dependencies: 212
-- Data for Name: processed_blocks; Type: TABLE DATA; Schema: public; Owner: flux
--

COPY public.processed_blocks (height, "timestamp", hash) FROM stdin;
\.


--
-- TOC entry 3003 (class 0 OID 16444)
-- Dependencies: 213
-- Data for Name: protocol; Type: TABLE DATA; Schema: public; Owner: flux
--

COPY public.protocol (owner, creation_bond, max_fee) FROM stdin;
flux-dev	250000000000000000	5000000000000000000
\.


--
-- TOC entry 3004 (class 0 OID 16450)
-- Dependencies: 214
-- Data for Name: resolution_windows; Type: TABLE DATA; Schema: public; Owner: flux
--

COPY public.resolution_windows (market_id, round, bond_size, end_time, outcome) FROM stdin;
\.


--
-- TOC entry 3011 (class 0 OID 0)
-- Dependencies: 208
-- Name: fills_id_seq; Type: SEQUENCE SET; Schema: public; Owner: flux
--

SELECT pg_catalog.setval('public.fills_id_seq', 38688, true);


--
-- TOC entry 2836 (class 2606 OID 16458)
-- Name: account_share_balances account_share_balances_pkey; Type: CONSTRAINT; Schema: public; Owner: flux
--

ALTER TABLE ONLY public.account_share_balances
    ADD CONSTRAINT account_share_balances_pkey PRIMARY KEY (market_id, account_id, outcome);


--
-- TOC entry 2838 (class 2606 OID 16460)
-- Name: account_stake_in_outcomes account_stake_in_outcome_pkey; Type: CONSTRAINT; Schema: public; Owner: flux
--

ALTER TABLE ONLY public.account_stake_in_outcomes
    ADD CONSTRAINT account_stake_in_outcome_pkey PRIMARY KEY (account_id, market_id, outcome, round);


--
-- TOC entry 2842 (class 2606 OID 16462)
-- Name: claimable_if_valids claimable_if_valid_pkey; Type: CONSTRAINT; Schema: public; Owner: flux
--

ALTER TABLE ONLY public.claimable_if_valids
    ADD CONSTRAINT claimable_if_valid_pkey PRIMARY KEY (market_id, account_id);


--
-- TOC entry 2844 (class 2606 OID 16464)
-- Name: claimed_markets claimed_markets_pkey; Type: CONSTRAINT; Schema: public; Owner: flux
--

ALTER TABLE ONLY public.claimed_markets
    ADD CONSTRAINT claimed_markets_pkey PRIMARY KEY (market_id, account_id);


--
-- TOC entry 2840 (class 2606 OID 16466)
-- Name: accounts markets_pkey; Type: CONSTRAINT; Schema: public; Owner: flux
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT markets_pkey PRIMARY KEY (id);


--
-- TOC entry 2846 (class 2606 OID 16468)
-- Name: markets markets_pkey1; Type: CONSTRAINT; Schema: public; Owner: flux
--

ALTER TABLE ONLY public.markets
    ADD CONSTRAINT markets_pkey1 PRIMARY KEY (id);


--
-- TOC entry 2848 (class 2606 OID 16470)
-- Name: orderbooks orderbooks_pkey; Type: CONSTRAINT; Schema: public; Owner: flux
--

ALTER TABLE ONLY public.orderbooks
    ADD CONSTRAINT orderbooks_pkey PRIMARY KEY (market_id, outcome);


--
-- TOC entry 2850 (class 2606 OID 16472)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: flux
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id, outcome, market_id);


--
-- TOC entry 2852 (class 2606 OID 16474)
-- Name: processed_blocks processed_blocks_pkey; Type: CONSTRAINT; Schema: public; Owner: flux
--

ALTER TABLE ONLY public.processed_blocks
    ADD CONSTRAINT processed_blocks_pkey PRIMARY KEY (height, "timestamp", hash);


--
-- TOC entry 2854 (class 2606 OID 16476)
-- Name: protocol protocol_data_pkey; Type: CONSTRAINT; Schema: public; Owner: flux
--

ALTER TABLE ONLY public.protocol
    ADD CONSTRAINT protocol_data_pkey PRIMARY KEY (owner, creation_bond, max_fee);


--
-- TOC entry 2856 (class 2606 OID 16478)
-- Name: resolution_windows resolution_windows_pkey; Type: CONSTRAINT; Schema: public; Owner: flux
--

ALTER TABLE ONLY public.resolution_windows
    ADD CONSTRAINT resolution_windows_pkey PRIMARY KEY (market_id, round);


--
-- TOC entry 2864 (class 2620 OID 16618)
-- Name: markets notify_update_markets; Type: TRIGGER; Schema: public; Owner: flux
--

CREATE TRIGGER notify_update_markets AFTER INSERT OR UPDATE ON public.markets FOR EACH ROW EXECUTE FUNCTION public.notify_update_markets();


--
-- TOC entry 2865 (class 2620 OID 16616)
-- Name: orders notify_update_orders; Type: TRIGGER; Schema: public; Owner: flux
--

CREATE TRIGGER notify_update_orders AFTER INSERT OR UPDATE ON public.orders FOR EACH ROW EXECUTE FUNCTION public.notify_update_orders();


--
-- TOC entry 2861 (class 2606 OID 16479)
-- Name: fills market_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: flux
--

ALTER TABLE ONLY public.fills
    ADD CONSTRAINT market_id_fkey FOREIGN KEY (market_id) REFERENCES public.markets(id) NOT VALID;


--
-- TOC entry 2862 (class 2606 OID 16484)
-- Name: orders market_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: flux
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT market_id_fkey FOREIGN KEY (market_id) REFERENCES public.markets(id) NOT VALID;


--
-- TOC entry 2860 (class 2606 OID 16489)
-- Name: claimed_markets market_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: flux
--

ALTER TABLE ONLY public.claimed_markets
    ADD CONSTRAINT market_id_fkey FOREIGN KEY (market_id) REFERENCES public.markets(id);


--
-- TOC entry 2857 (class 2606 OID 16494)
-- Name: account_share_balances market_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: flux
--

ALTER TABLE ONLY public.account_share_balances
    ADD CONSTRAINT market_id_fkey FOREIGN KEY (market_id) REFERENCES public.markets(id);


--
-- TOC entry 2863 (class 2606 OID 16499)
-- Name: resolution_windows markets_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: flux
--

ALTER TABLE ONLY public.resolution_windows
    ADD CONSTRAINT markets_id_fkey FOREIGN KEY (market_id) REFERENCES public.markets(id);


--
-- TOC entry 2859 (class 2606 OID 16504)
-- Name: claimable_if_valids marketst_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: flux
--

ALTER TABLE ONLY public.claimable_if_valids
    ADD CONSTRAINT marketst_id_fkey FOREIGN KEY (market_id) REFERENCES public.markets(id);


--
-- TOC entry 2858 (class 2606 OID 16509)
-- Name: account_stake_in_outcomes resolution_windows_fkey; Type: FK CONSTRAINT; Schema: public; Owner: flux
--

ALTER TABLE ONLY public.account_stake_in_outcomes
    ADD CONSTRAINT resolution_windows_fkey FOREIGN KEY (market_id, round) REFERENCES public.resolution_windows(market_id, round);


-- Completed on 2020-08-29 16:45:07 CEST

--
-- PostgreSQL database dump complete
--

