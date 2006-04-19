--
-- This is the required schema for PostgreSQL. Load this into the
-- database using the psql interactive terminal:
--
--     template1=> \i db-setup.pgsql
--

-- CREATE DATABASE jabberd2;
-- \c jabberd2

--
-- c2s authentication/registration table
--
CREATE TABLE "authreg" (
    "username" varchar(1023) NOT NULL,
    "realm" varchar(1023) NOT NULL,
    "password" varchar(256),
    "token" varchar(10),
    "sequence" integer,
    "hash" varchar(40) );

CREATE SEQUENCE "object-sequence";

--
-- Session manager tables 
--

--
-- Active (seen) users
-- Used by: core
--
CREATE TABLE "active" (
    "collection-owner" text PRIMARY KEY,
    "object-sequence" bigint,
    "time" integer );

--
-- Logout times
-- Used by: mod_iq_last
--
CREATE TABLE "logout" (
    "collection-owner" text PRIMARY KEY,
    "object-sequence" bigint,
    "time" integer NOT NULL );

--
-- Roster items
-- Used by: mod_roster
--
CREATE TABLE "roster-items" (
    "collection-owner" text,
    "object-sequence" bigint,
    "jid" text NOT NULL,
    "name" text,
    "to" boolean NOT NULL,
    "from" boolean NOT NULL,
    "ask" integer NOT NULL,
    PRIMARY KEY ("collection-owner", "jid") );

CREATE INDEX i_rosteri_owner ON "roster-items" USING btree ("collection-owner");

--
-- Roster groups
-- Used by: mod_roster
--
CREATE TABLE "roster-groups" (
    "collection-owner" text,
    "object-sequence" bigint,
    "jid" text NOT NULL,
    "group" text NOT NULL,
    PRIMARY KEY ("collection-owner", "jid", "group") );

CREATE INDEX i_rosterg_owner ON "roster-groups" USING btree ("collection-owner");
CREATE INDEX i_rosterg_owner_jid ON "roster-groups" USING btree ("collection-owner", "jid");

--
-- vCard (user profile information)
-- Used by: mod_iq_vcard
--
CREATE TABLE "vcard" (
    "collection-owner" text PRIMARY KEY,
    "object-sequence" bigint,
    "fn" text,
    "nickname" text,
    "url" text,
    "tel" text,
    "email" text,
    "title" text,
    "role" text,
    "bday" text,
    "tz" text,
    "n-family" text,
    "n-given" text,
    "n-middle" text,
    "n-prefix" text,
    "n-suffix" text,
    "adr-street" text,
    "adr-extadd" text,
    "adr-pobox" text,
    "adr-locality" text,
    "adr-region" text,
    "adr-pcode" text,
    "adr-country" text,
    "geo-lat" text,
    "geo-lon" text,
    "org-orgname" text,
    "org-orgunit" text,
    "agent-extval" text,
    "sort-string" text,
    "desc" text,
    "note" text,
    
    "photo-type" text,
    "photo-binval" text,
    "photo-extval" text,
    
    "logo-type" text,
    "logo-binval" text,
    "logo-extval" text,
    
    "sound-phonetic" text,
    "sound-binval" text,
    "sound-extval" text,
    
    "key-type" text,
    "key-cred" text,
    
    "rev" text
    );

--
-- Offline message queue
-- Used by: mod_offline
--
CREATE TABLE "queue" (
    "collection-owner" text,
    "object-sequence" bigint,
    "xml" text NOT NULL );

CREATE INDEX i_queue_owner ON "queue" USING btree ("collection-owner");

--
-- Private XML storage
-- Used by: mod_iq_private
--
CREATE TABLE "private" (
    "collection-owner" text,
    "object-sequence" bigint,
    "ns" text,
    "xml" text,
    PRIMARY KEY ("collection-owner", "ns") );

CREATE INDEX i_private_owner ON "private" USING btree ("collection-owner");

--
-- Message Of The Day (MOTD) messages (announcements)
-- Used by: mod_announce
--
CREATE TABLE "motd-message" (
    "collection-owner" text PRIMARY KEY,
    "object-sequence" bigint,
    "xml" text NOT NULL);

--
-- Times of last MOTD message for each user
-- Used by: mod_announce
--
CREATE TABLE "motd-times" (
    "collection-owner" text PRIMARY KEY,
    "object-sequence" bigint,
    "time" integer NOT NULL);

--
-- User-published discovery items
-- Used by: mod_disco_publish
--
CREATE TABLE "disco-items" (
    "collection-owner" text,
    "object-sequence" bigint,
    "jid" text,
    "name" text,
    "node" text );

CREATE INDEX i_discoi_owner ON "disco-items" USING btree ("collection-owner");

--
-- Default privacy list
-- Used by: mod_privacy
--
CREATE TABLE "privacy-default" (
    "collection-owner" text PRIMARY KEY,
    "object-sequence" bigint,
    "default" text );

--
-- Privacy lists
-- Used by: mod_privacy
--
CREATE TABLE "privacy-items" (
    "collection-owner" text,
    "object-sequence" bigint,
    "list" text NOT NULL,
    "type" text,
    "value" text,
    "deny" boolean,
    "order" integer,
    "block" integer );

CREATE INDEX i_privacyi_owner ON "privacy-items" USING btree ("collection-owner");

--
-- Vacation settings
-- Used by: mod_vacation
--
CREATE TABLE "vacation-settings" (
    "collection-owner" text PRIMARY KEY,
    "object-sequence" bigint,
    "start" int,
    "end" int,
    "message" text );

--
-- User status information
-- Used by: mod_status
--
CREATE TABLE "status" (
    "collection-owner" text PRIMARY KEY,
    "object-sequence" bigint,
    "status" text NOT NULL,
    "show" text,
    "last-login" int DEFAULT '0',
    "last-logout" int DEFAULT '0' );