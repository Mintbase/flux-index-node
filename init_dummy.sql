--
-- PostgreSQL database dump
--

-- Dumped from database version 12.3 (Debian 12.3-1.pgdg100+1)
-- Dumped by pg_dump version 12.2

-- Started on 2020-08-15 17:20:04 CEST

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
-- TOC entry 202 (class 1259 OID 16385)
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
-- TOC entry 203 (class 1259 OID 16391)
-- Name: accounts; Type: TABLE; Schema: public; Owner: flux
--

CREATE TABLE public.accounts (
    id text NOT NULL,
    affiliate_earnings numeric
);


ALTER TABLE public.accounts OWNER TO flux;

--
-- TOC entry 204 (class 1259 OID 16397)
-- Name: claimable_if_valids; Type: TABLE; Schema: public; Owner: flux
--

CREATE TABLE public.claimable_if_valids (
    account_id character varying(100) NOT NULL,
    market_id bigint NOT NULL,
    claimable numeric NOT NULL
);


ALTER TABLE public.claimable_if_valids OWNER TO flux;

--
-- TOC entry 213 (class 1259 OID 25334)
-- Name: claimed_markets; Type: TABLE; Schema: public; Owner: flux
--

CREATE TABLE public.claimed_markets (
    market_id bigint NOT NULL,
    account_id text NOT NULL
);


ALTER TABLE public.claimed_markets OWNER TO flux;

--
-- TOC entry 205 (class 1259 OID 16403)
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
-- TOC entry 206 (class 1259 OID 16409)
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
-- TOC entry 2998 (class 0 OID 0)
-- Dependencies: 206
-- Name: fills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: flux
--

ALTER SEQUENCE public.fills_id_seq OWNED BY public.fills.block_height;


--
-- TOC entry 207 (class 1259 OID 16411)
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
-- TOC entry 208 (class 1259 OID 16417)
-- Name: orderbooks; Type: TABLE; Schema: public; Owner: flux
--

CREATE TABLE public.orderbooks (
    market_id bigint NOT NULL,
    outcome bigint NOT NULL
);


ALTER TABLE public.orderbooks OWNER TO flux;

--
-- TOC entry 209 (class 1259 OID 16420)
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
-- TOC entry 212 (class 1259 OID 16559)
-- Name: processed_blocks; Type: TABLE; Schema: public; Owner: flux
--

CREATE TABLE public.processed_blocks (
    height numeric NOT NULL,
    "timestamp" numeric NOT NULL,
    hash character varying(200) NOT NULL
);


ALTER TABLE public.processed_blocks OWNER TO flux;

--
-- TOC entry 210 (class 1259 OID 16426)
-- Name: protocol; Type: TABLE; Schema: public; Owner: flux
--

CREATE TABLE public.protocol (
    owner character varying(100) NOT NULL,
    creation_bond numeric NOT NULL,
    max_fee numeric NOT NULL
);


ALTER TABLE public.protocol OWNER TO flux;

--
-- TOC entry 211 (class 1259 OID 16432)
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
-- TOC entry 2827 (class 2604 OID 24873)
-- Name: fills block_height; Type: DEFAULT; Schema: public; Owner: flux
--

ALTER TABLE ONLY public.fills ALTER COLUMN block_height SET DEFAULT nextval('public.fills_id_seq'::regclass);


--
-- TOC entry 2981 (class 0 OID 16385)
-- Dependencies: 202
-- Data for Name: account_stake_in_outcomes; Type: TABLE DATA; Schema: public; Owner: flux
--

