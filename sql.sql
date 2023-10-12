/************ Create: Schemas ***************/

/* Add Schema: security */
CREATE SCHEMA security;

/* Add Schema: to-do */
CREATE SCHEMA "to-do";

/* Add extension: uuid-ossp */
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

/************ Create: Tables ***************/

/******************** Add Table: security.users ************************/

/* Build Table Structure */
CREATE TABLE security.users
(
	user_id UUID DEFAULT uuid_generate_v4() NOT NULL,
	user_fullname VARCHAR(500) NOT NULL,
	user_email VARCHAR(500) NOT NULL,
	user_password VARCHAR(128) NOT NULL,
	user_status BOOL DEFAULT true NOT NULL,
	user_created_at TIMESTAMP DEFAULT NOW() NOT NULL,
	user_updated_at TIMESTAMP NULL,
	user_deleted_at TIMESTAMP NULL
);

/* Add Primary Key */
ALTER TABLE security.users ADD CONSTRAINT pkusers
	PRIMARY KEY (user_id);

/* Add Comments */
COMMENT ON COLUMN security.users.user_id IS 'UUID del usuario';

COMMENT ON COLUMN security.users.user_fullname IS 'nombre completo del usuario';

COMMENT ON COLUMN security.users.user_email IS 'correo del usuario';

COMMENT ON COLUMN security.users.user_password IS 'contraseña del usuario en sha512';

COMMENT ON COLUMN security.users.user_status IS 'estado del usuario';

COMMENT ON COLUMN security.users.user_created_at IS 'cuándo fue creado';

COMMENT ON COLUMN security.users.user_updated_at IS 'cuándo fue actualizado';

COMMENT ON COLUMN security.users.user_deleted_at IS 'cuándo fue borrado';

/* Add Indexes */
CREATE UNIQUE INDEX "users_user_email_Idx" ON security.users (user_email, user_deleted_at);

CREATE INDEX "users_user_email_user_password_Idx" ON security.users (user_email, user_password);

CREATE INDEX "users_user_status_Idx" ON security.users (user_status, user_deleted_at);


/******************** Add Table: "to-do"."to_dos" ************************/

/* Build Table Structure */
CREATE TABLE "to-do"."to_dos"
(
	to_do_id UUID DEFAULT uuid_generate_v4() NOT NULL,
	user_id UUID NOT NULL,
	to_do_detail_from_id UUID NULL,
	to_do_title VARCHAR(500) NOT NULL,
	to_do_description VARCHAR(2048) NULL,
	to_do_completed BOOL DEFAULT false NOT NULL,
	to_do_status BOOL DEFAULT true NOT NULL,
	to_do_created_at TIMESTAMP DEFAULT NOW() NOT NULL,
	to_do_updated_at TIMESTAMP NULL,
	to_do_deleted_at TIMESTAMP NULL
);

/* Add Primary Key */
ALTER TABLE "to-do"."to_dos" ADD CONSTRAINT pkto_dos
	PRIMARY KEY (to_do_id);

/* Add Comments */
COMMENT ON COLUMN "to-do"."to_dos".to_do_id IS 'UUID de la tarea';

COMMENT ON COLUMN "to-do"."to_dos".user_id IS 'UUID del usuario al que le pertenece la tarea';

COMMENT ON COLUMN "to-do"."to_dos".to_do_detail_from_id IS 'UUID de la sub-tarea';

COMMENT ON COLUMN "to-do"."to_dos".to_do_title IS 'titulo de la tarea';

COMMENT ON COLUMN "to-do"."to_dos".to_do_description IS 'descripción de la tarea';

COMMENT ON COLUMN "to-do"."to_dos".to_do_completed IS 'estado de la tarea';

COMMENT ON COLUMN "to-do"."to_dos".to_do_status IS 'estado del registro';

COMMENT ON COLUMN "to-do"."to_dos".to_do_created_at IS 'cuándo fue creado';

COMMENT ON COLUMN "to-do"."to_dos".to_do_updated_at IS 'cuándo fue actualizado';

COMMENT ON COLUMN "to-do"."to_dos".to_do_deleted_at IS 'cuándo fue borrado';

/* Add Indexes */
CREATE UNIQUE INDEX "to_dos_to_do_detail_from_id_Idx" ON "to-do"."to_dos" (to_do_id, to_do_detail_from_id);

CREATE INDEX "to_dos_to_do_status_Idx" ON "to-do"."to_dos" (to_do_status, to_do_deleted_at);

CREATE INDEX "to_dos_user_id_Idx" ON "to-do"."to_dos" (user_id);


/************ Add Foreign Keys ***************/

/* Add Foreign Key: fk_to_dos_to_dos */
ALTER TABLE "to-do"."to_dos" ADD CONSTRAINT fk_to_dos_to_dos
	FOREIGN KEY (to_do_detail_from_id) REFERENCES "to-do"."to_dos" (to_do_id)
	ON UPDATE RESTRICT ON DELETE RESTRICT;

/* Add Foreign Key: fk_to_dos_users */
ALTER TABLE "to-do"."to_dos" ADD CONSTRAINT fk_to_dos_users
	FOREIGN KEY (user_id) REFERENCES security.users (user_id)
	ON UPDATE RESTRICT ON DELETE RESTRICT;
