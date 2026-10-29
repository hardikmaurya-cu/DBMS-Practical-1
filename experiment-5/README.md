# Experiment 5: ER Diagram to Relational Schema and SQL Implementation

> **DBMS Laboratory**

---

## 📌 Attached Lab Submission
📄 **Original Lab Handwritten PDF**: [DBMS_Exp_2_Relational_Schema.pdf](./DBMS_Exp_2_Relational_Schema.pdf)

---

## 🎯 Aim
To convert the **Entity-Relationship (ER) Diagram** designed in Experiment 4 into a normalized **Relational Schema** (18 tables), implement the schema in MySQL with primary and foreign key constraints, populate the tables with sample records, and demonstrate:
1. Complete relational schema generation (`SHOW TABLES;`).
2. Verification of inserted records.
3. **Referential Integrity Violation** handling (`ERROR 1452 (23000)`).
4. **`ON DELETE SET NULL`** behavior.
5. **`ON DELETE CASCADE`** behavior across dependent relationships.

---

## 📋 Relational Schema Mapping Table

| # | Table Name | Primary Key | Foreign Key(s) & References | Delete Action |
|:---:|:---|:---|:---|:---|
| 1 | `CUSTOMER` | `CustomerID` | *None* | — |
| 2 | `CUSTOMER_PHONE` | `(CustomerID, Phone)` | `CustomerID` $\to$ `CUSTOMER(CustomerID)` | `ON DELETE CASCADE` |
| 3 | `CUSTOMER_ALT_PHONE` | `(CustomerID, AltPhone)` | `CustomerID` $\to$ `CUSTOMER(CustomerID)` | `ON DELETE CASCADE` |
| 4 | `SELLER` | `SellerID` | *None* | — |
| 5 | `SELLER_PHONE` | `(SellerID, Phone)` | `SellerID` $\to$ `SELLER(SellerID)` | `ON DELETE CASCADE` |
| 6 | `CATEGORY` | `CategoryID` | `ParentCategoryID` $\to$ `CATEGORY(CategoryID)` | `ON DELETE SET NULL` |
| 7 | `PRODUCT` | `ProductID` | `SellerID` $\to$ `SELLER(SellerID)`<br>`CategoryID` $\to$ `CATEGORY(CategoryID)` | `ON DELETE CASCADE`<br>`ON DELETE SET NULL` |
| 8 | `PRODUCT_IMAGE` | `(ProductID, Image)` | `ProductID` $\to$ `PRODUCT(ProductID)` | `ON DELETE CASCADE` |
| 9 | `ELECTRONICS` | `ProductID` | `ProductID` $\to$ `PRODUCT(ProductID)` | `ON DELETE CASCADE` |
| 10 | `CLOTHING` | `ProductID` | `ProductID` $\to$ `PRODUCT(ProductID)` | `ON DELETE CASCADE` |
| 11 | `BOOKS` | `ProductID` | `ProductID` $\to$ `PRODUCT(ProductID)` | `ON DELETE CASCADE` |
| 12 | `ADDRESS` | `AddressID` | `CustomerID` $\to$ `CUSTOMER(CustomerID)` | `ON DELETE CASCADE` |
| 13 | `ADDRESS_MOBILE` | `(AddressID, MobileNo)` | `AddressID` $\to$ `ADDRESS(AddressID)` | `ON DELETE CASCADE` |
| 14 | `ORDERS` | `OrderID` | `CustomerID` $\to$ `CUSTOMER(CustomerID)`<br>`AddressID` $\to$ `ADDRESS(AddressID)` | `ON DELETE CASCADE`<br>`ON DELETE SET NULL` |
| 15 | `ORDER_COUPON` | `(OrderID, CouponCode)` | `OrderID` $\to$ `ORDERS(OrderID)` | `ON DELETE CASCADE` |
| 16 | `ORDERITEM` | `(OrderID, ItemNo)` | `OrderID` $\to$ `ORDERS(OrderID)`<br>`ProductID` $\to$ `PRODUCT(ProductID)` | `ON DELETE CASCADE`<br>`ON DELETE CASCADE` |
| 17 | `PAYMENT` | `PaymentID` | `OrderID` $\to$ `ORDERS(OrderID)` | `ON DELETE CASCADE` |
| 18 | `DELIVERY` | `DeliveryID` | `OrderID` $\to$ `ORDERS(OrderID)`<br>`AddressID` $\to$ `ADDRESS(AddressID)` | `ON DELETE CASCADE`<br>`ON DELETE CASCADE` |

---

## 🛠️ Execution Guide

Execute the complete experiment script using the MySQL client:

```bash
mysql -u <username> -p < experiment-5/experiment_5.sql
```

Enter your MySQL password when prompted.

---

## 📝 SQL Implementation

### 1. DDL: Database & Table Creation

```sql
CREATE DATABASE ECOMMERCE;
USE ECOMMERCE;

-- 1. Customer
CREATE TABLE CUSTOMER (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Password VARCHAR(100) NOT NULL,
    DateOfBirth DATE NOT NULL
);

-- 2. Customer Phone
CREATE TABLE CUSTOMER_PHONE (
    CustomerID INT,
    Phone VARCHAR(15),
    PRIMARY KEY (CustomerID, Phone),
    FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID)
        ON DELETE CASCADE
);

-- 3. Customer Alternate Phone
CREATE TABLE CUSTOMER_ALT_PHONE (
    CustomerID INT,
    AltPhone VARCHAR(15),
    PRIMARY KEY (CustomerID, AltPhone),
    FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID)
        ON DELETE CASCADE
);

-- 4. Seller
CREATE TABLE SELLER (
    SellerID INT PRIMARY KEY,
    SellerName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    GSTIN VARCHAR(20) UNIQUE NOT NULL,
    AccountNo VARCHAR(20),
    IFSCCode VARCHAR(20),
    BankName VARCHAR(50)
);

-- 5. Seller Phone
CREATE TABLE SELLER_PHONE (
    SellerID INT,
    Phone VARCHAR(15),
    PRIMARY KEY (SellerID, Phone),
    FOREIGN KEY (SellerID) REFERENCES SELLER(SellerID)
        ON DELETE CASCADE
);

-- 6. Category (Self-referential)
CREATE TABLE CATEGORY (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL,
    Description VARCHAR(100),
    ParentCategoryID INT,
    FOREIGN KEY (ParentCategoryID) REFERENCES CATEGORY(CategoryID)
        ON DELETE SET NULL
);

-- 7. Product
CREATE TABLE PRODUCT (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50) NOT NULL,
    Description VARCHAR(100),
    Price DECIMAL(10,2) NOT NULL,
    StockQty INT NOT NULL,
    Weight DECIMAL(8,2),
    SellerID INT NOT NULL,
    CategoryID INT,
    FOREIGN KEY (SellerID) REFERENCES SELLER(SellerID)
        ON DELETE CASCADE,
    FOREIGN KEY (CategoryID) REFERENCES CATEGORY(CategoryID)
        ON DELETE SET NULL
);

-- 8. Product Image
CREATE TABLE PRODUCT_IMAGE (
    ProductID INT,
    Image VARCHAR(200),
    PRIMARY KEY (ProductID, Image),
    FOREIGN KEY (ProductID) REFERENCES PRODUCT(ProductID)
        ON DELETE CASCADE
);

-- 9. Electronics (Product Subclass)
CREATE TABLE ELECTRONICS (
    ProductID INT PRIMARY KEY,
    Brand VARCHAR(50),
    Warranty VARCHAR(30),
    PowerRating VARCHAR(30),
    FOREIGN KEY (ProductID) REFERENCES PRODUCT(ProductID)
        ON DELETE CASCADE
);

-- 10. Clothing (Product Subclass)
CREATE TABLE CLOTHING (
    ProductID INT PRIMARY KEY,
    Size VARCHAR(20),
    Colour VARCHAR(20),
    Material VARCHAR(30),
    FOREIGN KEY (ProductID) REFERENCES PRODUCT(ProductID)
        ON DELETE CASCADE
);

-- 11. Books (Product Subclass)
CREATE TABLE BOOKS (
    ProductID INT PRIMARY KEY,
    ISBN VARCHAR(20) UNIQUE,
    Author VARCHAR(50),
    Publisher VARCHAR(50),
    FOREIGN KEY (ProductID) REFERENCES PRODUCT(ProductID)
        ON DELETE CASCADE
);

-- 12. Address
CREATE TABLE ADDRESS (
    AddressID INT PRIMARY KEY,
    DoorNo VARCHAR(10),
    Street VARCHAR(50),
    Area VARCHAR(50),
    City VARCHAR(30),
    State VARCHAR(30),
    Pincode VARCHAR(10) NOT NULL,
    AddressType VARCHAR(20),
    CustomerID INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID)
        ON DELETE CASCADE
);

-- 13. Address Mobile
CREATE TABLE ADDRESS_MOBILE (
    AddressID INT,
    MobileNo VARCHAR(15),
    PRIMARY KEY (AddressID, MobileNo),
    FOREIGN KEY (AddressID) REFERENCES ADDRESS(AddressID)
        ON DELETE CASCADE
);

-- 14. Orders
CREATE TABLE ORDERS (
    OrderID INT PRIMARY KEY,
    OrderDate DATE NOT NULL,
    OrderStatus VARCHAR(20) NOT NULL,
    TotalAmount DECIMAL(10,2) NOT NULL,
    CustomerID INT NOT NULL,
    AddressID INT,
    FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID)
        ON DELETE CASCADE,
    FOREIGN KEY (AddressID) REFERENCES ADDRESS(AddressID)
        ON DELETE SET NULL
);

-- 15. Order Coupon
CREATE TABLE ORDER_COUPON (
    OrderID INT,
    CouponCode VARCHAR(30),
    PRIMARY KEY (OrderID, CouponCode),
    FOREIGN KEY (OrderID) REFERENCES ORDERS(OrderID)
        ON DELETE CASCADE
);

-- 16. Order Item
CREATE TABLE ORDERITEM (
    OrderID INT,
    ItemNo INT,
    ProductID INT NOT NULL,
    ItemPrice DECIMAL(10,2) NOT NULL,
    Quantity INT NOT NULL,
    Discount DECIMAL(10,2),
    TaxAmount DECIMAL(10,2),
    PRIMARY KEY (OrderID, ItemNo),
    FOREIGN KEY (OrderID) REFERENCES ORDERS(OrderID)
        ON DELETE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES PRODUCT(ProductID)
        ON DELETE CASCADE
);

-- 17. Payment
CREATE TABLE PAYMENT (
    PaymentID INT PRIMARY KEY,
    PaymentDate DATE NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentMethod VARCHAR(30) NOT NULL,
    TransactionID VARCHAR(30) UNIQUE,
    PaymentStatus VARCHAR(20) NOT NULL,
    OrderID INT UNIQUE NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES ORDERS(OrderID)
        ON DELETE CASCADE
);

-- 18. Delivery
CREATE TABLE DELIVERY (
    DeliveryID INT PRIMARY KEY,
    DeliveryDate DATE,
    DeliveryStatus VARCHAR(20) NOT NULL,
    TrackingID VARCHAR(30) UNIQUE,
    DeliveryPartner VARCHAR(50),
    ShippingCharge DECIMAL(8,2),
    OrderID INT UNIQUE NOT NULL,
    AddressID INT,
    FOREIGN KEY (OrderID) REFERENCES ORDERS(OrderID)
        ON DELETE CASCADE,
    FOREIGN KEY (AddressID) REFERENCES ADDRESS(AddressID)
        ON DELETE CASCADE
);
```