COPY public.account_stake_in_outcomes (account_id, market_id, outcome, stake, round) FROM stdin;
test.near	5	0	5000000000000000000	0
test.near	6	0	5000000000000000000	0
test.near	7	0	3000000000000000000	0
test.near	8	0	5000000000000000000	0
test.near	8	1	10000000000000000000	1
test.near	9	0	5000000000000000000	0
test.near	10	0	5000000000000000000	0
test.near	11	0	5000000000000000000	0
test.near	15	0	5000000000000000000	0
test.near	16	0	5000000000000000000	0
test.near	17	0	5000000000000000000	0
test.near	18	0	5000000000000000000	0
test.near	19	0	5000000000000000000	0
test.near	20	0	5000000000000000000	0
test.near	21	0	5000000000000000000	0
test.near	22	0	5000000000000000000	0
test.near	23	0	5000000000000000000	0
test.near	24	0	5000000000000000000	0
test.near	26	0	5000000000000000000	0
test.near	27	0	5000000000000000000	0
test.near	28	0	5000000000000000000	0
test.near	29	0	5000000000000000000	0
test.near	30	0	5000000000000000000	0
test.near	31	0	5000000000000000000	0
test.near	32	0	5000000000000000000	0
test.near	33	0	5000000000000000000	0
test.near	34	0	5000000000000000000	0
\.


--
-- TOC entry 2982 (class 0 OID 16391)
-- Dependencies: 203
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: flux
--

COPY public.accounts (id, affiliate_earnings) FROM stdin;
test.near	0
\.


--
-- TOC entry 2983 (class 0 OID 16397)
-- Dependencies: 204
-- Data for Name: claimable_if_valids; Type: TABLE DATA; Schema: public; Owner: flux
--

COPY public.claimable_if_valids (account_id, market_id, claimable) FROM stdin;
\.


--
-- TOC entry 2992 (class 0 OID 25334)
-- Dependencies: 213
-- Data for Name: claimed_markets; Type: TABLE DATA; Schema: public; Owner: flux
--

COPY public.claimed_markets (market_id, account_id) FROM stdin;
34	test.near
\.


--
-- TOC entry 2984 (class 0 OID 16403)
-- Dependencies: 205
-- Data for Name: fills; Type: TABLE DATA; Schema: public; Owner: flux
--

COPY public.fills (order_id, market_id, outcome, amount, fill_time, owner, price, block_height) FROM stdin;
0	18	0	2000	2020-08-14 16:54:52.612118+00	test.near	50	322934
0	18	1	2000	2020-08-14 16:54:52.656065+00	test.near	50	322934
0	19	0	2000	2020-08-14 16:55:52.668992+00	test.near	50	323031
0	19	1	2000	2020-08-14 16:55:52.695873+00	test.near	50	323031
0	20	0	2000	2020-08-14 16:57:43.615002+00	test.near	50	323211
0	20	1	2000	2020-08-14 16:57:43.652487+00	test.near	50	323211
0	21	0	2000	2020-08-14 16:58:28.510204+00	test.near	50	323284
0	21	1	2000	2020-08-14 16:58:28.53273+00	test.near	50	323284
0	22	0	2000	2020-08-14 16:59:20.714919+00	test.near	50	323367
0	22	1	2000	2020-08-14 16:59:20.742388+00	test.near	50	323367
0	23	0	200000000000	2020-08-14 17:01:17.11597+00	test.near	50	323554
0	23	1	200000000000	2020-08-14 17:01:17.148377+00	test.near	50	323554
0	24	0	200000000000	2020-08-14 17:04:14.225488+00	test.near	50	323841
0	24	1	200000000000	2020-08-14 17:04:14.261532+00	test.near	50	323841
0	26	0	200000000000	2020-08-14 17:05:31.419964+00	test.near	50	323965
0	26	1	200000000000	2020-08-14 17:05:31.446327+00	test.near	50	323965
0	27	0	200000000000	2020-08-14 17:06:37.337049+00	test.near	50	324070
0	27	1	200000000000	2020-08-14 17:06:37.376648+00	test.near	50	324070
0	28	0	200000000000	2020-08-14 17:13:12.631304+00	test.near	50	324564
0	28	1	200000000000	2020-08-14 17:13:12.681811+00	test.near	50	324564
0	29	0	200000000000	2020-08-14 17:15:21.045323+00	test.near	50	324772
0	29	1	200000000000	2020-08-14 17:15:21.076012+00	test.near	50	324772
0	30	0	200000000000	2020-08-14 17:18:04.226373+00	test.near	50	324962
0	30	1	200000000000	2020-08-14 17:18:04.260597+00	test.near	50	324962
0	31	0	200000000000	2020-08-14 17:24:06.86761+00	test.near	50	325496
0	31	1	200000000000	2020-08-14 17:24:06.902083+00	test.near	50	325496
0	32	0	200000000000	2020-08-14 17:30:22.622804+00	test.near	50	325853
0	32	1	200000000000	2020-08-14 17:30:22.663049+00	test.near	50	325853
0	33	0	200000000000	2020-08-14 17:33:06.677392+00	test.near	50	326118
0	33	1	200000000000	2020-08-14 17:33:06.705626+00	test.near	50	326118
0	34	0	200000000000	2020-08-14 17:41:58.577191+00	test.near	50	326887
0	34	1	200000000000	2020-08-14 17:41:58.619502+00	test.near	50	326887
\.


