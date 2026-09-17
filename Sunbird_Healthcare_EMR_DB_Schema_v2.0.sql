-- ============================================================
-- HEALTHCARE CORE SYSTEM — EMR MODULE
-- Database Schema Script v1.0
-- Schema: emr
-- Database: PostgreSQL 14
-- Solutions Architect: Alaa Himour
-- Backend Engineer: Zeina Itriq
-- ============================================================

-- Create schema
CREATE SCHEMA IF NOT EXISTS emr;
SET search_path TO emr;

-- ============================================================
-- SEQUENCES
-- ============================================================
CREATE SEQUENCE IF NOT EXISTS emr_patients_rid_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS emr_patient_contact_rid_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS emr_patient_identifier_rid_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS emr_patient_log_rid_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS emr_encounters_rid_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS emr_encounter_log_rid_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS emr_adt_admit_rid_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS emr_adt_admit_log_rid_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS emr_adt_register_rid_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS emr_adt_register_log_rid_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS emr_adt_transfer_rid_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS emr_adt_transfer_log_rid_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS emr_adt_discharge_rid_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS emr_adt_discharge_log_rid_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS emr_adt_preadmit_rid_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS emr_adt_update_rid_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS emr_orm_order_rid_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS emr_orm_order_log_rid_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS emr_oru_result_rid_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS emr_oru_result_log_rid_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS emr_oru_observation_rid_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS emr_oru_observation_log_rid_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS emr_sch_appointment_rid_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS emr_sch_appointment_log_rid_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS emr_patient_vitals_rid_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS emr_patient_vitals_log_rid_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS emr_diagnoses_rid_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS emr_diagnoses_log_rid_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS emr_msg_inbound_rid_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS emr_msg_outbound_rid_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS emr_msg_transaction_rid_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS emr_msg_error_rid_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS emr_msg_ack_rid_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS emr_msg_retry_rid_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS emr_notif_template_rid_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS emr_notif_queue_rid_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS emr_notif_log_rid_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS emr_dashboard_daily_summary_rid_seq START 1 INCREMENT 1;

-- ============================================================
-- SECTION 1: PATIENT DOMAIN
-- ============================================================

CREATE TABLE emr_patients (
    rid                 BIGINT          NOT NULL DEFAULT nextval('emr_patients_rid_seq'),
    mrn                 VARCHAR(20)     NOT NULL,
    national_id         VARCHAR(20)     NULL,
    national_id_type    VARCHAR(10)     NULL,       -- NID / IQAMA / PASSPORT / OTHER
    first_name          VARCHAR(100)    NOT NULL,
    middle_name         VARCHAR(100)    NULL,
    last_name           VARCHAR(100)    NOT NULL,
    first_name_ar       VARCHAR(100)    NULL,
    last_name_ar        VARCHAR(100)    NULL,
    date_of_birth       DATE            NOT NULL,
    gender              VARCHAR(1)      NOT NULL,   -- M / F / U
    marital_status      VARCHAR(2)      NULL,       -- S / M / D / W
    nationality         VARCHAR(10)     NULL,       -- ISO 3166-1 alpha-3
    religion            VARCHAR(50)     NULL,
    blood_type          VARCHAR(5)      NULL,       -- A+/A-/B+/B-/AB+/AB-/O+/O-
    language            VARCHAR(10)     NULL,       -- AR / EN
    is_vip              BOOLEAN         NOT NULL DEFAULT FALSE,
    is_active           BOOLEAN         NOT NULL DEFAULT TRUE,
    entry_source        VARCHAR(20)     NOT NULL,   -- MANUAL / HL7 / FHIR
    transaction_rid     BIGINT          NULL,
    -- Audit fields
    version             BIGINT          NOT NULL DEFAULT 0,
    created_by          BIGINT          NOT NULL,
    creation_date       TIMESTAMP       NOT NULL DEFAULT NOW(),
    update_date         TIMESTAMP       NULL,
    updated_by          BIGINT          NULL,
    is_deleted          BOOLEAN         NOT NULL DEFAULT FALSE,
    deleted_at          TIMESTAMP       NULL,
    deleted_by          BIGINT          NULL,
    CONSTRAINT pk_emr_patients PRIMARY KEY (rid),
    CONSTRAINT uq_emr_patients_mrn UNIQUE (mrn)
);
CREATE INDEX idx_emr_patients_mrn ON emr_patients(mrn);
CREATE INDEX idx_emr_patients_national_id ON emr_patients(national_id);
CREATE INDEX idx_emr_patients_dob ON emr_patients(date_of_birth);
COMMENT ON TABLE emr_patients IS 'Patient master record. MRN is the primary business key. All transactions check MRN before processing.';

-- ─────────────────────────────────────────────────────────────
CREATE TABLE emr_patient_contact (
    rid                 BIGINT          NOT NULL DEFAULT nextval('emr_patient_contact_rid_seq'),
    patient_rid         BIGINT          NOT NULL,
    phone_mobile        VARCHAR(20)     NULL,
    phone_home          VARCHAR(20)     NULL,
    phone_work          VARCHAR(20)     NULL,
    email               VARCHAR(150)    NULL,
    address_line1       VARCHAR(200)    NULL,
    address_line2       VARCHAR(200)    NULL,
    city                VARCHAR(100)    NULL,
    region              VARCHAR(100)    NULL,
    postal_code         VARCHAR(20)     NULL,
    country             VARCHAR(10)     NULL,       -- ISO 3166-1 alpha-3
    emergency_name      VARCHAR(200)    NULL,
    emergency_relation  VARCHAR(50)     NULL,
    emergency_phone     VARCHAR(20)     NULL,
    entry_source        VARCHAR(20)     NOT NULL,
    transaction_rid     BIGINT          NULL,
    version             BIGINT          NOT NULL DEFAULT 0,
    created_by          BIGINT          NOT NULL,
    creation_date       TIMESTAMP       NOT NULL DEFAULT NOW(),
    update_date         TIMESTAMP       NULL,
    updated_by          BIGINT          NULL,
    is_deleted          BOOLEAN         NOT NULL DEFAULT FALSE,
    deleted_at          TIMESTAMP       NULL,
    deleted_by          BIGINT          NULL,
    CONSTRAINT pk_emr_patient_contact PRIMARY KEY (rid),
    CONSTRAINT fk_emr_patient_contact_patient FOREIGN KEY (patient_rid) REFERENCES emr_patients(rid)
);
CREATE INDEX idx_emr_patient_contact_patient ON emr_patient_contact(patient_rid);

-- ─────────────────────────────────────────────────────────────
CREATE TABLE emr_patient_identifier (
    rid                 BIGINT          NOT NULL DEFAULT nextval('emr_patient_identifier_rid_seq'),
    patient_rid         BIGINT          NOT NULL,
    id_type             VARCHAR(30)     NOT NULL,   -- PASSPORT / INSURANCE / FACILITY / BORDER
    id_value            VARCHAR(100)    NOT NULL,
    issuing_country     VARCHAR(10)     NULL,
    expiry_date         DATE            NULL,
    is_primary          BOOLEAN         NOT NULL DEFAULT FALSE,
    version             BIGINT          NOT NULL DEFAULT 0,
    created_by          BIGINT          NOT NULL,
    creation_date       TIMESTAMP       NOT NULL DEFAULT NOW(),
    update_date         TIMESTAMP       NULL,
    updated_by          BIGINT          NULL,
    is_deleted          BOOLEAN         NOT NULL DEFAULT FALSE,
    deleted_at          TIMESTAMP       NULL,
    deleted_by          BIGINT          NULL,
    CONSTRAINT pk_emr_patient_identifier PRIMARY KEY (rid),
    CONSTRAINT fk_emr_patient_identifier_patient FOREIGN KEY (patient_rid) REFERENCES emr_patients(rid)
);
CREATE INDEX idx_emr_patient_identifier_patient ON emr_patient_identifier(patient_rid);
CREATE INDEX idx_emr_patient_identifier_value ON emr_patient_identifier(id_value);

-- ─────────────────────────────────────────────────────────────
CREATE TABLE emr_patient_log (
    rid                 BIGINT          NOT NULL DEFAULT nextval('emr_patient_log_rid_seq'),
    patient_rid         BIGINT          NOT NULL,
    event_type          VARCHAR(20)     NOT NULL,   -- ADT_A08 / MANUAL_UPDATE / MRN_MERGE
    event_datetime      TIMESTAMP       NOT NULL DEFAULT NOW(),
    old_values          JSONB           NULL,
    new_values          JSONB           NULL,
    changed_by          BIGINT          NOT NULL,
    transaction_rid     BIGINT          NULL,
    version             BIGINT          NOT NULL DEFAULT 0,
    created_by          BIGINT          NOT NULL,
    creation_date       TIMESTAMP       NOT NULL DEFAULT NOW(),
    update_date         TIMESTAMP       NULL,
    updated_by          BIGINT          NULL,
    is_deleted          BOOLEAN         NOT NULL DEFAULT FALSE,
    deleted_at          TIMESTAMP       NULL,
    deleted_by          BIGINT          NULL,
    CONSTRAINT pk_emr_patient_log PRIMARY KEY (rid),
    CONSTRAINT fk_emr_patient_log_patient FOREIGN KEY (patient_rid) REFERENCES emr_patients(rid)
);
CREATE INDEX idx_emr_patient_log_patient ON emr_patient_log(patient_rid);
CREATE INDEX idx_emr_patient_log_event ON emr_patient_log(event_type, event_datetime);

-- ============================================================
-- SECTION 2: ENCOUNTER DOMAIN
-- ============================================================

CREATE TABLE emr_encounters (
    rid                 BIGINT          NOT NULL DEFAULT nextval('emr_encounters_rid_seq'),
    patient_rid         BIGINT          NOT NULL,
    mrn                 VARCHAR(20)     NOT NULL,
    visit_number        VARCHAR(50)     NOT NULL,
    patient_class       VARCHAR(2)      NOT NULL,   -- I=Inpatient O=Outpatient E=Emergency R=Recurring P=Preadmit
    encounter_status    VARCHAR(20)     NOT NULL DEFAULT 'PLANNED', -- PLANNED/ARRIVED/IN_PROGRESS/FINISHED/CANCELLED
    encounter_type      VARCHAR(50)     NULL,       -- ROUTINE / EMERGENCY / FOLLOW_UP / PROCEDURE
    admission_datetime  TIMESTAMP       NULL,
    discharge_datetime  TIMESTAMP       NULL,
    facility_code       VARCHAR(20)     NOT NULL,
    tenant_rid          BIGINT          NOT NULL,
    branch_rid          BIGINT          NOT NULL,
    attending_provider  VARCHAR(50)     NULL,
    referring_provider  VARCHAR(50)     NULL,
    primary_diagnosis   VARCHAR(20)     NULL,       -- ICD-10-AM
    entry_source        VARCHAR(20)     NOT NULL,
    transaction_rid     BIGINT          NULL,
    version             BIGINT          NOT NULL DEFAULT 0,
    created_by          BIGINT          NOT NULL,
    creation_date       TIMESTAMP       NOT NULL DEFAULT NOW(),
    update_date         TIMESTAMP       NULL,
    updated_by          BIGINT          NULL,
    is_deleted          BOOLEAN         NOT NULL DEFAULT FALSE,
    deleted_at          TIMESTAMP       NULL,
    deleted_by          BIGINT          NULL,
    CONSTRAINT pk_emr_encounters PRIMARY KEY (rid),
    CONSTRAINT uq_emr_encounters_visit UNIQUE (visit_number, tenant_rid),
    CONSTRAINT fk_emr_encounters_patient FOREIGN KEY (patient_rid) REFERENCES emr_patients(rid)
);
CREATE INDEX idx_emr_encounters_patient ON emr_encounters(patient_rid);
CREATE INDEX idx_emr_encounters_mrn ON emr_encounters(mrn);
CREATE INDEX idx_emr_encounters_class ON emr_encounters(patient_class);
CREATE INDEX idx_emr_encounters_status ON emr_encounters(encounter_status);
CREATE INDEX idx_emr_encounters_admission ON emr_encounters(admission_datetime);
COMMENT ON TABLE emr_encounters IS 'Master encounter table. One row per patient visit regardless of class (I/O/E/R/P). HL7 PV1-2 maps to patient_class.';

-- ─────────────────────────────────────────────────────────────
CREATE TABLE emr_encounter_log (
    rid                 BIGINT          NOT NULL DEFAULT nextval('emr_encounter_log_rid_seq'),
    encounter_rid       BIGINT          NOT NULL,
    event_type          VARCHAR(20)     NOT NULL,
    event_datetime      TIMESTAMP       NOT NULL DEFAULT NOW(),
    old_values          JSONB           NULL,
    new_values          JSONB           NULL,
    changed_by          BIGINT          NOT NULL,
    transaction_rid     BIGINT          NULL,
    version             BIGINT          NOT NULL DEFAULT 0,
    created_by          BIGINT          NOT NULL,
    creation_date       TIMESTAMP       NOT NULL DEFAULT NOW(),
    update_date         TIMESTAMP       NULL,
    updated_by          BIGINT          NULL,
    is_deleted          BOOLEAN         NOT NULL DEFAULT FALSE,
    deleted_at          TIMESTAMP       NULL,
    deleted_by          BIGINT          NULL,
    CONSTRAINT pk_emr_encounter_log PRIMARY KEY (rid),
    CONSTRAINT fk_emr_encounter_log_encounter FOREIGN KEY (encounter_rid) REFERENCES emr_encounters(rid)
);
CREATE INDEX idx_emr_encounter_log_encounter ON emr_encounter_log(encounter_rid);

-- ============================================================
-- SECTION 3: ADT DOMAIN
-- ============================================================

-- ADT A01 — Inpatient Admission
CREATE TABLE emr_adt_admit (
    rid                     BIGINT          NOT NULL DEFAULT nextval('emr_adt_admit_rid_seq'),
    encounter_rid           BIGINT          NOT NULL,
    patient_rid             BIGINT          NOT NULL,
    admit_datetime          TIMESTAMP       NOT NULL,
    admit_source            VARCHAR(10)     NULL,   -- PV1-14
    admit_type              VARCHAR(10)     NULL,   -- PV1-4: A=Accident E=Emergency R=Routine
    ward_code               VARCHAR(20)     NULL,
    room_code               VARCHAR(20)     NULL,
    bed_code                VARCHAR(20)     NULL,
    attending_provider_id   VARCHAR(50)     NULL,   -- PV1-7
    consulting_provider_id  VARCHAR(50)     NULL,   -- PV1-9
    admitting_provider_id   VARCHAR(50)     NULL,   -- PV1-17
    hospital_service        VARCHAR(20)     NULL,   -- PV1-10
    vip_indicator           VARCHAR(5)      NULL,   -- PV1-16
    admit_status            VARCHAR(20)     NOT NULL DEFAULT 'ACTIVE',
    entry_source            VARCHAR(20)     NOT NULL,
    transaction_rid         BIGINT          NULL,
    version                 BIGINT          NOT NULL DEFAULT 0,
    created_by              BIGINT          NOT NULL,
    creation_date           TIMESTAMP       NOT NULL DEFAULT NOW(),
    update_date             TIMESTAMP       NULL,
    updated_by              BIGINT          NULL,
    is_deleted              BOOLEAN         NOT NULL DEFAULT FALSE,
    deleted_at              TIMESTAMP       NULL,
    deleted_by              BIGINT          NULL,
    CONSTRAINT pk_emr_adt_admit PRIMARY KEY (rid),
    CONSTRAINT fk_emr_adt_admit_encounter FOREIGN KEY (encounter_rid) REFERENCES emr_encounters(rid),
    CONSTRAINT fk_emr_adt_admit_patient FOREIGN KEY (patient_rid) REFERENCES emr_patients(rid)
);
CREATE INDEX idx_emr_adt_admit_encounter ON emr_adt_admit(encounter_rid);
CREATE INDEX idx_emr_adt_admit_patient ON emr_adt_admit(patient_rid);
CREATE INDEX idx_emr_adt_admit_datetime ON emr_adt_admit(admit_datetime);
CREATE INDEX idx_emr_adt_admit_ward ON emr_adt_admit(ward_code);
COMMENT ON TABLE emr_adt_admit IS 'HL7 ADT A01 - Inpatient admission event. Master table holds current state.';

CREATE TABLE emr_adt_admit_log (
    rid                 BIGINT          NOT NULL DEFAULT nextval('emr_adt_admit_log_rid_seq'),
    adt_admit_rid       BIGINT          NOT NULL,
    event_type          VARCHAR(20)     NOT NULL,   -- A01 / A11=Cancel / MANUAL_UPDATE
    event_datetime      TIMESTAMP       NOT NULL DEFAULT NOW(),
    old_values          JSONB           NULL,
    new_values          JSONB           NULL,
    changed_by          BIGINT          NOT NULL,
    transaction_rid     BIGINT          NULL,
    version             BIGINT          NOT NULL DEFAULT 0,
    created_by          BIGINT          NOT NULL,
    creation_date       TIMESTAMP       NOT NULL DEFAULT NOW(),
    update_date         TIMESTAMP       NULL,
    updated_by          BIGINT          NULL,
    is_deleted          BOOLEAN         NOT NULL DEFAULT FALSE,
    deleted_at          TIMESTAMP       NULL,
    deleted_by          BIGINT          NULL,
    CONSTRAINT pk_emr_adt_admit_log PRIMARY KEY (rid),
    CONSTRAINT fk_emr_adt_admit_log_admit FOREIGN KEY (adt_admit_rid) REFERENCES emr_adt_admit(rid)
);
CREATE INDEX idx_emr_adt_admit_log_admit ON emr_adt_admit_log(adt_admit_rid);

