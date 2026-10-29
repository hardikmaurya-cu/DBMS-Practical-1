# Experiment 4: Conceptual Database Design & ER Diagram for an Indian E-Commerce Platform

> **DBMS Laboratory**

---

## 📌 Attached Lab Submission
📄 **Original Lab Handwritten PDF**: [DBMS_Exp_1_ER_Diagram.pdf](./DBMS_Exp_1_ER_Diagram.pdf)

---

## 🎯 Aim
To design an **Entity Relationship (ER) Diagram** for an Indian E-Commerce Platform modeling entities: `Customer` / `User`, `Product`, `Order`, `Seller`, `Category`, `Payment`, `Delivery`, `Address`, `Cart`, `Wishlist`, and `Product_Review`. The design incorporates primary keys, foreign keys, composite attributes, multi-valued attributes, weak entities, product specialization / generalization, and participation constraints.

---

## 📖 Theoretical Concepts

An **Entity Relationship (ER) Model** is a high-level conceptual data model used in database design. It visually defines entities, their attributes, and relationships among them:

1. **Entity**: A real-world distinguishable object represented by a rectangle (e.g., `Customer`, `Seller`, `Product`, `Order`).
2. **Attribute**: A characteristic or property of an entity represented by an oval (e.g., `Email`, `Price`, `OrderDate`).
3. **Primary Key**: An attribute or combination of attributes that uniquely identifies an entity instance (underlined in conventional ER diagrams).
4. **Composite Attribute**: An attribute composed of multiple granular sub-attributes:
   - Example: `Address` consists of `DoorNo`, `Street`, `Area`, `City`, `State`, and `Pincode`.
5. **Multi-Valued Attribute**: An attribute that can hold more than one value for a single entity instance, represented by a double oval:
   - Example: Multiple phone numbers (`Customer_Phone`, `Customer_Alt_Phone`, `Seller_Phone`), multiple mobile numbers (`Address_Mobile`), and multiple image URLs (`Product_Image`).
6. **Weak Entity**: An entity whose existence depends on another strong entity and lacks a standalone primary key:
   - Example: `OrderItem` relies on `Order` via `(OrderID, ItemNo)` for identification.
7. **Relationship**: An association among two or more entities represented by a diamond (e.g., `Customer PLACES Order`, `Seller LISTS Product`).
8. **Specialization & Generalization**:
   - `Product` acts as a generalized superclass.
   - Subclasses specialize into distinct categories: `Electronics` (Brand, Warranty, PowerRating), `Clothing` (Size, Colour, Material), and `Books` (ISBN, Author, Publisher).
9. **Participation Constraints**:
   - **Total Participation (Mandatory)**: An entity must participate in the relationship (e.g., every `OrderItem` must belong to an `Order`).
   - **Partial Participation (Optional)**: An entity may or may not participate (e.g., a `Category` may not yet have any subcategories or products).

---

## 📊 Entity Relationship Diagram