--
-- TOC entry 2986 (class 0 OID 16411)
-- Dependencies: 207
-- Data for Name: markets; Type: TABLE DATA; Schema: public; Owner: flux
--

COPY public.markets (id, description, extra_info, creator, creation_date, end_date_time, outcomes, outcome_tags, categories, winning_outcome, resoluted, resolute_bond, filled_volume, disputed, finalized, creator_fee_percentage, resolution_fee_percentage, affiliate_fee_percentage, api_source, validity_bond_claimed) FROM stdin;
2	test		test.near	2020-08-14 13:58:31.942275+00	2020-08-15 16:17:59+00	2	{}	{}	\N	f	5000000000000000000	0	f	f	1	100	0		f
3	test		test.near	2020-08-14 14:03:08.841199+00	2020-08-15 16:17:59+00	2	{}	{}	\N	f	5000000000000000000	0	f	f	1	100	0		f
4	test		test.near	2020-08-14 14:08:53.573408+00	2020-08-15 16:17:59+00	2	{}	{}	\N	f	5000000000000000000	0	f	f	1	100	0		f
5	test		test.near	2020-08-14 14:16:55.809174+00	2020-08-15 16:17:59+00	2	{}	{}	\N	f	5000000000000000000	0	f	f	1	100	0		f
6	test		test.near	2020-08-14 14:26:02.256146+00	2020-08-15 16:17:59+00	2	{}	{}	\N	t	5000000000000000000	0	f	f	1	100	0		f
7	test		test.near	2020-08-14 14:29:50.316772+00	2020-08-15 16:17:59+00	2	{}	{}	\N	f	5000000000000000000	0	f	f	1	100	0		f
8	test		test.near	2020-08-14 14:45:11.780267+00	2020-08-15 16:17:59+00	2	{}	{}	\N	t	5000000000000000000	0	t	f	1	100	0		f
9	test		test.near	2020-08-14 15:18:24.421827+00	2020-08-15 16:17:59+00	2	{}	{}	\N	t	5000000000000000000	0	f	f	1	100	0		f
10	test		test.near	2020-08-14 15:19:25.811899+00	2020-08-15 16:17:59+00	2	{}	{}	\N	t	5000000000000000000	0	f	f	1	100	0		f
12	test		test.near	2020-08-14 15:20:20.408968+00	2020-08-15 16:17:59+00	2	{}	{}	\N	f	5000000000000000000	0	f	f	1	100	0		f
11	test		test.near	2020-08-14 15:20:15.351473+00	2020-08-15 16:17:59+00	2	{}	{}	\N	t	5000000000000000000	0	f	f	1	100	0		f
13	test		test.near	2020-08-14 15:21:29.624866+00	2020-08-15 16:17:59+00	2	{}	{}	\N	f	5000000000000000000	0	f	f	1	100	0		f
14	test		test.near	2020-08-14 15:21:37.687268+00	2020-08-15 16:17:59+00	2	{}	{}	\N	f	5000000000000000000	0	f	f	1	100	0		f
29	test		test.near	2020-08-14 17:15:12.447808+00	2020-08-15 16:17:59+00	2	{}	{}	0	t	5000000000000000000	0	f	t	1	100	50		f
15	test		test.near	2020-08-14 15:21:52.325734+00	2020-08-15 16:17:59+00	2	{}	{}	0	t	5000000000000000000	0	f	t	1	100	0		f
16	test		test.near	2020-08-14 16:53:46.643615+00	2020-08-15 16:17:59+00	2	{}	{}	0	t	5000000000000000000	0	f	t	1	100	0		f
17	test		test.near	2020-08-14 16:54:27.922762+00	2020-08-15 16:17:59+00	2	{}	{}	0	t	5000000000000000000	0	f	t	1	100	0		f
30	test		test.near	2020-08-14 17:17:56.13525+00	2020-08-15 16:17:59+00	2	{}	{}	0	t	5000000000000000000	0	f	t	1	100	50		f
18	test		test.near	2020-08-14 16:54:41.547336+00	2020-08-15 16:17:59+00	2	{}	{}	0	t	5000000000000000000	0	f	t	1	100	0		f
19	test		test.near	2020-08-14 16:54:43.561668+00	2020-08-15 16:17:59+00	2	{}	{}	0	t	5000000000000000000	0	f	t	1	100	0		f
20	test		test.near	2020-08-14 16:55:44.101101+00	2020-08-15 16:17:59+00	2	{}	{}	0	t	5000000000000000000	0	f	t	1	100	0		f
31	test		test.near	2020-08-14 17:23:58.30706+00	2020-08-15 16:17:59+00	2	{}	{}	0	t	5000000000000000000	0	f	t	1	100	50		f
21	test		test.near	2020-08-14 16:57:34.512775+00	2020-08-15 16:17:59+00	2	{}	{}	0	t	5000000000000000000	0	f	t	1	100	0		f
22	test		test.near	2020-08-14 16:58:19.940185+00	2020-08-15 16:17:59+00	2	{}	{}	0	t	5000000000000000000	0	f	t	1	100	0		f
23	test		test.near	2020-08-14 16:59:12.151397+00	2020-08-15 16:17:59+00	2	{}	{}	0	t	5000000000000000000	0	f	t	1	100	0		f
25	test		test.near	2020-08-14 17:04:05.466614+00	2020-08-15 16:17:59+00	2	{}	{}	\N	f	5000000000000000000	0	f	f	1	100	50		f
32	test		test.near	2020-08-14 17:30:14.057875+00	2020-08-15 16:17:59+00	2	{}	{}	0	t	5000000000000000000	0	f	t	1	100	50		f
24	test		test.near	2020-08-14 17:01:08.437571+00	2020-08-15 16:17:59+00	2	{}	{}	0	t	5000000000000000000	0	f	t	1	100	0		f
26	test		test.near	2020-08-14 17:05:22.597018+00	2020-08-15 16:17:59+00	2	{}	{}	0	t	5000000000000000000	0	f	t	1	100	50		f
27	test		test.near	2020-08-14 17:06:28.628731+00	2020-08-15 16:17:59+00	2	{}	{}	0	t	5000000000000000000	0	f	t	1	100	50		f
33	test		test.near	2020-08-14 17:32:58.13499+00	2020-08-15 16:17:59+00	2	{}	{}	0	t	5000000000000000000	0	f	t	1	100	50		f
28	test		test.near	2020-08-14 17:13:04.046946+00	2020-08-15 16:17:59+00	2	{}	{}	0	t	5000000000000000000	0	f	t	1	100	50		f
34	test		test.near	2020-08-14 17:41:50.443314+00	2020-08-15 16:17:59+00	2	{}	{}	0	t	5000000000000000000	0	f	t	1	100	50		f
\.