-- ADT A04 — OPD/ED Registration
CREATE TABLE emr_adt_register (
    rid                     BIGINT          NOT NULL DEFAULT nextval('emr_adt_register_rid_seq'),
    encounter_rid           BIGINT          NOT NULL,
    patient_rid             BIGINT          NOT NULL,
    register_datetime       TIMESTAMP       NOT NULL,
    patient_class           VARCHAR(2)      NOT NULL,  -- O=OPD E=Emergency
    clinic_code             VARCHAR(20)     NULL,
    visit_reason            VARCHAR(500)    NULL,
    attending_provider_id   VARCHAR(50)     NULL,
    triage_category         VARCHAR(5)      NULL,      -- P1/P2/P3/P4/P5
    arrival_mode            VARCHAR(20)     NULL,      -- WALK_IN / AMBULANCE / TRANSFER
    register_status         VARCHAR(20)     NOT NULL DEFAULT 'ACTIVE',
    entry_source            VARCHAR(20)     NOT NULL,
    transaction_rid         BIGINT          NULL,
    version                 BIGINT          NOT NULL DEFAULT 0,
    created_by              BIGINT          NOT NULL,
    creation_date           TIMESTAMP       NOT NULL DEFAULT NOW(),
    update_date             TIMESTAMP       NULL,
    updated_by              BIGINT          NULL,
    is_deleted              BOOLEAN         NOT NULL DEFAULT FALSE,
    deleted_at              TIMESTAMP       NULL,
    deleted_by              BIGINT          NULL,
    CONSTRAINT pk_emr_adt_register PRIMARY KEY (rid),
    CONSTRAINT fk_emr_adt_register_encounter FOREIGN KEY (encounter_rid) REFERENCES emr_encounters(rid),
    CONSTRAINT fk_emr_adt_register_patient FOREIGN KEY (patient_rid) REFERENCES emr_patients(rid)
);
CREATE INDEX idx_emr_adt_register_encounter ON emr_adt_register(encounter_rid);
CREATE INDEX idx_emr_adt_register_patient ON emr_adt_register(patient_rid);
CREATE INDEX idx_emr_adt_register_datetime ON emr_adt_register(register_datetime);
COMMENT ON TABLE emr_adt_register IS 'HL7 ADT A04 - OPD and ED registration event.';

CREATE TABLE emr_adt_register_log (
    rid                 BIGINT          NOT NULL DEFAULT nextval('emr_adt_register_log_rid_seq'),
    adt_register_rid    BIGINT          NOT NULL,
    event_type          VARCHAR(20)     NOT NULL,
    event_datetime      TIMESTAMP       NOT NULL DEFAULT NOW(),
    old_values          JSONB           NULL,
    new_values          JSONB           NULL,
    changed_by          BIGINT          NOT NULL,
    transaction_rid     BIGINT          NULL,
    version             BIGINT          NOT NULL DEFAULT 0,
    created_by          BIGINT          NOT NULL,
    creation_date       TIMESTAMP       NOT NULL DEFAULT NOW(),
    update_date         TIMESTAMP       NULL,
    updated_by          BIGINT          NULL,
    is_deleted          BOOLEAN         NOT NULL DEFAULT FALSE,
    deleted_at          TIMESTAMP       NULL,
    deleted_by          BIGINT          NULL,
    CONSTRAINT pk_emr_adt_register_log PRIMARY KEY (rid),
    CONSTRAINT fk_emr_adt_register_log_reg FOREIGN KEY (adt_register_rid) REFERENCES emr_adt_register(rid)
);
CREATE INDEX idx_emr_adt_register_log_reg ON emr_adt_register_log(adt_register_rid);

-- ADT A02 — Transfer
CREATE TABLE emr_adt_transfer (
    rid                     BIGINT          NOT NULL DEFAULT nextval('emr_adt_transfer_rid_seq'),
    encounter_rid           BIGINT          NOT NULL,
    patient_rid             BIGINT          NOT NULL,
    transfer_datetime       TIMESTAMP       NOT NULL,
    from_ward               VARCHAR(20)     NULL,
    from_room               VARCHAR(20)     NULL,
    from_bed                VARCHAR(20)     NULL,
    to_ward                 VARCHAR(20)     NULL,
    to_room                 VARCHAR(20)     NULL,
    to_bed                  VARCHAR(20)     NULL,
    transfer_reason         VARCHAR(200)    NULL,
    attending_provider_id   VARCHAR(50)     NULL,
    transfer_status         VARCHAR(20)     NOT NULL DEFAULT 'ACTIVE',
    entry_source            VARCHAR(20)     NOT NULL,
    transaction_rid         BIGINT          NULL,
    version                 BIGINT          NOT NULL DEFAULT 0,
    created_by              BIGINT          NOT NULL,
    creation_date           TIMESTAMP       NOT NULL DEFAULT NOW(),
    update_date             TIMESTAMP       NULL,
    updated_by              BIGINT          NULL,
    is_deleted              BOOLEAN         NOT NULL DEFAULT FALSE,
    deleted_at              TIMESTAMP       NULL,
    deleted_by              BIGINT          NULL,
    CONSTRAINT pk_emr_adt_transfer PRIMARY KEY (rid),
    CONSTRAINT fk_emr_adt_transfer_encounter FOREIGN KEY (encounter_rid) REFERENCES emr_encounters(rid),
    CONSTRAINT fk_emr_adt_transfer_patient FOREIGN KEY (patient_rid) REFERENCES emr_patients(rid)
);
CREATE INDEX idx_emr_adt_transfer_encounter ON emr_adt_transfer(encounter_rid);
COMMENT ON TABLE emr_adt_transfer IS 'HL7 ADT A02 - Patient transfer between wards/units.';

CREATE TABLE emr_adt_transfer_log (
    rid                 BIGINT          NOT NULL DEFAULT nextval('emr_adt_transfer_log_rid_seq'),
    adt_transfer_rid    BIGINT          NOT NULL,
    event_type          VARCHAR(20)     NOT NULL,   -- A02 / A12=Cancel
    event_datetime      TIMESTAMP       NOT NULL DEFAULT NOW(),
    old_values          JSONB           NULL,
    new_values          JSONB           NULL,
    changed_by          BIGINT          NOT NULL,
    transaction_rid     BIGINT          NULL,
    version             BIGINT          NOT NULL DEFAULT 0,
    created_by          BIGINT          NOT NULL,
    creation_date       TIMESTAMP       NOT NULL DEFAULT NOW(),
    update_date         TIMESTAMP       NULL,
    updated_by          BIGINT          NULL,
    is_deleted          BOOLEAN         NOT NULL DEFAULT FALSE,
    deleted_at          TIMESTAMP       NULL,
    deleted_by          BIGINT          NULL,
    CONSTRAINT pk_emr_adt_transfer_log PRIMARY KEY (rid),
    CONSTRAINT fk_emr_adt_transfer_log_tr FOREIGN KEY (adt_transfer_rid) REFERENCES emr_adt_transfer(rid)
);
CREATE INDEX idx_emr_adt_transfer_log_tr ON emr_adt_transfer_log(adt_transfer_rid);

-- ADT A03 — Discharge
CREATE TABLE emr_adt_discharge (
    rid                         BIGINT          NOT NULL DEFAULT nextval('emr_adt_discharge_rid_seq'),
    encounter_rid               BIGINT          NOT NULL,
    patient_rid                 BIGINT          NOT NULL,
    discharge_datetime          TIMESTAMP       NOT NULL,
    discharge_disposition       VARCHAR(10)     NULL,   -- PV1-36
    discharge_to_location       VARCHAR(100)    NULL,
    length_of_stay_days         INTEGER         NULL,
    attending_provider_id       VARCHAR(50)     NULL,
    discharge_condition         VARCHAR(20)     NULL,   -- GOOD/FAIR/POOR/EXPIRED
    discharge_status            VARCHAR(20)     NOT NULL DEFAULT 'COMPLETED',
    entry_source                VARCHAR(20)     NOT NULL,
    transaction_rid             BIGINT          NULL,
    version                     BIGINT          NOT NULL DEFAULT 0,
    created_by                  BIGINT          NOT NULL,
    creation_date               TIMESTAMP       NOT NULL DEFAULT NOW(),
    update_date                 TIMESTAMP       NULL,
    updated_by                  BIGINT          NULL,
    is_deleted                  BOOLEAN         NOT NULL DEFAULT FALSE,
    deleted_at                  TIMESTAMP       NULL,
    deleted_by                  BIGINT          NULL,
    CONSTRAINT pk_emr_adt_discharge PRIMARY KEY (rid),
    CONSTRAINT fk_emr_adt_discharge_encounter FOREIGN KEY (encounter_rid) REFERENCES emr_encounters(rid),
    CONSTRAINT fk_emr_adt_discharge_patient FOREIGN KEY (patient_rid) REFERENCES emr_patients(rid)
);
CREATE INDEX idx_emr_adt_discharge_encounter ON emr_adt_discharge(encounter_rid);
CREATE INDEX idx_emr_adt_discharge_datetime ON emr_adt_discharge(discharge_datetime);
COMMENT ON TABLE emr_adt_discharge IS 'HL7 ADT A03 - Patient discharge event.';

CREATE TABLE emr_adt_discharge_log (
    rid                 BIGINT          NOT NULL DEFAULT nextval('emr_adt_discharge_log_rid_seq'),
    adt_discharge_rid   BIGINT          NOT NULL,
    event_type          VARCHAR(20)     NOT NULL,   -- A03 / A13=Cancel
    event_datetime      TIMESTAMP       NOT NULL DEFAULT NOW(),
    old_values          JSONB           NULL,
    new_values          JSONB           NULL,
    changed_by          BIGINT          NOT NULL,
    transaction_rid     BIGINT          NULL,
    version             BIGINT          NOT NULL DEFAULT 0,
    created_by          BIGINT          NOT NULL,
    creation_date       TIMESTAMP       NOT NULL DEFAULT NOW(),
    update_date         TIMESTAMP       NULL,
    updated_by          BIGINT          NULL,
    is_deleted          BOOLEAN         NOT NULL DEFAULT FALSE,
    deleted_at          TIMESTAMP       NULL,
    deleted_by          BIGINT          NULL,
    CONSTRAINT pk_emr_adt_discharge_log PRIMARY KEY (rid),
    CONSTRAINT fk_emr_adt_discharge_log_d FOREIGN KEY (adt_discharge_rid) REFERENCES emr_adt_discharge(rid)
);
CREATE INDEX idx_emr_adt_discharge_log_d ON emr_adt_discharge_log(adt_discharge_rid);

-- ADT A05 — Pre-Admit
CREATE TABLE emr_adt_preadmit (
    rid                     BIGINT          NOT NULL DEFAULT nextval('emr_adt_preadmit_rid_seq'),
    encounter_rid           BIGINT          NOT NULL,
    patient_rid             BIGINT          NOT NULL,
    preadmit_datetime       TIMESTAMP       NOT NULL,
    planned_admit_date      DATE            NULL,
    planned_ward            VARCHAR(20)     NULL,
    planned_procedure       VARCHAR(200)    NULL,
    attending_provider_id   VARCHAR(50)     NULL,
    preadmit_status         VARCHAR(20)     NOT NULL DEFAULT 'PENDING',
    entry_source            VARCHAR(20)     NOT NULL,
    transaction_rid         BIGINT          NULL,
    version                 BIGINT          NOT NULL DEFAULT 0,
    created_by              BIGINT          NOT NULL,
    creation_date           TIMESTAMP       NOT NULL DEFAULT NOW(),
    update_date             TIMESTAMP       NULL,
    updated_by              BIGINT          NULL,
    is_deleted              BOOLEAN         NOT NULL DEFAULT FALSE,
    deleted_at              TIMESTAMP       NULL,
    deleted_by              BIGINT          NULL,
    CONSTRAINT pk_emr_adt_preadmit PRIMARY KEY (rid),
    CONSTRAINT fk_emr_adt_preadmit_encounter FOREIGN KEY (encounter_rid) REFERENCES emr_encounters(rid),
    CONSTRAINT fk_emr_adt_preadmit_patient FOREIGN KEY (patient_rid) REFERENCES emr_patients(rid)
);
CREATE INDEX idx_emr_adt_preadmit_encounter ON emr_adt_preadmit(encounter_rid);

-- ADT A08 — Update
CREATE TABLE emr_adt_update (
    rid                 BIGINT          NOT NULL DEFAULT nextval('emr_adt_update_rid_seq'),
    encounter_rid       BIGINT          NOT NULL,
    patient_rid         BIGINT          NOT NULL,
    update_datetime     TIMESTAMP       NOT NULL,
    updated_segment     VARCHAR(10)     NULL,   -- PID / PV1 / NK1
    old_values          JSONB           NULL,
    new_values          JSONB           NULL,
    update_reason       VARCHAR(200)    NULL,
    entry_source        VARCHAR(20)     NOT NULL,
    transaction_rid     BIGINT          NULL,
    version             BIGINT          NOT NULL DEFAULT 0,
    created_by          BIGINT          NOT NULL,
    creation_date       TIMESTAMP       NOT NULL DEFAULT NOW(),
    update_date         TIMESTAMP       NULL,
    updated_by          BIGINT          NULL,
    is_deleted          BOOLEAN         NOT NULL DEFAULT FALSE,
    deleted_at          TIMESTAMP       NULL,
    deleted_by          BIGINT          NULL,
    CONSTRAINT pk_emr_adt_update PRIMARY KEY (rid),
    CONSTRAINT fk_emr_adt_update_encounter FOREIGN KEY (encounter_rid) REFERENCES emr_encounters(rid),
    CONSTRAINT fk_emr_adt_update_patient FOREIGN KEY (patient_rid) REFERENCES emr_patients(rid)
);
CREATE INDEX idx_emr_adt_update_encounter ON emr_adt_update(encounter_rid);

-- ============================================================
-- SECTION 4: ORM DOMAIN
-- ============================================================

CREATE TABLE emr_orm_order (
    rid                     BIGINT          NOT NULL DEFAULT nextval('emr_orm_order_rid_seq'),
    encounter_rid           BIGINT          NOT NULL,
    patient_rid             BIGINT          NOT NULL,
    placer_order_number     VARCHAR(50)     NOT NULL,
    filler_order_number     VARCHAR(50)     NULL,
    order_type              VARCHAR(10)     NOT NULL,   -- LAB / RAD / OTHER
    order_control           VARCHAR(5)      NOT NULL,   -- NW / CA / OC
    order_status            VARCHAR(20)     NOT NULL DEFAULT 'ORDERED',
    service_code            VARCHAR(50)     NULL,       -- LOINC/local
    service_name            VARCHAR(200)    NULL,
    priority                VARCHAR(10)     NULL,       -- R=Routine S=Stat A=ASAP
    ordered_datetime        TIMESTAMP       NOT NULL,
    collection_datetime     TIMESTAMP       NULL,
    ordering_provider_id    VARCHAR(50)     NULL,
    department_code         VARCHAR(20)     NULL,
    clinical_info           VARCHAR(500)    NULL,
    specimen_type           VARCHAR(50)     NULL,
    body_site               VARCHAR(100)    NULL,
    entry_source            VARCHAR(20)     NOT NULL,
    transaction_rid         BIGINT          NULL,
    version                 BIGINT          NOT NULL DEFAULT 0,
    created_by              BIGINT          NOT NULL,
    creation_date           TIMESTAMP       NOT NULL DEFAULT NOW(),
    update_date             TIMESTAMP       NULL,
    updated_by              BIGINT          NULL,
    is_deleted              BOOLEAN         NOT NULL DEFAULT FALSE,
    deleted_at              TIMESTAMP       NULL,
    deleted_by              BIGINT          NULL,
    CONSTRAINT pk_emr_orm_order PRIMARY KEY (rid),
    CONSTRAINT uq_emr_orm_order_placer UNIQUE (placer_order_number),
    CONSTRAINT fk_emr_orm_order_encounter FOREIGN KEY (encounter_rid) REFERENCES emr_encounters(rid),
    CONSTRAINT fk_emr_orm_order_patient FOREIGN KEY (patient_rid) REFERENCES emr_patients(rid)
);
CREATE INDEX idx_emr_orm_order_encounter ON emr_orm_order(encounter_rid);
CREATE INDEX idx_emr_orm_order_patient ON emr_orm_order(patient_rid);
CREATE INDEX idx_emr_orm_order_status ON emr_orm_order(order_status);
CREATE INDEX idx_emr_orm_order_type ON emr_orm_order(order_type);
COMMENT ON TABLE emr_orm_order IS 'HL7 ORM O01 - Clinical orders master. Covers lab and radiology orders.';

CREATE TABLE emr_orm_order_log (
    rid                 BIGINT          NOT NULL DEFAULT nextval('emr_orm_order_log_rid_seq'),
    orm_order_rid       BIGINT          NOT NULL,
    event_type          VARCHAR(20)     NOT NULL,   -- NW / CA / OC / SC
    event_datetime      TIMESTAMP       NOT NULL DEFAULT NOW(),
    old_values          JSONB           NULL,
    new_values          JSONB           NULL,
    changed_by          BIGINT          NOT NULL,
    transaction_rid     BIGINT          NULL,
    version             BIGINT          NOT NULL DEFAULT 0,
    created_by          BIGINT          NOT NULL,
    creation_date       TIMESTAMP       NOT NULL DEFAULT NOW(),
    update_date         TIMESTAMP       NULL,
    updated_by          BIGINT          NULL,
    is_deleted          BOOLEAN         NOT NULL DEFAULT FALSE,
    deleted_at          TIMESTAMP       NULL,
    deleted_by          BIGINT          NULL,
    CONSTRAINT pk_emr_orm_order_log PRIMARY KEY (rid),
    CONSTRAINT fk_emr_orm_order_log_order FOREIGN KEY (orm_order_rid) REFERENCES emr_orm_order(rid)
);
CREATE INDEX idx_emr_orm_order_log_order ON emr_orm_order_log(orm_order_rid);

-- ============================================================
-- SECTION 5: ORU DOMAIN
-- ============================================================

