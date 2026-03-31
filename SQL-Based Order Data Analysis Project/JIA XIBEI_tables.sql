CREATE DATABASE lab3_db;
USE lab3_db;


CREATE TABLE CUSTOMER (
    Cus_number INT PRIMARY KEY,
    Cus_name VARCHAR(100) NOT NULL,
    City VARCHAR(50),
    Phone VARCHAR(20)
);


CREATE TABLE EMPLOYEE (
    Emp_ID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Address VARCHAR(200),
    DOB DATE,
    Class ENUM('assistant', 'associate', 'manager') NOT NULL,
    Salary DECIMAL(10,2)
);


CREATE TABLE PAPER (
    Type_number INT PRIMARY KEY,
    Size VARCHAR(50),
    Weight DECIMAL(8,2),
    Unit_price DECIMAL(8,2) NOT NULL
);


CREATE TABLE BRANCH (
    Cus_no INT,
    Br_number INT,
    City VARCHAR(50),
    Phone VARCHAR(20),
    PRIMARY KEY (Cus_no, Br_number),
    FOREIGN KEY (Cus_no) REFERENCES CUSTOMER(Cus_number)
);


CREATE TABLE PAPER_ORDER (
    Order_number INT PRIMARY KEY,
    Order_date DATE NOT NULL,
    Amount DECIMAL(10,2),
    Cus_no INT,
    FOREIGN KEY (Cus_no) REFERENCES CUSTOMER(Cus_number)
);


CREATE TABLE ORDER_LINE (
    Order_no INT,
    Line_number INT,
    Reg_ship_date DATE,
    Act_ship_date DATE,
    Cus_no INT,
    Br_no INT,
    PRIMARY KEY (Order_no, Line_number),
    FOREIGN KEY (Order_no) REFERENCES PAPER_ORDER(Order_number),
    FOREIGN KEY (Cus_no, Br_no) REFERENCES BRANCH(Cus_no, Br_number)
);


CREATE TABLE HANDLES (
    Emp_ID INT,
    Order_no INT,
    PRIMARY KEY (Emp_ID, Order_no),
    FOREIGN KEY (Emp_ID) REFERENCES EMPLOYEE(Emp_ID),
    FOREIGN KEY (Order_no) REFERENCES PAPER_ORDER(Order_number)
);


CREATE TABLE ORDER_ITEM (
    Order_no INT,
    Line_no INT,
    Type_no INT,
    Quantity INT NOT NULL,
    PRIMARY KEY (Order_no, Line_no, Type_no),
    FOREIGN KEY (Order_no, Line_no) REFERENCES ORDER_LINE(Order_no, Line_number),
    FOREIGN KEY (Type_no) REFERENCES PAPER(Type_number)
);