--
-- TOC entry 2987 (class 0 OID 16417)
-- Dependencies: 208
-- Data for Name: orderbooks; Type: TABLE DATA; Schema: public; Owner: flux
--

COPY public.orderbooks (market_id, outcome) FROM stdin;
\.


--
-- TOC entry 2988 (class 0 OID 16420)
-- Dependencies: 209
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: flux
--

COPY public.orders (id, creator, outcome, market_id, spend, shares, price, filled, shares_filled, affiliate_account_id, creation_time, closed) FROM stdin;
0	test.near	0	18	100000	2000	50	100000	2000	test.near	2020-08-14 16:54:48.084657+00	t
0	test.near	1	18	100000	2000	50	100000	2000	test.near	2020-08-14 16:54:52.647677+00	t
0	test.near	0	19	100000	2000	50	100000	2000	test.near	2020-08-14 16:55:48.132141+00	t
0	test.near	1	19	100000	2000	50	100000	2000	test.near	2020-08-14 16:55:52.688975+00	t
0	test.near	0	20	100000	2000	50	100000	2000	test.near	2020-08-14 16:57:39.086134+00	t
0	test.near	1	20	100000	2000	50	100000	2000	test.near	2020-08-14 16:57:43.646974+00	t
0	test.near	0	21	100000	2000	50	100000	2000	test.near	2020-08-14 16:58:24.475268+00	t
0	test.near	1	21	100000	2000	50	100000	2000	test.near	2020-08-14 16:58:28.527149+00	t
0	test.near	0	22	100000	2000	50	100000	2000	test.near	2020-08-14 16:59:16.180743+00	t
0	test.near	1	22	100000	2000	50	100000	2000	test.near	2020-08-14 16:59:20.73658+00	t
0	test.near	0	23	10000000000000	200000000000	50	10000000000000	200000000000	test.near	2020-08-14 17:01:12.582078+00	t
0	test.near	1	23	10000000000000	200000000000	50	10000000000000	200000000000	test.near	2020-08-14 17:01:17.140037+00	t
0	test.near	0	24	10000000000000	200000000000	50	10000000000000	200000000000	test.near	2020-08-14 17:04:10.012488+00	t
0	test.near	1	24	10000000000000	200000000000	50	10000000000000	200000000000	test.near	2020-08-14 17:04:14.251288+00	t
0	test.near	0	26	10000000000000	200000000000	50	10000000000000	200000000000	test.near	2020-08-14 17:05:27.270618+00	t
0	test.near	1	26	10000000000000	200000000000	50	10000000000000	200000000000	test.near	2020-08-14 17:05:31.439625+00	t
0	test.near	0	27	10000000000000	200000000000	50	10000000000000	200000000000	test.near	2020-08-14 17:06:33.173157+00	t
0	test.near	1	27	10000000000000	200000000000	50	10000000000000	200000000000	test.near	2020-08-14 17:06:37.367571+00	t
0	test.near	0	28	10000000000000	200000000000	50	10000000000000	200000000000	test.near	2020-08-14 17:13:08.085972+00	t
0	test.near	1	28	10000000000000	200000000000	50	10000000000000	200000000000	test.near	2020-08-14 17:13:12.673243+00	t
0	test.near	0	29	10000000000000	200000000000	50	10000000000000	200000000000	test.near	2020-08-14 17:15:16.976525+00	t
0	test.near	1	29	10000000000000	200000000000	50	10000000000000	200000000000	test.near	2020-08-14 17:15:21.068949+00	t
0	test.near	0	30	10000000000000	200000000000	50	10000000000000	200000000000	test.near	2020-08-14 17:18:00.158151+00	t
0	test.near	1	30	10000000000000	200000000000	50	10000000000000	200000000000	test.near	2020-08-14 17:18:04.252905+00	t
0	test.near	0	31	10000000000000	200000000000	50	10000000000000	200000000000	test.near	2020-08-14 17:24:02.336867+00	t
0	test.near	1	31	10000000000000	200000000000	50	10000000000000	200000000000	test.near	2020-08-14 17:24:06.893724+00	t
0	test.near	0	32	10000000000000	200000000000	50	10000000000000	200000000000	test.near	2020-08-14 17:30:18.594154+00	t
0	test.near	1	32	10000000000000	200000000000	50	10000000000000	200000000000	test.near	2020-08-14 17:30:22.656216+00	t
0	test.near	0	33	10000000000000	200000000000	50	10000000000000	200000000000	test.near	2020-08-14 17:33:02.659785+00	t
0	test.near	1	33	10000000000000	200000000000	50	10000000000000	200000000000	test.near	2020-08-14 17:33:06.698039+00	t
0	test.near	0	34	10000000000000	200000000000	50	10000000000000	200000000000	test.near	2020-08-14 17:41:54.004648+00	t
0	test.near	1	34	10000000000000	200000000000	50	10000000000000	200000000000	test.near	2020-08-14 17:41:58.609065+00	t
\.


