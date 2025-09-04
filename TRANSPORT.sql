-- Database: public_transport
CREATE TABLE lines (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    route_description TEXT,
    operation_hours VARCHAR(100)
);