```mermaid
erDiagram
    CUSTOMER ||--o{ CUSTOMER_PHONE : "has"
    CUSTOMER ||--o{ CUSTOMER_ALT_PHONE : "has"
    CUSTOMER ||--o{ ADDRESS : "has"
    CUSTOMER ||--o{ ORDERS : "places"
    CUSTOMER ||--o{ CART : "adds to"
    CUSTOMER ||--o{ WISHLIST : "adds to"
    CUSTOMER ||--o{ PRODUCT_REVIEW : "writes"
    
    SELLER ||--o{ SELLER_PHONE : "has"
    SELLER ||--o{ PRODUCT : "lists"
    
    CATEGORY ||--o{ CATEGORY : "parent of"
    CATEGORY ||--o{ PRODUCT : "classifies"
    
    PRODUCT ||--o{ PRODUCT_IMAGE : "has"
    PRODUCT ||--o{ PRODUCT_REVIEW : "receives"
    PRODUCT ||--o{ CART : "in"
    PRODUCT ||--o{ WISHLIST : "in"
    PRODUCT ||--o| ELECTRONICS : "specializes to"
    PRODUCT ||--o| CLOTHING : "specializes to"
    PRODUCT ||--o| BOOKS : "specializes to"
    PRODUCT ||--o{ ORDERITEM : "included in"
    
    ADDRESS ||--o{ ADDRESS_MOBILE : "has"
    ADDRESS ||--o{ ORDERS : "shipping destination"
    ADDRESS ||--o{ DELIVERY : "delivered to"
    
    ORDERS ||--|{ ORDERITEM : "contains"
    ORDERS ||--o{ ORDER_COUPON : "applies"
    ORDERS ||--|| PAYMENT : "paid with"
    ORDERS ||--|| DELIVERY : "fulfilled by"

    CUSTOMER {
        int CustomerID PK
        string FullName
        string Email UK
        string Phone
        string PasswordHash
        date DOB
        string Gender
    }

    SELLER {
        int SellerID PK
        string SellerName
        string Email UK
        string Phone
        string GSTIN UK
        string BankDetails
        string Address
    }

    CATEGORY {
        int CategoryID PK
        string CategoryName
        string Description
        int ParentCategoryID FK
    }

    PRODUCT {
        int ProductID PK
        string ProductName
        string Description
        decimal Price
        decimal Discount
        int Stock
        string Brand
        string ImageURL
        int CategoryID FK
        int SellerID FK
    }

    ELECTRONICS {
        int ProductID PK, FK
        string Brand
        string Warranty
        string PowerRating
    }

    CLOTHING {
        int ProductID PK, FK
        string Size
        string Colour
        string Material
    }

    BOOKS {
        int ProductID PK, FK
        string ISBN UK
        string Author
        string Publisher
    }

    ADDRESS {
        int AddressID PK
        int CustomerID FK
        string FullName
        string Phone
        string AddressLine1
        string AddressLine2
        string City
        string State
        string Pincode
        string AddressType
    }

    ORDERS {
        int OrderID PK
        int CustomerID FK
        date OrderDate
        string OrderStatus
        decimal TotalAmount
        int ShippingAddressID FK
    }

    ORDERITEM {
        int OrderID PK, FK
        int ItemNo PK
        int ProductID FK
        int SellerID FK
        decimal ItemPrice
        int Quantity
        decimal Discount
        decimal Subtotal
    }

    COUPON {
        int CouponID PK
        string CouponCode UK
        string Description
        string DiscountType
        decimal DiscountValue
        decimal MinOrderValue
        date ExpiryDate
        boolean IsActive
    }

    PAYMENT {
        int PaymentID PK
        int OrderID FK, UK
        date PaymentDate
        decimal Amount
        string PaymentMethod
        string PaymentStatus
    }

    DELIVERY {
        int DeliveryID PK
        int OrderID FK, UK
        int AddressID FK
        date DeliveryDate
        string DeliveryStatus
        string TrackingID UK
        string DeliveryPartner
        decimal ShippingCharge
    }

    CART {
        int CartID PK
        int CustomerID FK
        int ProductID FK
        int Quantity
        datetime AddedDate
    }

    WISHLIST {
        int WishlistID PK
        int CustomerID FK
        int ProductID FK
        datetime AddedDate
    }

    PRODUCT_REVIEW {
        int ReviewID PK
        int CustomerID FK
        int ProductID FK
        int Rating
        string ReviewText
        datetime ReviewDate
    }
```

---

## 🏷️ Key Entities & Attributes Summary

| Entity | Primary Key | Key Attributes & Constraints | Relationships |
|:---|:---|:---|:---|
| **CUSTOMER** | `CustomerID` | `FullName`, `Email` (UNIQUE), `Phone`, `PasswordHash`, `DOB`, `Gender` | Places Orders, Has Addresses, Adds to Cart/Wishlist |
| **SELLER** | `SellerID` | `SellerName`, `Email` (UNIQUE), `Phone`, `GSTIN` (UNIQUE), `BankDetails`, `Address` | Lists Products |
| **CATEGORY** | `CategoryID` | `CategoryName`, `Description`, `ParentCategoryID` (Self-referential FK) | Classifies Products, Subcategory hierarchy |
| **PRODUCT** | `ProductID` | `ProductName`, `Description`, `Price`, `Stock`, `Brand`, `ImageURL` | Base class for Electronics, Clothing, Books |
| **ADDRESS** | `AddressID` | `DoorNo`, `Street`, `Area`, `City`, `State`, `Pincode`, `AddressType` | Belongs to Customer, Order delivery destination |
| **ORDERS** | `OrderID` | `OrderDate`, `OrderStatus`, `TotalAmount`, `CustomerID` (FK), `ShippingAddressID` (FK) | Has OrderItems, Payment, Delivery, Coupons |
| **ORDERITEM** | `(OrderID, ItemNo)` | `ProductID` (FK), `SellerID` (FK), `Quantity`, `ItemPrice`, `Discount`, `Subtotal` | Composite weak entity linking Orders and Products |
| **PAYMENT** | `PaymentID` | `OrderID` (UNIQUE FK), `PaymentDate`, `Amount`, `PaymentMethod`, `PaymentStatus` | 1:1 relation with Orders |
| **DELIVERY** | `DeliveryID` | `OrderID` (UNIQUE FK), `AddressID` (FK), `TrackingID` (UNIQUE), `DeliveryPartner`, `ShippingCharge` | Fulfils Orders |

---

## 🔗 Next Step
Proceed to **[Experiment 5: Relational Schema Mapping & SQL Implementation](../experiment-5/)** to view the physical relational schema, table creation DDL, sample data DML, and execution tests for referential integrity violations, `ON DELETE SET NULL`, and `ON DELETE CASCADE`.