--
-- TOC entry 2991 (class 0 OID 16559)
-- Dependencies: 212
-- Data for Name: processed_blocks; Type: TABLE DATA; Schema: public; Owner: flux
--

COPY public.processed_blocks (height, "timestamp", hash) FROM stdin;
\.


--
-- TOC entry 2989 (class 0 OID 16426)
-- Dependencies: 210
-- Data for Name: protocol; Type: TABLE DATA; Schema: public; Owner: flux
--

COPY public.protocol (owner, creation_bond, max_fee) FROM stdin;
flux-dev	250000000000000000	5000000000000000000
\.


--
-- TOC entry 2990 (class 0 OID 16432)
-- Dependencies: 211
-- Data for Name: resolution_windows; Type: TABLE DATA; Schema: public; Owner: flux
--

COPY public.resolution_windows (market_id, round, bond_size, end_time, outcome) FROM stdin;
2	0	5000000000000000000	2020-08-15 16:17:59+00	\N
3	0	5000000000000000000	2020-08-15 16:17:59+00	\N
4	0	5000000000000000000	2020-08-15 16:17:59+00	\N
5	0	5000000000000000000	2020-08-15 16:17:59+00	\N
5	1	10000000000000000000	2020-08-15 02:18:13+00	\N
6	0	5000000000000000000	2020-08-15 16:17:59+00	\N
6	1	10000000000000000000	2020-08-15 02:26:08+00	\N
7	0	5000000000000000000	2020-08-15 16:17:59+00	\N
8	0	5000000000000000000	2020-08-15 16:17:59+00	\N
8	1	10000000000000000000	2020-08-15 02:45:14+00	\N
8	2	20000000000000000000	2020-08-15 02:45:18+00	\N
9	0	5000000000000000000	2020-08-15 16:17:59+00	\N
9	1	10000000000000000000	2020-08-15 03:18:26+00	\N
10	0	5000000000000000000	2020-08-15 16:17:59+00	\N
10	1	10000000000000000000	2020-08-15 03:19:27+00	\N
11	0	5000000000000000000	2020-08-15 16:17:59+00	\N
12	0	5000000000000000000	2020-08-15 16:17:59+00	\N
11	1	10000000000000000000	2020-08-15 03:20:23+00	\N
13	0	5000000000000000000	2020-08-15 16:17:59+00	\N
14	0	5000000000000000000	2020-08-15 16:17:59+00	\N
15	0	5000000000000000000	2020-08-15 16:17:59+00	\N
15	1	10000000000000000000	2020-08-15 03:21:55+00	\N
16	0	5000000000000000000	2020-08-15 16:17:59+00	\N
16	1	10000000000000000000	2020-08-15 04:53:49+00	\N
17	0	5000000000000000000	2020-08-15 16:17:59+00	\N
17	1	10000000000000000000	2020-08-15 04:54:30+00	\N
18	0	5000000000000000000	2020-08-15 16:17:59+00	\N
19	0	5000000000000000000	2020-08-15 16:17:59+00	\N
18	1	10000000000000000000	2020-08-15 04:54:55+00	\N
20	0	5000000000000000000	2020-08-15 16:17:59+00	\N
19	1	10000000000000000000	2020-08-15 04:55:55+00	\N
21	0	5000000000000000000	2020-08-15 16:17:59+00	\N
20	1	10000000000000000000	2020-08-15 04:57:46+00	\N
22	0	5000000000000000000	2020-08-15 16:17:59+00	\N
21	1	10000000000000000000	2020-08-15 04:58:30+00	\N
23	0	5000000000000000000	2020-08-15 16:17:59+00	\N
22	1	10000000000000000000	2020-08-15 04:59:23+00	\N
24	0	5000000000000000000	2020-08-15 16:17:59+00	\N
23	1	10000000000000000000	2020-08-15 05:01:19+00	\N
25	0	5000000000000000000	2020-08-15 16:17:59+00	\N
24	1	10000000000000000000	2020-08-15 05:04:17+00	\N
26	0	5000000000000000000	2020-08-15 16:17:59+00	\N
26	1	10000000000000000000	2020-08-15 05:05:34+00	\N
27	0	5000000000000000000	2020-08-15 16:17:59+00	\N
27	1	10000000000000000000	2020-08-15 05:06:40+00	\N
28	0	5000000000000000000	2020-08-15 16:17:59+00	\N
28	1	10000000000000000000	2020-08-15 05:13:15+00	\N
29	0	5000000000000000000	2020-08-15 16:17:59+00	\N
29	1	10000000000000000000	2020-08-15 05:15:23+00	\N
30	0	5000000000000000000	2020-08-15 16:17:59+00	\N
30	1	10000000000000000000	2020-08-15 05:18:07+00	\N
31	0	5000000000000000000	2020-08-15 16:17:59+00	\N
31	1	10000000000000000000	2020-08-15 05:24:09+00	\N
32	0	5000000000000000000	2020-08-15 16:17:59+00	\N
32	1	10000000000000000000	2020-08-15 05:30:25+00	\N
33	0	5000000000000000000	2020-08-15 16:17:59+00	\N
33	1	10000000000000000000	2020-08-15 05:33:09+00	\N
34	0	5000000000000000000	2020-08-15 16:17:59+00	\N
34	1	10000000000000000000	2020-08-15 05:42:01+00	\N
\.