CREATE TABLE emr_oru_result (
    rid                     BIGINT          NOT NULL DEFAULT nextval('emr_oru_result_rid_seq'),
    encounter_rid           BIGINT          NOT NULL,
    patient_rid             BIGINT          NOT NULL,
    order_rid               BIGINT          NULL,
    placer_order_number     VARCHAR(50)     NULL,
    filler_order_number     VARCHAR(50)     NULL,
    result_type             VARCHAR(10)     NOT NULL,   -- LAB / RAD / VITAL / OTHER
    service_code            VARCHAR(50)     NULL,
    service_name            VARCHAR(200)    NULL,
    result_status           VARCHAR(5)      NOT NULL,   -- F/P/C/X
    result_datetime         TIMESTAMP       NOT NULL,
    report_datetime         TIMESTAMP       NULL,
    performing_lab          VARCHAR(100)    NULL,
    interpreting_provider   VARCHAR(50)     NULL,
    clinical_info           VARCHAR(500)    NULL,
    has_critical            BOOLEAN         NOT NULL DEFAULT FALSE,
    entry_source            VARCHAR(20)     NOT NULL,
    transaction_rid         BIGINT          NULL,
    version                 BIGINT          NOT NULL DEFAULT 0,
    created_by              BIGINT          NOT NULL,
    creation_date           TIMESTAMP       NOT NULL DEFAULT NOW(),
    update_date             TIMESTAMP       NULL,
    updated_by              BIGINT          NULL,
    is_deleted              BOOLEAN         NOT NULL DEFAULT FALSE,
    deleted_at              TIMESTAMP       NULL,
    deleted_by              BIGINT          NULL,
    CONSTRAINT pk_emr_oru_result PRIMARY KEY (rid),
    CONSTRAINT fk_emr_oru_result_encounter FOREIGN KEY (encounter_rid) REFERENCES emr_encounters(rid),
    CONSTRAINT fk_emr_oru_result_patient FOREIGN KEY (patient_rid) REFERENCES emr_patients(rid),
    CONSTRAINT fk_emr_oru_result_order FOREIGN KEY (order_rid) REFERENCES emr_orm_order(rid)
);
CREATE INDEX idx_emr_oru_result_encounter ON emr_oru_result(encounter_rid);
CREATE INDEX idx_emr_oru_result_patient ON emr_oru_result(patient_rid);
CREATE INDEX idx_emr_oru_result_critical ON emr_oru_result(has_critical) WHERE has_critical = TRUE;
COMMENT ON TABLE emr_oru_result IS 'HL7 ORU R01 - Result report header. One row per result report.';

CREATE TABLE emr_oru_result_log (
    rid                 BIGINT          NOT NULL DEFAULT nextval('emr_oru_result_log_rid_seq'),
    oru_result_rid      BIGINT          NOT NULL,
    event_type          VARCHAR(20)     NOT NULL,
    event_datetime      TIMESTAMP       NOT NULL DEFAULT NOW(),
    old_values          JSONB           NULL,
    new_values          JSONB           NULL,
    changed_by          BIGINT          NOT NULL,
    transaction_rid     BIGINT          NULL,
    version             BIGINT          NOT NULL DEFAULT 0,
    created_by          BIGINT          NOT NULL,
    creation_date       TIMESTAMP       NOT NULL DEFAULT NOW(),
    update_date         TIMESTAMP       NULL,
    updated_by          BIGINT          NULL,
    is_deleted          BOOLEAN         NOT NULL DEFAULT FALSE,
    deleted_at          TIMESTAMP       NULL,
    deleted_by          BIGINT          NULL,
    CONSTRAINT pk_emr_oru_result_log PRIMARY KEY (rid),
    CONSTRAINT fk_emr_oru_result_log_result FOREIGN KEY (oru_result_rid) REFERENCES emr_oru_result(rid)
);

CREATE TABLE emr_oru_observation (
    rid                     BIGINT          NOT NULL DEFAULT nextval('emr_oru_observation_rid_seq'),
    result_rid              BIGINT          NOT NULL,
    obx_sequence            INTEGER         NOT NULL,
    value_type              VARCHAR(5)      NOT NULL,   -- NM/ST/CWE/TX/FT/SN/DT
    observation_code        VARCHAR(50)     NOT NULL,   -- LOINC
    observation_name        VARCHAR(200)    NOT NULL,
    observation_value       TEXT            NULL,
    units                   VARCHAR(50)     NULL,
    reference_range         VARCHAR(100)    NULL,
    abnormal_flag           VARCHAR(5)      NULL,       -- N/L/H/LL/HH/A/AA/C
    is_critical             BOOLEAN         NOT NULL DEFAULT FALSE,
    observation_status      VARCHAR(5)      NOT NULL,   -- F/P/C/X/R
    observation_datetime    TIMESTAMP       NULL,
    performing_org          VARCHAR(100)    NULL,
    entry_source            VARCHAR(20)     NOT NULL,
    transaction_rid         BIGINT          NULL,
    version                 BIGINT          NOT NULL DEFAULT 0,
    created_by              BIGINT          NOT NULL,
    creation_date           TIMESTAMP       NOT NULL DEFAULT NOW(),
    update_date             TIMESTAMP       NULL,
    updated_by              BIGINT          NULL,
    is_deleted              BOOLEAN         NOT NULL DEFAULT FALSE,
    deleted_at              TIMESTAMP       NULL,
    deleted_by              BIGINT          NULL,
    CONSTRAINT pk_emr_oru_observation PRIMARY KEY (rid),
    CONSTRAINT fk_emr_oru_observation_result FOREIGN KEY (result_rid) REFERENCES emr_oru_result(rid)
);
CREATE INDEX idx_emr_oru_observation_result ON emr_oru_observation(result_rid);
CREATE INDEX idx_emr_oru_observation_critical ON emr_oru_observation(is_critical) WHERE is_critical = TRUE;
CREATE INDEX idx_emr_oru_observation_code ON emr_oru_observation(observation_code);
COMMENT ON TABLE emr_oru_observation IS 'Individual OBX segments. One row per observation per result report.';

CREATE TABLE emr_oru_observation_log (
    rid                     BIGINT          NOT NULL DEFAULT nextval('emr_oru_observation_log_rid_seq'),
    oru_observation_rid     BIGINT          NOT NULL,
    event_type              VARCHAR(20)     NOT NULL,
    event_datetime          TIMESTAMP       NOT NULL DEFAULT NOW(),
    old_values              JSONB           NULL,
    new_values              JSONB           NULL,
    changed_by              BIGINT          NOT NULL,
    transaction_rid         BIGINT          NULL,
    version                 BIGINT          NOT NULL DEFAULT 0,
    created_by              BIGINT          NOT NULL,
    creation_date           TIMESTAMP       NOT NULL DEFAULT NOW(),
    update_date             TIMESTAMP       NULL,
    updated_by              BIGINT          NULL,
    is_deleted              BOOLEAN         NOT NULL DEFAULT FALSE,
    deleted_at              TIMESTAMP       NULL,
    deleted_by              BIGINT          NULL,
    CONSTRAINT pk_emr_oru_observation_log PRIMARY KEY (rid),
    CONSTRAINT fk_emr_oru_observation_log_obs FOREIGN KEY (oru_observation_rid) REFERENCES emr_oru_observation(rid)
);

-- ============================================================
-- SECTION 6: SCH DOMAIN
-- ============================================================

CREATE TABLE emr_sch_appointment (
    rid                     BIGINT          NOT NULL DEFAULT nextval('emr_sch_appointment_rid_seq'),
    patient_rid             BIGINT          NOT NULL,
    encounter_rid           BIGINT          NULL,
    placer_appointment_id   VARCHAR(50)     NOT NULL,
    filler_appointment_id   VARCHAR(50)     NULL,
    appointment_status      VARCHAR(20)     NOT NULL DEFAULT 'SCHEDULED',
    appointment_type        VARCHAR(50)     NULL,
    appointment_reason      VARCHAR(200)    NULL,
    start_datetime          TIMESTAMP       NOT NULL,
    end_datetime            TIMESTAMP       NULL,
    duration_minutes        INTEGER         NULL,
    clinic_code             VARCHAR(20)     NULL,
    resource_id             VARCHAR(50)     NULL,
    provider_id             VARCHAR(50)     NULL,
    entry_source            VARCHAR(20)     NOT NULL,
    transaction_rid         BIGINT          NULL,
    version                 BIGINT          NOT NULL DEFAULT 0,
    created_by              BIGINT          NOT NULL,
    creation_date           TIMESTAMP       NOT NULL DEFAULT NOW(),
    update_date             TIMESTAMP       NULL,
    updated_by              BIGINT          NULL,
    is_deleted              BOOLEAN         NOT NULL DEFAULT FALSE,
    deleted_at              TIMESTAMP       NULL,
    deleted_by              BIGINT          NULL,
    CONSTRAINT pk_emr_sch_appointment PRIMARY KEY (rid),
    CONSTRAINT uq_emr_sch_appointment_placer UNIQUE (placer_appointment_id),
    CONSTRAINT fk_emr_sch_appointment_patient FOREIGN KEY (patient_rid) REFERENCES emr_patients(rid),
    CONSTRAINT fk_emr_sch_appointment_encounter FOREIGN KEY (encounter_rid) REFERENCES emr_encounters(rid)
);
CREATE INDEX idx_emr_sch_appointment_patient ON emr_sch_appointment(patient_rid);
CREATE INDEX idx_emr_sch_appointment_start ON emr_sch_appointment(start_datetime);
CREATE INDEX idx_emr_sch_appointment_status ON emr_sch_appointment(appointment_status);
CREATE INDEX idx_emr_sch_appointment_clinic ON emr_sch_appointment(clinic_code);
COMMENT ON TABLE emr_sch_appointment IS 'HL7 SCH - Appointment master. S12/S13/S14/S15 events tracked in log table.';

CREATE TABLE emr_sch_appointment_log (
    rid                 BIGINT          NOT NULL DEFAULT nextval('emr_sch_appointment_log_rid_seq'),
    appointment_rid     BIGINT          NOT NULL,
    event_type          VARCHAR(5)      NOT NULL,   -- S12/S13/S14/S15
    event_datetime      TIMESTAMP       NOT NULL DEFAULT NOW(),
    old_values          JSONB           NULL,
    new_values          JSONB           NULL,
    changed_by          BIGINT          NOT NULL,
    cancel_reason       VARCHAR(200)    NULL,
    transaction_rid     BIGINT          NULL,
    version             BIGINT          NOT NULL DEFAULT 0,
    created_by          BIGINT          NOT NULL,
    creation_date       TIMESTAMP       NOT NULL DEFAULT NOW(),
    update_date         TIMESTAMP       NULL,
    updated_by          BIGINT          NULL,
    is_deleted          BOOLEAN         NOT NULL DEFAULT FALSE,
    deleted_at          TIMESTAMP       NULL,
    deleted_by          BIGINT          NULL,
    CONSTRAINT pk_emr_sch_appointment_log PRIMARY KEY (rid),
    CONSTRAINT fk_emr_sch_appointment_log_appt FOREIGN KEY (appointment_rid) REFERENCES emr_sch_appointment(rid)
);
CREATE INDEX idx_emr_sch_appointment_log_appt ON emr_sch_appointment_log(appointment_rid);

-- ============================================================
-- SECTION 7: VITALS DOMAIN
-- ============================================================

CREATE TABLE emr_patient_vitals (
    rid                 BIGINT          NOT NULL DEFAULT nextval('emr_patient_vitals_rid_seq'),
    encounter_rid       BIGINT          NOT NULL,
    patient_rid         BIGINT          NOT NULL,
    observation_code    VARCHAR(20)     NOT NULL,   -- LOINC
    observation_name    VARCHAR(100)    NOT NULL,
    value_numeric       NUMERIC(10,4)   NULL,
    value_text          VARCHAR(200)    NULL,
    unit                VARCHAR(20)     NULL,
    reference_range     VARCHAR(100)    NULL,
    abnormal_flag       VARCHAR(5)      NULL,       -- N/L/H/LL/HH
    is_critical         BOOLEAN         NOT NULL DEFAULT FALSE,
    recorded_datetime   TIMESTAMP       NOT NULL,
    recorded_by         BIGINT          NOT NULL,
    device_id           VARCHAR(50)     NULL,
    entry_source        VARCHAR(20)     NOT NULL,   -- MANUAL / HL7 / FHIR / DEVICE
    transaction_rid     BIGINT          NULL,
    version             BIGINT          NOT NULL DEFAULT 0,
    created_by          BIGINT          NOT NULL,
    creation_date       TIMESTAMP       NOT NULL DEFAULT NOW(),
    update_date         TIMESTAMP       NULL,
    updated_by          BIGINT          NULL,
    is_deleted          BOOLEAN         NOT NULL DEFAULT FALSE,
    deleted_at          TIMESTAMP       NULL,
    deleted_by          BIGINT          NULL,
    CONSTRAINT pk_emr_patient_vitals PRIMARY KEY (rid),
    CONSTRAINT fk_emr_patient_vitals_encounter FOREIGN KEY (encounter_rid) REFERENCES emr_encounters(rid),
    CONSTRAINT fk_emr_patient_vitals_patient FOREIGN KEY (patient_rid) REFERENCES emr_patients(rid)
);
CREATE INDEX idx_emr_patient_vitals_encounter ON emr_patient_vitals(encounter_rid);
CREATE INDEX idx_emr_patient_vitals_patient ON emr_patient_vitals(patient_rid);
CREATE INDEX idx_emr_patient_vitals_code ON emr_patient_vitals(observation_code);
CREATE INDEX idx_emr_patient_vitals_critical ON emr_patient_vitals(is_critical) WHERE is_critical = TRUE;
COMMENT ON TABLE emr_patient_vitals IS 'LOINC-coded triage and intake vitals. One row per observation per visit.';

CREATE TABLE emr_patient_vitals_log (
    rid                 BIGINT          NOT NULL DEFAULT nextval('emr_patient_vitals_log_rid_seq'),
    vitals_rid          BIGINT          NOT NULL,
    event_type          VARCHAR(20)     NOT NULL,
    event_datetime      TIMESTAMP       NOT NULL DEFAULT NOW(),
    old_values          JSONB           NULL,
    new_values          JSONB           NULL,
    changed_by          BIGINT          NOT NULL,
    transaction_rid     BIGINT          NULL,
    version             BIGINT          NOT NULL DEFAULT 0,
    created_by          BIGINT          NOT NULL,
    creation_date       TIMESTAMP       NOT NULL DEFAULT NOW(),
    update_date         TIMESTAMP       NULL,
    updated_by          BIGINT          NULL,
    is_deleted          BOOLEAN         NOT NULL DEFAULT FALSE,
    deleted_at          TIMESTAMP       NULL,
    deleted_by          BIGINT          NULL,
    CONSTRAINT pk_emr_patient_vitals_log PRIMARY KEY (rid),
    CONSTRAINT fk_emr_patient_vitals_log_v FOREIGN KEY (vitals_rid) REFERENCES emr_patient_vitals(rid)
);

-- ============================================================
-- SECTION 8: DIAGNOSES DOMAIN
-- ============================================================

CREATE TABLE emr_diagnoses (
    rid                 BIGINT          NOT NULL DEFAULT nextval('emr_diagnoses_rid_seq'),
    encounter_rid       BIGINT          NOT NULL,
    patient_rid         BIGINT          NOT NULL,
    diagnosis_code      VARCHAR(20)     NOT NULL,   -- ICD-10-AM
    diagnosis_desc      VARCHAR(500)    NOT NULL,
    diagnosis_desc_ar   VARCHAR(500)    NULL,
    diagnosis_type      VARCHAR(15)     NOT NULL,   -- PRIMARY/SECONDARY/ADMITTING/WORKING/DISCHARGE
    diagnosis_rank      INTEGER         NULL,
    onset_date          DATE            NULL,
    diagnosed_by        VARCHAR(50)     NULL,
    diagnosis_status    VARCHAR(20)     NOT NULL DEFAULT 'ACTIVE',
    entry_source        VARCHAR(20)     NOT NULL,
    transaction_rid     BIGINT          NULL,
    version             BIGINT          NOT NULL DEFAULT 0,
    created_by          BIGINT          NOT NULL,
    creation_date       TIMESTAMP       NOT NULL DEFAULT NOW(),
    update_date         TIMESTAMP       NULL,
    updated_by          BIGINT          NULL,
    is_deleted          BOOLEAN         NOT NULL DEFAULT FALSE,
    deleted_at          TIMESTAMP       NULL,
    deleted_by          BIGINT          NULL,
    CONSTRAINT pk_emr_diagnoses PRIMARY KEY (rid),
    CONSTRAINT fk_emr_diagnoses_encounter FOREIGN KEY (encounter_rid) REFERENCES emr_encounters(rid),
    CONSTRAINT fk_emr_diagnoses_patient FOREIGN KEY (patient_rid) REFERENCES emr_patients(rid)
);
CREATE INDEX idx_emr_diagnoses_encounter ON emr_diagnoses(encounter_rid);
CREATE INDEX idx_emr_diagnoses_patient ON emr_diagnoses(patient_rid);
CREATE INDEX idx_emr_diagnoses_code ON emr_diagnoses(diagnosis_code);

CREATE TABLE emr_diagnoses_log (
    rid                 BIGINT          NOT NULL DEFAULT nextval('emr_diagnoses_log_rid_seq'),
    diagnoses_rid       BIGINT          NOT NULL,
    event_type          VARCHAR(20)     NOT NULL,
    event_datetime      TIMESTAMP       NOT NULL DEFAULT NOW(),
    old_values          JSONB           NULL,
    new_values          JSONB           NULL,
    changed_by          BIGINT          NOT NULL,
    transaction_rid     BIGINT          NULL,
    version             BIGINT          NOT NULL DEFAULT 0,
    created_by          BIGINT          NOT NULL,
    creation_date       TIMESTAMP       NOT NULL DEFAULT NOW(),
    update_date         TIMESTAMP       NULL,
    updated_by          BIGINT          NULL,
    is_deleted          BOOLEAN         NOT NULL DEFAULT FALSE,
    deleted_at          TIMESTAMP       NULL,
    deleted_by          BIGINT          NULL,
    CONSTRAINT pk_emr_diagnoses_log PRIMARY KEY (rid),
    CONSTRAINT fk_emr_diagnoses_log_d FOREIGN KEY (diagnoses_rid) REFERENCES emr_diagnoses(rid)
);

-- ============================================================
-- SECTION 9: INTEGRATION MESSAGING DOMAIN
-- ============================================================

