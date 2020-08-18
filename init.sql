PGDMP         8                x           flux    12.3 (Debian 12.3-1.pgdg100+1)    12.2 /    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16384    flux    DATABASE     t   CREATE DATABASE flux WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';
    DROP DATABASE flux;
                flux    false            �            1259    16385    account_stake_in_outcomes    TABLE     �   CREATE TABLE public.account_stake_in_outcomes (
    account_id text NOT NULL,
    market_id bigint NOT NULL,
    outcome bigint NOT NULL,
    stake numeric NOT NULL,
    round bigint NOT NULL
);
 -   DROP TABLE public.account_stake_in_outcomes;
       public         heap    flux    false            �            1259    16391    accounts    TABLE     W   CREATE TABLE public.accounts (
    id text NOT NULL,
    affiliate_earnings numeric
);
    DROP TABLE public.accounts;
       public         heap    flux    false            �            1259    16397    claimable_if_valids    TABLE     �   CREATE TABLE public.claimable_if_valids (
    account_id character varying(100) NOT NULL,
    market_id bigint NOT NULL,
    claimable numeric NOT NULL
);
 '   DROP TABLE public.claimable_if_valids;
       public         heap    flux    false            �            1259    25334    claimed_markets    TABLE     e   CREATE TABLE public.claimed_markets (
    market_id bigint NOT NULL,
    account_id text NOT NULL
);
 #   DROP TABLE public.claimed_markets;
       public         heap    flux    false            �            1259    16403    fills    TABLE     +  CREATE TABLE public.fills (
    order_id numeric NOT NULL,
    market_id bigint NOT NULL,
    outcome bigint NOT NULL,
    amount numeric NOT NULL,
    fill_time timestamp with time zone NOT NULL,
    owner character varying NOT NULL,
    price bigint NOT NULL,
    block_height numeric NOT NULL
);
    DROP TABLE public.fills;
       public         heap    flux    false            �            1259    16409    fills_id_seq    SEQUENCE     u   CREATE SEQUENCE public.fills_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.fills_id_seq;
       public          flux    false    205            �           0    0    fills_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.fills_id_seq OWNED BY public.fills.block_height;
          public          flux    false    206            �            1259    16411    markets    TABLE     �  CREATE TABLE public.markets (
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
    DROP TABLE public.markets;
       public         heap    flux    false            �            1259    16417 
   orderbooks    TABLE     _   CREATE TABLE public.orderbooks (
    market_id bigint NOT NULL,
    outcome bigint NOT NULL
);
    DROP TABLE public.orderbooks;
       public         heap    flux    false            �            1259    16420    orders    TABLE     �  CREATE TABLE public.orders (
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
    DROP TABLE public.orders;
       public         heap    flux    false            �            1259    16559    processed_blocks    TABLE     �   CREATE TABLE public.processed_blocks (
    height numeric NOT NULL,
    "timestamp" numeric NOT NULL,
    hash character varying(200) NOT NULL
);
 $   DROP TABLE public.processed_blocks;
       public         heap    flux    false            �            1259    16426    protocol    TABLE     �   CREATE TABLE public.protocol (
    owner character varying(100) NOT NULL,
    creation_bond numeric NOT NULL,
    max_fee numeric NOT NULL
);
    DROP TABLE public.protocol;
       public         heap    flux    false            �            1259    16432    resolution_windows    TABLE     �   CREATE TABLE public.resolution_windows (
    market_id bigint NOT NULL,
    round bigint NOT NULL,
    bond_size numeric NOT NULL,
    end_time timestamp with time zone NOT NULL,
    outcome bigint
);
 &   DROP TABLE public.resolution_windows;
       public         heap    flux    false                       2604    24873    fills block_height    DEFAULT     n   ALTER TABLE ONLY public.fills ALTER COLUMN block_height SET DEFAULT nextval('public.fills_id_seq'::regclass);
 A   ALTER TABLE public.fills ALTER COLUMN block_height DROP DEFAULT;
       public          flux    false    206    205            �          0    16385    account_stake_in_outcomes 
   TABLE DATA           a   COPY public.account_stake_in_outcomes (account_id, market_id, outcome, stake, round) FROM stdin;
    public          flux    false    202   @<       �          0    16391    accounts 
   TABLE DATA           :   COPY public.accounts (id, affiliate_earnings) FROM stdin;
    public          flux    false    203   ]<       �          0    16397    claimable_if_valids 
   TABLE DATA           O   COPY public.claimable_if_valids (account_id, market_id, claimable) FROM stdin;
    public          flux    false    204   �<       �          0    25334    claimed_markets 
   TABLE DATA           @   COPY public.claimed_markets (market_id, account_id) FROM stdin;
    public          flux    false    213   �<       �          0    16403    fills 
   TABLE DATA           l   COPY public.fills (order_id, market_id, outcome, amount, fill_time, owner, price, block_height) FROM stdin;
    public          flux    false    205   �<       �          0    16411    markets 
   TABLE DATA           H  COPY public.markets (id, description, extra_info, creator, creation_date, end_date_time, outcomes, outcome_tags, categories, winning_outcome, resoluted, resolute_bond, filled_volume, disputed, finalized, creator_fee_percentage, resolution_fee_percentage, affiliate_fee_percentage, api_source, validity_bond_claimed) FROM stdin;
    public          flux    false    207   �<       �          0    16417 
   orderbooks 
   TABLE DATA           8   COPY public.orderbooks (market_id, outcome) FROM stdin;
    public          flux    false    208   �<       �          0    16420    orders 
   TABLE DATA           �   COPY public.orders (id, creator, outcome, market_id, spend, shares, price, filled, shares_filled, affiliate_account_id, creation_time, closed) FROM stdin;
    public          flux    false    209   =       �          0    16559    processed_blocks 
   TABLE DATA           E   COPY public.processed_blocks (height, "timestamp", hash) FROM stdin;
    public          flux    false    212   4=       �          0    16426    protocol 
   TABLE DATA           A   COPY public.protocol (owner, creation_bond, max_fee) FROM stdin;
    public          flux    false    210   Q=       �          0    16432    resolution_windows 
   TABLE DATA           \   COPY public.resolution_windows (market_id, round, bond_size, end_time, outcome) FROM stdin;
    public          flux    false    211   �=       �           0    0    fills_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.fills_id_seq', 38688, true);
          public          flux    false    206                       2606    25277 7   account_stake_in_outcomes account_stake_in_outcome_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.account_stake_in_outcomes
    ADD CONSTRAINT account_stake_in_outcome_pkey PRIMARY KEY (account_id, market_id, outcome, round);
 a   ALTER TABLE ONLY public.account_stake_in_outcomes DROP CONSTRAINT account_stake_in_outcome_pkey;
       public            flux    false    202    202    202    202                       2606    16448 +   claimable_if_valids claimable_if_valid_pkey 
   CONSTRAINT     |   ALTER TABLE ONLY public.claimable_if_valids
    ADD CONSTRAINT claimable_if_valid_pkey PRIMARY KEY (market_id, account_id);
 U   ALTER TABLE ONLY public.claimable_if_valids DROP CONSTRAINT claimable_if_valid_pkey;
       public            flux    false    204    204                       2606    25341 $   claimed_markets claimed_markets_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public.claimed_markets
    ADD CONSTRAINT claimed_markets_pkey PRIMARY KEY (market_id, account_id);
 N   ALTER TABLE ONLY public.claimed_markets DROP CONSTRAINT claimed_markets_pkey;
       public            flux    false    213    213                       2606    25325    accounts markets_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT markets_pkey PRIMARY KEY (id);
 ?   ALTER TABLE ONLY public.accounts DROP CONSTRAINT markets_pkey;
       public            flux    false    203                       2606    24781    markets markets_pkey1 
   CONSTRAINT     S   ALTER TABLE ONLY public.markets
    ADD CONSTRAINT markets_pkey1 PRIMARY KEY (id);
 ?   ALTER TABLE ONLY public.markets DROP CONSTRAINT markets_pkey1;
       public            flux    false    207                       2606    16456    orderbooks orderbooks_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.orderbooks
    ADD CONSTRAINT orderbooks_pkey PRIMARY KEY (market_id, outcome);
 D   ALTER TABLE ONLY public.orderbooks DROP CONSTRAINT orderbooks_pkey;
       public            flux    false    208    208                       2606    16458    orders orders_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id, outcome, market_id);
 <   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_pkey;
       public            flux    false    209    209    209                       2606    16566 &   processed_blocks processed_blocks_pkey 
   CONSTRAINT     {   ALTER TABLE ONLY public.processed_blocks
    ADD CONSTRAINT processed_blocks_pkey PRIMARY KEY (height, "timestamp", hash);
 P   ALTER TABLE ONLY public.processed_blocks DROP CONSTRAINT processed_blocks_pkey;
       public            flux    false    212    212    212                       2606    16460    protocol protocol_data_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.protocol
    ADD CONSTRAINT protocol_data_pkey PRIMARY KEY (owner, creation_bond, max_fee);
 E   ALTER TABLE ONLY public.protocol DROP CONSTRAINT protocol_data_pkey;
       public            flux    false    210    210    210                       2606    16462 *   resolution_windows resolution_windows_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.resolution_windows
    ADD CONSTRAINT resolution_windows_pkey PRIMARY KEY (market_id, round);
 T   ALTER TABLE ONLY public.resolution_windows DROP CONSTRAINT resolution_windows_pkey;
       public            flux    false    211    211            #           2606    24831    fills market_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.fills
    ADD CONSTRAINT market_id_fkey FOREIGN KEY (market_id) REFERENCES public.markets(id) NOT VALID;
 >   ALTER TABLE ONLY public.fills DROP CONSTRAINT market_id_fkey;
       public          flux    false    2835    205    207            $           2606    24860    orders market_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT market_id_fkey FOREIGN KEY (market_id) REFERENCES public.markets(id) NOT VALID;
 ?   ALTER TABLE ONLY public.orders DROP CONSTRAINT market_id_fkey;
       public          flux    false    209    207    2835            &           2606    25342    claimed_markets market_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.claimed_markets
    ADD CONSTRAINT market_id_fkey FOREIGN KEY (market_id) REFERENCES public.markets(id);
 H   ALTER TABLE ONLY public.claimed_markets DROP CONSTRAINT market_id_fkey;
       public          flux    false    213    2835    207            %           2606    24782 "   resolution_windows markets_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.resolution_windows
    ADD CONSTRAINT markets_id_fkey FOREIGN KEY (market_id) REFERENCES public.markets(id);
 L   ALTER TABLE ONLY public.resolution_windows DROP CONSTRAINT markets_id_fkey;
       public          flux    false    207    2835    211            !           2606    24792 $   claimable_if_valids marketst_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.claimable_if_valids
    ADD CONSTRAINT marketst_id_fkey FOREIGN KEY (market_id) REFERENCES public.markets(id);
 N   ALTER TABLE ONLY public.claimable_if_valids DROP CONSTRAINT marketst_id_fkey;
       public          flux    false    207    2835    204            "           2606    24826    fills order_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.fills
    ADD CONSTRAINT order_id_fkey FOREIGN KEY (order_id, outcome, market_id) REFERENCES public.orders(id, outcome, market_id) NOT VALID;
 =   ALTER TABLE ONLY public.fills DROP CONSTRAINT order_id_fkey;
       public          flux    false    205    209    209    209    2839    205    205                        2606    16520 1   account_stake_in_outcomes resolution_windows_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.account_stake_in_outcomes
    ADD CONSTRAINT resolution_windows_fkey FOREIGN KEY (market_id, round) REFERENCES public.resolution_windows(market_id, round);
 [   ALTER TABLE ONLY public.account_stake_in_outcomes DROP CONSTRAINT resolution_windows_fkey;
       public          flux    false    211    211    202    202    2843            �      x������ � �      �      x�+I-.��KM,�4������ 3_�      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �       x�K�)��MI-�425@�"\1z\\\ U$
�      �      x������ � �     