--
-- TOC entry 2999 (class 0 OID 0)
-- Dependencies: 206
-- Name: fills_id_seq; Type: SEQUENCE SET; Schema: public; Owner: flux
--

SELECT pg_catalog.setval('public.fills_id_seq', 38688, true);


--
-- TOC entry 2829 (class 2606 OID 25277)
-- Name: account_stake_in_outcomes account_stake_in_outcome_pkey; Type: CONSTRAINT; Schema: public; Owner: flux
--

ALTER TABLE ONLY public.account_stake_in_outcomes
    ADD CONSTRAINT account_stake_in_outcome_pkey PRIMARY KEY (account_id, market_id, outcome, round);


--
-- TOC entry 2833 (class 2606 OID 16448)
-- Name: claimable_if_valids claimable_if_valid_pkey; Type: CONSTRAINT; Schema: public; Owner: flux
--

ALTER TABLE ONLY public.claimable_if_valids
    ADD CONSTRAINT claimable_if_valid_pkey PRIMARY KEY (market_id, account_id);


--
-- TOC entry 2847 (class 2606 OID 25341)
-- Name: claimed_markets claimed_markets_pkey; Type: CONSTRAINT; Schema: public; Owner: flux
--

ALTER TABLE ONLY public.claimed_markets
    ADD CONSTRAINT claimed_markets_pkey PRIMARY KEY (market_id, account_id);


