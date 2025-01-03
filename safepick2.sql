CREATE TABLE  parents (
    id INT PRIMARY KEY,        -- Unique ID for each user
    name VARCHAR(255) NOT NULL,                -- Parent's name
    email VARCHAR(255) NOT NULL UNIQUE,        -- Parent's email (must be unique)
    password VARCHAR(255) NOT NULL,            -- Parent's password
    phone_number VARCHAR(15),                 -- Parent's phone number
    student_name VARCHAR(255),                -- Student's name
    grade VARCHAR(10),                        -- Grade of the student
);

-- Create the `children` table to store child information
CREATE TABLE children (
    id INT  PRIMARY KEY,        -- Unique ID for each child
    parent_id INT NOT NULL,                   -- Foreign key referencing the parent (user)
    child_name VARCHAR(255) NOT NULL,          -- Child's name
    class VARCHAR(50),                        -- Child's class
    FOREIGN KEY (parent_id) REFERENCES parents(id)  -- Link to the user (parent)
);