--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: addresses; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE addresses (
    id integer NOT NULL,
    number integer,
    street_name character varying,
    street_type character varying,
    subburb character varying,
    city character varying,
    post_code character varying,
    state character varying,
    country character varying,
    addresable_id integer,
    addresable_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE addresses_id_seq OWNED BY addresses.id;


--
-- Name: areas; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE areas (
    id integer NOT NULL,
    city character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: areas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE areas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: areas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE areas_id_seq OWNED BY areas.id;


--
-- Name: ckeditor_assets; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE ckeditor_assets (
    id integer NOT NULL,
    data_file_name character varying NOT NULL,
    data_content_type character varying,
    data_file_size integer,
    assetable_id integer,
    assetable_type character varying(30),
    type character varying(30),
    width integer,
    height integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: ckeditor_assets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ckeditor_assets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ckeditor_assets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ckeditor_assets_id_seq OWNED BY ckeditor_assets.id;


--
-- Name: commontator_comments; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE commontator_comments (
    id integer NOT NULL,
    creator_type character varying,
    creator_id integer,
    editor_type character varying,
    editor_id integer,
    thread_id integer NOT NULL,
    body text NOT NULL,
    deleted_at timestamp without time zone,
    cached_votes_up integer DEFAULT 0,
    cached_votes_down integer DEFAULT 0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: commontator_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE commontator_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: commontator_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE commontator_comments_id_seq OWNED BY commontator_comments.id;


--
-- Name: commontator_subscriptions; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE commontator_subscriptions (
    id integer NOT NULL,
    subscriber_type character varying NOT NULL,
    subscriber_id integer NOT NULL,
    thread_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: commontator_subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE commontator_subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: commontator_subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE commontator_subscriptions_id_seq OWNED BY commontator_subscriptions.id;


--
-- Name: commontator_threads; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE commontator_threads (
    id integer NOT NULL,
    commontable_type character varying,
    commontable_id integer,
    closed_at timestamp without time zone,
    closer_type character varying,
    closer_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: commontator_threads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE commontator_threads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: commontator_threads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE commontator_threads_id_seq OWNED BY commontator_threads.id;


--
-- Name: contact_forms; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE contact_forms (
    id integer NOT NULL,
    email character varying,
    phone character varying,
    subject character varying,
    message text,
    contact_location_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: contact_forms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE contact_forms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contact_forms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE contact_forms_id_seq OWNED BY contact_forms.id;


--
-- Name: contact_locations; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE contact_locations (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: contact_locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE contact_locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contact_locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE contact_locations_id_seq OWNED BY contact_locations.id;


--
-- Name: contacts; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE contacts (
    id integer NOT NULL,
    name character varying,
    "position" character varying,
    email character varying,
    visible boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    avatar_file_name character varying,
    avatar_content_type character varying,
    avatar_file_size integer,
    avatar_updated_at timestamp without time zone,
    contact_location_id integer
);


--
-- Name: contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE contacts_id_seq OWNED BY contacts.id;


--
-- Name: course_versions; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE course_versions (
    id integer NOT NULL,
    version_number integer,
    date_added timestamp without time zone,
    class_size integer,
    expiry_date date,
    enrolment_end_added timestamp without time zone,
    students_count integer,
    course_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: course_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE course_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: course_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE course_versions_id_seq OWNED BY course_versions.id;


--
-- Name: courses; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE courses (
    id integer NOT NULL,
    name character varying,
    class_size integer,
    expiry_date date,
    enrolment_end_date timestamp without time zone,
    product_version_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    slug character varying NOT NULL
);


--
-- Name: courses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE courses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: courses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE courses_id_seq OWNED BY courses.id;


--
-- Name: essay_responses; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE essay_responses (
    id integer NOT NULL,
    response text,
    time_submited time without time zone,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: essay_responses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE essay_responses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: essay_responses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE essay_responses_id_seq OWNED BY essay_responses.id;


--
-- Name: essay_tutor_responses; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE essay_tutor_responses (
    id integer NOT NULL,
    response text,
    rate numeric(10,2),
    essay_response_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: essay_tutor_responses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE essay_tutor_responses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: essay_tutor_responses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE essay_tutor_responses_id_seq OWNED BY essay_tutor_responses.id;


--
-- Name: essays; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE essays (
    id integer NOT NULL,
    title character varying,
    question text,
    date_added timestamp without time zone,
    expiration_date timestamp without time zone,
    tutor_id integer,
    student_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    essay_response_id integer
);


--
-- Name: essays_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE essays_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: essays_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE essays_id_seq OWNED BY essays.id;


--
-- Name: exam_sections; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE exam_sections (
    id integer NOT NULL,
    title character varying,
    "dificultyRating" double precision,
    exam_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    slug character varying
);


--
-- Name: exam_sections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE exam_sections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: exam_sections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE exam_sections_id_seq OWNED BY exam_sections.id;


--
-- Name: exams; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE exams (
    id integer NOT NULL,
    date_started timestamp without time zone,
    date_finished timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    subject_id integer,
    "examType" character varying
);


--
-- Name: exams_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE exams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: exams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE exams_id_seq OWNED BY exams.id;


--
-- Name: mcq_answers; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE mcq_answers (
    id integer NOT NULL,
    answer text,
    correct boolean,
    mcq_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: mcq_answers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mcq_answers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mcq_answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mcq_answers_id_seq OWNED BY mcq_answers.id;


--
-- Name: mcq_stems; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE mcq_stems (
    id integer NOT NULL,
    title character varying,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: mcq_stems_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mcq_stems_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mcq_stems_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mcq_stems_id_seq OWNED BY mcq_stems.id;


--
-- Name: mcqs; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE mcqs (
    id integer NOT NULL,
    question text,
    difficulty double precision,
    examinable boolean,
    publish boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    mcq_stem_id integer,
    exam_section_id integer,
    explanation text
);


--
-- Name: mcqs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mcqs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mcqs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mcqs_id_seq OWNED BY mcqs.id;


--
-- Name: mcqs_questionaires; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE mcqs_questionaires (
    questionaire_id integer NOT NULL,
    mcq_id integer NOT NULL
);


--
-- Name: photos; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE photos (
    id integer NOT NULL,
    product_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    image_file_name character varying,
    image_content_type character varying,
    image_file_size integer,
    image_updated_at timestamp without time zone
);


--
-- Name: photos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE photos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: photos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE photos_id_seq OWNED BY photos.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE products (
    id integer NOT NULL,
    sku character varying,
    currency character varying,
    name character varying,
    description text,
    cost numeric(7,2),
    type character varying,
    weight double precision,
    length double precision,
    width double precision,
    height double precision,
    starting_date timestamp without time zone,
    stopping_date timestamp without time zone,
    expiration_date timestamp without time zone,
    course_version_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    slug character varying
);


--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE products_id_seq OWNED BY products.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: student_class_sessions; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE student_class_sessions (
    id integer NOT NULL,
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    frequency integer,
    student_class_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: student_class_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE student_class_sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: student_class_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE student_class_sessions_id_seq OWNED BY student_class_sessions.id;


--
-- Name: student_classes; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE student_classes (
    id integer NOT NULL,
    name character varying,
    size integer,
    subject_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: student_classes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE student_classes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: student_classes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE student_classes_id_seq OWNED BY student_classes.id;


--
-- Name: students_classes; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE students_classes (
    id integer NOT NULL,
    user_id integer,
    student_class_id integer
);


--
-- Name: subjects; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE subjects (
    id integer NOT NULL,
    title character varying,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    slug character varying,
    course_version_id integer,
    course_id integer
);


--
-- Name: user_subjects; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE user_subjects (
    id integer NOT NULL,
    user_id integer,
    subject_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: student_courses; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW student_courses AS
    SELECT DISTINCT s.course_version_id, scs.user_id FROM ((students_classes scs LEFT JOIN student_classes sc ON ((sc.id = scs.student_class_id))) LEFT JOIN subjects s ON ((s.id = sc.subject_id))) WHERE ((s.course_version_id IS NOT NULL) AND (scs.user_id IS NOT NULL)) UNION SELECT DISTINCT s.course_version_id, us.user_id FROM (subjects s LEFT JOIN user_subjects us ON ((us.subject_id = s.id))) WHERE ((s.course_version_id IS NOT NULL) AND (us.user_id IS NOT NULL));


--
-- Name: student_questions; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE student_questions (
    id integer NOT NULL,
    question text,
    date_published timestamp without time zone,
    published boolean,
    user_id integer,
    tutor_answer_id integer,
    subject_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    slug character varying
);


--
-- Name: student_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE student_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: student_questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE student_questions_id_seq OWNED BY student_questions.id;


--
-- Name: students_classes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE students_classes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: students_classes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE students_classes_id_seq OWNED BY students_classes.id;


--
-- Name: students_course_versions; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE students_course_versions (
    id integer NOT NULL,
    user_id integer,
    course_version_id integer
);


--
-- Name: students_course_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE students_course_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: students_course_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE students_course_versions_id_seq OWNED BY students_course_versions.id;


--
-- Name: subjects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE subjects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subjects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE subjects_id_seq OWNED BY subjects.id;


--
-- Name: survey_answers; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE survey_answers (
    id integer NOT NULL,
    user_id integer,
    survey_question_id integer,
    answer text,
    rating integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: survey_answers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE survey_answers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: survey_answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE survey_answers_id_seq OWNED BY survey_answers.id;


--
-- Name: survey_questions; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE survey_questions (
    id integer NOT NULL,
    survey_id integer,
    question text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: survey_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE survey_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: survey_questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE survey_questions_id_seq OWNED BY survey_questions.id;


--
-- Name: surveys; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE surveys (
    id integer NOT NULL,
    title character varying,
    date_published timestamp without time zone,
    date_start timestamp without time zone,
    published boolean,
    date_closed timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    slug character varying
);


--
-- Name: surveys_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE surveys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: surveys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE surveys_id_seq OWNED BY surveys.id;


--
-- Name: tutor_answers; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE tutor_answers (
    id integer NOT NULL,
    answer text,
    date_published timestamp without time zone,
    published boolean,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: tutor_answers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tutor_answers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tutor_answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tutor_answers_id_seq OWNED BY tutor_answers.id;


--
-- Name: tutors_classes; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE tutors_classes (
    id integer NOT NULL,
    user_id integer,
    student_class_id integer
);


--
-- Name: tutors_classes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tutors_classes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tutors_classes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tutors_classes_id_seq OWNED BY tutors_classes.id;


--
-- Name: user_subjects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_subjects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_subjects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_subjects_id_seq OWNED BY user_subjects.id;


--
-- Name: user_surveys; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE user_surveys (
    id integer NOT NULL,
    user_id integer,
    survey_id integer,
    is_submited boolean
);


--
-- Name: user_surveys_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_surveys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_surveys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_surveys_id_seq OWNED BY user_surveys.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    first_name character varying,
    last_name character varying,
    username character varying,
    date_of_birth date,
    date_signed_up timestamp without time zone,
    role character varying,
    bio text,
    profile_image character varying,
    slug character varying
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY addresses ALTER COLUMN id SET DEFAULT nextval('addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY areas ALTER COLUMN id SET DEFAULT nextval('areas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ckeditor_assets ALTER COLUMN id SET DEFAULT nextval('ckeditor_assets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY commontator_comments ALTER COLUMN id SET DEFAULT nextval('commontator_comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY commontator_subscriptions ALTER COLUMN id SET DEFAULT nextval('commontator_subscriptions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY commontator_threads ALTER COLUMN id SET DEFAULT nextval('commontator_threads_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY contact_forms ALTER COLUMN id SET DEFAULT nextval('contact_forms_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY contact_locations ALTER COLUMN id SET DEFAULT nextval('contact_locations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY contacts ALTER COLUMN id SET DEFAULT nextval('contacts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY course_versions ALTER COLUMN id SET DEFAULT nextval('course_versions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY courses ALTER COLUMN id SET DEFAULT nextval('courses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY essay_responses ALTER COLUMN id SET DEFAULT nextval('essay_responses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY essay_tutor_responses ALTER COLUMN id SET DEFAULT nextval('essay_tutor_responses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY essays ALTER COLUMN id SET DEFAULT nextval('essays_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY exam_sections ALTER COLUMN id SET DEFAULT nextval('exam_sections_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY exams ALTER COLUMN id SET DEFAULT nextval('exams_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mcq_answers ALTER COLUMN id SET DEFAULT nextval('mcq_answers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mcq_stems ALTER COLUMN id SET DEFAULT nextval('mcq_stems_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mcqs ALTER COLUMN id SET DEFAULT nextval('mcqs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY photos ALTER COLUMN id SET DEFAULT nextval('photos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY products ALTER COLUMN id SET DEFAULT nextval('products_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY student_class_sessions ALTER COLUMN id SET DEFAULT nextval('student_class_sessions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY student_classes ALTER COLUMN id SET DEFAULT nextval('student_classes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY student_questions ALTER COLUMN id SET DEFAULT nextval('student_questions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY students_classes ALTER COLUMN id SET DEFAULT nextval('students_classes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY students_course_versions ALTER COLUMN id SET DEFAULT nextval('students_course_versions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY subjects ALTER COLUMN id SET DEFAULT nextval('subjects_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY survey_answers ALTER COLUMN id SET DEFAULT nextval('survey_answers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY survey_questions ALTER COLUMN id SET DEFAULT nextval('survey_questions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY surveys ALTER COLUMN id SET DEFAULT nextval('surveys_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tutor_answers ALTER COLUMN id SET DEFAULT nextval('tutor_answers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tutors_classes ALTER COLUMN id SET DEFAULT nextval('tutors_classes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_subjects ALTER COLUMN id SET DEFAULT nextval('user_subjects_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_surveys ALTER COLUMN id SET DEFAULT nextval('user_surveys_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: areas_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY areas
    ADD CONSTRAINT areas_pkey PRIMARY KEY (id);


--
-- Name: ckeditor_assets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY ckeditor_assets
    ADD CONSTRAINT ckeditor_assets_pkey PRIMARY KEY (id);


--
-- Name: commontator_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY commontator_comments
    ADD CONSTRAINT commontator_comments_pkey PRIMARY KEY (id);


--
-- Name: commontator_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY commontator_subscriptions
    ADD CONSTRAINT commontator_subscriptions_pkey PRIMARY KEY (id);


--
-- Name: commontator_threads_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY commontator_threads
    ADD CONSTRAINT commontator_threads_pkey PRIMARY KEY (id);


--
-- Name: contact_forms_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY contact_forms
    ADD CONSTRAINT contact_forms_pkey PRIMARY KEY (id);


--
-- Name: contact_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY contact_locations
    ADD CONSTRAINT contact_locations_pkey PRIMARY KEY (id);


--
-- Name: contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY contacts
    ADD CONSTRAINT contacts_pkey PRIMARY KEY (id);


--
-- Name: course_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY course_versions
    ADD CONSTRAINT course_versions_pkey PRIMARY KEY (id);


--
-- Name: courses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (id);


--
-- Name: essay_responses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY essay_responses
    ADD CONSTRAINT essay_responses_pkey PRIMARY KEY (id);


--
-- Name: essay_tutor_responses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY essay_tutor_responses
    ADD CONSTRAINT essay_tutor_responses_pkey PRIMARY KEY (id);


--
-- Name: essays_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY essays
    ADD CONSTRAINT essays_pkey PRIMARY KEY (id);


--
-- Name: exam_sections_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY exam_sections
    ADD CONSTRAINT exam_sections_pkey PRIMARY KEY (id);


--
-- Name: exams_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY exams
    ADD CONSTRAINT exams_pkey PRIMARY KEY (id);


--
-- Name: mcq_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY mcq_answers
    ADD CONSTRAINT mcq_answers_pkey PRIMARY KEY (id);


--
-- Name: mcq_stems_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY mcq_stems
    ADD CONSTRAINT mcq_stems_pkey PRIMARY KEY (id);


--
-- Name: mcqs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY mcqs
    ADD CONSTRAINT mcqs_pkey PRIMARY KEY (id);


--
-- Name: photos_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY photos
    ADD CONSTRAINT photos_pkey PRIMARY KEY (id);


--
-- Name: products_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: student_class_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY student_class_sessions
    ADD CONSTRAINT student_class_sessions_pkey PRIMARY KEY (id);


--
-- Name: student_classes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY student_classes
    ADD CONSTRAINT student_classes_pkey PRIMARY KEY (id);


--
-- Name: student_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY student_questions
    ADD CONSTRAINT student_questions_pkey PRIMARY KEY (id);


--
-- Name: students_classes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY students_classes
    ADD CONSTRAINT students_classes_pkey PRIMARY KEY (id);


--
-- Name: students_course_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY students_course_versions
    ADD CONSTRAINT students_course_versions_pkey PRIMARY KEY (id);


--
-- Name: subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY subjects
    ADD CONSTRAINT subjects_pkey PRIMARY KEY (id);


--
-- Name: survey_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY survey_answers
    ADD CONSTRAINT survey_answers_pkey PRIMARY KEY (id);


--
-- Name: survey_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY survey_questions
    ADD CONSTRAINT survey_questions_pkey PRIMARY KEY (id);


--
-- Name: surveys_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY surveys
    ADD CONSTRAINT surveys_pkey PRIMARY KEY (id);


--
-- Name: tutor_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY tutor_answers
    ADD CONSTRAINT tutor_answers_pkey PRIMARY KEY (id);


--
-- Name: tutors_classes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY tutors_classes
    ADD CONSTRAINT tutors_classes_pkey PRIMARY KEY (id);


--
-- Name: user_subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY user_subjects
    ADD CONSTRAINT user_subjects_pkey PRIMARY KEY (id);


--
-- Name: user_surveys_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY user_surveys
    ADD CONSTRAINT user_surveys_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_ckeditor_assetable; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX idx_ckeditor_assetable ON ckeditor_assets USING btree (assetable_type, assetable_id);


--
-- Name: idx_ckeditor_assetable_type; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX idx_ckeditor_assetable_type ON ckeditor_assets USING btree (assetable_type, type, assetable_id);


--
-- Name: index_areas_on_city; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_areas_on_city ON areas USING btree (city);


--
-- Name: index_commontator_comments_on_c_id_and_c_type_and_t_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_commontator_comments_on_c_id_and_c_type_and_t_id ON commontator_comments USING btree (creator_id, creator_type, thread_id);


--
-- Name: index_commontator_comments_on_cached_votes_down; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_commontator_comments_on_cached_votes_down ON commontator_comments USING btree (cached_votes_down);


--
-- Name: index_commontator_comments_on_cached_votes_up; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_commontator_comments_on_cached_votes_up ON commontator_comments USING btree (cached_votes_up);


--
-- Name: index_commontator_comments_on_thread_id_and_created_at; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_commontator_comments_on_thread_id_and_created_at ON commontator_comments USING btree (thread_id, created_at);


--
-- Name: index_commontator_subscriptions_on_s_id_and_s_type_and_t_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX index_commontator_subscriptions_on_s_id_and_s_type_and_t_id ON commontator_subscriptions USING btree (subscriber_id, subscriber_type, thread_id);


--
-- Name: index_commontator_subscriptions_on_thread_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_commontator_subscriptions_on_thread_id ON commontator_subscriptions USING btree (thread_id);


--
-- Name: index_commontator_threads_on_c_id_and_c_type; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX index_commontator_threads_on_c_id_and_c_type ON commontator_threads USING btree (commontable_id, commontable_type);


--
-- Name: index_contact_forms_on_contact_location_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_contact_forms_on_contact_location_id ON contact_forms USING btree (contact_location_id);


--
-- Name: index_contacts_on_contact_location_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_contacts_on_contact_location_id ON contacts USING btree (contact_location_id);


--
-- Name: index_courses_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX index_courses_on_slug ON courses USING btree (slug);


--
-- Name: index_essay_responses_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_essay_responses_on_user_id ON essay_responses USING btree (user_id);


--
-- Name: index_essay_tutor_responses_on_essay_response_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_essay_tutor_responses_on_essay_response_id ON essay_tutor_responses USING btree (essay_response_id);


--
-- Name: index_essays_on_essay_response_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_essays_on_essay_response_id ON essays USING btree (essay_response_id);


--
-- Name: index_essays_on_student_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_essays_on_student_id ON essays USING btree (student_id);


--
-- Name: index_essays_on_tutor_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_essays_on_tutor_id ON essays USING btree (tutor_id);


--
-- Name: index_exam_sections_on_exam_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_exam_sections_on_exam_id ON exam_sections USING btree (exam_id);


--
-- Name: index_exam_sections_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX index_exam_sections_on_slug ON exam_sections USING btree (slug);


--
-- Name: index_exams_on_date_finished; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_exams_on_date_finished ON exams USING btree (date_finished);


--
-- Name: index_exams_on_date_started; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_exams_on_date_started ON exams USING btree (date_started);


--
-- Name: index_exams_on_subject_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_exams_on_subject_id ON exams USING btree (subject_id);


--
-- Name: index_mcq_answers_on_mcq_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_mcq_answers_on_mcq_id ON mcq_answers USING btree (mcq_id);


--
-- Name: index_mcqs_on_exam_section_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_mcqs_on_exam_section_id ON mcqs USING btree (exam_section_id);


--
-- Name: index_mcqs_on_mcq_stem_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_mcqs_on_mcq_stem_id ON mcqs USING btree (mcq_stem_id);


--
-- Name: index_photos_on_product_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_photos_on_product_id ON photos USING btree (product_id);


--
-- Name: index_products_on_cost; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_products_on_cost ON products USING btree (cost);


--
-- Name: index_products_on_course_version_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_products_on_course_version_id ON products USING btree (course_version_id);


--
-- Name: index_products_on_height; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_products_on_height ON products USING btree (height);


--
-- Name: index_products_on_length; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_products_on_length ON products USING btree (length);


--
-- Name: index_products_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_products_on_name ON products USING btree (name);


--
-- Name: index_products_on_sku; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_products_on_sku ON products USING btree (sku);


--
-- Name: index_products_on_starting_date; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_products_on_starting_date ON products USING btree (starting_date);


--
-- Name: index_products_on_stopping_date; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_products_on_stopping_date ON products USING btree (stopping_date);


--
-- Name: index_products_on_weight; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_products_on_weight ON products USING btree (weight);


--
-- Name: index_student_class_sessions_on_student_class_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_student_class_sessions_on_student_class_id ON student_class_sessions USING btree (student_class_id);


--
-- Name: index_student_classes_on_subject_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_student_classes_on_subject_id ON student_classes USING btree (subject_id);


--
-- Name: index_student_questions_on_date_published; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_student_questions_on_date_published ON student_questions USING btree (date_published);


--
-- Name: index_student_questions_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX index_student_questions_on_slug ON student_questions USING btree (slug);


--
-- Name: index_student_questions_on_subject_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_student_questions_on_subject_id ON student_questions USING btree (subject_id);


--
-- Name: index_student_questions_on_tutor_answer_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_student_questions_on_tutor_answer_id ON student_questions USING btree (tutor_answer_id);


--
-- Name: index_student_questions_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_student_questions_on_user_id ON student_questions USING btree (user_id);


--
-- Name: index_students_classes_on_student_class_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_students_classes_on_student_class_id ON students_classes USING btree (student_class_id);


--
-- Name: index_students_classes_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_students_classes_on_user_id ON students_classes USING btree (user_id);


--
-- Name: index_subjects_on_course_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_subjects_on_course_id ON subjects USING btree (course_id);


--
-- Name: index_subjects_on_course_version_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_subjects_on_course_version_id ON subjects USING btree (course_version_id);


--
-- Name: index_subjects_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX index_subjects_on_slug ON subjects USING btree (slug);


--
-- Name: index_subjects_on_title; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_subjects_on_title ON subjects USING btree (title);


--
-- Name: index_survey_answers_on_survey_question_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_survey_answers_on_survey_question_id ON survey_answers USING btree (survey_question_id);


--
-- Name: index_survey_answers_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_survey_answers_on_user_id ON survey_answers USING btree (user_id);


--
-- Name: index_survey_questions_on_survey_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_survey_questions_on_survey_id ON survey_questions USING btree (survey_id);


--
-- Name: index_surveys_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX index_surveys_on_slug ON surveys USING btree (slug);


--
-- Name: index_tutor_answers_on_date_published; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_tutor_answers_on_date_published ON tutor_answers USING btree (date_published);


--
-- Name: index_tutor_answers_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_tutor_answers_on_user_id ON tutor_answers USING btree (user_id);


--
-- Name: index_tutors_classes_on_student_class_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_tutors_classes_on_student_class_id ON tutors_classes USING btree (student_class_id);


--
-- Name: index_tutors_classes_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_tutors_classes_on_user_id ON tutors_classes USING btree (user_id);


--
-- Name: index_user_subjects_on_subject_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_user_subjects_on_subject_id ON user_subjects USING btree (subject_id);


--
-- Name: index_user_subjects_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_user_subjects_on_user_id ON user_subjects USING btree (user_id);


--
-- Name: index_user_surveys_on_survey_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_user_surveys_on_survey_id ON user_surveys USING btree (survey_id);


--
-- Name: index_user_surveys_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_user_surveys_on_user_id ON user_surveys USING btree (user_id);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);


--
-- Name: index_users_on_date_of_birth; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_users_on_date_of_birth ON users USING btree (date_of_birth);


--
-- Name: index_users_on_date_signed_up; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_users_on_date_signed_up ON users USING btree (date_signed_up);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_first_name; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_users_on_first_name ON users USING btree (first_name);


--
-- Name: index_users_on_last_name; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_users_on_last_name ON users USING btree (last_name);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_users_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX index_users_on_slug ON users USING btree (slug);


--
-- Name: index_users_on_username; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_users_on_username ON users USING btree (username);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_rails_10710add2f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY photos
    ADD CONSTRAINT fk_rails_10710add2f FOREIGN KEY (product_id) REFERENCES products(id);


--
-- Name: fk_rails_258468bc4e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY student_questions
    ADD CONSTRAINT fk_rails_258468bc4e FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_29e084d796; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_surveys
    ADD CONSTRAINT fk_rails_29e084d796 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_2b8bcc5100; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY exams
    ADD CONSTRAINT fk_rails_2b8bcc5100 FOREIGN KEY (subject_id) REFERENCES subjects(id);


--
-- Name: fk_rails_34f7b22503; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY student_questions
    ADD CONSTRAINT fk_rails_34f7b22503 FOREIGN KEY (subject_id) REFERENCES subjects(id);


--
-- Name: fk_rails_52caf311a1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY subjects
    ADD CONSTRAINT fk_rails_52caf311a1 FOREIGN KEY (course_version_id) REFERENCES course_versions(id);


--
-- Name: fk_rails_53fd5f3baf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY students_classes
    ADD CONSTRAINT fk_rails_53fd5f3baf FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_5ed48cb771; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY student_classes
    ADD CONSTRAINT fk_rails_5ed48cb771 FOREIGN KEY (subject_id) REFERENCES subjects(id);


--
-- Name: fk_rails_621f80522c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY survey_answers
    ADD CONSTRAINT fk_rails_621f80522c FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_6bd4cba2c2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY products
    ADD CONSTRAINT fk_rails_6bd4cba2c2 FOREIGN KEY (course_version_id) REFERENCES course_versions(id);


--
-- Name: fk_rails_78acd65dc8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY students_classes
    ADD CONSTRAINT fk_rails_78acd65dc8 FOREIGN KEY (student_class_id) REFERENCES student_classes(id);


--
-- Name: fk_rails_865a285651; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY essays
    ADD CONSTRAINT fk_rails_865a285651 FOREIGN KEY (essay_response_id) REFERENCES essay_responses(id);


--
-- Name: fk_rails_89abe31482; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tutors_classes
    ADD CONSTRAINT fk_rails_89abe31482 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_8eb2359433; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contact_forms
    ADD CONSTRAINT fk_rails_8eb2359433 FOREIGN KEY (contact_location_id) REFERENCES contact_locations(id);


--
-- Name: fk_rails_a164149aed; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tutor_answers
    ADD CONSTRAINT fk_rails_a164149aed FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_a1bf68115b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_subjects
    ADD CONSTRAINT fk_rails_a1bf68115b FOREIGN KEY (subject_id) REFERENCES subjects(id);


--
-- Name: fk_rails_a8519682c4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY student_questions
    ADD CONSTRAINT fk_rails_a8519682c4 FOREIGN KEY (tutor_answer_id) REFERENCES tutor_answers(id);


--
-- Name: fk_rails_aa3e88ca08; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY student_class_sessions
    ADD CONSTRAINT fk_rails_aa3e88ca08 FOREIGN KEY (student_class_id) REFERENCES student_classes(id);


--
-- Name: fk_rails_ab0ed09b45; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY exam_sections
    ADD CONSTRAINT fk_rails_ab0ed09b45 FOREIGN KEY (exam_id) REFERENCES exams(id);


--
-- Name: fk_rails_bf2e5b9d19; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mcqs
    ADD CONSTRAINT fk_rails_bf2e5b9d19 FOREIGN KEY (mcq_stem_id) REFERENCES mcq_stems(id);


--
-- Name: fk_rails_d0558bfd89; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY survey_questions
    ADD CONSTRAINT fk_rails_d0558bfd89 FOREIGN KEY (survey_id) REFERENCES surveys(id);


--
-- Name: fk_rails_d31cccf6a9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY subjects
    ADD CONSTRAINT fk_rails_d31cccf6a9 FOREIGN KEY (course_id) REFERENCES courses(id);


--
-- Name: fk_rails_d3d3dc4da3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tutors_classes
    ADD CONSTRAINT fk_rails_d3d3dc4da3 FOREIGN KEY (student_class_id) REFERENCES student_classes(id);


--
-- Name: fk_rails_d4e8a0fe8b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mcq_answers
    ADD CONSTRAINT fk_rails_d4e8a0fe8b FOREIGN KEY (mcq_id) REFERENCES mcqs(id);


--
-- Name: fk_rails_d5508fe8d0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY survey_answers
    ADD CONSTRAINT fk_rails_d5508fe8d0 FOREIGN KEY (survey_question_id) REFERENCES survey_questions(id);


--
-- Name: fk_rails_e30a7dc503; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_subjects
    ADD CONSTRAINT fk_rails_e30a7dc503 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_e38389079e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_surveys
    ADD CONSTRAINT fk_rails_e38389079e FOREIGN KEY (survey_id) REFERENCES surveys(id);


--
-- Name: fk_rails_e4e3d1c626; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY essay_tutor_responses
    ADD CONSTRAINT fk_rails_e4e3d1c626 FOREIGN KEY (essay_response_id) REFERENCES essay_responses(id);


--
-- Name: fk_rails_eb89f31b18; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY essay_responses
    ADD CONSTRAINT fk_rails_eb89f31b18 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_ecb0ca99dd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mcqs
    ADD CONSTRAINT fk_rails_ecb0ca99dd FOREIGN KEY (exam_section_id) REFERENCES exam_sections(id);


--
-- Name: fk_rails_f8f769232e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contacts
    ADD CONSTRAINT fk_rails_f8f769232e FOREIGN KEY (contact_location_id) REFERENCES contact_locations(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20150928115523');

INSERT INTO schema_migrations (version) VALUES ('20150928121116');

INSERT INTO schema_migrations (version) VALUES ('20150928121145');

INSERT INTO schema_migrations (version) VALUES ('20150928121443');

INSERT INTO schema_migrations (version) VALUES ('20150928122914');

INSERT INTO schema_migrations (version) VALUES ('20150928123126');

INSERT INTO schema_migrations (version) VALUES ('20150928134725');

INSERT INTO schema_migrations (version) VALUES ('20150928145909');

INSERT INTO schema_migrations (version) VALUES ('20150928152154');

INSERT INTO schema_migrations (version) VALUES ('20150929111847');

INSERT INTO schema_migrations (version) VALUES ('20150929111929');

INSERT INTO schema_migrations (version) VALUES ('20150929112231');

INSERT INTO schema_migrations (version) VALUES ('20150929122239');

INSERT INTO schema_migrations (version) VALUES ('20150929124550');

INSERT INTO schema_migrations (version) VALUES ('20150930045908');

INSERT INTO schema_migrations (version) VALUES ('20150930074145');

INSERT INTO schema_migrations (version) VALUES ('20150930122457');

INSERT INTO schema_migrations (version) VALUES ('20150930141502');

INSERT INTO schema_migrations (version) VALUES ('20151001061126');

INSERT INTO schema_migrations (version) VALUES ('20151001090901');

INSERT INTO schema_migrations (version) VALUES ('20151001091220');

INSERT INTO schema_migrations (version) VALUES ('20151001093351');

INSERT INTO schema_migrations (version) VALUES ('20151001094958');

INSERT INTO schema_migrations (version) VALUES ('20151001112337');

INSERT INTO schema_migrations (version) VALUES ('20151001122119');

INSERT INTO schema_migrations (version) VALUES ('20151002093740');

INSERT INTO schema_migrations (version) VALUES ('20151002094037');

INSERT INTO schema_migrations (version) VALUES ('20151002094109');

INSERT INTO schema_migrations (version) VALUES ('20151005125023');

INSERT INTO schema_migrations (version) VALUES ('20151005125059');

INSERT INTO schema_migrations (version) VALUES ('20151006064228');

INSERT INTO schema_migrations (version) VALUES ('20151006104444');

INSERT INTO schema_migrations (version) VALUES ('20151006104510');

INSERT INTO schema_migrations (version) VALUES ('20151006104516');

INSERT INTO schema_migrations (version) VALUES ('20151007154552');

INSERT INTO schema_migrations (version) VALUES ('20151007155224');

INSERT INTO schema_migrations (version) VALUES ('20151008085405');

INSERT INTO schema_migrations (version) VALUES ('20151008094455');

INSERT INTO schema_migrations (version) VALUES ('20151008095407');

INSERT INTO schema_migrations (version) VALUES ('20151008095635');

INSERT INTO schema_migrations (version) VALUES ('20151008113959');

INSERT INTO schema_migrations (version) VALUES ('20151008120646');

INSERT INTO schema_migrations (version) VALUES ('20151008130939');

INSERT INTO schema_migrations (version) VALUES ('20151008131536');

INSERT INTO schema_migrations (version) VALUES ('20151009094055');

INSERT INTO schema_migrations (version) VALUES ('20151009095144');

INSERT INTO schema_migrations (version) VALUES ('20151009143904');

INSERT INTO schema_migrations (version) VALUES ('20151009144332');

INSERT INTO schema_migrations (version) VALUES ('20151012090835');

INSERT INTO schema_migrations (version) VALUES ('20151012104539');

INSERT INTO schema_migrations (version) VALUES ('20151013102332');

INSERT INTO schema_migrations (version) VALUES ('20151013103110');

INSERT INTO schema_migrations (version) VALUES ('20151013124659');

INSERT INTO schema_migrations (version) VALUES ('20151013124708');

INSERT INTO schema_migrations (version) VALUES ('20151014093335');

INSERT INTO schema_migrations (version) VALUES ('20151014103252');

INSERT INTO schema_migrations (version) VALUES ('20151014103302');

INSERT INTO schema_migrations (version) VALUES ('20151014113120');

INSERT INTO schema_migrations (version) VALUES ('20151014125719');

INSERT INTO schema_migrations (version) VALUES ('20151015061038');

INSERT INTO schema_migrations (version) VALUES ('20151015093154');

INSERT INTO schema_migrations (version) VALUES ('20151015121629');

INSERT INTO schema_migrations (version) VALUES ('20151016075001');

INSERT INTO schema_migrations (version) VALUES ('20151019115917');

INSERT INTO schema_migrations (version) VALUES ('20151019132716');

INSERT INTO schema_migrations (version) VALUES ('20151019133607');

INSERT INTO schema_migrations (version) VALUES ('20151019134534');

INSERT INTO schema_migrations (version) VALUES ('20151020094246');

INSERT INTO schema_migrations (version) VALUES ('20151020094959');