--
-- TOC entry 2831 (class 2606 OID 25325)
-- Name: accounts markets_pkey; Type: CONSTRAINT; Schema: public; Owner: flux
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT markets_pkey PRIMARY KEY (id);


--
-- TOC entry 2835 (class 2606 OID 24781)
-- Name: markets markets_pkey1; Type: CONSTRAINT; Schema: public; Owner: flux
--

ALTER TABLE ONLY public.markets
    ADD CONSTRAINT markets_pkey1 PRIMARY KEY (id);


--
-- TOC entry 2837 (class 2606 OID 16456)
-- Name: orderbooks orderbooks_pkey; Type: CONSTRAINT; Schema: public; Owner: flux
--

ALTER TABLE ONLY public.orderbooks
    ADD CONSTRAINT orderbooks_pkey PRIMARY KEY (market_id, outcome);


--
-- TOC entry 2839 (class 2606 OID 16458)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: flux
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id, outcome, market_id);


--
-- TOC entry 2845 (class 2606 OID 16566)
-- Name: processed_blocks processed_blocks_pkey; Type: CONSTRAINT; Schema: public; Owner: flux
--

ALTER TABLE ONLY public.processed_blocks
    ADD CONSTRAINT processed_blocks_pkey PRIMARY KEY (height, "timestamp", hash);


