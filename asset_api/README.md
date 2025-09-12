**Course:** Distributed Systems and Applications (DSA612S)
**Due date:** 21 September 2025 @ 23h59

This project has two parts:

1. **Asset Management System (REST API in Ballerina)**

   * Create, update, delete, and view assets.
   * Track maintenance schedules and overdue items.
   * Manage components, work orders, and tasks.

2. **Car Rental System (gRPC in Ballerina)**

   * **Admin:** Add, update, or remove cars, list reservations.
   * **Customer:** View available cars, search by plate, add to cart, place reservations.

---

## 🛠️ Tools Used

* **Language:** Ballerina
* **Protocols:** REST + gRPC
* **Storage:** Map/Table (in-memory)

---

## ⚙️ How to Run

1. Install [Ballerina](https://ballerina.io/downloads/).
2. Clone this repo:

   ```bash
   git clone https://github.com/<your-org>/dsa612s-assignment1.git
   cd dsa612s-assignment1
   ```
3. Run the services:

   * Asset API:

     ```bash
     bal run assets-api/main.bal
     ```
   * Car Rental System:

     ```bash
     bal run car-rental-grpc/server.bal
     ```

---

## 👥 Group Work Rules

* Work in groups of **5–7 students**.
* Everyone must commit code (commit history = contribution).
* No commits → No marks.
* No late submissions.

---

## ⚠️ Important Notes

* **Deadline:** 21 September 2025, 23h59.
* **Plagiarism or 100% AI code = 0 marks.**
* Code must run on the command line or with a framework.

