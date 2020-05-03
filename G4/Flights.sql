/*CREATE SCHEMA FLIGHTS;

GO

CREATE TABLE FLIGHTS.AIRPORT
(
		airport_code		INT				NOT NULL,
		city				VARCHAR(30)		NOT NULL,
		state				VARCHAR(30)		NOT NULL,
		name				VARCHAR(20)		NOT NULL,
		PRIMARY KEY(airport_code)
);

CREATE TABLE FLIGHTS.AIRPLANE_TYPE
(
		type_name			VARCHAR(20)		NOT NULL,
		max_seats			SMALLINT		NOT NULL,
		company				VARCHAR(30)		NOT NULL,
		PRIMARY KEY(type_name)
);
CREATE TABLE FLIGHTS.CAN_LAND
(
		airport				INT				NOT NULL,
		airplane_type		VARCHAR(20)		NOT NULL,
		PRIMARY KEY(airport,airplane_type),
		FOREIGN KEY(airport)		REFERENCES FLIGHTS.AIRPORT(airport_code),
		FOREIGN KEY(airplane_type)	REFERENCES FLIGHTS.AIRPLANE_TYPE(type_name)
);

CREATE TABLE FLIGHTS.AIRPLANE
(
		airplane_id			VARCHAR(20)		NOT NULL,
		total_no_seats		SMALLINT		NOT NULL,
		PRIMARY KEY(airplane_id),
		FOREIGN KEY(airplane_id)	REFERENCES FLIGHTS.AIRPLANE_TYPE(type_name)
);

CREATE TABLE FLIGHTS.FLIGHT
(
		number				INT				NOT NULL,
		airline				VARCHAR(25)		NOT NULL,
		weekdays			VARCHAR(15)		NOT NULL,
		PRIMARY KEY(number)
);
*/
/*CREATE TABLE FLIGHTS.FLIGHT_LEG
(
		number				INT				NOT NULL,
		leg_no				INT				NOT NULL,
		PRIMARY KEY(number,leg_no),
		FOREIGN KEY(number)			REFERENCES FLIGHTS.FLIGHT(number),
		FOREIGN KEY(leg_no)			REFERENCES FLIGHTS.AIRPORT(airport_code)
);
*/

/*
CREATE TABLE FLIGHTS.LEG_INSTANCE
(
		number				INT				NOT NULL,
		no_avaiable_seats	SMALLINT,
		date				DATE			NOT NULL,
		leg_no				INT				NOT NULL,
		PRIMARY KEY(number,date,leg_no),
		FOREIGN KEY(number)			REFERENCES FLIGHTS.FLIGHT(number),
		FOREIGN KEY(leg_no)			REFERENCES FLIGHTS.AIRPORT(airport_code)
);
*/
/*DROP TABLE FLIGHTS.LEG_INSTANCE;

CREATE TABLE FLIGHTS.LEG_INSTANCE
(
		number				INT				NOT NULL,
		no_avaiable_seats	SMALLINT,
		datee				DATE			NOT NULL,
		leg_no				INT				NOT NULL,
		PRIMARY KEY(number,datee,leg_no),
		FOREIGN KEY(number)			REFERENCES FLIGHTS.FLIGHT(number),
		FOREIGN KEY(leg_no)			REFERENCES FLIGHTS.AIRPORT(airport_code)
);
*/

/*CREATE TABLE FLIGHTS.FARE	
(
		number				INT				NOT NULL,
		restrictions		VARCHAR(50)		NOT NULL,
		amount				INT				NOT NULL,
		code				INT				NOT NULL,
		PRIMARY KEY(number,code),
		FOREIGN KEY(number)			REFERENCES FLIGHTS.FLIGHT(number)
);
*/

/*
CREATE TABLE FLIGHTS.SEAT
(
		number				INT				NOT NULL,
		seat_no				SMALLINT		NOT NULL,
		date				DATE			NOT NULL,
		leg_no				INT				NOT NULL,
		PRIMARY KEY(number,seat_no,date,leg_no),
		FOREIGN KEY(number)			REFERENCES FLIGHTS.FLIGHT(number),
		FOREIGN KEY(date)			REFERENCES FLIGHTS.LEG_INSTANCE(date),
		FOREIGN KEY(leg_no)			REFERENCES FLIGHTS.AIRPORT(airport_code)
);

*/

CREATE TABLE FLIGHTS.SEAT
(
		number				INT				NOT NULL,
		seat_no				SMALLINT		NOT NULL,
		datee				DATE			NOT NULL,
		leg_no				INT				NOT NULL,
		PRIMARY KEY(number,seat_no,datee,leg_no),
		FOREIGN KEY(number,datee,leg_no)			REFERENCES FLIGHTS.LEG_INSTANCE(number,datee,leg_no),
);