--
-- TOC entry 2841 (class 2606 OID 16460)
-- Name: protocol protocol_data_pkey; Type: CONSTRAINT; Schema: public; Owner: flux
--

ALTER TABLE ONLY public.protocol
    ADD CONSTRAINT protocol_data_pkey PRIMARY KEY (owner, creation_bond, max_fee);


--
-- TOC entry 2843 (class 2606 OID 16462)
-- Name: resolution_windows resolution_windows_pkey; Type: CONSTRAINT; Schema: public; Owner: flux
--

ALTER TABLE ONLY public.resolution_windows
    ADD CONSTRAINT resolution_windows_pkey PRIMARY KEY (market_id, round);


--
-- TOC entry 2851 (class 2606 OID 24831)
-- Name: fills market_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: flux
--

ALTER TABLE ONLY public.fills
    ADD CONSTRAINT market_id_fkey FOREIGN KEY (market_id) REFERENCES public.markets(id) NOT VALID;


--
-- TOC entry 2852 (class 2606 OID 24860)
-- Name: orders market_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: flux
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT market_id_fkey FOREIGN KEY (market_id) REFERENCES public.markets(id) NOT VALID;


--
-- TOC entry 2854 (class 2606 OID 25342)
-- Name: claimed_markets market_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: flux
--

ALTER TABLE ONLY public.claimed_markets
    ADD CONSTRAINT market_id_fkey FOREIGN KEY (market_id) REFERENCES public.markets(id);


--
-- TOC entry 2853 (class 2606 OID 24782)
-- Name: resolution_windows markets_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: flux
--

ALTER TABLE ONLY public.resolution_windows
    ADD CONSTRAINT markets_id_fkey FOREIGN KEY (market_id) REFERENCES public.markets(id);


--
-- TOC entry 2849 (class 2606 OID 24792)
-- Name: claimable_if_valids marketst_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: flux
--

ALTER TABLE ONLY public.claimable_if_valids
    ADD CONSTRAINT marketst_id_fkey FOREIGN KEY (market_id) REFERENCES public.markets(id);


--
-- TOC entry 2850 (class 2606 OID 24826)
-- Name: fills order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: flux
--

ALTER TABLE ONLY public.fills
    ADD CONSTRAINT order_id_fkey FOREIGN KEY (order_id, outcome, market_id) REFERENCES public.orders(id, outcome, market_id) NOT VALID;


--
-- TOC entry 2848 (class 2606 OID 16520)
-- Name: account_stake_in_outcomes resolution_windows_fkey; Type: FK CONSTRAINT; Schema: public; Owner: flux
--

ALTER TABLE ONLY public.account_stake_in_outcomes
    ADD CONSTRAINT resolution_windows_fkey FOREIGN KEY (market_id, round) REFERENCES public.resolution_windows(market_id, round);


-- Completed on 2020-08-15 17:20:05 CEST

--
-- PostgreSQL database dump complete
--