---

### 2. DML: Sample Data Inserts

```sql
-- Customer
INSERT INTO CUSTOMER VALUES (1, 'Priyanshu', 'priyanshumishra02007@gmail.com', 'pass123', '2007-01-20');
INSERT INTO CUSTOMER_PHONE VALUES (1, '6388046065');
INSERT INTO CUSTOMER_ALT_PHONE VALUES (1, '6388046065');

-- Seller
INSERT INTO SELLER VALUES (101, 'Tech Store', 'tech@gmail.com', 'GST123', '123456', 'SBIN002', 'SBI');
INSERT INTO SELLER_PHONE VALUES (101, '7897897919');

-- Category (Parent & Child Hierarchy)
INSERT INTO CATEGORY VALUES (201, 'Electronics', 'Electronic Items', NULL);
INSERT INTO CATEGORY VALUES (202, 'Mobiles', 'Mobile Phones', 201);

-- Product & Specialization
INSERT INTO PRODUCT VALUES (301, 'Laptop', 'Gaming Laptop', 75000.00, 10, 2.50, 101, 201);
INSERT INTO ELECTRONICS VALUES (301, 'ASUS', '2 Years', '120W');
INSERT INTO PRODUCT_IMAGE VALUES (301, 'laptop.jpg');

-- Address
INSERT INTO ADDRESS VALUES (401, '121', 'Nawabganj', 'Unnao', 'Uttar Pradesh', '209859', 'Work', 1);
INSERT INTO ADDRESS_MOBILE VALUES (401, '9192958085');

-- Order & Order Items
INSERT INTO ORDERS VALUES (501, '2026-08-14', 'Placed', 75000.00, 1, 401);
INSERT INTO ORDERITEM VALUES (501, 1, 301, 75000.00, 1, 1000.00, 9000.00);
INSERT INTO ORDER_COUPON VALUES (501, 'WELCOME10');

-- Payment & Delivery
INSERT INTO PAYMENT VALUES (601, '2026-08-14', 74000.00, 'UPI', 'TXN123', 'Paid', 501);
INSERT INTO DELIVERY VALUES (701, NULL, 'Processing', 'TRK123', 'Delhivery', 100.00, 501, 401);
```