CREATE TABLE emr_msg_inbound (
    rid                     BIGINT          NOT NULL DEFAULT nextval('emr_msg_inbound_rid_seq'),
    message_uid             VARCHAR(100)    NOT NULL,
    message_control_id      VARCHAR(50)     NOT NULL,   -- MSH-10
    message_type            VARCHAR(10)     NOT NULL,   -- ADT/ORM/ORU/SCH
    event_type              VARCHAR(10)     NOT NULL,   -- A01/O01/R01/S12
    message_version         VARCHAR(10)     NOT NULL,   -- 2.3/2.5/R4
    protocol                VARCHAR(10)     NOT NULL,   -- HL7V2/FHIR
    source_system           VARCHAR(100)    NULL,       -- MSH-3
    source_facility         VARCHAR(100)    NULL,       -- MSH-4
    raw_message             TEXT            NOT NULL,
    received_datetime       TIMESTAMP       NOT NULL DEFAULT NOW(),
    patient_mrn             VARCHAR(20)     NULL,
    processing_status       VARCHAR(20)     NOT NULL DEFAULT 'RECEIVED',
    tenant_rid              BIGINT          NOT NULL,
    branch_rid              BIGINT          NOT NULL,
    version                 BIGINT          NOT NULL DEFAULT 0,
    created_by              BIGINT          NOT NULL DEFAULT 0,
    creation_date           TIMESTAMP       NOT NULL DEFAULT NOW(),
    update_date             TIMESTAMP       NULL,
    updated_by              BIGINT          NULL,
    is_deleted              BOOLEAN         NOT NULL DEFAULT FALSE,
    deleted_at              TIMESTAMP       NULL,
    deleted_by              BIGINT          NULL,
    CONSTRAINT pk_emr_msg_inbound PRIMARY KEY (rid),
    CONSTRAINT uq_emr_msg_inbound_uid UNIQUE (message_uid)
);
CREATE INDEX idx_emr_msg_inbound_type ON emr_msg_inbound(message_type, event_type);
CREATE INDEX idx_emr_msg_inbound_status ON emr_msg_inbound(processing_status);
CREATE INDEX idx_emr_msg_inbound_mrn ON emr_msg_inbound(patient_mrn);
CREATE INDEX idx_emr_msg_inbound_received ON emr_msg_inbound(received_datetime);
COMMENT ON TABLE emr_msg_inbound IS 'Raw inbound messages before processing. Supports HL7 v2 and FHIR R4.';

CREATE TABLE emr_msg_outbound (
    rid                     BIGINT          NOT NULL DEFAULT nextval('emr_msg_outbound_rid_seq'),
    message_uid             VARCHAR(100)    NOT NULL,
    message_control_id      VARCHAR(50)     NOT NULL,
    message_type            VARCHAR(10)     NOT NULL,
    event_type              VARCHAR(10)     NOT NULL,
    protocol                VARCHAR(10)     NOT NULL,   -- HL7V2/FHIR
    target_system           VARCHAR(100)    NULL,       -- MSH-5
    target_facility         VARCHAR(100)    NULL,       -- MSH-6
    raw_message             TEXT            NOT NULL,
    trigger_event           VARCHAR(50)     NULL,       -- DB trigger that generated this
    sent_datetime           TIMESTAMP       NULL,
    delivery_status         VARCHAR(20)     NOT NULL DEFAULT 'PENDING',
    patient_mrn             VARCHAR(20)     NULL,
    inbound_msg_rid         BIGINT          NULL,
    tenant_rid              BIGINT          NOT NULL,
    version                 BIGINT          NOT NULL DEFAULT 0,
    created_by              BIGINT          NOT NULL DEFAULT 0,
    creation_date           TIMESTAMP       NOT NULL DEFAULT NOW(),
    update_date             TIMESTAMP       NULL,
    updated_by              BIGINT          NULL,
    is_deleted              BOOLEAN         NOT NULL DEFAULT FALSE,
    deleted_at              TIMESTAMP       NULL,
    deleted_by              BIGINT          NULL,
    CONSTRAINT pk_emr_msg_outbound PRIMARY KEY (rid),
    CONSTRAINT fk_emr_msg_outbound_inbound FOREIGN KEY (inbound_msg_rid) REFERENCES emr_msg_inbound(rid)
);
CREATE INDEX idx_emr_msg_outbound_status ON emr_msg_outbound(delivery_status);
CREATE INDEX idx_emr_msg_outbound_type ON emr_msg_outbound(message_type, event_type);

CREATE TABLE emr_msg_transaction (
    rid                     BIGINT          NOT NULL DEFAULT nextval('emr_msg_transaction_rid_seq'),
    inbound_msg_rid         BIGINT          NULL,
    transaction_status      VARCHAR(20)     NOT NULL DEFAULT 'RECEIVED',
    parsed_datetime         TIMESTAMP       NULL,
    validated_datetime      TIMESTAMP       NULL,
    processed_datetime      TIMESTAMP       NULL,
    failed_datetime         TIMESTAMP       NULL,
    affected_table          VARCHAR(100)    NULL,
    affected_rid            BIGINT          NULL,
    processing_duration_ms  INTEGER         NULL,
    notify_channel          VARCHAR(50)     NULL,       -- pg_notify channel
    entry_source            VARCHAR(20)     NOT NULL,
    version                 BIGINT          NOT NULL DEFAULT 0,
    created_by              BIGINT          NOT NULL DEFAULT 0,
    creation_date           TIMESTAMP       NOT NULL DEFAULT NOW(),
    update_date             TIMESTAMP       NULL,
    updated_by              BIGINT          NULL,
    is_deleted              BOOLEAN         NOT NULL DEFAULT FALSE,
    deleted_at              TIMESTAMP       NULL,
    deleted_by              BIGINT          NULL,
    CONSTRAINT pk_emr_msg_transaction PRIMARY KEY (rid),
    CONSTRAINT fk_emr_msg_transaction_inbound FOREIGN KEY (inbound_msg_rid) REFERENCES emr_msg_inbound(rid)
);
CREATE INDEX idx_emr_msg_transaction_inbound ON emr_msg_transaction(inbound_msg_rid);
CREATE INDEX idx_emr_msg_transaction_status ON emr_msg_transaction(transaction_status);
CREATE INDEX idx_emr_msg_transaction_table ON emr_msg_transaction(affected_table);

CREATE TABLE emr_msg_error (
    rid                 BIGINT          NOT NULL DEFAULT nextval('emr_msg_error_rid_seq'),
    transaction_rid     BIGINT          NOT NULL,
    error_code          VARCHAR(20)     NULL,
    error_segment       VARCHAR(10)     NULL,   -- PID/PV1/OBX
    error_field         VARCHAR(20)     NULL,
    error_description   TEXT            NOT NULL,
    severity            VARCHAR(10)     NOT NULL,  -- ERROR/WARNING/INFO
    resolved            BOOLEAN         NOT NULL DEFAULT FALSE,
    resolved_datetime   TIMESTAMP       NULL,
    resolved_by         BIGINT          NULL,
    version             BIGINT          NOT NULL DEFAULT 0,
    created_by          BIGINT          NOT NULL DEFAULT 0,
    creation_date       TIMESTAMP       NOT NULL DEFAULT NOW(),
    update_date         TIMESTAMP       NULL,
    updated_by          BIGINT          NULL,
    is_deleted          BOOLEAN         NOT NULL DEFAULT FALSE,
    deleted_at          TIMESTAMP       NULL,
    deleted_by          BIGINT          NULL,
    CONSTRAINT pk_emr_msg_error PRIMARY KEY (rid),
    CONSTRAINT fk_emr_msg_error_transaction FOREIGN KEY (transaction_rid) REFERENCES emr_msg_transaction(rid)
);
CREATE INDEX idx_emr_msg_error_transaction ON emr_msg_error(transaction_rid);
CREATE INDEX idx_emr_msg_error_severity ON emr_msg_error(severity);
CREATE INDEX idx_emr_msg_error_resolved ON emr_msg_error(resolved);

CREATE TABLE emr_msg_ack (
    rid                 BIGINT          NOT NULL DEFAULT nextval('emr_msg_ack_rid_seq'),
    transaction_rid     BIGINT          NOT NULL,
    ack_type            VARCHAR(10)     NOT NULL,   -- AA/AE/AR or 200/400/500
    ack_code            VARCHAR(20)     NULL,
    ack_message         TEXT            NULL,
    ack_datetime        TIMESTAMP       NOT NULL DEFAULT NOW(),
    ack_sent            BOOLEAN         NOT NULL DEFAULT FALSE,
    version             BIGINT          NOT NULL DEFAULT 0,
    created_by          BIGINT          NOT NULL DEFAULT 0,
    creation_date       TIMESTAMP       NOT NULL DEFAULT NOW(),
    update_date         TIMESTAMP       NULL,
    updated_by          BIGINT          NULL,
    is_deleted          BOOLEAN         NOT NULL DEFAULT FALSE,
    deleted_at          TIMESTAMP       NULL,
    deleted_by          BIGINT          NULL,
    CONSTRAINT pk_emr_msg_ack PRIMARY KEY (rid),
    CONSTRAINT fk_emr_msg_ack_transaction FOREIGN KEY (transaction_rid) REFERENCES emr_msg_transaction(rid)
);
CREATE INDEX idx_emr_msg_ack_transaction ON emr_msg_ack(transaction_rid);

CREATE TABLE emr_msg_retry (
    rid                 BIGINT          NOT NULL DEFAULT nextval('emr_msg_retry_rid_seq'),
    transaction_rid     BIGINT          NOT NULL,
    retry_attempt       INTEGER         NOT NULL,
    retry_datetime      TIMESTAMP       NOT NULL DEFAULT NOW(),
    retry_status        VARCHAR(20)     NOT NULL,   -- SUCCESS/FAILED
    retry_reason        VARCHAR(200)    NULL,
    retry_by            BIGINT          NULL,
    version             BIGINT          NOT NULL DEFAULT 0,
    created_by          BIGINT          NOT NULL DEFAULT 0,
    creation_date       TIMESTAMP       NOT NULL DEFAULT NOW(),
    update_date         TIMESTAMP       NULL,
    updated_by          BIGINT          NULL,
    is_deleted          BOOLEAN         NOT NULL DEFAULT FALSE,
    deleted_at          TIMESTAMP       NULL,
    deleted_by          BIGINT          NULL,
    CONSTRAINT pk_emr_msg_retry PRIMARY KEY (rid),
    CONSTRAINT fk_emr_msg_retry_transaction FOREIGN KEY (transaction_rid) REFERENCES emr_msg_transaction(rid)
);
CREATE INDEX idx_emr_msg_retry_transaction ON emr_msg_retry(transaction_rid);

-- ============================================================
-- SECTION 10: NOTIFICATION DOMAIN
-- ============================================================

CREATE TABLE emr_notif_template (
    rid                 BIGINT          NOT NULL DEFAULT nextval('emr_notif_template_rid_seq'),
    template_code       VARCHAR(50)     NOT NULL,
    event_type          VARCHAR(20)     NOT NULL,
    language            VARCHAR(5)      NOT NULL,   -- AR / EN
    channel             VARCHAR(20)     NOT NULL,   -- SMS/WHATSAPP/EMAIL
    subject             VARCHAR(200)    NULL,
    body_template       TEXT            NOT NULL,
    is_active           BOOLEAN         NOT NULL DEFAULT TRUE,
    description         VARCHAR(500)    NULL,
    version             BIGINT          NOT NULL DEFAULT 0,
    created_by          BIGINT          NOT NULL,
    creation_date       TIMESTAMP       NOT NULL DEFAULT NOW(),
    update_date         TIMESTAMP       NULL,
    updated_by          BIGINT          NULL,
    is_deleted          BOOLEAN         NOT NULL DEFAULT FALSE,
    deleted_at          TIMESTAMP       NULL,
    deleted_by          BIGINT          NULL,
    CONSTRAINT pk_emr_notif_template PRIMARY KEY (rid),
    CONSTRAINT uq_emr_notif_template UNIQUE (template_code, language, channel)
);
CREATE INDEX idx_emr_notif_template_event ON emr_notif_template(event_type);

CREATE TABLE emr_notif_queue (
    rid                 BIGINT          NOT NULL DEFAULT nextval('emr_notif_queue_rid_seq'),
    patient_rid         BIGINT          NOT NULL,
    encounter_rid       BIGINT          NULL,
    template_rid        BIGINT          NOT NULL,
    event_type          VARCHAR(20)     NOT NULL,
    channel             VARCHAR(20)     NOT NULL,
    recipient_phone     VARCHAR(20)     NULL,
    recipient_email     VARCHAR(150)    NULL,
    message_body        TEXT            NOT NULL,
    queue_status        VARCHAR(20)     NOT NULL DEFAULT 'PENDING',
    queued_datetime     TIMESTAMP       NOT NULL DEFAULT NOW(),
    sent_datetime       TIMESTAMP       NULL,
    failed_reason       VARCHAR(500)    NULL,
    retry_count         INTEGER         NOT NULL DEFAULT 0,
    transaction_rid     BIGINT          NULL,
    version             BIGINT          NOT NULL DEFAULT 0,
    created_by          BIGINT          NOT NULL DEFAULT 0,
    creation_date       TIMESTAMP       NOT NULL DEFAULT NOW(),
    update_date         TIMESTAMP       NULL,
    updated_by          BIGINT          NULL,
    is_deleted          BOOLEAN         NOT NULL DEFAULT FALSE,
    deleted_at          TIMESTAMP       NULL,
    deleted_by          BIGINT          NULL,
    CONSTRAINT pk_emr_notif_queue PRIMARY KEY (rid),
    CONSTRAINT fk_emr_notif_queue_patient FOREIGN KEY (patient_rid) REFERENCES emr_patients(rid),
    CONSTRAINT fk_emr_notif_queue_template FOREIGN KEY (template_rid) REFERENCES emr_notif_template(rid)
);
CREATE INDEX idx_emr_notif_queue_status ON emr_notif_queue(queue_status);
CREATE INDEX idx_emr_notif_queue_patient ON emr_notif_queue(patient_rid);

CREATE TABLE emr_notif_log (
    rid                 BIGINT          NOT NULL DEFAULT nextval('emr_notif_log_rid_seq'),
    queue_rid           BIGINT          NOT NULL,
    patient_rid         BIGINT          NOT NULL,
    event_type          VARCHAR(20)     NOT NULL,
    channel             VARCHAR(20)     NOT NULL,
    delivery_status     VARCHAR(20)     NOT NULL,
    delivery_datetime   TIMESTAMP       NULL,
    provider_response   VARCHAR(500)    NULL,
    version             BIGINT          NOT NULL DEFAULT 0,
    created_by          BIGINT          NOT NULL DEFAULT 0,
    creation_date       TIMESTAMP       NOT NULL DEFAULT NOW(),
    update_date         TIMESTAMP       NULL,
    updated_by          BIGINT          NULL,
    is_deleted          BOOLEAN         NOT NULL DEFAULT FALSE,
    deleted_at          TIMESTAMP       NULL,
    deleted_by          BIGINT          NULL,
    CONSTRAINT pk_emr_notif_log PRIMARY KEY (rid),
    CONSTRAINT fk_emr_notif_log_queue FOREIGN KEY (queue_rid) REFERENCES emr_notif_queue(rid),
    CONSTRAINT fk_emr_notif_log_patient FOREIGN KEY (patient_rid) REFERENCES emr_patients(rid)
);
CREATE INDEX idx_emr_notif_log_patient ON emr_notif_log(patient_rid);
CREATE INDEX idx_emr_notif_log_status ON emr_notif_log(delivery_status);

-- ============================================================
-- SECTION 11: DASHBOARD DOMAIN
-- ============================================================

CREATE TABLE emr_dashboard_daily_summary (
    rid                         BIGINT      NOT NULL DEFAULT nextval('emr_dashboard_daily_summary_rid_seq'),
    summary_date                DATE        NOT NULL,
    tenant_rid                  BIGINT      NOT NULL,
    branch_rid                  BIGINT      NOT NULL,
    total_patients              INTEGER     NOT NULL DEFAULT 0,
    new_mrns_today              INTEGER     NOT NULL DEFAULT 0,
    active_encounters           INTEGER     NOT NULL DEFAULT 0,
    opd_visits_today            INTEGER     NOT NULL DEFAULT 0,
    inpatient_admissions        INTEGER     NOT NULL DEFAULT 0,
    pending_discharges          INTEGER     NOT NULL DEFAULT 0,
    appointments_today          INTEGER     NOT NULL DEFAULT 0,
    appointments_cancelled      INTEGER     NOT NULL DEFAULT 0,
    appointments_noshow         INTEGER     NOT NULL DEFAULT 0,
    pending_orders              INTEGER     NOT NULL DEFAULT 0,
    completed_results           INTEGER     NOT NULL DEFAULT 0,
    critical_results            INTEGER     NOT NULL DEFAULT 0,
    msg_received_today          INTEGER     NOT NULL DEFAULT 0,
    msg_processed_today         INTEGER     NOT NULL DEFAULT 0,
    msg_failed_today            INTEGER     NOT NULL DEFAULT 0,
    manual_entries_today        INTEGER     NOT NULL DEFAULT 0,
    last_refreshed              TIMESTAMP   NOT NULL DEFAULT NOW(),
    version                     BIGINT      NOT NULL DEFAULT 0,
    created_by                  BIGINT      NOT NULL DEFAULT 0,
    creation_date               TIMESTAMP   NOT NULL DEFAULT NOW(),
    update_date                 TIMESTAMP   NULL,
    updated_by                  BIGINT      NULL,
    is_deleted                  BOOLEAN     NOT NULL DEFAULT FALSE,
    deleted_at                  TIMESTAMP   NULL,
    deleted_by                  BIGINT      NULL,
    CONSTRAINT pk_emr_dashboard_daily_summary PRIMARY KEY (rid),
    CONSTRAINT uq_emr_dashboard_daily UNIQUE (summary_date, tenant_rid, branch_rid)
);
CREATE INDEX idx_emr_dashboard_date ON emr_dashboard_daily_summary(summary_date);

-- ============================================================
-- SECTION 12: STORED PROCEDURES & TRIGGERS
-- ============================================================

-- ─── MRN CHECK ───────────────────────────────────────────────
CREATE OR REPLACE FUNCTION emr.sp_emr_mrn_check(p_mrn VARCHAR(20))
RETURNS BIGINT AS $$
DECLARE
    v_patient_rid BIGINT;
BEGIN
    SELECT rid INTO v_patient_rid
    FROM emr.emr_patients
    WHERE mrn = p_mrn AND is_deleted = FALSE;
    RETURN v_patient_rid; -- NULL if not found
END;
$$ LANGUAGE plpgsql;
COMMENT ON FUNCTION emr.sp_emr_mrn_check IS 'Check if MRN exists. Returns patient_rid or NULL. Called before every transaction.';

-- ─── MESSAGE ROUTER ──────────────────────────────────────────
CREATE OR REPLACE FUNCTION emr.sp_emr_msg_route()
RETURNS TRIGGER AS $$
DECLARE
    v_transaction_rid BIGINT;
    v_channel VARCHAR(50);
