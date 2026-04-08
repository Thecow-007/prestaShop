# PrestaShop Automated Test Suite

This repository contains the functional Robot Framework test suite for PrestaShop 9 (Hummingbird theme).

## Prerequisites

Ensure your local PrestaShop instance is running via Docker on `http://localhost:8080/`.

To install the required Python libraries for test automation, run:
```bash
pip install -r requirements.txt
```

## Running Tests

Execute the complete test suite from the root directory:
```bash
python -m robot tests/
```

## Important: Test Data Configuration

The automation tests (`TC-05-02` Out-of-Stock and `TC-06-02` Quantity Exceeding Stock) rely on definitive database stock constraints to trigger PrestaShop's UI validations reliably. 

Before running the tests on a **fresh** local Docker instance, you must configure the stock data for specific test products. Run the following command against your PrestaShop MySQL container (assuming your PrestaShop DB container is named `prestashop-db` or similar):

```bash
docker exec -i mysql sh -c 'mysql -u root -pprestashop prestashop -e "UPDATE ps_stock_available SET quantity = 0, out_of_stock = 0 WHERE id_product = 8; UPDATE ps_product SET available_for_order = 0 WHERE id_product = 8; UPDATE ps_stock_available SET quantity = 10, out_of_stock = 0 WHERE id_product = 2;"'
```
*Note: Adjust `mysql -u root -pprestashop` to match your local `.env` database credentials.*

- **Product 2** is used for "Valid Add to Cart" tests and is forced to 10 stock items.
- **Product 8** is used exclusively for "Out-Of-Stock" tests and is completely disabled from order availability.