---

## 📊 Outputs & Constraint Demonstrations

### Output 1: SHOW TABLES
Proves that all 18 tables have been generated:

```sql
SHOW TABLES;
```

```text
+-----------------------+
| Tables_in_ecommerce   |
+-----------------------+
| ADDRESS               |
| ADDRESS_MOBILE        |
| BOOKS                 |
| CATEGORY              |
| CLOTHING              |
| CUSTOMER              |
| CUSTOMER_ALT_PHONE    |
| CUSTOMER_PHONE        |
| DELIVERY              |
| ELECTRONICS           |
| ORDERS                |
| ORDERITEM             |
| ORDER_COUPON          |
| PAYMENT               |
| PRODUCT               |
| PRODUCT_IMAGE         |
| SELLER                |
| SELLER_PHONE          |
+-----------------------+
18 rows in set
```

---

### Output 2: Sample Data Verification
Verifying inserted records:

```sql
SELECT * FROM CUSTOMER;
```
| CustomerID | Name | Email | Password | DateOfBirth |
|:---:|:---|:---|:---|:---:|
| 1 | Priyanshu | priyanshumishra02007@gmail.com | pass123 | 2007-01-20 |

```sql
SELECT * FROM PRODUCT;
```
| ProductID | ProductName | Description | Price | StockQty | Weight | SellerID | CategoryID |
|:---:|:---|:---|:---:|:---:|:---:|:---:|:---:|
| 301 | Laptop | Gaming Laptop | 75000.00 | 10 | 2.50 | 101 | 201 |

```sql
SELECT * FROM ORDERS;
```
| OrderID | OrderDate | OrderStatus | TotalAmount | CustomerID | AddressID |
|:---:|:---:|:---|:---:|:---:|:---:|
| 501 | 2026-08-14 | Placed | 75000.00 | 1 | 401 |

---

### Output 3: Referential Integrity Violation Demonstration
Attempting to insert an order with non-existent `CustomerID = 999`:

```sql
INSERT INTO ORDERS VALUES (502, '2026-08-14', 'Placed', 50000.00, 999, 401);
```

**Observed Result**:
```text
ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails
(`ECOMMERCE`.`ORDERS`, CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`CustomerID`) REFERENCES `CUSTOMER` (`CustomerID`) ON DELETE CASCADE)
```
- **Reason**: `CustomerID = 999` does not exist in the parent `CUSTOMER` table.
- **Verification**: Foreign key constraint enforcement successfully prevents orphan records.

---

### Output 4: ON DELETE SET NULL Demonstration
When parent `CATEGORY` (ID `201`) is deleted, dependent products have their `CategoryID` updated to `NULL` without losing the product record:

```sql
-- Step 1: Check category before deletion
SELECT ProductID, ProductName, CategoryID FROM PRODUCT WHERE ProductID = 301;
-- Result: CategoryID is 201

-- Step 2: Delete parent category
DELETE FROM CATEGORY WHERE CategoryID = 201;

-- Step 3: Check product category after deletion
SELECT ProductID, ProductName, CategoryID FROM PRODUCT WHERE ProductID = 301;
-- Result: CategoryID is NULL
```

| ProductID | ProductName | CategoryID |
|:---:|:---|:---:|
| 301 | Laptop | **NULL** |

> **Conclusion**: `ON DELETE SET NULL` demonstrated successfully.

---

### Output 5: ON DELETE CASCADE Demonstration
When parent `CUSTOMER` (ID `1`) is deleted, all dependent rows across `ORDERS`, `CUSTOMER_PHONE`, etc. are automatically cascade-deleted:

```sql
-- Step 1: Verify order exists
SELECT * FROM ORDERS WHERE CustomerID = 1;
-- Result: 1 row returned (OrderID 501)

-- Step 2: Delete parent customer
DELETE FROM CUSTOMER WHERE CustomerID = 1;
-- Output: Query OK, 1 row affected

-- Step 3: Verify dependent order has been cascaded
SELECT * FROM ORDERS WHERE CustomerID = 1;
-- Output: Empty set

-- Step 4: Verify dependent phone numbers have been cascaded
SELECT * FROM CUSTOMER_PHONE WHERE CustomerID = 1;
-- Output: Empty set
```

> **Conclusion**: Deleting the parent customer automatically deleted all related child records. `ON DELETE CASCADE` demonstrated successfully.