BEGIN
    -- Create transaction record
    INSERT INTO emr.emr_msg_transaction (
        inbound_msg_rid, transaction_status, entry_source,
        notify_channel, created_by, creation_date
    ) VALUES (
        NEW.rid, 'RECEIVED', NEW.protocol,
        'emr.' || LOWER(NEW.message_type), 0, NOW()
    ) RETURNING rid INTO v_transaction_rid;

    -- Update inbound status
    UPDATE emr.emr_msg_inbound
    SET processing_status = 'PARSED', update_date = NOW()
    WHERE rid = NEW.rid;

    -- Route by message type and event
    v_channel := 'emr.' || LOWER(NEW.message_type);

    -- Fire pg_notify with transaction payload
    PERFORM pg_notify(
        v_channel,
        json_build_object(
            'transaction_rid',  v_transaction_rid,
            'inbound_rid',      NEW.rid,
            'message_type',     NEW.message_type,
            'event_type',       NEW.event_type,
            'patient_mrn',      NEW.patient_mrn,
            'protocol',         NEW.protocol,
            'source_system',    NEW.source_system
        )::text
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_emr_msg_inbound_insert
    AFTER INSERT ON emr.emr_msg_inbound
    FOR EACH ROW EXECUTE FUNCTION emr.sp_emr_msg_route();
COMMENT ON TRIGGER trg_emr_msg_inbound_insert ON emr.emr_msg_inbound
    IS 'Fires on every inbound message insert. Routes to Spring Boot via pg_notify.';

-- ─── ADT ADMIT TRIGGER → HL7 OUTBOUND BUILDER ────────────────
CREATE OR REPLACE FUNCTION emr.fn_emr_build_hl7_adt_a01(p_admit_rid BIGINT)
RETURNS TEXT AS $$
DECLARE
    v_admit     emr.emr_adt_admit%ROWTYPE;
    v_enc       emr.emr_encounters%ROWTYPE;
    v_pat       emr.emr_patients%ROWTYPE;
    v_msg_ctrl  VARCHAR(20);
    v_hl7       TEXT;
BEGIN
    SELECT * INTO v_admit FROM emr.emr_adt_admit WHERE rid = p_admit_rid;
    SELECT * INTO v_enc   FROM emr.emr_encounters  WHERE rid = v_admit.encounter_rid;
    SELECT * INTO v_pat   FROM emr.emr_patients     WHERE rid = v_admit.patient_rid;

    v_msg_ctrl := 'MSG' || TO_CHAR(NOW(), 'YYYYMMDDHH24MISS');

    v_hl7 :=
        'MSH|^~\&|EMR|' || v_enc.facility_code || '|EXT_SYS||' ||
        TO_CHAR(NOW(), 'YYYYMMDDH24MISS') || '||ADT^A01^ADT_A01|' ||
        v_msg_ctrl || '|P|2.5|||AL|NE||UNICODE UTF-8' || E'\r' ||
        'EVN|A01|' || TO_CHAR(v_admit.admit_datetime, 'YYYYMMDDH24MISS') || E'\r' ||
        'PID|1||' || v_pat.mrn || '^^^FAC^MR||' ||
        v_pat.last_name || '^' || v_pat.first_name || '||' ||
        TO_CHAR(v_pat.date_of_birth, 'YYYYMMDD') || '|' || v_pat.gender || E'\r' ||
        'PV1|1|I|' || COALESCE(v_admit.ward_code,'') || '^' ||
        COALESCE(v_admit.room_code,'') || '^' || COALESCE(v_admit.bed_code,'') ||
        '|||' || COALESCE(v_admit.attending_provider_id,'') ||
        '|||' || COALESCE(v_admit.hospital_service,'') ||
        '||||||||||||||||||||||||' ||
        TO_CHAR(v_admit.admit_datetime, 'YYYYMMDDH24MISS') || E'\r';

    RETURN v_hl7;
END;
$$ LANGUAGE plpgsql;
COMMENT ON FUNCTION emr.fn_emr_build_hl7_adt_a01 IS 'Builds HL7 v2 ADT A01 message from admit record. FHIR builder fn_emr_build_fhir_adt_a01 reserved for Phase 2.';

-- ─── ADT ADMIT OUTBOUND TRIGGER ──────────────────────────────
CREATE OR REPLACE FUNCTION emr.trg_fn_emr_adt_admit_outbound()
RETURNS TRIGGER AS $$
DECLARE
    v_hl7_msg   TEXT;
    v_msg_uid   VARCHAR(100);
BEGIN
    v_hl7_msg := emr.fn_emr_build_hl7_adt_a01(NEW.rid);
    v_msg_uid  := 'OUT-A01-' || NEW.rid || '-' || EXTRACT(EPOCH FROM NOW())::BIGINT;

    INSERT INTO emr.emr_msg_outbound (
        message_uid, message_control_id, message_type, event_type,
        protocol, raw_message, trigger_event, delivery_status,
        patient_mrn, tenant_rid, created_by, creation_date
    )
    SELECT
        v_msg_uid,
        'MSG' || TO_CHAR(NOW(), 'YYYYMMDDHH24MISS'),
        'ADT', 'A01', 'HL7V2',
        v_hl7_msg,
        'trg_emr_adt_admit_insert',
        'PENDING',
        p.mrn,
        e.tenant_rid,
        0, NOW()
    FROM emr.emr_encounters e
    JOIN emr.emr_patients p ON p.rid = e.patient_rid
    WHERE e.rid = NEW.encounter_rid;

    -- Notify Spring Boot
    PERFORM pg_notify('emr.adt', json_build_object(
        'event',        'A01',
        'admit_rid',    NEW.rid,
        'patient_rid',  NEW.patient_rid,
        'entry_source', NEW.entry_source
    )::text);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_emr_adt_admit_insert
    AFTER INSERT ON emr.emr_adt_admit
    FOR EACH ROW EXECUTE FUNCTION emr.trg_fn_emr_adt_admit_outbound();

-- ─── NOTIFICATION FIRE PROCEDURE ────────────────────────────
CREATE OR REPLACE FUNCTION emr.sp_emr_notif_fire(
    p_event_type    VARCHAR(20),
    p_patient_rid   BIGINT,
    p_encounter_rid BIGINT DEFAULT NULL
)
RETURNS VOID AS $$
DECLARE
    v_template      emr.emr_notif_template%ROWTYPE;
    v_patient       emr.emr_patients%ROWTYPE;
    v_encounter     emr.emr_encounters%ROWTYPE;
    v_admit         emr.emr_adt_admit%ROWTYPE;
    v_body          TEXT;
BEGIN
    SELECT * INTO v_patient FROM emr.emr_patients WHERE rid = p_patient_rid;
    IF p_encounter_rid IS NOT NULL THEN
        SELECT * INTO v_encounter FROM emr.emr_encounters WHERE rid = p_encounter_rid;
        SELECT * INTO v_admit FROM emr.emr_adt_admit
            WHERE encounter_rid = p_encounter_rid ORDER BY rid DESC LIMIT 1;
    END IF;

    FOR v_template IN
        SELECT * FROM emr.emr_notif_template
        WHERE event_type = p_event_type AND is_active = TRUE AND is_deleted = FALSE
    LOOP
        v_body := v_template.body_template;
        -- Resolve placeholders
        v_body := REPLACE(v_body, '{{patient_name}}',    COALESCE(v_patient.first_name || ' ' || v_patient.last_name, ''));
        v_body := REPLACE(v_body, '{{patient_name_ar}}', COALESCE(v_patient.first_name_ar || ' ' || v_patient.last_name_ar, ''));
        v_body := REPLACE(v_body, '{{mrn}}',             COALESCE(v_patient.mrn, ''));
        v_body := REPLACE(v_body, '{{ward}}',            COALESCE(v_admit.ward_code, ''));
        v_body := REPLACE(v_body, '{{bed}}',             COALESCE(v_admit.bed_code, ''));

        INSERT INTO emr.emr_notif_queue (
            patient_rid, encounter_rid, template_rid, event_type,
            channel, message_body, queue_status, queued_datetime,
            created_by, creation_date
        ) VALUES (
            p_patient_rid, p_encounter_rid, v_template.rid, p_event_type,
            v_template.channel, v_body, 'PENDING', NOW(), 0, NOW()
        );
    END LOOP;

    -- Notify Spring Boot notification listener
    PERFORM pg_notify('emr.notif', json_build_object(
        'event_type',    p_event_type,
        'patient_rid',   p_patient_rid,
        'encounter_rid', p_encounter_rid
    )::text);
END;
$$ LANGUAGE plpgsql;
COMMENT ON FUNCTION emr.sp_emr_notif_fire IS 'Resolves template placeholders and queues notifications. Called by ADT/SCH triggers.';

-- ─── DASHBOARD REFRESH PROCEDURE ─────────────────────────────
CREATE OR REPLACE FUNCTION emr.sp_emr_refresh_dashboard(
    p_tenant_rid BIGINT,
    p_branch_rid BIGINT
)
RETURNS VOID AS $$
DECLARE
    v_today DATE := CURRENT_DATE;
BEGIN
    INSERT INTO emr.emr_dashboard_daily_summary (
        summary_date, tenant_rid, branch_rid,
        total_patients, new_mrns_today, active_encounters,
        opd_visits_today, inpatient_admissions, pending_discharges,
        appointments_today, appointments_cancelled, appointments_noshow,
        pending_orders, completed_results, critical_results,
        msg_received_today, msg_processed_today, msg_failed_today,
        manual_entries_today, last_refreshed, created_by, creation_date
    )
    SELECT
        v_today, p_tenant_rid, p_branch_rid,
        (SELECT COUNT(*) FROM emr.emr_patients WHERE is_deleted=FALSE),
        (SELECT COUNT(*) FROM emr.emr_patients WHERE DATE(creation_date)=v_today AND is_deleted=FALSE),
        (SELECT COUNT(*) FROM emr.emr_encounters WHERE encounter_status='IN_PROGRESS' AND tenant_rid=p_tenant_rid),
        (SELECT COUNT(*) FROM emr.emr_adt_register WHERE DATE(register_datetime)=v_today AND is_deleted=FALSE),
        (SELECT COUNT(*) FROM emr.emr_adt_admit WHERE DATE(admit_datetime)=v_today AND is_deleted=FALSE),
        (SELECT COUNT(*) FROM emr.emr_adt_admit WHERE admit_status='ACTIVE' AND is_deleted=FALSE),
        (SELECT COUNT(*) FROM emr.emr_sch_appointment WHERE DATE(start_datetime)=v_today AND is_deleted=FALSE),
        (SELECT COUNT(*) FROM emr.emr_sch_appointment WHERE DATE(start_datetime)=v_today AND appointment_status='CANCELLED'),
        (SELECT COUNT(*) FROM emr.emr_sch_appointment WHERE DATE(start_datetime)=v_today AND appointment_status='NOSHOW'),
        (SELECT COUNT(*) FROM emr.emr_orm_order WHERE order_status='ORDERED' AND is_deleted=FALSE),
        (SELECT COUNT(*) FROM emr.emr_oru_result WHERE DATE(result_datetime)=v_today AND result_status='F'),
        (SELECT COUNT(*) FROM emr.emr_oru_result WHERE DATE(result_datetime)=v_today AND has_critical=TRUE),
        (SELECT COUNT(*) FROM emr.emr_msg_inbound WHERE DATE(received_datetime)=v_today),
        (SELECT COUNT(*) FROM emr.emr_msg_transaction WHERE DATE(processed_datetime)=v_today AND transaction_status='PROCESSED'),
        (SELECT COUNT(*) FROM emr.emr_msg_transaction WHERE DATE(failed_datetime)=v_today AND transaction_status='FAILED'),
        (SELECT COUNT(*) FROM emr.emr_msg_transaction WHERE DATE(creation_date)=v_today AND entry_source='MANUAL'),
        NOW()
    ON CONFLICT (summary_date, tenant_rid, branch_rid) DO UPDATE SET
        total_patients          = EXCLUDED.total_patients,
        new_mrns_today          = EXCLUDED.new_mrns_today,
        active_encounters       = EXCLUDED.active_encounters,
        opd_visits_today        = EXCLUDED.opd_visits_today,
        inpatient_admissions    = EXCLUDED.inpatient_admissions,
        pending_discharges      = EXCLUDED.pending_discharges,
        appointments_today      = EXCLUDED.appointments_today,
        appointments_cancelled  = EXCLUDED.appointments_cancelled,
        appointments_noshow     = EXCLUDED.appointments_noshow,
        pending_orders          = EXCLUDED.pending_orders,
        completed_results       = EXCLUDED.completed_results,
        critical_results        = EXCLUDED.critical_results,
        msg_received_today      = EXCLUDED.msg_received_today,
        msg_processed_today     = EXCLUDED.msg_processed_today,
        msg_failed_today        = EXCLUDED.msg_failed_today,
        manual_entries_today    = EXCLUDED.manual_entries_today,
        last_refreshed          = NOW(),
        update_date             = NOW();
END;
$$ LANGUAGE plpgsql;
COMMENT ON FUNCTION emr.sp_emr_refresh_dashboard IS 'Upserts daily KPI summary. Called every 15 min by pg_cron or Spring Boot scheduler.';

-- ============================================================
-- SEED: NOTIFICATION TEMPLATES
-- ============================================================
INSERT INTO emr.emr_notif_template (template_code, event_type, language, channel, subject, body_template, is_active, created_by, creation_date) VALUES
('NOTIF_ADT_ADMIT','ADT_A01','EN','SMS',NULL,'Dear {{patient_name}}, you have been admitted to our facility. MRN: {{mrn}}, Ward: {{ward}}, Bed: {{bed}}. Wishing you a speedy recovery.',TRUE,0,NOW()),
('NOTIF_ADT_ADMIT','ADT_A01','AR','SMS',NULL,'عزيزنا {{patient_name_ar}}، تم تنويمك في مستشفانا. رقم المريض: {{mrn}}، الجناح: {{ward}}، السرير: {{bed}}. نتمنى لك الشفاء العاجل.',TRUE,0,NOW()),
('NOTIF_ADT_DISCHARGE','ADT_A03','EN','SMS',NULL,'Dear {{patient_name}}, you have been discharged. MRN: {{mrn}}. Please follow your physician instructions. Thank you for choosing us.',TRUE,0,NOW()),
('NOTIF_SCH_BOOKED','SCH_S12','EN','SMS',NULL,'Dear {{patient_name}}, your appointment has been booked. Date: {{appointment_date}}, Time: {{appointment_time}}, Clinic: {{clinic_name}}.',TRUE,0,NOW()),
('NOTIF_SCH_REMINDER','SCH_S12','EN','SMS',NULL,'Reminder: You have an appointment tomorrow. Time: {{appointment_time}}, Clinic: {{clinic_name}}. Please arrive 15 minutes early.',TRUE,0,NOW()),
('NOTIF_SCH_CANCELLED','SCH_S14','EN','SMS',NULL,'Dear {{patient_name}}, your appointment on {{appointment_date}} has been cancelled. Please contact us to reschedule.',TRUE,0,NOW()),
('NOTIF_MRN_CREATED','MRN_NEW','EN','SMS',NULL,'Welcome to our facility, {{patient_name}}. Your Medical Record Number (MRN) is: {{mrn}}. Please keep this for all future visits.',TRUE,0,NOW()),
('NOTIF_ORU_RESULT_READY','ORU_R01','EN','SMS',NULL,'Dear {{patient_name}}, your {{result_type}} results are now available. Please contact your physician to discuss them.',TRUE,0,NOW());

-- ============================================================
-- END OF SCRIPT
-- ============================================================

-- ============================================================
-- DEV SEED DATA
-- For development and testing purposes only
-- DO NOT run in production
-- ============================================================

SET search_path TO emr;

-- ─────────────────────────────────────────────────────────────
-- 1. PATIENTS (10 dev patients)
-- ─────────────────────────────────────────────────────────────
INSERT INTO emr.emr_patients (
    mrn, national_id, national_id_type,
    first_name, middle_name, last_name,
    first_name_ar, last_name_ar,
    date_of_birth, gender, marital_status,
    nationality, blood_type, language,
    is_vip, is_active, entry_source,
    created_by, creation_date, version
) VALUES
('MRN-2026-00001','1012345678','NID','Ahmed','Khalid','Al-Rashidi','أحمد','الرشيدي','1980-03-15','M','M','SAU','O+','AR',FALSE,TRUE,'MANUAL',1,NOW(),0),
('MRN-2026-00002','1023456789','NID','Fatima','Ali','Al-Zahrani','فاطمة','الزهراني','1992-07-22','F','M','SAU','A+','AR',FALSE,TRUE,'MANUAL',1,NOW(),0),
('MRN-2026-00003','1034567890','NID','Mohammed','Hassan','Al-Ghamdi','محمد','الغامدي','1975-11-08','M','M','SAU','B+','AR',TRUE,TRUE,'MANUAL',1,NOW(),0),
('MRN-2026-00004','1045678901','NID','Sara','Nasser','Al-Otaibi','سارة','العتيبي','1988-05-30','F','S','SAU','AB+','EN',FALSE,TRUE,'HL7',1,NOW(),0),
('MRN-2026-00005','1056789012','NID','Omar','Ibrahim','Al-Shehri','عمر','الشهري','1965-01-12','M','M','SAU','O-','AR',FALSE,TRUE,'MANUAL',1,NOW(),0),
('MRN-2026-00006','1067890123','NID','Maryam','Saad','Al-Qahtani','مريم','القحطاني','1995-09-18','F','S','SAU','A-','AR',FALSE,TRUE,'HL7',1,NOW(),0),
('MRN-2026-00007','2012345678','IQAMA','John','Michael','Smith',NULL,NULL,'1983-06-25','M','M','USA','B-','EN',FALSE,TRUE,'MANUAL',1,NOW(),0),
('MRN-2026-00008','1078901234','NID','Noura','Fahad','Al-Dosari','نورة','الدوسري','1970-12-03','F','M','SAU','AB-','AR',FALSE,TRUE,'MANUAL',1,NOW(),0),
('MRN-2026-00009','1089012345','NID','Abdullah','Mansour','Al-Harbi','عبدالله','الحربي','1990-04-07','M','S','SAU','O+','AR',FALSE,TRUE,'HL7',1,NOW(),0),
('MRN-2026-00010','1090123456','NID','Hessa','Turki','Al-Mutairi','هيصة','المطيري','1998-08-14','F','S','SAU','A+','AR',FALSE,TRUE,'MANUAL',1,NOW(),0);

-- ─────────────────────────────────────────────────────────────
-- 2. PATIENT CONTACTS
-- ─────────────────────────────────────────────────────────────
INSERT INTO emr.emr_patient_contact (
    patient_rid, phone_mobile, phone_home, email,
    address_line1, city, region, country,
    emergency_name, emergency_relation, emergency_phone,
    entry_source, created_by, creation_date, version
) VALUES
(1,'0501234567','0112345678','ahmed.alrashidi@email.sa','King Fahad Road, Villa 12','Riyadh','Riyadh Region','SAU','Khalid Al-Rashidi','Brother','0509876543','MANUAL',1,NOW(),0),
(2,'0502345678',NULL,'fatima.zahrani@email.sa','Olaya Street, Apt 5A','Riyadh','Riyadh Region','SAU','Ali Al-Zahrani','Father','0503456789','MANUAL',1,NOW(),0),
(3,'0503456789','0114567890',NULL,'Tahlia Street, Villa 8','Riyadh','Riyadh Region','SAU','Hassan Al-Ghamdi','Son','0504567890','MANUAL',1,NOW(),0),
(4,'0504567890',NULL,'sara.otaibi@email.sa','Prince Sultan Road, Apt 3B','Jeddah','Makkah Region','SAU','Nasser Al-Otaibi','Father','0505678901','MANUAL',1,NOW(),0),
(5,'0505678901','0116789012',NULL,'Al-Amir Street, Villa 22','Riyadh','Riyadh Region','SAU','Ibrahim Al-Shehri','Son','0506789012','MANUAL',1,NOW(),0),
(6,'0506789012',NULL,'maryam.qahtani@email.sa','Al-Rawdah District','Riyadh','Riyadh Region','SAU','Saad Al-Qahtani','Father','0507890123','MANUAL',1,NOW(),0),
(7,'0507890123',NULL,'john.smith@email.com','Diplomatic Quarter, Block 5','Riyadh','Riyadh Region','SAU','Jane Smith','Wife','0508901234','MANUAL',1,NOW(),0),
(8,'0508901234','0118901234',NULL,'King Abdullah Road, Villa 3','Dammam','Eastern Province','SAU','Fahad Al-Dosari','Husband','0509012345','MANUAL',1,NOW(),0),
(9,'0509012345',NULL,NULL,'Al-Nakheel District, Villa 7','Riyadh','Riyadh Region','SAU','Mansour Al-Harbi','Father','0501234560','MANUAL',1,NOW(),0),
(10,'0501234560',NULL,'hessa.mutairi@email.sa','Al-Wurud District, Apt 2A','Riyadh','Riyadh Region','SAU','Turki Al-Mutairi','Father','0502345670','MANUAL',1,NOW(),0);

-- ─────────────────────────────────────────────────────────────
-- 3. PATIENT IDENTIFIERS
-- ─────────────────────────────────────────────────────────────
INSERT INTO emr.emr_patient_identifier (
    patient_rid, id_type, id_value, issuing_country, is_primary,
    created_by, creation_date, version
) VALUES
(1,'NID','1012345678','SAU',TRUE,1,NOW(),0),
(2,'NID','1023456789','SAU',TRUE,1,NOW(),0),
(3,'NID','1034567890','SAU',TRUE,1,NOW(),0),
(3,'INSURANCE','INS-2026-3456','SAU',FALSE,1,NOW(),0),
(4,'NID','1045678901','SAU',TRUE,1,NOW(),0),
(5,'NID','1056789012','SAU',TRUE,1,NOW(),0),
(6,'NID','1067890123','SAU',TRUE,1,NOW(),0),
(7,'IQAMA','2012345678','USA',TRUE,1,NOW(),0),
(7,'PASSPORT','AB1234567','USA',FALSE,1,NOW(),0),
(8,'NID','1078901234','SAU',TRUE,1,NOW(),0),
(9,'NID','1089012345','SAU',TRUE,1,NOW(),0),
(10,'NID','1090123456','SAU',TRUE,1,NOW(),0);

-- ─────────────────────────────────────────────────────────────
-- 4. ENCOUNTERS
-- ─────────────────────────────────────────────────────────────
INSERT INTO emr.emr_encounters (
    patient_rid, mrn, visit_number, patient_class, encounter_status,
    encounter_type, admission_datetime, discharge_datetime,
    facility_code, tenant_rid, branch_rid,
    attending_provider, primary_diagnosis,
    entry_source, created_by, creation_date, version
) VALUES
-- Inpatient (active)
(1,'MRN-2026-00001','VIS-2026-00001','I','IN_PROGRESS','ROUTINE','2026-01-28 08:00:00',NULL,'RMC',1,1,'DR001','J18.1','MANUAL',1,NOW(),0),
-- OPD (completed)
(2,'MRN-2026-00002','VIS-2026-00002','O','FINISHED','FOLLOW_UP','2026-01-27 10:00:00','2026-01-27 11:30:00','RMC',1,1,'DR002','E11.9','MANUAL',1,NOW(),0),
-- Inpatient (active, VIP)
(3,'MRN-2026-00003','VIS-2026-00003','I','IN_PROGRESS','EMERGENCY','2026-01-29 02:00:00',NULL,'RMC',1,1,'DR003','I21.0','HL7',1,NOW(),0),
-- OPD (active today)
(4,'MRN-2026-00004','VIS-2026-00004','O','ARRIVED','ROUTINE','2026-01-30 09:00:00',NULL,'RMC',1,1,'DR002',NULL,'MANUAL',1,NOW(),0),
-- Emergency (active)
(5,'MRN-2026-00005','VIS-2026-00005','E','IN_PROGRESS','EMERGENCY','2026-01-30 07:30:00',NULL,'RMC',1,1,'DR004','J96.0','HL7',1,NOW(),0),
-- OPD (completed)
(6,'MRN-2026-00006','VIS-2026-00006','O','FINISHED','ROUTINE','2026-01-25 11:00:00','2026-01-25 12:00:00','RMC',1,1,'DR002','N39.0','MANUAL',1,NOW(),0),
-- OPD (completed)
(7,'MRN-2026-00007','VIS-2026-00007','O','FINISHED','FOLLOW_UP','2026-01-26 14:00:00','2026-01-26 15:00:00','RMC',1,1,'DR005','M54.5','MANUAL',1,NOW(),0),
-- Inpatient (discharged)
(8,'MRN-2026-00008','VIS-2026-00008','I','FINISHED','ROUTINE','2026-01-20 10:00:00','2026-01-27 11:00:00','RMC',1,1,'DR001','K80.2','MANUAL',1,NOW(),0),
-- Pre-admit
(9,'MRN-2026-00009','VIS-2026-00009','P','PLANNED','ROUTINE','2026-02-01 08:00:00',NULL,'RMC',1,1,'DR003',NULL,'MANUAL',1,NOW(),0),
-- OPD (active today)
(10,'MRN-2026-00010','VIS-2026-00010','O','ARRIVED','ROUTINE','2026-01-30 10:30:00',NULL,'RMC',1,1,'DR002',NULL,'MANUAL',1,NOW(),0);

-- ─────────────────────────────────────────────────────────────
-- 5. ADT ADMIT (inpatient admits)
-- ─────────────────────────────────────────────────────────────
INSERT INTO emr.emr_adt_admit (
    encounter_rid, patient_rid,
    admit_datetime, admit_source, admit_type,
    ward_code, room_code, bed_code,
    attending_provider_id, hospital_service,
    admit_status, entry_source, created_by, creation_date, version
) VALUES
(1,1,'2026-01-28 08:00:00','1','R','WARD-MED-A','RM-101','BED-A','DR001','MEDICINE','ACTIVE','MANUAL',1,NOW(),0),
(3,3,'2026-01-29 02:00:00','7','E','WARD-CCU','RM-CCU-01','BED-01','DR003','CARDIOLOGY','ACTIVE','HL7',1,NOW(),0),
(8,8,'2026-01-20 10:00:00','1','R','WARD-SURG-B','RM-205','BED-B','DR001','SURGERY','ACTIVE','MANUAL',1,NOW(),0);

-- ─────────────────────────────────────────────────────────────
-- 6. ADT REGISTER (OPD/ED registrations)
-- ─────────────────────────────────────────────────────────────
INSERT INTO emr.emr_adt_register (
    encounter_rid, patient_rid,
    register_datetime, patient_class, clinic_code, visit_reason,
    attending_provider_id,
    register_status, entry_source, created_by, creation_date, version
) VALUES
(2,2,'2026-01-27 10:00:00','O','CLINIC-ENDO-01','Diabetes follow-up, HbA1c check','DR002','ACTIVE','MANUAL',1,NOW(),0),
(4,4,'2026-01-30 09:00:00','O','CLINIC-OPD-01','General check-up','DR002','ACTIVE','MANUAL',1,NOW(),0),
(5,5,'2026-01-30 07:30:00','E','ED','Shortness of breath, SpO2 88%','DR004','ACTIVE','HL7',1,NOW(),0),
(6,6,'2026-01-25 11:00:00','O','CLINIC-OPD-02','Urinary tract infection symptoms','DR002','ACTIVE','MANUAL',1,NOW(),0),
(7,7,'2026-01-26 14:00:00','O','CLINIC-ORTHO-01','Lower back pain follow-up','DR005','ACTIVE','MANUAL',1,NOW(),0),
(10,10,'2026-01-30 10:30:00','O','CLINIC-OPD-01','Routine annual checkup','DR002','ACTIVE','MANUAL',1,NOW(),0);

-- ─────────────────────────────────────────────────────────────
-- 7. ADT DISCHARGE
-- ─────────────────────────────────────────────────────────────
INSERT INTO emr.emr_adt_discharge (
    encounter_rid, patient_rid,
    discharge_datetime, discharge_disposition,
    discharge_condition, length_of_stay_days,
    attending_provider_id,
    discharge_status, entry_source, created_by, creation_date, version
) VALUES
(8,8,'2026-01-27 11:00:00','01','GOOD',7,'DR001','COMPLETED','MANUAL',1,NOW(),0);

-- ─────────────────────────────────────────────────────────────
-- 8. ADT TRANSFER
-- ─────────────────────────────────────────────────────────────
INSERT INTO emr.emr_adt_transfer (
    encounter_rid, patient_rid,
    transfer_datetime,
    from_ward, from_room, from_bed,
    to_ward, to_room, to_bed,
    transfer_reason, attending_provider_id,
    transfer_status, entry_source, created_by, creation_date, version
) VALUES
(3,3,'2026-01-29 14:00:00','WARD-ED','RM-ED-05','BED-05','WARD-CCU','RM-CCU-01','BED-01',
 'Cardiac monitoring required after STEMI diagnosis','DR003','ACTIVE','HL7',1,NOW(),0);

-- ─────────────────────────────────────────────────────────────
-- 9. ADT PRE-ADMIT
-- ─────────────────────────────────────────────────────────────
INSERT INTO emr.emr_adt_preadmit (
    encounter_rid, patient_rid,
    preadmit_datetime, planned_admit_date, planned_ward,
    planned_procedure, attending_provider_id,
    preadmit_status, entry_source, created_by, creation_date, version
) VALUES
(9,9,'2026-01-30 09:00:00','2026-02-01','WARD-SURG-A',
 'Elective laparoscopic cholecystectomy','DR006',
 'PENDING','MANUAL',1,NOW(),0);

-- ─────────────────────────────────────────────────────────────
-- 10. ORM ORDERS
-- ─────────────────────────────────────────────────────────────
INSERT INTO emr.emr_orm_order (
    encounter_rid, patient_rid,
    placer_order_number, order_type, order_control, order_status,
    service_code, service_name, priority,
    ordered_datetime, ordering_provider_id, department_code,
    specimen_type, entry_source, created_by, creation_date, version
) VALUES
-- Lab orders for encounter 1
(1,1,'ORD-2026-0001','LAB','NW','COMPLETED','58410-2','CBC — Complete Blood Count','R','2026-01-28 09:00:00','DR001','CENTRAL-LAB','BLD','MANUAL',1,NOW(),0),
(1,1,'ORD-2026-0002','LAB','NW','COMPLETED','2093-3','Lipid Panel','R','2026-01-28 09:05:00','DR001','CENTRAL-LAB','BLD','MANUAL',1,NOW(),0),
(1,1,'ORD-2026-0003','LAB','NW','ORDERED','4548-4','HbA1c','R','2026-01-29 08:00:00','DR001','CENTRAL-LAB','BLD','MANUAL',1,NOW(),0),
-- Radiology order for encounter 1
(1,1,'ORD-2026-0004','RAD','NW','IN_PROGRESS','36643-5','Chest X-Ray PA','R','2026-01-28 10:00:00','DR001','RADIOLOGY',NULL,'MANUAL',1,NOW(),0),
-- Lab order for encounter 3 (CCU)
(3,3,'ORD-2026-0005','LAB','NW','COMPLETED','2532-0','Troponin I','S','2026-01-29 02:30:00','DR003','CENTRAL-LAB','BLD','HL7',1,NOW(),0),
(3,3,'ORD-2026-0006','LAB','NW','COMPLETED','13969-1','CK-MB','S','2026-01-29 02:35:00','DR003','CENTRAL-LAB','BLD','HL7',1,NOW(),0),
-- Lab order for encounter 5 (ED)
(5,5,'ORD-2026-0007','LAB','NW','COMPLETED','2703-7','Arterial Blood Gas','S','2026-01-30 07:45:00','DR004','CENTRAL-LAB','ART','HL7',1,NOW(),0),
-- Cancelled order
(2,2,'ORD-2026-0008','LAB','NW','CANCELLED','2345-7','Blood Glucose Fasting','R','2026-01-27 10:30:00','DR002','CENTRAL-LAB','BLD','MANUAL',1,NOW(),0);

-- ─────────────────────────────────────────────────────────────
-- 11. ORU RESULTS
-- ─────────────────────────────────────────────────────────────
INSERT INTO emr.emr_oru_result (
    encounter_rid, patient_rid, order_rid,
    result_type, service_code, service_name,
    result_status, result_datetime, report_datetime,
    performing_lab, has_critical,
    entry_source, created_by, creation_date, version
) VALUES
-- CBC result for order 1
(1,1,1,'LAB','58410-2','CBC — Complete Blood Count','F','2026-01-28 10:30:00','2026-01-28 10:35:00','CENTRAL-LAB',FALSE,'HL7',1,NOW(),0),
-- Lipid panel result for order 2
(1,1,2,'LAB','2093-3','Lipid Panel','F','2026-01-28 11:00:00','2026-01-28 11:05:00','CENTRAL-LAB',FALSE,'HL7',1,NOW(),0),
-- Troponin result for order 5 — CRITICAL
(3,3,5,'LAB','2532-0','Troponin I','F','2026-01-29 03:00:00','2026-01-29 03:05:00','CENTRAL-LAB',TRUE,'HL7',1,NOW(),0),
-- CK-MB result for order 6
(3,3,6,'LAB','13969-1','CK-MB','F','2026-01-29 03:10:00','2026-01-29 03:15:00','CENTRAL-LAB',TRUE,'HL7',1,NOW(),0),
-- ABG result for order 7
(5,5,7,'LAB','2703-7','Arterial Blood Gas','F','2026-01-30 08:15:00','2026-01-30 08:20:00','CENTRAL-LAB',TRUE,'HL7',1,NOW(),0);

-- ─────────────────────────────────────────────────────────────
-- 12. ORU OBSERVATIONS (OBX)
-- ─────────────────────────────────────────────────────────────
INSERT INTO emr.emr_oru_observation (
    result_rid, obx_sequence, value_type,
    observation_code, observation_name,
    observation_value, units, reference_range,
    abnormal_flag, is_critical, observation_status,
    observation_datetime, entry_source, created_by, creation_date, version
) VALUES
-- CBC (result 1)
(1,1,'NM','6690-2','WBC','7.2','10*3/uL','4.5-11.0','N',FALSE,'F','2026-01-28 10:30:00','HL7',1,NOW(),0),
(1,2,'NM','718-7','Hemoglobin','13.5','g/dL','13.5-17.5','N',FALSE,'F','2026-01-28 10:30:00','HL7',1,NOW(),0),
(1,3,'NM','777-3','Platelets','285','10*3/uL','150-400','N',FALSE,'F','2026-01-28 10:30:00','HL7',1,NOW(),0),
(1,4,'NM','4544-3','Hematocrit','42.0','%','41.0-53.0','N',FALSE,'F','2026-01-28 10:30:00','HL7',1,NOW(),0),
-- Lipid panel (result 2)
(2,1,'NM','2093-3','Total Cholesterol','210','mg/dL','< 200','H',FALSE,'F','2026-01-28 11:00:00','HL7',1,NOW(),0),
(2,2,'NM','2571-8','Triglycerides','185','mg/dL','< 150','H',FALSE,'F','2026-01-28 11:00:00','HL7',1,NOW(),0),
(2,3,'NM','2085-9','HDL Cholesterol','42','mg/dL','> 40','N',FALSE,'F','2026-01-28 11:00:00','HL7',1,NOW(),0),
(2,4,'NM','13457-7','LDL Cholesterol','130','mg/dL','< 100','H',FALSE,'F','2026-01-28 11:00:00','HL7',1,NOW(),0),
-- Troponin CRITICAL (result 3)
(3,1,'NM','2532-0','Troponin I','12.4','ng/mL','< 0.04','AA',TRUE,'F','2026-01-29 03:00:00','HL7',1,NOW(),0),
-- CK-MB CRITICAL (result 4)
(4,1,'NM','13969-1','CK-MB','85','U/L','< 25','HH',TRUE,'F','2026-01-29 03:10:00','HL7',1,NOW(),0),
-- ABG CRITICAL (result 5)
(5,1,'NM','11558-4','pH','7.28','','7.35-7.45','LL',TRUE,'F','2026-01-30 08:15:00','HL7',1,NOW(),0),
(5,2,'NM','2019-8','PaCO2','55','mmHg','35-45','HH',TRUE,'F','2026-01-30 08:15:00','HL7',1,NOW(),0),
(5,3,'NM','2703-7','PaO2','52','mmHg','80-100','LL',TRUE,'F','2026-01-30 08:15:00','HL7',1,NOW(),0);

-- ─────────────────────────────────────────────────────────────
-- 13. SCH APPOINTMENTS
-- ─────────────────────────────────────────────────────────────
INSERT INTO emr.emr_sch_appointment (
    patient_rid, encounter_rid,
    placer_appointment_id, appointment_status,
    appointment_type, appointment_reason,
    start_datetime, end_datetime, duration_minutes,
    clinic_code, provider_id,
    entry_source, created_by, creation_date, version
) VALUES
-- Today appointments
(4,NULL,'APT-2026-001','SCHEDULED','ROUTINE','General check-up','2026-01-30 09:00:00','2026-01-30 09:30:00',30,'CLINIC-OPD-01','DR002','MANUAL',1,NOW(),0),
(10,NULL,'APT-2026-002','SCHEDULED','ROUTINE','Annual checkup','2026-01-30 10:30:00','2026-01-30 11:00:00',30,'CLINIC-OPD-01','DR002','MANUAL',1,NOW(),0),
(2,NULL,'APT-2026-003','COMPLETED','FOLLOW_UP','Diabetes follow-up','2026-01-27 10:00:00','2026-01-27 11:00:00',60,'CLINIC-ENDO-01','DR002','MANUAL',1,NOW(),0),
(6,NULL,'APT-2026-004','COMPLETED','ROUTINE','UTI follow-up','2026-01-25 11:00:00','2026-01-25 11:30:00',30,'CLINIC-OPD-02','DR002','MANUAL',1,NOW(),0),
(7,NULL,'APT-2026-005','COMPLETED','FOLLOW_UP','Back pain follow-up','2026-01-26 14:00:00','2026-01-26 15:00:00',60,'CLINIC-ORTHO-01','DR005','MANUAL',1,NOW(),0),
-- Cancelled
(1,NULL,'APT-2026-006','CANCELLED','ROUTINE','OPD visit','2026-01-28 09:00:00','2026-01-28 09:30:00',30,'CLINIC-OPD-01','DR002','MANUAL',1,NOW(),0),
-- Future appointments
(9,NULL,'APT-2026-007','SCHEDULED','ROUTINE','Pre-op assessment','2026-02-01 08:00:00','2026-02-01 09:00:00',60,'CLINIC-SURG-01','DR006','MANUAL',1,NOW(),0),
(5,NULL,'APT-2026-008','SCHEDULED','FOLLOW_UP','Post-ED follow-up','2026-02-03 10:00:00','2026-02-03 10:30:00',30,'CLINIC-RESP-01','DR004','MANUAL',1,NOW(),0),
-- No-show
(8,NULL,'APT-2026-009','NOSHOW','FOLLOW_UP','Post-discharge follow-up','2026-01-29 09:00:00','2026-01-29 09:30:00',30,'CLINIC-SURG-01','DR001','MANUAL',1,NOW(),0);

-- ─────────────────────────────────────────────────────────────
-- 14. SCH APPOINTMENT LOGS
-- ─────────────────────────────────────────────────────────────
INSERT INTO emr.emr_sch_appointment_log (
    appointment_rid, event_type, event_datetime,
    old_values, new_values, changed_by,
    created_by, creation_date, version
) VALUES
(1,'S12','2026-01-28 08:00:00',NULL,'{"status":"SCHEDULED"}',1,1,NOW(),0),
(2,'S12','2026-01-29 09:00:00',NULL,'{"status":"SCHEDULED"}',1,1,NOW(),0),
(6,'S12','2026-01-27 09:00:00',NULL,'{"status":"SCHEDULED"}',1,1,NOW(),0),
(6,'S14','2026-01-27 16:00:00','{"status":"SCHEDULED"}','{"status":"CANCELLED","reason":"Patient request"}',1,1,NOW(),0);

-- ─────────────────────────────────────────────────────────────
-- 15. PATIENT VITALS
-- ─────────────────────────────────────────────────────────────
INSERT INTO emr.emr_patient_vitals (
    encounter_rid, patient_rid,
    observation_code, observation_name,
    value_numeric, unit, reference_range,
    abnormal_flag, is_critical,
    recorded_datetime, recorded_by,
    entry_source, created_by, creation_date, version
) VALUES
-- Encounter 1 vitals (Ahmed Al-Rashidi, inpatient)
(1,1,'29463-7','Body Weight',82.5,'kg','50-120','N',FALSE,'2026-01-28 08:30:00',2,'MANUAL',2,NOW(),0),
(1,1,'8302-2','Body Height',175.0,'cm','—','N',FALSE,'2026-01-28 08:30:00',2,'MANUAL',2,NOW(),0),
(1,1,'8310-5','Body Temperature',37.8,'Cel','36.1-37.2','H',FALSE,'2026-01-28 08:30:00',2,'MANUAL',2,NOW(),0),
(1,1,'8480-6','Systolic BP',145.0,'mmHg','90-120','H',FALSE,'2026-01-28 08:30:00',2,'MANUAL',2,NOW(),0),
(1,1,'8462-4','Diastolic BP',92.0,'mmHg','60-80','H',FALSE,'2026-01-28 08:30:00',2,'MANUAL',2,NOW(),0),
(1,1,'8867-4','Heart Rate',88.0,'/min','60-100','N',FALSE,'2026-01-28 08:30:00',2,'MANUAL',2,NOW(),0),
(1,1,'2708-6','Oxygen Saturation',97.0,'%','95-100','N',FALSE,'2026-01-28 08:30:00',2,'MANUAL',2,NOW(),0),
-- Encounter 3 vitals (Mohammed Al-Ghamdi, CCU — CRITICAL)
(3,3,'8480-6','Systolic BP',88.0,'mmHg','90-120','LL',TRUE,'2026-01-29 02:15:00',2,'HL7',2,NOW(),0),
(3,3,'8867-4','Heart Rate',128.0,'/min','60-100','HH',TRUE,'2026-01-29 02:15:00',2,'HL7',2,NOW(),0),
(3,3,'8310-5','Body Temperature',38.9,'Cel','36.1-37.2','H',FALSE,'2026-01-29 02:15:00',2,'HL7',2,NOW(),0),
(3,3,'2708-6','Oxygen Saturation',91.0,'%','95-100','L',FALSE,'2026-01-29 02:15:00',2,'HL7',2,NOW(),0),
-- Encounter 5 vitals (Omar Al-Shehri, ED — CRITICAL SpO2)
(5,5,'2708-6','Oxygen Saturation',88.0,'%','95-100','LL',TRUE,'2026-01-30 07:35:00',2,'HL7',2,NOW(),0),
(5,5,'9279-1','Respiratory Rate',28.0,'/min','12-20','H',FALSE,'2026-01-30 07:35:00',2,'HL7',2,NOW(),0),
(5,5,'8480-6','Systolic BP',110.0,'mmHg','90-120','N',FALSE,'2026-01-30 07:35:00',2,'HL7',2,NOW(),0),
(5,5,'8867-4','Heart Rate',112.0,'/min','60-100','H',FALSE,'2026-01-30 07:35:00',2,'HL7',2,NOW(),0),
-- Encounter 4 vitals (Sara, OPD)
(4,4,'29463-7','Body Weight',65.0,'kg','50-120','N',FALSE,'2026-01-30 09:10:00',2,'MANUAL',2,NOW(),0),
(4,4,'8310-5','Body Temperature',36.8,'Cel','36.1-37.2','N',FALSE,'2026-01-30 09:10:00',2,'MANUAL',2,NOW(),0),
(4,4,'8480-6','Systolic BP',118.0,'mmHg','90-120','N',FALSE,'2026-01-30 09:10:00',2,'MANUAL',2,NOW(),0),
(4,4,'8867-4','Heart Rate',74.0,'/min','60-100','N',FALSE,'2026-01-30 09:10:00',2,'MANUAL',2,NOW(),0);

-- ─────────────────────────────────────────────────────────────
-- 16. DIAGNOSES
-- ─────────────────────────────────────────────────────────────
INSERT INTO emr.emr_diagnoses (
    encounter_rid, patient_rid,
    diagnosis_code, diagnosis_desc, diagnosis_desc_ar,
    diagnosis_type, diagnosis_rank, diagnosed_by,
    diagnosis_status, entry_source, created_by, creation_date, version
) VALUES
-- Encounter 1 — Community Acquired Pneumonia
(1,1,'J18.1','Lobar pneumonia, unspecified organism','الالتهاب الرئوي الفصي','PRIMARY',1,'DR001','ACTIVE','MANUAL',1,NOW(),0),
(1,1,'I10','Essential (primary) hypertension','ارتفاع ضغط الدم الأساسي','SECONDARY',2,'DR001','ACTIVE','MANUAL',1,NOW(),0),
-- Encounter 2 — Diabetes follow-up
(2,2,'E11.9','Type 2 diabetes mellitus without complications','السكري من النوع الثاني','PRIMARY',1,'DR002','ACTIVE','MANUAL',1,NOW(),0),
-- Encounter 3 — STEMI
(3,3,'I21.0','Acute transmural myocardial infarction of anterior wall','احتشاء عضلة القلب الأمامي الحاد','PRIMARY',1,'DR003','ACTIVE','HL7',1,NOW(),0),
(3,3,'I10','Essential (primary) hypertension','ارتفاع ضغط الدم الأساسي','SECONDARY',2,'DR003','ACTIVE','HL7',1,NOW(),0),
-- Encounter 5 — Respiratory failure
(5,5,'J96.0','Acute respiratory failure, unspecified whether with hypoxia or hypercapnia','فشل تنفسي حاد','PRIMARY',1,'DR004','ACTIVE','HL7',1,NOW(),0),
-- Encounter 8 — Cholelithiasis (discharged)
(8,8,'K80.2','Calculus of gallbladder without cholecystitis','حصى المرارة','PRIMARY',1,'DR001','RESOLVED','MANUAL',1,NOW(),0);

-- ─────────────────────────────────────────────────────────────
-- 17. INTEGRATION — INBOUND MESSAGES
-- ─────────────────────────────────────────────────────────────
INSERT INTO emr.emr_msg_inbound (
    message_uid, message_control_id, message_type, event_type,
    message_version, protocol, source_system, source_facility,
    raw_message, received_datetime, patient_mrn,
    processing_status, tenant_rid, branch_rid,
    created_by, creation_date, version
) VALUES
('uuid-msg-001','MSG20260129020001','ADT','A01','2.5','HL7V2','ORACLE-HEALTH','RMC',
 'MSH|^~\&|ORACLE-HEALTH|RMC|EMR|RMC|20260129020000||ADT^A01|MSG20260129020001|P|2.5|||AL|NE||UNICODE UTF-8\rEVN|A01|20260129020000\rPID|1||MRN-2026-00003^^^RMC^MR||Al-Ghamdi^Mohammed||19751108|M\rPV1|1|I|WARD-CCU^RM-CCU-01^BED-01|||DR003|||CARDIOLOGY',
 '2026-01-29 02:00:00','MRN-2026-00003','PROCESSED',1,1,1,NOW(),0),

('uuid-msg-002','MSG20260129023001','ORU','R01','2.5','HL7V2','CENTRAL-LAB','RMC',
 'MSH|^~\&|CENTRAL-LAB|RMC|EMR|RMC|20260129030000||ORU^R01|MSG20260129023001|P|2.5\rPID|1||MRN-2026-00003^^^RMC^MR\rOBR|1|ORD-2026-0005|FIL-001|2532-0^Troponin I^LN|||20260129023000\rOBX|1|NM|2532-0^Troponin I^LN||12.4|ng/mL|<0.04|AA|||F',
 '2026-01-29 03:00:00','MRN-2026-00003','PROCESSED',1,1,1,NOW(),0),

('uuid-msg-003','MSG20260130073001','ADT','A04','2.5','HL7V2','ORACLE-HEALTH','RMC',
 'MSH|^~\&|ORACLE-HEALTH|RMC|EMR|RMC|20260130073000||ADT^A04|MSG20260130073001|P|2.5\rPID|1||MRN-2026-00005^^^RMC^MR\rPV1|1|E|ED',
 '2026-01-30 07:30:00','MRN-2026-00005','PROCESSED',1,1,1,NOW(),0),

('uuid-msg-004','MSG20260130080001','ORU','R01','2.5','HL7V2','CENTRAL-LAB','RMC',
 'MSH|^~\&|CENTRAL-LAB|RMC|EMR|RMC|20260130081500||ORU^R01|MSG20260130080001|P|2.5\rPID|1||MRN-2026-00005^^^RMC^MR\rOBR|1|ORD-2026-0007|FIL-002|2703-7^ABG^LN|||20260130073000\rOBX|1|NM|11558-4^pH^LN||7.28||7.35-7.45|LL|||F',
 '2026-01-30 08:15:00','MRN-2026-00005','PROCESSED',1,1,1,NOW(),0),

-- Failed message (for dev testing of error flow)
('uuid-msg-005','MSG20260130090001','ADT','A01','2.5','HL7V2','ORACLE-HEALTH','RMC',
 'MSH|^~\&|ORACLE-HEALTH|RMC|EMR|RMC|20260130090000||ADT^A01|MSG20260130090001|P|2.5\rPID|1||INVALID-MRN^^^RMC^MR\rPV1|1|I|WARD-X',
 '2026-01-30 09:00:00','INVALID-MRN','FAILED',1,1,1,NOW(),0),

-- Pending message (not yet processed — for testing queue)
('uuid-msg-006','MSG20260130103001','SCH','S12','2.5','HL7V2','SCHEDULING-SYS','RMC',
 'MSH|^~\&|SCHEDULING-SYS|RMC|EMR|RMC|20260130103000||SIU^S12|MSG20260130103001|P|2.5\rPID|1||MRN-2026-00010^^^RMC^MR',
 '2026-01-30 10:30:00','MRN-2026-00010','RECEIVED',1,1,1,NOW(),0);

-- ─────────────────────────────────────────────────────────────
-- 18. INTEGRATION — TRANSACTIONS
-- ─────────────────────────────────────────────────────────────
INSERT INTO emr.emr_msg_transaction (
    inbound_msg_rid, transaction_status,
    parsed_datetime, validated_datetime, processed_datetime, failed_datetime,
    affected_table, affected_rid, processing_duration_ms,
    notify_channel, entry_source,
    created_by, creation_date, version
) VALUES
(1,'PROCESSED','2026-01-29 02:00:01','2026-01-29 02:00:02','2026-01-29 02:00:03',NULL,'emr_adt_admit',2,320,'emr.adt','HL7',1,NOW(),0),
(2,'PROCESSED','2026-01-29 03:00:01','2026-01-29 03:00:02','2026-01-29 03:00:03',NULL,'emr_oru_result',3,280,'emr.oru','HL7',1,NOW(),0),
(3,'PROCESSED','2026-01-30 07:30:01','2026-01-30 07:30:02','2026-01-30 07:30:03',NULL,'emr_adt_register',5,195,'emr.adt','HL7',1,NOW(),0),
(4,'PROCESSED','2026-01-30 08:15:01','2026-01-30 08:15:02','2026-01-30 08:15:03',NULL,'emr_oru_result',5,310,'emr.oru','HL7',1,NOW(),0),
(5,'FAILED','2026-01-30 09:00:01','2026-01-30 09:00:02',NULL,'2026-01-30 09:00:03',NULL,NULL,NULL,'emr.adt','HL7',1,NOW(),0),
(6,'RECEIVED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'emr.sch','HL7',1,NOW(),0);

-- ─────────────────────────────────────────────────────────────
-- 19. INTEGRATION — ERRORS (for failed message)
-- ─────────────────────────────────────────────────────────────
INSERT INTO emr.emr_msg_error (
    transaction_rid, error_code, error_segment, error_field,
    error_description, severity, resolved,
    created_by, creation_date, version
) VALUES
(5,'EMR-001','PID','PID-3','MRN INVALID-MRN not found in emr_patients. Patient does not exist and auto-creation is disabled for ADT A01.','ERROR',FALSE,1,NOW(),0);

-- ─────────────────────────────────────────────────────────────
-- 20. INTEGRATION — ACK RECORDS
-- ─────────────────────────────────────────────────────────────
INSERT INTO emr.emr_msg_ack (
    transaction_rid, ack_type, ack_code, ack_message,
    ack_datetime, ack_sent,
    created_by, creation_date, version
) VALUES
(1,'AA','200','MSH|^~\&|EMR|RMC|ORACLE-HEALTH|RMC|20260129020004||ACK^A01|ACK001|P|2.5\rMSA|AA|MSG20260129020001','2026-01-29 02:00:04',TRUE,1,NOW(),0),
(2,'AA','200','MSH|^~\&|EMR|RMC|CENTRAL-LAB|RMC|20260129030004||ACK^R01|ACK002|P|2.5\rMSA|AA|MSG20260129023001','2026-01-29 03:00:04',TRUE,1,NOW(),0),
(3,'AA','200','MSH|^~\&|EMR|RMC|ORACLE-HEALTH|RMC|20260130073004||ACK^A04|ACK003|P|2.5\rMSA|AA|MSG20260130073001','2026-01-30 07:30:04',TRUE,1,NOW(),0),
(4,'AA','200','MSH|^~\&|EMR|RMC|CENTRAL-LAB|RMC|20260130081504||ACK^R01|ACK004|P|2.5\rMSA|AA|MSG20260130080001','2026-01-30 08:15:04',TRUE,1,NOW(),0),
(5,'AE','422','MSH|^~\&|EMR|RMC|ORACLE-HEALTH|RMC|20260130090004||ACK^A01|ACK005|P|2.5\rMSA|AE|MSG20260130090001\rERR|^^^EMR-001&MRN not found&HL70357','2026-01-30 09:00:04',TRUE,1,NOW(),0);

-- ─────────────────────────────────────────────────────────────
-- 21. OUTBOUND MESSAGES (HL7 generated by triggers)
-- ─────────────────────────────────────────────────────────────
INSERT INTO emr.emr_msg_outbound (
    message_uid, message_control_id, message_type, event_type,
    protocol, target_system, target_facility,
    raw_message, trigger_event, sent_datetime,
    delivery_status, patient_mrn, inbound_msg_rid, tenant_rid,
    created_by, creation_date, version
) VALUES
('OUT-A01-1-001','MSG20260128080001','ADT','A01','HL7V2','EXT-SYS','RMC',
 'MSH|^~\&|EMR|RMC|EXT-SYS||20260128080000||ADT^A01|MSG20260128080001|P|2.5|||AL|NE||UNICODE UTF-8\rEVN|A01|20260128080000\rPID|1||MRN-2026-00001^^^RMC^MR||Al-Rashidi^Ahmed||19800315|M\rPV1|1|I|WARD-MED-A^RM-101^BED-A|||DR001|||MEDICINE',
 'trg_emr_adt_admit_insert','2026-01-28 08:00:05','DELIVERED','MRN-2026-00001',NULL,1,1,NOW(),0),
('OUT-A01-2-001','MSG20260129020005','ADT','A01','HL7V2','EXT-SYS','RMC',
 'MSH|^~\&|EMR|RMC|EXT-SYS||20260129020000||ADT^A01|MSG20260129020005|P|2.5\rPV1|1|I|WARD-CCU^RM-CCU-01^BED-01',
 'trg_emr_adt_admit_insert','2026-01-29 02:00:05','DELIVERED','MRN-2026-00003',1,1,1,NOW(),0);

-- ─────────────────────────────────────────────────────────────
-- 22. NOTIFICATION QUEUE
-- ─────────────────────────────────────────────────────────────
INSERT INTO emr.emr_notif_queue (
    patient_rid, encounter_rid, template_rid, event_type,
    channel, recipient_phone, message_body,
    queue_status, queued_datetime, sent_datetime,
    retry_count, created_by, creation_date, version
) VALUES
-- Ahmed admitted — sent
(1,1,1,'ADT_A01','SMS','0501234567',
 'Dear Ahmed Al-Rashidi, you have been admitted to our facility. MRN: MRN-2026-00001, Ward: WARD-MED-A, Bed: BED-A. Wishing you a speedy recovery.',
 'SENT','2026-01-28 08:00:10','2026-01-28 08:00:15',0,1,NOW(),0),
-- Mohammed admitted (Arabic) — sent
(3,3,2,'ADT_A01','SMS','0503456789',
 'عزيزنا محمد الغامدي، تم تنويمك في مستشفانا. رقم المريض: MRN-2026-00003، الجناح: WARD-CCU، السرير: BED-01. نتمنى لك الشفاء العاجل.',
 'SENT','2026-01-29 02:00:10','2026-01-29 02:00:18',0,1,NOW(),0),
-- Noura discharged — sent
(8,8,3,'ADT_A03','SMS','0508901234',
 'Dear Noura Al-Dosari, you have been discharged. MRN: MRN-2026-00008. Please follow your physician instructions. Thank you for choosing us.',
 'SENT','2026-01-27 11:00:10','2026-01-27 11:00:14',0,1,NOW(),0),
-- Sara appointment booked — sent
(4,NULL,4,'SCH_S12','SMS','0504567890',
 'Dear Sara Al-Otaibi, your appointment has been booked. Date: 2026-01-30, Time: 09:00, Clinic: CLINIC-OPD-01.',
 'SENT','2026-01-28 14:00:00','2026-01-28 14:00:08',0,1,NOW(),0),
-- Failed notification — for dev testing
(5,5,1,'ADT_A01','SMS','0505678901',
 'Dear Omar Al-Shehri, you have been admitted to our facility. MRN: MRN-2026-00005.',
 'FAILED','2026-01-30 07:30:10',NULL,2,1,NOW(),0);

-- ─────────────────────────────────────────────────────────────
-- 23. NOTIFICATION LOG
-- ─────────────────────────────────────────────────────────────
INSERT INTO emr.emr_notif_log (
    queue_rid, patient_rid, event_type, channel,
    delivery_status, delivery_datetime, provider_response,
    created_by, creation_date, version
) VALUES
(1,1,'ADT_A01','SMS','DELIVERED','2026-01-28 08:00:16','{"status":"delivered","messageId":"SMS-001","provider":"twilio"}',1,NOW(),0),
(2,3,'ADT_A01','SMS','DELIVERED','2026-01-29 02:00:19','{"status":"delivered","messageId":"SMS-002","provider":"twilio"}',1,NOW(),0),
(3,8,'ADT_A03','SMS','DELIVERED','2026-01-27 11:00:15','{"status":"delivered","messageId":"SMS-003","provider":"twilio"}',1,NOW(),0),
(4,4,'SCH_S12','SMS','DELIVERED','2026-01-28 14:00:09','{"status":"delivered","messageId":"SMS-004","provider":"twilio"}',1,NOW(),0),
(5,5,'ADT_A01','SMS','FAILED','2026-01-30 07:30:12','{"status":"failed","error":"Invalid phone number format","provider":"twilio"}',1,NOW(),0);

-- ─────────────────────────────────────────────────────────────
-- 24. DASHBOARD DAILY SUMMARY (seeded for dev)
-- ─────────────────────────────────────────────────────────────
INSERT INTO emr.emr_dashboard_daily_summary (
    summary_date, tenant_rid, branch_rid,
    total_patients, new_mrns_today, active_encounters,
    opd_visits_today, inpatient_admissions, pending_discharges,
    appointments_today, appointments_cancelled, appointments_noshow,
    pending_orders, completed_results, critical_results,
    msg_received_today, msg_processed_today, msg_failed_today,
    manual_entries_today, last_refreshed,
    created_by, creation_date, version
) VALUES
('2026-01-30',1,1,10,2,3,4,1,2,2,1,1,1,5,3,6,5,1,4,NOW(),1,NOW(),0),
('2026-01-29',1,1,8,1,2,2,1,2,3,0,0,2,4,2,2,2,0,3,NOW(),1,NOW(),0),
('2026-01-28',1,1,7,2,3,3,2,2,4,0,0,0,2,0,1,1,0,5,NOW(),1,NOW(),0),
('2026-01-27',1,1,5,0,1,2,0,1,3,0,1,0,1,0,0,0,0,2,NOW(),1,NOW(),0),
('2026-01-25',1,1,5,1,0,2,0,0,2,0,0,0,0,0,0,0,0,2,NOW(),1,NOW(),0);

-- ─────────────────────────────────────────────────────────────
-- 25. PATIENT LOG (sample change history)
-- ─────────────────────────────────────────────────────────────
INSERT INTO emr.emr_patient_log (
    patient_rid, event_type, event_datetime,
    old_values, new_values, changed_by,
    created_by, creation_date, version
) VALUES
(1,'MANUAL_UPDATE','2026-01-28 09:00:00',
 '{"marital_status":"S","language":"EN"}',
 '{"marital_status":"M","language":"AR"}',
 1,1,NOW(),0),
(3,'ADT_A08','2026-01-29 14:00:00',
 '{"ward_code":"WARD-ED","room_code":"RM-ED-05"}',
 '{"ward_code":"WARD-CCU","room_code":"RM-CCU-01"}',
 1,1,NOW(),0);

-- ─────────────────────────────────────────────────────────────
-- 26. ENCOUNTER LOG (sample)
-- ─────────────────────────────────────────────────────────────
INSERT INTO emr.emr_encounter_log (
    encounter_rid, event_type, event_datetime,
    old_values, new_values, changed_by,
    created_by, creation_date, version
) VALUES
(1,'A01','2026-01-28 08:00:00',NULL,'{"encounter_status":"IN_PROGRESS","patient_class":"I"}',1,1,NOW(),0),
(3,'A01','2026-01-29 02:00:00',NULL,'{"encounter_status":"IN_PROGRESS","patient_class":"I"}',1,1,NOW(),0),
(3,'A02','2026-01-29 14:00:00','{"ward":"WARD-ED"}','{"ward":"WARD-CCU"}',1,1,NOW(),0),
(8,'A03','2026-01-27 11:00:00','{"encounter_status":"IN_PROGRESS"}','{"encounter_status":"FINISHED"}',1,1,NOW(),0);

-- ─────────────────────────────────────────────────────────────
-- 27. ADT ADMIT LOG (sample)
-- ─────────────────────────────────────────────────────────────
INSERT INTO emr.emr_adt_admit_log (
    adt_admit_rid, event_type, event_datetime,
    old_values, new_values, changed_by,
    created_by, creation_date, version
) VALUES
(1,'A01','2026-01-28 08:00:00',NULL,'{"admit_status":"ACTIVE","ward_code":"WARD-MED-A"}',1,1,NOW(),0),
(2,'A01','2026-01-29 02:00:00',NULL,'{"admit_status":"ACTIVE","ward_code":"WARD-CCU"}',1,1,NOW(),0),
(3,'A01','2026-01-20 10:00:00',NULL,'{"admit_status":"ACTIVE","ward_code":"WARD-SURG-B"}',1,1,NOW(),0);

-- ─────────────────────────────────────────────────────────────
-- 28. ORM ORDER LOG (sample)
-- ─────────────────────────────────────────────────────────────
INSERT INTO emr.emr_orm_order_log (
    orm_order_rid, event_type, event_datetime,
    old_values, new_values, changed_by,
    created_by, creation_date, version
) VALUES
(1,'NW','2026-01-28 09:00:00',NULL,'{"order_status":"ORDERED","service_name":"CBC"}',1,1,NOW(),0),
(1,'SC','2026-01-28 10:30:00','{"order_status":"ORDERED"}','{"order_status":"COMPLETED"}',1,1,NOW(),0),
(8,'NW','2026-01-27 10:30:00',NULL,'{"order_status":"ORDERED"}',1,1,NOW(),0),
(8,'CA','2026-01-27 11:00:00','{"order_status":"ORDERED"}','{"order_status":"CANCELLED","reason":"Duplicate order"}',1,1,NOW(),0);

-- ─────────────────────────────────────────────────────────────
-- 29. MSG RETRY (sample — for the failed message)
-- ─────────────────────────────────────────────────────────────
INSERT INTO emr.emr_msg_retry (
    transaction_rid, retry_attempt, retry_datetime,
    retry_status, retry_reason, retry_by,
    created_by, creation_date, version
) VALUES
(5,1,'2026-01-30 09:30:00','FAILED','Auto-retry attempt 1 — MRN still not found',NULL,1,NOW(),0),
(5,2,'2026-01-30 10:00:00','FAILED','Auto-retry attempt 2 — MRN still not found',NULL,1,NOW(),0);

-- ============================================================
-- END OF DEV SEED DATA
-- ============================================================

-- ============================================================
-- FHIR LAYER ADDITIONS v2.0
-- ============================================================

SET search_path TO emr;

-- ── FHIR columns on emr_patients ─────────────────────────────
ALTER TABLE emr.emr_patients
  ADD COLUMN IF NOT EXISTS fhir_id VARCHAR(64) NULL,
  ADD COLUMN IF NOT EXISTS fhir_identifier_system VARCHAR(200)
    NOT NULL DEFAULT 'http://rmc.sa/fhir/identifier/mrn';

CREATE UNIQUE INDEX IF NOT EXISTS idx_emr_patients_fhir_id
  ON emr.emr_patients(fhir_id) WHERE fhir_id IS NOT NULL;

COMMENT ON COLUMN emr.emr_patients.fhir_id
  IS 'FHIR logical ID — Patient/{fhir_id}. Auto-generated as patient-{rid} if null.';

-- ── FHIR columns on emr_encounters ───────────────────────────
ALTER TABLE emr.emr_encounters
  ADD COLUMN IF NOT EXISTS fhir_id VARCHAR(64) NULL,
  ADD COLUMN IF NOT EXISTS fhir_status VARCHAR(30) NULL;
-- fhir_status values: planned/arrived/in-progress/finished/cancelled/entered-in-error

COMMENT ON COLUMN emr.emr_encounters.fhir_status
  IS 'FHIR Encounter.status — maps from encounter_status field.';

-- ── FHIR columns on emr_orm_order ────────────────────────────
ALTER TABLE emr.emr_orm_order
  ADD COLUMN IF NOT EXISTS fhir_id VARCHAR(64) NULL;

-- ── FHIR columns on emr_oru_result ───────────────────────────
ALTER TABLE emr.emr_oru_result
  ADD COLUMN IF NOT EXISTS fhir_id VARCHAR(64) NULL;

-- ── FHIR columns on emr_sch_appointment ──────────────────────
ALTER TABLE emr.emr_sch_appointment
  ADD COLUMN IF NOT EXISTS fhir_id VARCHAR(64) NULL;

-- ── FHIR resource type on emr_msg_outbound ───────────────────
ALTER TABLE emr.emr_msg_outbound
  ADD COLUMN IF NOT EXISTS fhir_resource_type VARCHAR(50) NULL;

-- ── New table: emr_fhir_resource_log ─────────────────────────
CREATE SEQUENCE IF NOT EXISTS emr.emr_fhir_resource_log_rid_seq START 1;

CREATE TABLE IF NOT EXISTS emr.emr_fhir_resource_log (
    rid                 BIGINT        NOT NULL DEFAULT nextval('emr.emr_fhir_resource_log_rid_seq'),
    resource_type       VARCHAR(50)   NOT NULL,
    resource_id         VARCHAR(64)   NOT NULL,
    resource_version    INTEGER       NOT NULL DEFAULT 1,
    operation           VARCHAR(10)   NOT NULL,  -- CREATE/UPDATE/DELETE/READ
    emr_table           VARCHAR(100)  NOT NULL,
    emr_rid             BIGINT        NOT NULL,
    fhir_payload        JSONB         NOT NULL,
    operation_datetime  TIMESTAMP     NOT NULL DEFAULT NOW(),
    operated_by         BIGINT        NOT NULL DEFAULT 0,
    source              VARCHAR(20)   NOT NULL,  -- REST/FHIR/HL7/MANUAL
    version             BIGINT        NOT NULL DEFAULT 0,
    created_by          BIGINT        NOT NULL DEFAULT 0,
    creation_date       TIMESTAMP     NOT NULL DEFAULT NOW(),
    update_date         TIMESTAMP     NULL,
    updated_by          BIGINT        NULL,
    is_deleted          BOOLEAN       NOT NULL DEFAULT FALSE,
    deleted_at          TIMESTAMP     NULL,
    deleted_by          BIGINT        NULL,
    CONSTRAINT pk_emr_fhir_resource_log PRIMARY KEY (rid)
);

CREATE INDEX IF NOT EXISTS idx_emr_fhir_log_type_id
  ON emr.emr_fhir_resource_log(resource_type, resource_id);
CREATE INDEX IF NOT EXISTS idx_emr_fhir_log_version
  ON emr.emr_fhir_resource_log(resource_type, resource_id, resource_version);
CREATE INDEX IF NOT EXISTS idx_emr_fhir_log_emr
  ON emr.emr_fhir_resource_log(emr_table, emr_rid);

COMMENT ON TABLE emr.emr_fhir_resource_log
  IS 'Tracks every FHIR resource served or received. Supports _history endpoint.';

-- ── FHIR ID generator function ────────────────────────────────
CREATE OR REPLACE FUNCTION emr.fn_emr_generate_fhir_id(
    p_resource_type VARCHAR,
    p_rid           BIGINT
) RETURNS VARCHAR AS $$
BEGIN
    RETURN LOWER(p_resource_type) || '-' || p_rid::TEXT;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- ── Auto-populate fhir_id on patient insert ───────────────────
CREATE OR REPLACE FUNCTION emr.trg_fn_emr_patient_fhir_id()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.fhir_id IS NULL THEN
        NEW.fhir_id := emr.fn_emr_generate_fhir_id('patient', NEW.rid);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_emr_patient_fhir_id
    BEFORE INSERT ON emr.emr_patients
    FOR EACH ROW EXECUTE FUNCTION emr.trg_fn_emr_patient_fhir_id();

-- ── Auto-populate fhir_id on encounter insert ─────────────────
CREATE OR REPLACE FUNCTION emr.trg_fn_emr_encounter_fhir_id()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.fhir_id IS NULL THEN
        NEW.fhir_id := emr.fn_emr_generate_fhir_id('encounter', NEW.rid);
    END IF;
    NEW.fhir_status := CASE NEW.encounter_status
        WHEN 'PLANNED'     THEN 'planned'
        WHEN 'ARRIVED'     THEN 'arrived'
        WHEN 'IN_PROGRESS' THEN 'in-progress'
        WHEN 'FINISHED'    THEN 'finished'
        WHEN 'CANCELLED'   THEN 'cancelled'
        ELSE 'unknown'
    END;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_emr_encounter_fhir_id
    BEFORE INSERT OR UPDATE ON emr.emr_encounters
    FOR EACH ROW EXECUTE FUNCTION emr.trg_fn_emr_encounter_fhir_id();

-- ── Log FHIR resource on patient insert/update ────────────────
CREATE OR REPLACE FUNCTION emr.trg_fn_emr_fhir_patient_log()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO emr.emr_fhir_resource_log (
        resource_type, resource_id, resource_version,
        operation, emr_table, emr_rid,
        fhir_payload, source,
        created_by, creation_date
    ) VALUES (
        'Patient',
        COALESCE(NEW.fhir_id, 'patient-' || NEW.rid::TEXT),
        NEW.version,
        CASE TG_OP WHEN 'INSERT' THEN 'CREATE' ELSE 'UPDATE' END,
        'emr_patients', NEW.rid,
        jsonb_build_object(
            'resourceType', 'Patient',
            'id',           COALESCE(NEW.fhir_id, 'patient-' || NEW.rid::TEXT),
            'identifier',   jsonb_build_array(
                jsonb_build_object('system', NEW.fhir_identifier_system, 'value', NEW.mrn)
            ),
            'name', jsonb_build_array(
                jsonb_build_object('family', NEW.last_name, 'given', jsonb_build_array(NEW.first_name))
            ),
            'birthDate', NEW.date_of_birth,
            'gender',    CASE NEW.gender WHEN 'M' THEN 'male' WHEN 'F' THEN 'female' ELSE 'unknown' END,
            'active',    NEW.is_active
        ),
        NEW.entry_source,
        COALESCE(NEW.created_by, 0), NOW()
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_emr_fhir_patient_log
    AFTER INSERT OR UPDATE ON emr.emr_patients
    FOR EACH ROW EXECUTE FUNCTION emr.trg_fn_emr_fhir_patient_log();

-- ── Update dev seed fhir_ids ──────────────────────────────────
UPDATE emr.emr_patients SET fhir_id = emr.fn_emr_generate_fhir_id('patient', rid) WHERE fhir_id IS NULL;
UPDATE emr.emr_encounters SET fhir_id = emr.fn_emr_generate_fhir_id('encounter', rid) WHERE fhir_id IS NULL;
UPDATE emr.emr_orm_order SET fhir_id = emr.fn_emr_generate_fhir_id('servicerequest', rid) WHERE fhir_id IS NULL;
UPDATE emr.emr_oru_result SET fhir_id = emr.fn_emr_generate_fhir_id('diagnosticreport', rid) WHERE fhir_id IS NULL;
UPDATE emr.emr_sch_appointment SET fhir_id = emr.fn_emr_generate_fhir_id('appointment', rid) WHERE fhir_id IS NULL;

-- ============================================================
-- END FHIR ADDITIONS v2.0
-- ============================================================
